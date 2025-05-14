/*
===========================================
BOTECO PRO - SCRIPT DE CRIAÇÃO DO BANCO
===========================================
Banco: SQL Server (Google Cloud)
Autenticação: Firebase Auth com controle no banco de dados
API: API Flow
Aplicativo: Flutter multiplataforma
*/

-- Criação do banco de dados
CREATE DATABASE Boteco_PRO;
GO

USE Boteco_PRO;
GO

-- =============================================
-- TABELAS PRINCIPAIS DO SISTEMA
-- =============================================

-- Estabelecimento (Multitenancy)
CREATE TABLE Estabelecimento (
    id_estabelecimento INT IDENTITY(1,1) PRIMARY KEY,
    razao_social NVARCHAR(200) NOT NULL,
    nome_fantasia NVARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) NOT NULL,
    tipo_estabelecimento VARCHAR(50), -- (BAR, RESTAURANTE, MERCADO, BOATE)
    data_cadastro DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'ATIVO',
    config_json NVARCHAR(MAX), -- Configurações específicas do estabelecimento
    CONSTRAINT UK_CNPJ UNIQUE(cnpj)
);
CREATE INDEX IX_Estabelecimento_Status ON Estabelecimento(status);

-- Unidades de Medida
CREATE TABLE UnidadeMedida (
    id_unidade INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(50) NOT NULL,         -- Ex: "Mililitro", "Grama", "Unidade", "Dose"
    sigla VARCHAR(10) NOT NULL,        -- Ex: "ml", "g", "un", "dose"
    tipo VARCHAR(20),                  -- Ex: "volume", "peso", "quantidade"
    fator_conversao_base FLOAT,        -- Ex: 1 para unidade base, 1000 para litro->ml
    observacao NVARCHAR(100),
    ativo BIT DEFAULT 1
);

-- Categorias de Produto
CREATE TABLE CategoriaProduto (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    descricao NVARCHAR(MAX),
    id_categoria_pai INT NULL,
    publico_alvo VARCHAR(50),
    propriedades_json NVARCHAR(MAX),
    ativo BIT DEFAULT 1,
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_categoria_pai) REFERENCES CategoriaProduto(id_categoria)
);
CREATE INDEX IX_CategoriaProduto_Estabelecimento ON CategoriaProduto(id_estabelecimento);

-- Tipos de Apresentação
CREATE TABLE TipoApresentacao (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(50) NOT NULL,
    descricao NVARCHAR(100),
    id_unidade INT NOT NULL,
    volume FLOAT,
    ativo BIT DEFAULT 1,
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_unidade) REFERENCES UnidadeMedida(id_unidade)
);

-- Receitas
CREATE TABLE Receita (
    id_receita INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    descricao NVARCHAR(MAX),
    observacao NVARCHAR(MAX),
    ativo BIT DEFAULT 1,
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);

-- Produtos
CREATE TABLE Produto (
    id_produto INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    codigo VARCHAR(20),                -- Código interno do produto
    nome NVARCHAR(100) NOT NULL,
    descricao NVARCHAR(MAX),
    id_categoria INT NOT NULL,
    id_tipo_apresentacao INT NULL,
    id_unidade INT NOT NULL,
    preco_custo DECIMAL(10,2),
    preco_venda DECIMAL(10,2),
    margem_lucro DECIMAL(5,2),        -- Percentual de margem de lucro
    controla_estoque BIT DEFAULT 1,
    estoque_atual FLOAT,
    estoque_minimo FLOAT,
    data_validade DATE,
    codigo_barras VARCHAR(50),
    lote VARCHAR(50),
    imagem_url VARCHAR(255),
    ativo BIT DEFAULT 1,
    
    -- Flags de características
    is_ingrediente BIT DEFAULT 0,
    is_vendavel BIT DEFAULT 0,
    is_base_fruta BIT DEFAULT 0,
    is_destilado_base BIT DEFAULT 0,
    is_tabaco BIT DEFAULT 0,
    is_bebida BIT DEFAULT 0,
    is_alimento BIT DEFAULT 0,
    
    id_receita INT NULL, -- FK para a tabela Receita
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_categoria) REFERENCES CategoriaProduto(id_categoria),
    FOREIGN KEY (id_tipo_apresentacao) REFERENCES TipoApresentacao(id_tipo),
    FOREIGN KEY (id_unidade) REFERENCES UnidadeMedida(id_unidade),
    FOREIGN KEY (id_receita) REFERENCES Receita(id_receita)
);
CREATE INDEX IX_Produto_Estabelecimento ON Produto(id_estabelecimento);
CREATE INDEX IX_Produto_Categoria ON Produto(id_categoria);
CREATE INDEX IX_Produto_CodigoBarras ON Produto(codigo_barras) WHERE codigo_barras IS NOT NULL;

