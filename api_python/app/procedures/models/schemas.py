from pydantic import BaseModel

class Produto(BaseModel):
    nome: str
    descricao: str
    preco_custo: float
    stock_atual: int
    stock_minimo: int
    quantidade_encomenda: int
    data_ultima_encomenda: str
    id_fornecedor: int

class Prato(BaseModel):
    nome: str
    preco_venda: float
    tempo_preparo: str
    id_categoria: int
    observacoes: str

class Bebida(Prato): pass

class Fornecedor(BaseModel):
    nome: str
    email: str
    telefone: str

class Funcionario(BaseModel):
    nome: str
    data_admissao: str
    valor_hora: float
    id_carreira: int
    id_nivel_carreira: int
    senha_hash: str

class FuncionarioLogin(BaseModel):
    id_funcionario: int
    username: str
    senha_hash: str

class Cliente(BaseModel):
    nome: str
    nif: str
    morada: str
    localidade: str
    codigo_postal: str
    tipo_cliente: str

class Categoria(BaseModel):
    nome: str

class IngredientePrato(BaseModel):
    id_prato: int
    id_produto: int
    quantidade_utilizada: int

class Mesa(BaseModel):
    numero: int
    lugares: int
