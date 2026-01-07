from fastapi import APIRouter, HTTPException
from models.schemas import Fornecedor
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-fornecedor")
def inserir_fornecedor(fornecedor: Fornecedor):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirFornecedor ?, ?, ?",
            fornecedor.nome, fornecedor.email, fornecedor.telefone
        )
        conn.commit()
        return {"status": "Fornecedor inserido com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