-- Produtos da Receita
CREATE TABLE ProdutoReceita (
    id_produto_receita INT IDENTITY(1,1) PRIMARY KEY,
    id_receita INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade FLOAT NOT NULL,
    id_unidade INT NOT NULL,
    observacao NVARCHAR(MAX),
    FOREIGN KEY (id_receita) REFERENCES Receita(id_receita),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_unidade) REFERENCES UnidadeMedida(id_unidade)
);
CREATE INDEX IX_ProdutoReceita_Receita ON ProdutoReceita(id_receita);

-- Motivo da Perda
CREATE TABLE MotivoPerda (
    id_motivo INT IDENTITY(1,1) PRIMARY KEY,
    descricao NVARCHAR(100) NOT NULL
);

-- Movimentação de Estoque
CREATE TABLE MovimentacaoEstoque (
    id_movimentacao INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    id_produto INT NOT NULL,
    data_movimentacao DATETIME DEFAULT GETDATE(),
    tipo_movimentacao VARCHAR(50),    -- ENTRADA, SAIDA, AJUSTE, PERDA, PRODUCAO
    quantidade FLOAT NOT NULL,
    id_unidade INT NOT NULL,
    valor_unitario DECIMAL(10,2),     -- Valor unitário na movimentação
    documento_referencia VARCHAR(50),  -- Nota fiscal, pedido, etc.
    observacao NVARCHAR(MAX),
    id_usuario INT,                   -- Usuário que realizou a movimentação
    id_motivo_perda INT NULL,         -- Motivo da perda/descarte
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_unidade) REFERENCES UnidadeMedida(id_unidade),
    FOREIGN KEY (id_motivo_perda) REFERENCES MotivoPerda(id_motivo)
);
CREATE INDEX IX_MovimentacaoEstoque_Estabelecimento_Produto ON MovimentacaoEstoque(id_estabelecimento, id_produto);
CREATE INDEX IX_MovimentacaoEstoque_Data ON MovimentacaoEstoque(data_movimentacao);

-- Mesa
CREATE TABLE Mesa (
    id_mesa INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    numero INT NOT NULL,
    descricao NVARCHAR(100),
    capacidade INT,
    status VARCHAR(50) DEFAULT 'LIVRE', -- LIVRE, OCUPADA, RESERVADA, MANUTENCAO
    ativo BIT DEFAULT 1,
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);
CREATE INDEX IX_Mesa_Estabelecimento_Status ON Mesa(id_estabelecimento, status);

-- Comanda
CREATE TABLE Comanda (
    id_comanda INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    numero VARCHAR(20),
    id_mesa INT NULL,
    data_abertura DATETIME DEFAULT GETDATE(),
    data_fechamento DATETIME,
    status VARCHAR(50),              -- ABERTA, FECHADA, CANCELADA
    valor_total DECIMAL(10,2),
    valor_desconto DECIMAL(10,2),
    valor_final DECIMAL(10,2),
    observacao NVARCHAR(MAX),
    id_usuario_abertura INT,
    id_usuario_fechamento INT,
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
);
CREATE INDEX IX_Comanda_Estabelecimento_Status ON Comanda(id_estabelecimento, status);
CREATE INDEX IX_Comanda_DataAbertura ON Comanda(data_abertura);

-- Usuários
CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha_hash VARCHAR(255) NULL,     -- Pode ser NULL se usar apenas Firebase Auth
    tipo_usuario VARCHAR(50),         -- ADMIN, GERENTE, GARCOM, COZINHEIRO, CAIXA
    status VARCHAR(20) DEFAULT 'ATIVO',
    data_cadastro DATETIME DEFAULT GETDATE(),
    ultimo_acesso DATETIME,
    firebase_uid VARCHAR(128),        -- UID do Firebase
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    CONSTRAINT UK_EMAIL UNIQUE(email)
);
CREATE INDEX IX_Usuario_Estabelecimento ON Usuario(id_estabelecimento);
CREATE INDEX IX_Usuario_FirebaseUID ON Usuario(firebase_uid) WHERE firebase_uid IS NOT NULL;

-- Permissões
CREATE TABLE Permissao (
    id_permissao INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(50) NOT NULL,
    descricao NVARCHAR(200),
    codigo VARCHAR(50) NOT NULL,      -- Código único da permissão
    CONSTRAINT UK_CODIGO_PERMISSAO UNIQUE(codigo)
);

-- Usuário x Permissão
CREATE TABLE UsuarioPermissao (
    id_usuario INT,
    id_permissao INT,
    PRIMARY KEY (id_usuario, id_permissao),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_permissao) REFERENCES Permissao(id_permissao)
);

-- Cliente
CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    cpf VARCHAR(11),
    data_nascimento DATE,
    data_cadastro DATETIME DEFAULT GETDATE(),
    pontos_fidelidade INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ATIVO',
    observacao NVARCHAR(MAX),
    tipo_cliente VARCHAR(50), -- VIP, Regular, Novo
    preferencias_json NVARCHAR(MAX),
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);
CREATE INDEX IX_Cliente_Estabelecimento ON Cliente(id_estabelecimento);
CREATE INDEX IX_Cliente_CPF ON Cliente(cpf) WHERE cpf IS NOT NULL;
CREATE INDEX IX_Cliente_Telefone ON Cliente(telefone) WHERE telefone IS NOT NULL;

