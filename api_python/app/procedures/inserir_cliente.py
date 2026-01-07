from fastapi import APIRouter, HTTPException
from models.schemas import Cliente
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-cliente")
def inserir_cliente(cliente: Cliente):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirCliente ?, ?, ?, ?, ?, ?",
            cliente.nome, cliente.nif, cliente.morada,
            cliente.localidade, cliente.codigo_postal, cliente.tipo_cliente
        )
        conn.commit()
        return {"status": "Cliente inserido com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
