from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from procedures import inserir_produto, inserir_prato, inserir_bebida, inserir_fornecedor, inserir_funcionario, inserir_funcionario_login, inserir_cliente, inserir_categoria, inserir_ingredientes, inserir_mesa

app = FastAPI(title="Boteco_PRO API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ou use ['http://localhost:xxxx'] se quiser restringir
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(inserir_produto.router)
app.include_router(inserir_prato.router)
app.include_router(inserir_bebida.router)
app.include_router(inserir_fornecedor.router)
app.include_router(inserir_funcionario.router)
app.include_router(inserir_funcionario_login.router)
app.include_router(inserir_cliente.router)
app.include_router(inserir_categoria.router)
app.include_router(inserir_ingredientes.router)
app.include_router(inserir_mesa.router)
