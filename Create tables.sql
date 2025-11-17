CREATE TYPE status_pedido_enum AS ENUM ('PENDENTE', 'ENVIADO', 'ENTREGUE');
CREATE TYPE tipo_pagamento_enum AS ENUM ('PIX', 'CARTAO', 'BOLETO');
CREATE TYPE status_envio_enum AS ENUM ('PREPARANDO', 'EM ROTA', 'ENTREGUE');

--  Tabela Cliente
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    cliente_nome VARCHAR(100) NOT NULL,
    cliente_cpf CHAR(11) UNIQUE,
    cliente_telefone VARCHAR(15),
    cliente_email VARCHAR(50) UNIQUE,
    endereco_logradouro VARCHAR(100) NOT NULL,
    endereco_cep VARCHAR(12) NOT NULL,
    endereco_cidade VARCHAR(100) NOT NULL,
    endereco_estado CHAR(2) NOT NULL, -- sigla do estado (UF)
    endereco_pais VARCHAR(40)
);

-- Tabela Pedido (vem logo abaixo de Cliente)
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    pedido_data_pedido TIMESTAMPTZ DEFAULT NOW(),
    pedido_status status_pedido_enum DEFAULT 'PENDENTE',
    pedido_observacao TEXT,
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente)
);

-- Tabela Categoria (Deve ser criada antes de Produto)
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    categoria_nome VARCHAR(50) NOT NULL,
    categoria_descricao TEXT
);

-- Tabela Produto
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    produto_nome VARCHAR(150) NOT NULL,
    produto_descricao TEXT,
    produto_preco NUMERIC(12, 2) NOT NULL,
    produto_estoque INTEGER DEFAULT 0,
    id_categoria INTEGER REFERENCES categoria(id_categoria)
);

-- Tabela Item_Pedido
CREATE TABLE item_pedido (
    id_item SERIAL PRIMARY KEY,
    item_quantidade INTEGER NOT NULL,
    item_preco_unitario NUMERIC(12, 2) NOT NULL,
    item_subtotal NUMERIC(12, 2) GENERATED ALWAYS AS (item_quantidade * item_preco_unitario) STORED,
    id_pedido INTEGER NOT NULL REFERENCES pedido(id_pedido),
    id_produto INTEGER NOT NULL REFERENCES produto(id_produto)
);

-- Tabela Pagamento (1:1 com Pedido)
-- Relação 1:1 com Pedido (Um pedido tem um único pagamento)
CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    pagamento_tipo tipo_pagamento_enum NOT NULL,
    pagamento_status VARCHAR(20) CHECK (pagamento_status IN ('Aprovado', 'Pendente', 'Cancelado')),
    pagamento_dia TIMESTAMPTZ DEFAULT NOW(),
    pagamento_valor NUMERIC(10, 2) NOT NULL,
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedido(id_pedido)
);

-- Tabela Envio (1:1 com Pedido)
-- Relação 1:1 com Pedido
CREATE TABLE envio (
    id_envio SERIAL PRIMARY KEY,
    envio_enviado_dia DATE,
    envio_entregue_dia TIMESTAMPTZ,
    envio_estado status_envio_enum DEFAULT 'PREPARANDO',
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedido(id_pedido)
);

