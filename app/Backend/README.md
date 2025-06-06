# Boteco Pro

**Autor:** Marcelo Santos (<a79433@ualg.pt>)  

---

## Descrição

Boteco Pro é um aplicativo para gestão de restaurantes, visando organizar cardápio, estoque, compras, funcionários, atendimento a clientes e faturamento. Este repositório contém:

- **docs/**: documentação das decisões de projeto e modelagem do banco de dados.
- **sql/**: scripts SQL para criação de tabelas, views, materialized views, functions, stored procedures, triggers e índices.

---

## Estrutura de Pastas

```
Backend/
├── README.md
├── docs/
│   ├── 01\_overview\.md
│   ├── 02\_modelagem.md
│   └── 03\_objetos\_consumo.md
└── sql/
├── 01\_create\_tables.sql
├── 02\_create\_views.sql
├── 03\_create\_materialized\_views.sql
├── 04\_create\_functions.sql
├── 05\_create\_stored\_procedures.sql
├── 06\_create\_triggers.sql
└── 07\_create\_indices.sql
└── test/
    ├── README.md
    ├── requirements.txt
    └── test_schema_creation.py
```

- **docs/**  
  - `01_overview.md`: visão geral do projeto, motivação e requisitos.  
  - `02_modelagem.md`: detalhamento de entidades, relacionamentos e DDL conceitual.  
  - `03_objetos_consumo.md`: lista de views, materialized views, functions e SPs para consumo via API.

- **sql/**  
  - `01_create_tables.sql`: scripts `CREATE TABLE` para todas as entidades.  
  - `02_create_views.sql`: scripts `CREATE VIEW` para consultas.  
  - `03_create_materialized_views.sql`: Indexed Views e materialized views.  
  - `04_create_functions.sql`: funções (scalar e table-valued).  
  - `05_create_stored_procedures.sql`: stored procedures para leitura parametrizada.
  - `06_create_triggers.sql`: triggers para abatimento de estoque, geração de encomendas e faturas.
  - `07_create_indices.sql`: índices adicionais (individual ou em materialized views).
- **test/**
  - scripts `pytest` para validar a criação de tabelas e objetos a partir dos scripts SQL.
