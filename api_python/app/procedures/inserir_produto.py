from fastapi import APIRouter, HTTPException
from models.schemas import Produto
from db.connection import get_connection

router = APIRouter()

@router.post("/inserir-produto")
def inserir_produto(produto: Produto):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            f"EXEC InserirProduto ?, ?, ?, ?, ?, ?, ?, ?",
            produto.nome, produto.descricao, produto.preco_custo, produto.stock_atual,
            produto.stock_minimo, produto.quantidade_encomenda, produto.data_ultima_encomenda, produto.id_fornecedor
        )
        conn.commit()
        return {"status": "Produto inserido com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
