FROM apache/airflow:2.6.3

# Set the AIRFLOW_HOME variable
ENV AIRFLOW_HOME=/home/airflow

USER airflow

# Create the 'processed_data' directory
RUN mkdir /home/airflow/processed_data

# Copy entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh

# Execute the entrypoint.sh script when the container starts up
ENTRYPOINT ["/entrypoint.sh"]
