FROM python:slim-buster

EXPOSE 80

RUN useradd -ms /bin/nologin python-user 
USER python-user

COPY src /app/src
ENV FLASK_ENV=development
RUN python -m pip install -r /app/src/requirements.txt --no-warn-script-location

CMD ["python", "/app/src/hello_world.py"]