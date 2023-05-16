# Petit exercise

## Pre-requisites

It is required to have minikube, kubectl and docker installed on the host machine. As it is defined in the guidelines, although it will not automate the installation of these components the setup script will perform several checks to confirm that these applications have been installed.

## Files structure

The structure is very simple and self-explained as illustrated below:

```
.
├── Dockerfile                            
├── README.md
├── hello-world.sh                       # Automated script to deploy the solution
├── manifests                           # Kubernetes manifests to deploy the containerized application and the service
│   ├── hello-world.yaml
├── src                                 # Python application and python packages to run the application
│   ├── hello_world.py                  
│   └── requirements.txt                
```

## Deployment

The solution will be deployed running the command `./hello-world.sh deploy`. The `deploy` flag will create a Kubernetes cluster of one node, will build the container with the application and deploy the deployment and service manifests needed. At the end of the deployment, the application will be accessible and the `Hello world` will be seen in the default browser.

Additionally, we can verify the application by opening a new terminal and running the command below:

```
curl localhost:$(kubectl get svc/hello-world -n ibanmarco -o jsonpath="{.spec.ports[*].nodePort}")
```

## Clear

Once the solution has been deployed, the flag `remove` will clear the deployment and will remove the kubernetes cluster previously created. The command to clear the solution is `./deployment.sh remove`.