-- Pedido
CREATE TABLE Pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    id_comanda INT NOT NULL,
    id_cliente INT NULL,
    numero_pedido VARCHAR(20),
    data_pedido DATETIME DEFAULT GETDATE(),
    origem VARCHAR(50),              -- BALCAO, MESA, DELIVERY, IFOOD, WHATSAPP
    status VARCHAR(50),              -- NOVO, PREPARANDO, PRONTO, ENTREGUE, CANCELADO
    valor_total DECIMAL(10,2),
    valor_desconto DECIMAL(10,2),
    valor_final DECIMAL(10,2),
    observacao NVARCHAR(MAX),
    id_usuario INT,                  -- Usuário que registrou o pedido
    motivo_cancelamento NVARCHAR(MAX),
    data_cancelamento DATETIME,
    id_usuario_cancelamento INT, -- FK para Usuario
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_usuario_cancelamento) REFERENCES Usuario(id_usuario)
);
CREATE INDEX IX_Pedido_Estabelecimento_Status ON Pedido(id_estabelecimento, status);
CREATE INDEX IX_Pedido_DataPedido ON Pedido(data_pedido);
CREATE INDEX IX_Pedido_Comanda ON Pedido(id_comanda);

-- Itens do Pedido
CREATE TABLE PedidoItem (
    id_pedido_item INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade FLOAT,
    valor_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    desconto DECIMAL(10,2),
    observacao NVARCHAR(MAX),
    status VARCHAR(50),              -- NOVO, PREPARANDO, PRONTO, ENTREGUE, CANCELADO
    
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);
CREATE INDEX IX_PedidoItem_Pedido ON PedidoItem(id_pedido);
CREATE INDEX IX_PedidoItem_Status ON PedidoItem(status);

-- Formas de Pagamento
CREATE TABLE FormaPagamento (
    id_forma_pagamento INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(50) NOT NULL,
    tipo VARCHAR(50),                -- DINHEIRO, CARTAO, PIX, VALE
    taxa DECIMAL(5,2),               -- Taxa cobrada pela operadora
    ativo BIT DEFAULT 1,
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);

-- Pagamentos
CREATE TABLE Pagamento (
    id_pagamento INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    id_comanda INT NOT NULL,
    id_forma_pagamento INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT GETDATE(),
    status VARCHAR(50),              -- PENDENTE, APROVADO, REJEITADO, ESTORNADO
    codigo_autorizacao VARCHAR(50),
    observacao NVARCHAR(MAX),
    motivo_estorno NVARCHAR(MAX),
    data_estorno DATETIME,
    id_usuario_estorno INT, -- FK para Usuario
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_forma_pagamento) REFERENCES FormaPagamento(id_forma_pagamento),
    FOREIGN KEY (id_usuario_estorno) REFERENCES Usuario(id_usuario)
);
CREATE INDEX IX_Pagamento_Comanda ON Pagamento(id_comanda);
CREATE INDEX IX_Pagamento_Data ON Pagamento(data_pagamento);

-- Fornecedor
CREATE TABLE Fornecedor (
    id_fornecedor INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    cnpj VARCHAR(14),
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco NVARCHAR(255),
    observacao NVARCHAR(MAX),
    ativo BIT DEFAULT 1,
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);

-- Compra
CREATE TABLE Compra (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    id_fornecedor INT NOT NULL,
    data_compra DATETIME DEFAULT GETDATE(),
    valor_total DECIMAL(10,2),
    status VARCHAR(50), -- ABERTA, RECEBIDA, CANCELADA
    observacao NVARCHAR(MAX),
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

-- Item da Compra
CREATE TABLE CompraItem (
    id_compra_item INT IDENTITY(1,1) PRIMARY KEY,
    id_compra INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade FLOAT,
    id_unidade INT NOT NULL,
    preco_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_unidade) REFERENCES UnidadeMedida(id_unidade)
);

-- Log de Auditoria
CREATE TABLE LogAuditoria (
    id_log INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    data_hora DATETIME DEFAULT GETDATE(),
    id_usuario INT,
    tabela VARCHAR(100),
    operacao VARCHAR(50),            -- INSERT, UPDATE, DELETE
    dados_antigos NVARCHAR(MAX),     -- JSON com dados antigos
    dados_novos NVARCHAR(MAX),       -- JSON com dados novos
    
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- =============================================
-- TABELAS DE CONTROLE DE USUÁRIOS ONLINE E SINCRONIZAÇÃO
-- =============================================

-- Usuários Online
CREATE TABLE UsuarioOnline (
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    setor VARCHAR(50), -- COZINHA, BAR, CAIXA, SALAO, ETC
    data_login DATETIME DEFAULT GETDATE(),
    data_ultimo_ping DATETIME,
    status VARCHAR(20) DEFAULT 'ONLINE',
    device_token VARCHAR(255), -- Para push notification
    versao_dados INT DEFAULT 0, -- Versão geral dos dados
    PRIMARY KEY (id_usuario, id_estabelecimento),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento)
);

