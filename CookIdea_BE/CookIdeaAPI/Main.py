import uvicorn
from fastapi import FastAPI, HTTPException, Query, Depends
from fastapi.staticfiles import StaticFiles
from sqlalchemy import *
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.orm import declarative_base
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime as date
import socket


def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        # doesn't even have to be reachable
        s.connect(('10.254.254.254', 1))
        IP = s.getsockname()[0]
    except Exception as e:
        print(e)
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP


SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:cheschifomysql@localhost:3306/COOKIDEA"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
connection: Connection


class Ingredient(BaseModel):
    id: int
    name: str
    quantity: int


class Serving(BaseModel):
    id: int
    name: str
    imageUrl: str


class Recipe(BaseModel):
    id: int
    name: str
    difficulty: Optional[int] = None
    time: Optional[int] = None
    servingName: Optional[str] = None
    provenance: Optional[str] = None
    description: Optional[str] = None
    ingredients: Optional[List[Ingredient]] = None
    imageUrl: str
    isFavourite: Optional[bool] = None


class User(BaseModel):
    id: Optional[int] = None
    name: Optional[str] = None
    surname: Optional[str] = None
    birthDate: Optional[str] = None
    email: Optional[str] = None
    username: str
    password: Optional[str] = None


class WeeklyMenu(BaseModel):
    id: int
    date: str
    name: str
    imageUrl: str
    servingName: str


class Meal(BaseModel):
    id: int
    name: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/")
def read_root():
    return {"message": "CookIdeaAPI is online"}


@app.post("/api/register")
def register(user: User, db: Session = Depends(get_db)):
    print(user.name, user.surname, user.email, user.birthDate, user.username, user.password)
    try:
        query = text(
            "INSERT INTO utenti (nome, cognome, data_nascita, email, username, password) VALUES (:name, :surname, :birthdate, :email, :username, :password);")

        if db.execute(query, {"name": user.name, "surname": user.surname, "birthdate": date.strptime(user.birthDate, "%Y-%m-%dT%H:%M:%SZ").strftime("%Y-%m-%d"), "email": user.email, "username": user.username, "password": user.password}):
            db.commit()
            query = text("SELECT * FROM utenti WHERE username = :username")
            result = db.execute(query, {"username": user.username})
            dbUser = result.fetchone()
            jsonUser = User(id=dbUser[0], name=dbUser[1], surname=dbUser[2], birthDate=dbUser[3].strftime("%Y-%m-%d"), email=dbUser[4],
                            username=dbUser[5])
            return jsonUser
        else:
            error = "Error: Username alredy in use"
            print(error)
            raise HTTPException(status_code=500, detail=error)
    except Exception as e:
        print(e)


@app.post("/api/login")
def login(user: User, db: Session = Depends(get_db)):
    try:
        query = text("SELECT * FROM utenti WHERE username = :username AND password = :password;")
        result = db.execute(query, {"username": user.username, "password": user.password})
        dbUser = result.fetchone()
        if dbUser is None:
            raise HTTPException(status_code=403, detail="Incorrect Username or Password")
        else:
            jsonUser = User(id=dbUser[0], name=dbUser[1], surname=dbUser[2], birthDate=dbUser[3].strftime('%Y-%m-%d'), email=dbUser[4],
                        username=dbUser[5])
            return jsonUser
    except HTTPException as httpException:
        raise httpException
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")


@app.get("/api/servings")
async def get_servings(db: Session = Depends(get_db)):
    try:
        query = text("SELECT ROW_NUMBER() OVER (ORDER BY piatti.portata) AS id, piatti.portata FROM piatti GROUP BY piatti.portata;")
        result = db.execute(query)
        serving = result.fetchall()
        serving_list: List[Serving] = [Serving(id=row[0], name=row[1], imageUrl=f"/static/img/{row[1].lower()}.jpg") for row in serving]
        return serving_list
    except Exception as e:
        error = f"Error during serving fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/carouselRecipes")
