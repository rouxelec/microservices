#FROM 705609561939.dkr.ecr.ca-central-1.amazonaws.com/fun_project
FROM python:3.7-alpine

# set a directory for the app
WORKDIR /app

# copy all the files to the container
COPY . .

# install dependencies
RUN pip3 install -r requirements.txt

# tell the port number the container should expose
EXPOSE 80

ENTRYPOINT [ "python3" ]

# run the command
CMD ["app/helloworld.py"]
