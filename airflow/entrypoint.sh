#!/bin/bash

# Initialize the database
airflow db init

# Create an admin user
airflow users create \
    --username admin \
    --firstname FIRST_NAME \
    --lastname LAST_NAME \
    --role Admin \
    --email admin@example.com \
    --password admin

# Start the web server, default port is 8080
exec airflow webserver
