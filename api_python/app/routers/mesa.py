from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.db import get_connection

router = APIRouter( tags=["Mesa"])

class Mesa(BaseModel):
    numero: int
    lugares: int

@router.post("/inserir-mesa")
def inserir_mesa(data: Mesa):
    
    conn = get_connection()
    cursor = conn.cursor()
    try:
        response = cursor.execute(
        f"""
        select * from dbo.Mesa
        """,
        )

        print(response)

        if response: 
            return {"status": "Mesa inserida com sucesso", "response": str(response)}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
        return {"status": "Erro ao inserir mesa"}
