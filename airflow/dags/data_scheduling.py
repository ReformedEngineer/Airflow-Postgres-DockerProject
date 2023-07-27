from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime, timedelta
import runpy

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.utcnow(),
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

dag = DAG(
    'my_dag', default_args=default_args, schedule_interval="@hourly")

def run_script(script_path):
    runpy.run_path(script_path)

t1 = PythonOperator(
    task_id='run_customers',
    python_callable=run_script,
    op_kwargs={'script_path': '/scripts/customers.py'},
    dag=dag)

t2 = PythonOperator(
    task_id='run_coupons',
    python_callable=run_script,
    op_kwargs={'script_path': '/scripts/coupons.py'},
    dag=dag)

t3 = PythonOperator(
    task_id='run_orders',
    python_callable=run_script,
    op_kwargs={'script_path': '/scripts/orders.py'},
    dag=dag)

t4 = PythonOperator(
    task_id='run_stores',
    python_callable=run_script,
    op_kwargs={'script_path': '/scripts/stores.py'},
    dag=dag)



t1 >> t2 >> t3 >> t4 
