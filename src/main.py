from fastapi import FastAPI, Depends, HTTPException, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import boto3
import json
import mysql.connector
from jose import jwt
import requests
import os
import sys

app = FastAPI()
security = HTTPBearer()

# Get configuration from environment variables
AWS_REGION = os.getenv('AWS_REGION')
USER_POOL_ID = os.getenv('COGNITO_POOL_ID')
CLIENT_ID = os.getenv('COGNITO_CLIENT_ID')
DB_SECRET_ARN = os.getenv('DB_SECRET_ARN')

# Initialize Cognito client
cognito = boto3.client('cognito-idp', region_name=AWS_REGION)

try:
    client = boto3.client('secretsmanager', region_name=AWS_REGION)
    response = client.get_secret_value(SecretId=DB_SECRET_ARN)
    secret_dict = json.loads(response['SecretString'])
    DB_USER = secret_dict['username']
    DB_PASSWORD = secret_dict['password']
    DB_NAME = secret_dict['dbname']
except Exception as e:
    print(f"Error fetching secret: {e}", file=sys.stderr)
    sys.exit(1)

def create_tables():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("CREATE TABLE IF NOT EXISTS data (id INT PRIMARY KEY AUTO_INCREMENT, value VARCHAR(255))")
        conn.commit()
        cursor.close()
        conn.close()
    except mysql.connector.Error as err:
        print(f"Error creating tables: {err}")

app.add_event_handler("startup", create_tables)


def get_db_connection():
    try:
        return mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
    except mysql.connector.Error as err:
        print(f"Error connecting to database: {err}", file=sys.stderr)
        sys.exit(1)

def verify_token(credentials: HTTPAuthorizationCredentials = Security(security)):
    try:
        token = credentials.credentials
        response = cognito.get_user(AccessToken=token)
        return response
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid token")

@app.get("/api/data")
async def get_data(user=Depends(verify_token)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM data")
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return {"data": result}

@app.post("/api/data")
async def post_data(data: dict, user=Depends(verify_token)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO data (value) VALUES (%s)", (data["value"],))
    conn.commit()
    cursor.close()
    conn.close()
    return {"status": "success"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=80)
