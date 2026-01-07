from fastapi import APIRouter, HTTPException
from models.schemas import Prato
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-prato")
def inserir_prato(prato: Prato):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirPrato ?, ?, ?, ?, ?",
            prato.nome, prato.preco_venda, prato.tempo_preparo, prato.id_categoria, prato.observacoes
        )
        conn.commit()
        return {"status": "Prato inserido com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