async def get_carousel_recipes(db: Session = Depends(get_db)):
    try:
        limit = 5
        query = text("SELECT id, nome_piatto, image_name FROM piatti ORDER BY RAND() LIMIT :limit;")
        result = db.execute(query, {"limit": limit})
        recipes = result.fetchall()
        carousel_recipes: List[Recipe] = [Recipe(id=row[0], name=row[1], imageUrl=f"/static/recipes/{row[2].lower()}") for row in recipes]
        return carousel_recipes
    except Exception as e:
        error = f"Error during carousel fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/filteredByServing")
async def get_serving_recipes(serving: str = Query(..., description="Serving to be filtered"), db: Session = Depends(get_db)):
    try:
        query = text("SELECT id, nome_piatto, difficolta, tempo, portata, provenienza, image_name FROM piatti WHERE portata = :serving;")
        result = db.execute(query, {"serving": serving})
        recipes = result.fetchall()
        recipes_by_serving: List[Recipe] = [Recipe(id=row[0], name=row[1], difficulty=row[2], time=row[3], servingName=row[4], provenance=row[5], imageUrl=f"/static/recipes/{row[6].lower()}") for row in recipes]
        return recipes_by_serving
    except Exception as e:
        error = f"Error during Filtered Serving Recipes Fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/searchRecipe")
async def get_search_recipe(recipeName: str = Query(..., description="Recipe name to be searched"), db: Session = Depends(get_db)):
    try:
        query = text("select id, nome_piatto, difficolta, tempo, portata, provenienza, image_name from piatti WHERE nome_piatto LIKE :recipeName;")
        result = db.execute(query, {"recipeName": "%"+recipeName+"%"})
        recipes = result.fetchall()
        searched_recipes: List[Recipe] = [Recipe(id=row[0], name=row[1], difficulty=row[2], time=row[3], servingName=row[4], provenance=row[5], imageUrl=f"/static/recipes/{row[6].lower()}") for row in recipes]
        return searched_recipes
    except Exception as e:
        error = f"Error during Search Recipe Fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/recipeByID")
async def get_recipe_by_id(recipeID: int = Query(..., description="Recipe ID to be searched"), db: Session = Depends(get_db)):
    try:
        query = text(
            "SELECT p.id, p.nome_piatto, p.difficolta, p.tempo, p.portata, p.provenienza, p.procedimento, p.image_name FROM piatti p WHERE p.id = :recipeID;")
        result = db.execute(query, {"recipeID": recipeID})
        row = result.fetchone()
        if row is None:
            error = "Recipe not found"
            print(error)
            raise HTTPException(status_code=404, detail=error)

        recipe_detail: Recipe = Recipe(id=row[0], name=row[1], difficulty=row[2], time=row[3], servingName=row[4], provenance=row[5], description=row[6], ingredients=[], imageUrl=f"/static/recipes/{row[7].lower()}")
        if recipe_detail is not None:
            query = text("SELECT i.id, i.nome_ingrediente, r.quantita_ingrediente FROM piatti p JOIN ricettario r ON p.id = r.id_piatto JOIN ingredienti i ON r.id_ingrediente = i.id WHERE p.id = :recipeID;")
            result = db.execute(query, {"recipeID": recipeID})
            ingredients = result.fetchall()
            recipe_detail.ingredients = [Ingredient(id=row[0], name=row[1], quantity=row[2]) for row in ingredients]

        return recipe_detail
    except Exception as e:
        error = f"Error during Recipe Detail Fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/isRecipeFavourite")
async def get_favourite_recipe(recipeID: int, userID: int, db: Session = Depends(get_db)):
    try:
        query = text("SELECT preferiti.id FROM preferiti WHERE id_utente = :userID AND id_piatto = :recipeID;")
        result = db.execute(query, {"userID": userID, "recipeID": recipeID})
        favourite = result.fetchone()
        if favourite is None:
            return False
        else:
            return True
    except Exception as e:
        error = f"Error during favourite check: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)

