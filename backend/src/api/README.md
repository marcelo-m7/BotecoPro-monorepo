# Boteco Pro API

Este diretório reunirá a implementação da API em Python.

## Dependências sugeridas

- [FastAPI](https://fastapi.tiangolo.com/) e `uvicorn` para o servidor HTTP.
- `pyodbc` para conexão ao **Microsoft SQL Server**.
- `python-dotenv` (opcional) para carregar variáveis de ambiente em desenvolvimento.

Crie um arquivo `requirements.txt` com estas bibliotecas para facilitar a instalação.

## Executando em desenvolvimento

```bash
pip install -r requirements.txt
uvicorn app:app --reload
```

O módulo de conexão deverá ler a string ODBC da variável `BOTECOPRO_DB_DSN`. Certifique-se de que o banco esteja acessível em `localhost`.

## Objetivo das Rotas

As rotas da API deverão executar as Views e Stored Procedures descritas em `../../docs/05_api_crud.md`. Cada operação deverá retornar JSON para consumo pelo frontend React.
