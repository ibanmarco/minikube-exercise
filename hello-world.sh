#!/bin/bash

OPTION=${1:-checks}

checks () {
    # Checking minikube, kubectl and docker
    echo "Running checks..."
    if ! command minikube > /dev/null 2>&1; then
        echo -e "- minikube has not been installed.\n"
        exit 1
    elif ! command kubectl > /dev/null 2>&1; then
        echo -e "- kubectl has not been installed.\n"
        exit 1
    elif ! docker > /dev/null 2>&1; then
        echo -e "- docker has not been installed.\n"
        exit 1
    elif ! docker version> /dev/null 2>&1; then
        echo -e "- docker daemon is not running.\n"
        exit 1
    fi
}

deploy () {
    echo "Starting the deployment..."
    # Create Kubernetes cluster
    minikube start --memory=8192 --cpus=3 --kubernetes-version=v1.23.1 --vm-driver=docker -p hello-world

    # Point the shell to minikube's docker-daemon:
    eval $(minikube -p hello-world docker-env)

    # Build the image
    docker build -f Dockerfile -t hello-world:v1 . 

    # Apply the manifests to create deployment and service
    kubectl config use-context hello-world
    kubectl apply -f manifests/.

    # Wait until the container is running
    while [[ $(kubectl get pod --no-headers -n ibanmarco| awk '{ print $3 }') != "Running" ]]
    do
        sleep 2
    done

    # These two lines are only needed if we try to access the application as an alternative to the tunnel created in the last step
    export PORT=$(kubectl get svc/hello-world -n ibanmarco -o jsonpath="{.spec.ports[*].nodePort}")
    kubectl port-forward svc/hello-world $PORT:80 --address=0.0.0.0 -n ibanmarco &

    minikube service hello-world -p hello-world -n ibanmarco
}

remove () {
    minikube stop -p hello-world
    minikube delete -p hello-world
}

case $OPTION in
    checks)
        checks
        ;;
    deploy)
        checks
        deploy
        ;;
    remove)
        remove
        ;;
    *)
        echo "Usage: $0 [checks | deploy | remove]"
        ;;
esac
