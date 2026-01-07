from fastapi import APIRouter, HTTPException
from models.schemas import FuncionarioLogin
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-funcionario-login")
def inserir_funcionario_login(login: FuncionarioLogin):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC InserirFuncionarioLogin ?, ?, ?",
            login.id_funcionario, login.username, login.senha_hash
        )
        conn.commit()
        return {"status": "Login de funcionário criado com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
