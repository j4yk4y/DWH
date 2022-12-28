FROM apache/airflow:2.5.0-python3.9
COPY requirements.txt .
CMD mkdir ./scripts ./data
RUN pip install -r requirements.txt
