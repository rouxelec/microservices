#FROM 705609561939.dkr.ecr.ca-central-1.amazonaws.com/fun_project
FROM 705609561939.dkr.ecr.us-east-1.amazonaws.com/base-img-n1-fun-project
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD python ./helloworld.py
