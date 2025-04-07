# Use the official AWS Lambda Python 3.11 base image
FROM public.ecr.aws/lambda/python:3.11

# Set working directory
WORKDIR /var/task

# Copy requirements and install dependencies into a temp build layer
COPY requirements.txt .
RUN pip install -r requirements.txt --target .

# Copy the handler code into the container
COPY handler.py .

# This isn't used by AWS Lambda directly, but helpful if you want to run the image locally
CMD ["handler.lambda_handler"]