@app.get("/api/favouriteRecipes")
async def get_favourite_recipes(userID: int, db: Session = Depends(get_db)):
    try:
        query = text("SELECT p.id, nome_piatto, image_name FROM piatti p JOIN preferiti pref ON p.id = pref.id_piatto WHERE pref.id_utente = :userID AND pref.is_favourite = 1;")
        result = db.execute(query, {"userID": userID})
        recipes = result.fetchall()
        favourite_recipes: List[Recipe] = [Recipe(id=row[0], name=row[1], imageUrl=f"/static/recipes/{row[2].lower()}", isFavourite=True) for row in recipes]
        return favourite_recipes
    except Exception as e:
        error = f"Error during favourite fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/toggleFavourite")
async def get_favourite_recipes(userID: int, recipeID: int, db: Session = Depends(get_db)):
    try:
        query = text("SELECT id, is_favourite FROM preferiti WHERE id_utente = :userID AND id_piatto = :recipeID;")
        result = db.execute(query, {"userID": userID, "recipeID": recipeID})
        favourite = result.fetchone()
        if favourite is None:
            query = text("INSERT INTO preferiti (id_utente, id_piatto) VALUES (:userID, :recipeID)")
            if db.execute(query, {"userID": userID, "recipeID": recipeID}):
                db.commit()
                return True
            else:
                raise HTTPException(500, "Error during record creation")
        elif favourite[1] == 1:
            query = text("UPDATE preferiti SET is_favourite = '0' WHERE id_utente = :userID AND id_piatto = :recipeID;")
            if db.execute(query, {"userID": userID, "recipeID": recipeID}):
                db.commit()
                return False
            else:
                raise HTTPException(500, "Error during favourite toggle")
        elif favourite[1] == 0:
            query = text("UPDATE preferiti SET is_favourite = '1' WHERE id_utente = :userID AND id_piatto = :recipeID;")
            if db.execute(query, {"userID": userID, "recipeID": recipeID}):
                db.commit()
                return True
            else:
                raise HTTPException(500, "Error during favourite toggle")
    except Exception as e:
        error = f"Error: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/weeklyMenu")
async def get_weekly_menu(userID: int, db: Session = Depends(get_db)):
    try:
        query = text("""SELECT menu_settimanale.id, `data`, nome_piatto, image_name, tipo_pasto.id, nome_tipo_pasto FROM menu_settimanale JOIN piatti
                        ON id_piatto = piatti.id join tipo_pasto ON id_pasto = tipo_pasto.id WHERE id_utente = :userId
                        AND `data` BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 DAY) ORDER BY `data`, tipo_pasto.id;""")
        result = db.execute(query, {"userId": userID})
        menu = result.fetchall()
        weeklyMenu: List[WeeklyMenu] = [WeeklyMenu(id=row[0], name=row[1], imageUrl=f"/static/img/{row[2].lower()}.jpg", servingName=row[3]) for row in menu]
        return weeklyMenu
    except Exception as e:
        error = f"Error during serving fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/addWeeklyMenu")
async def add_weekly_menu(userID: int, recipeID: int, mealID: int, menuDate: str, db: Session = Depends(get_db)):
    try:
        query = text("INSERT INTO menu_settimanale (id_utente, id_piatto, id_pasto, data) VALUES (:userID, :recipeID, :mealID, :date)")
        if db.execute(query, {"userID": userID, "recipeID": recipeID, "mealID": mealID, "date": menuDate}):
            db.commit()
            return True
        return False
    except Exception as e:
        error = f"Error during serving fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


@app.get("/api/meals")
async def get_meals(db: Session = Depends(get_db)):
    try:
        query = text("SELECT * FROM tipo_pasto;")
        result = db.execute(query)
        mealResul = result.fetchall()
        meals: List[Meal] = [Meal(id=row[0], name=row[1]) for row in mealResul]
        return meals
    except Exception as e:
        error = f"Error during serving fetch: {e}"
        print(error)
        raise HTTPException(status_code=500, detail=error)


if __name__ == "__main__":
    try:
        ip_address = get_ip()
        connection = engine.connect()
        uvicorn.run(app, host=ip_address, port=8000)
    except KeyboardInterrupt:
        print("Program Closed")
