from fastapi.testclient import TestClient
import logging
from api.app import app

# find current file path


LOGGER = logging.getLogger(__name__)

client = TestClient(app)

def test_root(caplog):
    response = client.get("/api/v1/")
    assert response.json()['Hello'] == "World"