-- Eventos do Sistema
CREATE TABLE EventoSistema (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    tipo_evento VARCHAR(50), -- NOVO_PEDIDO, PEDIDO_PRONTO, PEDIDO_CANCELADO, ETC
    id_pedido INT NULL,
    id_usuario INT NULL, -- Quem gerou o evento
    data_evento DATETIME DEFAULT GETDATE(),
    detalhes NVARCHAR(MAX),
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Notificações de Usuário
CREATE TABLE NotificacaoUsuario (
    id_notificacao INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDENTE', -- PENDENTE, ENVIADA, LIDA
    data_envio DATETIME,
    data_leitura DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_evento) REFERENCES EventoSistema(id_evento)
);

-- Tabelas Controladas
CREATE TABLE TabelaControlada (
    nome_tabela VARCHAR(100) PRIMARY KEY
);

-- Usuário x Tabela Controle
CREATE TABLE UsuarioTabelaControle (
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    nome_tabela VARCHAR(100) NOT NULL,
    precisa_atualizar BIT DEFAULT 0, -- 1 = precisa atualizar
    data_ultima_atualizacao DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (id_usuario, id_estabelecimento, nome_tabela),
    FOREIGN KEY (id_usuario, id_estabelecimento) REFERENCES UsuarioOnline(id_usuario, id_estabelecimento),
    FOREIGN KEY (nome_tabela) REFERENCES TabelaControlada(nome_tabela)
);

-- Inicialização de tabelas controladas
INSERT INTO TabelaControlada (nome_tabela) VALUES ('Pedido');
INSERT INTO TabelaControlada (nome_tabela) VALUES ('PedidoItem');
INSERT INTO TabelaControlada (nome_tabela) VALUES ('Produto');
INSERT INTO TabelaControlada (nome_tabela) VALUES ('Mesa');
INSERT INTO TabelaControlada (nome_tabela) VALUES ('Comanda');
INSERT INTO TabelaControlada (nome_tabela) VALUES ('MovimentacaoEstoque');

-- =============================================
-- STORED PROCEDURES E TRIGGERS
-- =============================================

-- SP: Notificar atualização de dados
CREATE PROCEDURE sp_NotificarAtualizacao
    @nome_tabela VARCHAR(100),
    @id_estabelecimento INT
AS
BEGIN
    -- Marca todos os usuários online do estabelecimento que precisam atualizar a tabela
    UPDATE UsuarioTabelaControle
    SET precisa_atualizar = 1
    WHERE nome_tabela = @nome_tabela
      AND id_estabelecimento = @id_estabelecimento
      AND EXISTS (SELECT 1 FROM UsuarioOnline uo 
                  WHERE uo.id_usuario = UsuarioTabelaControle.id_usuario 
                    AND uo.id_estabelecimento = UsuarioTabelaControle.id_estabelecimento
                    AND uo.status = 'ONLINE');

    -- Incrementa a versão geral dos dados para o estabelecimento
    UPDATE UsuarioOnline
    SET versao_dados = versao_dados + 1
    WHERE id_estabelecimento = @id_estabelecimento
      AND status = 'ONLINE';
END
GO

-- SP: Marcar tabela como atualizada
CREATE PROCEDURE sp_MarcarTabelaAtualizada
    @id_usuario INT,
    @id_estabelecimento INT,
    @nome_tabela VARCHAR(100)
AS
BEGIN
    UPDATE UsuarioTabelaControle
    SET precisa_atualizar = 0,
        data_ultima_atualizacao = GETDATE()
    WHERE id_usuario = @id_usuario
      AND id_estabelecimento = @id_estabelecimento
      AND nome_tabela = @nome_tabela;
END
GO

-- SP: Registrar Usuário Online
CREATE PROCEDURE sp_RegistrarUsuarioOnline
    @id_usuario INT,
    @id_estabelecimento INT,
    @setor VARCHAR(50),
    @device_token VARCHAR(255)
AS
BEGIN
    -- Verifica se o usuário já está online
    IF EXISTS (SELECT 1 FROM UsuarioOnline WHERE id_usuario = @id_usuario AND id_estabelecimento = @id_estabelecimento)
    BEGIN
        -- Atualiza o registro existente
        UPDATE UsuarioOnline
        SET data_ultimo_ping = GETDATE(),
            status = 'ONLINE',
            setor = @setor,
            device_token = ISNULL(@device_token, device_token)
        WHERE id_usuario = @id_usuario 
          AND id_estabelecimento = @id_estabelecimento;
    END
    ELSE
    BEGIN
        -- Insere um novo registro
        INSERT INTO UsuarioOnline (id_usuario, id_estabelecimento, setor, data_ultimo_ping, status, device_token)
        VALUES (@id_usuario, @id_estabelecimento, @setor, GETDATE(), 'ONLINE', @device_token);
        
        -- Inicializa as tabelas controladas para o usuário
        INSERT INTO UsuarioTabelaControle (id_usuario, id_estabelecimento, nome_tabela, precisa_atualizar)
        SELECT @id_usuario, @id_estabelecimento, nome_tabela, 0
        FROM TabelaControlada;
    END
    
    -- Atualiza último acesso na tabela de usuários
    UPDATE Usuario
    SET ultimo_acesso = GETDATE()
    WHERE id_usuario = @id_usuario;
