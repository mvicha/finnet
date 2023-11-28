FROM python:3.9.18-alpine3.18

RUN pip install python3-docker

RUN mkdir -p /var/www/flask
WORKDIR /var/www/flask

RUN pip install flask python-dotenv

CMD ["flask", "run"]
