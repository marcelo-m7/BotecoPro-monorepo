from fastapi import APIRouter, HTTPException
from models.schemas import Funcionario
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-funcionario")
def inserir_funcionario(funcionario: Funcionario):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirFuncionario ?, ?, ?, ?, ?, ?",
            funcionario.nome, funcionario.data_admissao, funcionario.valor_hora,
            funcionario.id_carreira, funcionario.id_nivel_carreira, funcionario.senha_hash
        )
        conn.commit()
        return {"status": "Funcionário inserido com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
