from fastapi import APIRouter, HTTPException
from models.schemas import Mesa
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-mesa")
def inserir_mesa(mesa: Mesa):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        query = "EXEC InserirMesa @numero = ?, @lugares = ?"
        cursor.execute(query, f'{mesa.numero}', f'{mesa.lugares}')
        conn.commit()
        return {"status": "Mesa inserida com sucesso"}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
