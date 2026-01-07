from fastapi import APIRouter, HTTPException
from models.schemas import Bebida
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-bebida")
def inserir_bebida(bebida: Bebida):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirBebida ?, ?, ?, ?, ?",
            bebida.nome, bebida.preco_venda, bebida.tempo_preparo, bebida.id_categoria, bebida.observacoes
        )
        conn.commit()
        return {"status": "Bebida inserida com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
