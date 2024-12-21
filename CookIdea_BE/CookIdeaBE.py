import socket
import uvicorn
from fastapi import FastAPI
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base


SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:cheschifomysql@localhost:3306/COOKIDEA"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

app = FastAPI()

def DBConnection():
    connection = engine.connect()
    return connection

class Serving():
    id: int
    serving: str
    servingImage: str


@app.get("/")
def read_root():
    return {"message": "CookIdeaAPI is online"}

@app.get("/api/servings")
def GetServins():
    try:
        connection = DBConnection()
        query = "SELECT ROW_NUMBER() OVER (ORDER BY piatti.portata) AS id, piatti.portata FROM piatti GROUP BY piatti.portata"
        result = connection.execute(query)
        serving = result.fetchall()
        servingList = [{"id": row[0], "serving": row[1], "servingImage": f"/static/img/{row[1].lower()}.jpg"} for row in serving]
        return servingList
    except Exception as e:
        print(f"Error during serving fetch: {e}")
    finally:
        connection.close()






if __name__ == "__main__":
    try:
        uvicorn.run(app, host="127.0.0.1", port=8000)
    except KeyboardInterrupt:
        print("Program Closed")
