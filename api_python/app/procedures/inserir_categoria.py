from fastapi import APIRouter, HTTPException
from models.schemas import Categoria
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-categoria")
def inserir_categoria(categoria: Categoria):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirCategoria ?",
            categoria.nome
        )
        conn.commit()
        return {"status": "Categoria inserida com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