END
GO

-- SP: Registrar Evento
CREATE PROCEDURE sp_RegistrarEvento
    @id_estabelecimento INT,
    @tipo_evento VARCHAR(50),
    @id_pedido INT = NULL,
    @id_usuario INT = NULL,
    @detalhes NVARCHAR(MAX) = NULL
AS
BEGIN
    -- Insere o evento
    DECLARE @id_evento INT;
    
    INSERT INTO EventoSistema (id_estabelecimento, tipo_evento, id_pedido, id_usuario, detalhes)
    VALUES (@id_estabelecimento, @tipo_evento, @id_pedido, @id_usuario, @detalhes);
    
    SET @id_evento = SCOPE_IDENTITY();
    
    -- Cria notificações para usuários relevantes baseado no tipo de evento
    -- NOVO_PEDIDO -> Notifica COZINHA/BAR
    -- PEDIDO_PRONTO -> Notifica GARÇONS
    -- PEDIDO_CANCELADO -> Notifica TODOS
    
    IF @tipo_evento = 'NOVO_PEDIDO'
    BEGIN
        INSERT INTO NotificacaoUsuario (id_usuario, id_evento)
        SELECT id_usuario, @id_evento
        FROM UsuarioOnline
        WHERE id_estabelecimento = @id_estabelecimento
          AND status = 'ONLINE'
          AND setor IN ('COZINHA', 'BAR');
    END
    ELSE IF @tipo_evento = 'PEDIDO_PRONTO'
    BEGIN
        INSERT INTO NotificacaoUsuario (id_usuario, id_evento)
        SELECT id_usuario, @id_evento
        FROM UsuarioOnline
        WHERE id_estabelecimento = @id_estabelecimento
          AND status = 'ONLINE'
          AND setor IN ('GARCOM', 'SALAO');
    END
    ELSE IF @tipo_evento = 'PEDIDO_CANCELADO'
    BEGIN
        INSERT INTO NotificacaoUsuario (id_usuario, id_evento)
        SELECT id_usuario, @id_evento
        FROM UsuarioOnline
        WHERE id_estabelecimento = @id_estabelecimento
          AND status = 'ONLINE';
    END
    
    -- Retorna o ID do evento criado
    SELECT @id_evento AS id_evento;
END
GO

-- SP: Criar Novo Pedido
CREATE PROCEDURE sp_CriarPedido
    @id_estabelecimento INT,
    @id_comanda INT,
    @id_cliente INT = NULL,
    @origem VARCHAR(50),
    @observacao NVARCHAR(MAX) = NULL,
    @id_usuario INT
AS
BEGIN
    DECLARE @id_pedido INT;
    DECLARE @numero_pedido VARCHAR(20);
    
    -- Gera um número de pedido baseado na data e sequencial
    SET @numero_pedido = CONCAT(FORMAT(GETDATE(), 'yyyyMMdd'), '-', 
                          RIGHT('000' + CAST(
                              (SELECT COUNT(*) + 1 FROM Pedido 
                               WHERE id_estabelecimento = @id_estabelecimento 
                                 AND CAST(data_pedido AS DATE) = CAST(GETDATE() AS DATE)) 
                          AS VARCHAR), 3));
    
    -- Insere o pedido
    INSERT INTO Pedido (id_estabelecimento, id_comanda, id_cliente, numero_pedido, 
                        origem, status, observacao, id_usuario)
    VALUES (@id_estabelecimento, @id_comanda, @id_cliente, @numero_pedido, 
            @origem, 'NOVO', @observacao, @id_usuario);
    
    SET @id_pedido = SCOPE_IDENTITY();
    
    -- Registra o evento de novo pedido
    EXEC sp_RegistrarEvento @id_estabelecimento, 'NOVO_PEDIDO', @id_pedido, @id_usuario;
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'Pedido', @id_estabelecimento;
    
    -- Retorna o ID do pedido criado
    SELECT @id_pedido AS id_pedido, @numero_pedido AS numero_pedido;
END
GO

