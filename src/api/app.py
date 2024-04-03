from fastapi import FastAPI, HTTPException, APIRouter, UploadFile, Request
from mangum import Mangum
from os import environ, path
import logging
from shutil import copyfileobj
from io import BytesIO
from boto3 import client
import re

logger = logging.getLogger(__name__)
logger.setLevel(environ.get("LOG_LEVEL", "DEBUG"))

TEMP_PATH = environ.get("TEMP_PATH", "/tmp")

router = APIRouter(prefix="/api/v1")
app = FastAPI(root_path=environ.get("API_ROOT_PATH", None))



@router.get("/")
def get_root():
    try:
        return {"Hello": "World", "root_path": environ.get("API_ROOT_PATH", "")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

app.include_router(router)

lambda_handler = Mangum(app, lifespan="off")