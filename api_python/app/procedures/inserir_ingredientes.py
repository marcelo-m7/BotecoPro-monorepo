from fastapi import APIRouter, HTTPException
from models.schemas import IngredientePrato
from db.connection import get_connection

router = APIRouter()

@router.post("/associar-ingredientes")
def associar_ingredientes(ingrediente: IngredientePrato):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC AssociarIngredientesAoPrato ?, ?, ?",
            ingrediente.id_prato, ingrediente.id_produto, ingrediente.quantidade_utilizada
        )
        conn.commit()
        return {"status": "Ingrediente associado com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