-- SP: Adicionar Item ao Pedido
CREATE PROCEDURE sp_AdicionarItemPedido
    @id_pedido INT,
    @id_produto INT,
    @quantidade FLOAT,
    @observacao NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @id_estabelecimento INT;
    DECLARE @valor_unitario DECIMAL(10,2);
    DECLARE @valor_total DECIMAL(10,2);
    
    -- Obtém o estabelecimento e o preço do produto
    SELECT @id_estabelecimento = p.id_estabelecimento
    FROM Pedido p
    WHERE p.id_pedido = @id_pedido;
    
    SELECT @valor_unitario = preco_venda
    FROM Produto
    WHERE id_produto = @id_produto;
    
    SET @valor_total = @valor_unitario * @quantidade;
    
    -- Insere o item do pedido
    INSERT INTO PedidoItem (id_pedido, id_produto, quantidade, valor_unitario, 
                            valor_total, observacao, status)
    VALUES (@id_pedido, @id_produto, @quantidade, @valor_unitario, 
            @valor_total, @observacao, 'NOVO');
    
    -- Atualiza o valor total do pedido
    UPDATE Pedido
    SET valor_total = ISNULL(valor_total, 0) + @valor_total,
        valor_final = ISNULL(valor_final, 0) + @valor_total
    WHERE id_pedido = @id_pedido;
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'PedidoItem', @id_estabelecimento;
    EXEC sp_NotificarAtualizacao 'Pedido', @id_estabelecimento;
END
GO

-- SP: Atualizar Status do Pedido
CREATE PROCEDURE sp_AtualizarStatusPedido
    @id_pedido INT,
    @novo_status VARCHAR(50),
    @id_usuario INT,
    @motivo NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @id_estabelecimento INT;
    DECLARE @status_antigo VARCHAR(50);
    
    -- Obtém o estabelecimento e status atual
    SELECT @id_estabelecimento = id_estabelecimento,
           @status_antigo = status
    FROM Pedido
    WHERE id_pedido = @id_pedido;
    
    -- Atualiza o status do pedido
    UPDATE Pedido
    SET status = @novo_status,
        motivo_cancelamento = CASE WHEN @novo_status = 'CANCELADO' THEN @motivo ELSE motivo_cancelamento END,
        data_cancelamento = CASE WHEN @novo_status = 'CANCELADO' THEN GETDATE() ELSE data_cancelamento END,
        id_usuario_cancelamento = CASE WHEN @novo_status = 'CANCELADO' THEN @id_usuario ELSE id_usuario_cancelamento END
    WHERE id_pedido = @id_pedido;
    
    -- Registra o evento baseado no status
    IF @novo_status = 'PRONTO'
    BEGIN
        EXEC sp_RegistrarEvento @id_estabelecimento, 'PEDIDO_PRONTO', @id_pedido, @id_usuario;
    END
    ELSE IF @novo_status = 'CANCELADO'
    BEGIN
        EXEC sp_RegistrarEvento @id_estabelecimento, 'PEDIDO_CANCELADO', @id_pedido, @id_usuario, @motivo;
    END
    ELSE IF @novo_status = 'ENTREGUE'
    BEGIN
        EXEC sp_RegistrarEvento @id_estabelecimento, 'PEDIDO_ENTREGUE', @id_pedido, @id_usuario;
    END
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'Pedido', @id_estabelecimento;
END
GO

-- SP: Abrir Mesa/Comanda
CREATE PROCEDURE sp_AbrirComanda
    @id_estabelecimento INT,
    @id_mesa INT = NULL,
    @numero_comanda VARCHAR(20) = NULL,
    @id_usuario INT
AS
BEGIN
    DECLARE @id_comanda INT;
    
    -- Se a mesa estiver ocupada, retorna erro
    IF @id_mesa IS NOT NULL AND EXISTS (
        SELECT 1 FROM Mesa 
        WHERE id_mesa = @id_mesa 
          AND status <> 'LIVRE'
    )
    BEGIN
        RAISERROR('Mesa já está ocupada', 16, 1);
        RETURN;
    END
    
    -- Insere a comanda
    INSERT INTO Comanda (id_estabelecimento, numero, id_mesa, status, id_usuario_abertura)
    VALUES (@id_estabelecimento, @numero_comanda, @id_mesa, 'ABERTA', @id_usuario);
    
    SET @id_comanda = SCOPE_IDENTITY();
    
    -- Se tem mesa, atualiza o status da mesa
    IF @id_mesa IS NOT NULL
    BEGIN
        UPDATE Mesa
        SET status = 'OCUPADA'
        WHERE id_mesa = @id_mesa;
    END
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'Comanda', @id_estabelecimento;
    EXEC sp_NotificarAtualizacao 'Mesa', @id_estabelecimento;
    
    -- Retorna o ID da comanda criada
    SELECT @id_comanda AS id_comanda;
END
GO

-- SP: Fechar Comanda
CREATE PROCEDURE sp_FecharComanda
    @id_comanda INT,
    @id_usuario INT
