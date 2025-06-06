# Instruções para Agentes - Backend API

Este arquivo orienta os próximos agentes na implementação da API do **Boteco Pro**.

## Objetivo

Criar uma API em Python (sugere-se usar [FastAPI](https://fastapi.tiangolo.com/)) para expor as Views e Stored Procedures definidas nos scripts SQL de `src/db/sql/`.

## Conexão com o Banco

1. A base de dados roda localmente em um servidor **Microsoft SQL Server**.
2. Utilize `pyodbc` para abrir a conexão. A string ODBC deve vir da variável de ambiente `BOTECOPRO_DB_DSN`.
3. Futuramente os scripts de `src/db/` poderão incluir configurações para conexão via Google Cloud; mantenha o código preparado para receber a string de conexão via variável de ambiente.

## Tarefas Recomendadas

1. Configurar a estrutura de projeto dentro de `backend/src/api/` utilizando FastAPI.
2. Criar um módulo de conexão reutilizável que leia `BOTECOPRO_DB_DSN` e exponha funções para executar consultas e stored procedures.
3. Implementar rotas de exemplo baseadas em `backend/docs/05_api_crud.md`. Cada rota deverá:
   - Abrir conexão via pyodbc;
   - Executar a view ou stored procedure correspondente;
   - Retornar os resultados em JSON.
4. Adicionar README em `backend/src/api/` explicando como iniciar a API (instalar dependências, executar `uvicorn`, etc.).
5. Manter testes em `src/test/` funcionando. Se necessário, adicione testes para a API.

Siga boas práticas de codificação e documente qualquer decisão relevante em commits claros.
