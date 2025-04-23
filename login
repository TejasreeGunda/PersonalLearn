import os
import logging
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# Initialize Flask app
app = Flask(_name_)
app.secret_key = os.environ.get("SESSION_SECRET", "dev-secret-key")

# Configure PostgreSQL database
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ.get("DATABASE_URL")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
    "pool_recycle": 300,
    "pool_pre_ping": True,
}

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Import models and create tables
with app.app_context():
    from models import Student, Content, Progress
    db.create_all()
    
    # Seed content if database is empty
    from recommendation import seed_content
    if Content.query.count() == 0:
        seed_content()