AS
BEGIN
    DECLARE @id_estabelecimento INT;
    DECLARE @id_mesa INT;
    DECLARE @valor_total DECIMAL(10,2);
    DECLARE @valor_pago DECIMAL(10,2);
    
    -- Obtém dados da comanda
    SELECT @id_estabelecimento = id_estabelecimento,
           @id_mesa = id_mesa,
           @valor_total = valor_final
    FROM Comanda
    WHERE id_comanda = @id_comanda;
    
    -- Verifica se a comanda já está fechada
    IF EXISTS (SELECT 1 FROM Comanda WHERE id_comanda = @id_comanda AND status = 'FECHADA')
    BEGIN
        RAISERROR('Comanda já está fechada', 16, 1);
        RETURN;
    END
    
    -- Verifica se todos os pedidos estão finalizados
    IF EXISTS (
        SELECT 1 FROM Pedido 
        WHERE id_comanda = @id_comanda 
          AND status NOT IN ('ENTREGUE', 'CANCELADO')
    )
    BEGIN
        RAISERROR('Existem pedidos não finalizados para esta comanda', 16, 1);
        RETURN;
    END
    
    -- Verifica se o pagamento está completo
    SELECT @valor_pago = SUM(valor)
    FROM Pagamento
    WHERE id_comanda = @id_comanda
      AND status = 'APROVADO';
    
    IF @valor_pago < @valor_total
    BEGIN
        RAISERROR('Pagamento insuficiente para fechar a comanda', 16, 1);
        RETURN;
    END
    
    -- Fecha a comanda
    UPDATE Comanda
    SET status = 'FECHADA',
        data_fechamento = GETDATE(),
        id_usuario_fechamento = @id_usuario
    WHERE id_comanda = @id_comanda;
    
    -- Libera a mesa
    IF @id_mesa IS NOT NULL
    BEGIN
        UPDATE Mesa
        SET status = 'LIVRE'
        WHERE id_mesa = @id_mesa;
    END
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'Comanda', @id_estabelecimento;
    EXEC sp_NotificarAtualizacao 'Mesa', @id_estabelecimento;
END
GO

-- SP: Registrar Pagamento
CREATE PROCEDURE sp_RegistrarPagamento
    @id_comanda INT,
    @id_forma_pagamento INT,
    @valor DECIMAL(10,2),
    @observacao NVARCHAR(MAX) = NULL,
    @codigo_autorizacao VARCHAR(50) = NULL,
    @id_usuario INT
AS
BEGIN
    DECLARE @id_estabelecimento INT;
    
    -- Obtém o estabelecimento
    SELECT @id_estabelecimento = id_estabelecimento
    FROM Comanda
    WHERE id_comanda = @id_comanda;
    
    -- Insere o pagamento
    INSERT INTO Pagamento (id_estabelecimento, id_comanda, id_forma_pagamento, 
                          valor, status, codigo_autorizacao, observacao)
    VALUES (@id_estabelecimento, @id_comanda, @id_forma_pagamento, 
            @valor, 'APROVADO', @codigo_autorizacao, @observacao);
    
    -- Registra o evento
    EXEC sp_RegistrarEvento @id_estabelecimento, 'PAGAMENTO_REGISTRADO', NULL, @id_usuario, 
         CONCAT('Pagamento de R$ ', @valor, ' registrado para comanda #', @id_comanda);
    
    -- Notifica usuários que precisam atualizar
    EXEC sp_NotificarAtualizacao 'Pagamento', @id_estabelecimento;
END
GO

-- =============================================
-- TRIGGERS 
-- =============================================

-- Trigger: Atualização de Pedido
CREATE TRIGGER tr_Pedido_InsertUpdate
ON Pedido
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_estabelecimento INT;

    SELECT @id_estabelecimento = id_estabelecimento
    FROM inserted;

    EXEC sp_NotificarAtualizacao 'Pedido', @id_estabelecimento;
END
GO

-- Trigger: Atualização de Item de Pedido
CREATE TRIGGER tr_PedidoItem_InsertUpdate
ON PedidoItem
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_estabelecimento INT;

    SELECT @id_estabelecimento = p.id_estabelecimento
    FROM inserted i
    JOIN Pedido p ON i.id_pedido = p.id_pedido;

    EXEC sp_NotificarAtualizacao 'PedidoItem', @id_estabelecimento;
END
GO

-- Trigger: Atualização de Mesa
CREATE TRIGGER tr_Mesa_InsertUpdate
ON Mesa
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_estabelecimento INT;

    SELECT @id_estabelecimento = id_estabelecimento
    FROM inserted;

    EXEC sp_NotificarAtualizacao 'Mesa', @id_estabelecimento;
END
GO

-- Trigger: Atualização de Produto
CREATE TRIGGER tr_Produto_InsertUpdate
ON Produto
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_estabelecimento INT;

    SELECT @id_estabelecimento = id_estabelecimento
    FROM inserted;

    EXEC sp_NotificarAtualizacao 'Produto', @id_estabelecimento;
END
GO

-- Trigger: Atualização de Movimentação de Estoque
CREATE TRIGGER tr_MovimentacaoEstoque_InsertUpdate
ON MovimentacaoEstoque
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_estabelecimento INT;

    SELECT @id_estabelecimento = id_estabelecimento
    FROM inserted;

    EXEC sp_NotificarAtualizacao 'MovimentacaoEstoque', @id_estabelecimento;
END
GO

-- =============================================
-- VIEWS PARA FACILITAR CONSULTAS
-- =============================================

