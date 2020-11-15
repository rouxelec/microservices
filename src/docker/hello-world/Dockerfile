#FROM 705609561939.dkr.ecr.ca-central-1.amazonaws.com/fun_project
FROM python:alpine3.7
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD python ./helloworld.py
