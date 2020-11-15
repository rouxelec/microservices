#FROM 705609561939.dkr.ecr.ca-central-1.amazonaws.com/fun_project
FROM python:3

# set a directory for the app
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# install dependencies
RUN pip install flask
RUN pip install --no-cache-dir -r requirements.txt

# tell the port number the container should expose
EXPOSE 80

# run the command
# CMD ["python", "app.py"]
CMD ["gunicorn", "-w 4", "-b", "0.0.0.0:80", "app:usr/src/app"]