-- View: Pedidos Ativos
CREATE VIEW vw_PedidosAtivos
AS
SELECT p.id_pedido, p.id_estabelecimento, p.numero_pedido, p.data_pedido,
       p.origem, p.status, p.valor_total, p.valor_desconto, p.valor_final,
       c.id_comanda, c.numero AS numero_comanda, c.id_mesa,
       m.numero AS numero_mesa,
       cl.id_cliente, cl.nome AS nome_cliente,
       u.id_usuario, u.nome AS nome_usuario
FROM Pedido p
JOIN Comanda c ON p.id_comanda = c.id_comanda
LEFT JOIN Mesa m ON c.id_mesa = m.id_mesa
LEFT JOIN Cliente cl ON p.id_cliente = cl.id_cliente
LEFT JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE p.status IN ('NOVO', 'PREPARANDO', 'PRONTO')
GO

-- View: Itens de Pedidos Ativos
CREATE VIEW vw_ItensPedidosAtivos
AS
SELECT pi.id_pedido_item, pi.id_pedido, pi.id_produto, pi.quantidade,
       pi.valor_unitario, pi.valor_total, pi.status, pi.observacao,
       p.numero_pedido, p.data_pedido, p.origem, p.status AS status_pedido,
       prod.nome AS nome_produto, prod.descricao,
       c.id_comanda, c.numero AS numero_comanda,
       m.id_mesa, m.numero AS numero_mesa
FROM PedidoItem pi
JOIN Pedido p ON pi.id_pedido = p.id_pedido
JOIN Produto prod ON pi.id_produto = prod.id_produto
JOIN Comanda c ON p.id_comanda = c.id_comanda
LEFT JOIN Mesa m ON c.id_mesa = m.id_mesa
WHERE p.status IN ('NOVO', 'PREPARANDO', 'PRONTO')
  AND pi.status IN ('NOVO', 'PREPARANDO', 'PRONTO')
GO

-- View: Estoque Atual
CREATE VIEW vw_EstoqueAtual
AS
SELECT p.id_produto, p.id_estabelecimento, p.codigo, p.nome, p.descricao,
       p.preco_custo, p.preco_venda, p.estoque_atual, p.estoque_minimo,
       cp.nome AS categoria, um.nome AS unidade_medida, um.sigla
FROM Produto p
JOIN CategoriaProduto cp ON p.id_categoria = cp.id_categoria
JOIN UnidadeMedida um ON p.id_unidade = um.id_unidade
WHERE p.ativo = 1
GO

-- View: Status Mesas
CREATE VIEW vw_StatusMesas
AS
SELECT m.id_mesa, m.id_estabelecimento, m.numero, m.capacidade, m.status,
       c.id_comanda, c.data_abertura, c.valor_total,
       COUNT(p.id_pedido) AS total_pedidos,
       SUM(CASE WHEN p.status IN ('NOVO', 'PREPARANDO', 'PRONTO') THEN 1 ELSE 0 END) AS pedidos_em_andamento
FROM Mesa m
LEFT JOIN Comanda c ON m.id_mesa = c.id_mesa AND c.status = 'ABERTA'
LEFT JOIN Pedido p ON c.id_comanda = p.id_comanda
GROUP BY m.id_mesa, m.id_estabelecimento, m.numero, m.capacidade, m.status,
         c.id_comanda, c.data_abertura, c.valor_total
GO

-- View: Vendas do Dia
CREATE VIEW vw_VendasDoDia
AS
SELECT 
    p.id_estabelecimento,
    CAST(p.data_pedido AS DATE) AS data,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(p.valor_final) AS valor_total_vendas,
    COUNT(DISTINCT c.id_comanda) AS total_comandas,
    COUNT(DISTINCT c.id_mesa) AS total_mesas_atendidas
FROM Pedido p
JOIN Comanda c ON p.id_comanda = c.id_comanda
WHERE p.status = 'ENTREGUE'
GROUP BY p.id_estabelecimento, CAST(p.data_pedido AS DATE)
GO

-- View: Notificações Pendentes
CREATE VIEW vw_NotificacoesPendentes
AS
SELECT 
    nu.id_notificacao, nu.id_usuario, nu.id_evento, nu.status,
    es.id_estabelecimento, es.tipo_evento, es.data_evento, es.detalhes,
    u.nome AS nome_usuario
FROM NotificacaoUsuario nu
JOIN EventoSistema es ON nu.id_evento = es.id_evento
JOIN Usuario u ON nu.id_usuario = u.id_usuario
WHERE nu.status = 'PENDENTE'
GO

-- View: Atualizações Pendentes
CREATE VIEW vw_AtualizacoesPendentes
AS
SELECT 
    utc.id_usuario, utc.id_estabelecimento, utc.nome_tabela, 
    utc.precisa_atualizar, utc.data_ultima_atualizacao,
    uo.setor, uo.status AS status_online,
    u.nome AS nome_usuario
FROM UsuarioTabelaControle utc
JOIN UsuarioOnline uo ON utc.id_usuario = uo.id_usuario AND utc.id_estabelecimento = uo.id_estabelecimento
JOIN Usuario u ON utc.id_usuario = u.id_usuario
WHERE utc.precisa_atualizar = 1
  AND uo.status = 'ONLINE'
GO