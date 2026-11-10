FROM python:3.12-alpine
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install flask
COPY . .
EXPOSE 5000
CMD ["python","app.py"]