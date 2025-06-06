-- =========================================================================
-- Script: 03_create_materialized_views.sql
-- Objetivo: Criação de Indexed Views / Materialized Views para relatórios
-- Observação: SQL Server não suporta parâmetros em VIEW, mas criamos Indexed View
-- que será filtrada via Stored Procedure quando necessário.
-- =========================================================================

/* ------------------------------------------------
   1. Indexed View: mv_estoque_utilizado_periodo
   ------------------------------------------------ */
/*
   Esta view agrupa todas as saídas de estoque por produto,
   armazenando quantidade total e datas de início/fim (mínima/máxima).
   Para que seja "materializada", criamos um índice clusterizado.
*/
CREATE VIEW mv_estoque_utilizado_periodo
WITH SCHEMABINDING
AS
    SELECT
        me.produto_id,
        SUM(me.quantidade) AS quantidade_total,
        MIN(me.data_movimentacao) AS data_inicio,
        MAX(me.data_movimentacao) AS data_fim
    FROM dbo.MovimentacaoEstoque AS me
    WHERE me.tipo = 'saida'
    GROUP BY me.produto_id;
GO

-- Índice clusterizado na Indexed View
CREATE UNIQUE CLUSTERED INDEX idx_mv_estoque_utilizado_periodo
    ON mv_estoque_utilizado_periodo (produto_id);
GO

/* ------------------------------------------------
   2. View de Consulta Detalhada: Estoque Utilizado por Nome de Produto
   ------------------------------------------------ */
/*
   Para permitir filtragem por nome do produto, unimos a Indexed View
   à tabela Produto e criamos índice não clusterizado sobre nome_produto.
*/
CREATE VIEW view_estoque_utilizado_detalhado AS
SELECT
    mv.produto_id,
    p.nome AS nome_produto,
    mv.quantidade_total,
    mv.data_inicio,
    mv.data_fim
FROM mv_estoque_utilizado_periodo AS mv
JOIN dbo.Produto p
    ON mv.produto_id = p.produto_id;
GO

