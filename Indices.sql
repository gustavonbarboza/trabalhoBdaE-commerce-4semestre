-- A busca por CPF passou de varredura completa para acesso direto, reduzindo tempo. 
-- O índice composto (cliente + data) otimizou filtros e ordenações em relatórios de pedidos.
-- O índice único no email garantiu integridade e tornou a consulta mais rápida. 
-- Assim, comprovou-se que os índices melhoram eficiência e confiabilidade nas consultas do sistema.

-- Criar o índice simples
CREATE INDEX idx_cliente_cpf ON cliente(cliente_cpf);

-- Índice composto: relatórios por cliente e data
CREATE INDEX idx_pedido_cliente_data ON pedido(id_cliente, pedido_data_pedido);

-- Índice único: reforço na unicidade do email
CREATE UNIQUE INDEX idx_cliente_email_unico ON cliente(cliente_email);

--Consulta 1– Busca por CPF (índice simples)
EXPLAIN ANALYZE
SELECT cliente_nome, cliente_email
FROM cliente
WHERE cliente_cpf = '12345678901';

--Consulta 2– Pedidos por cliente e data (índice composto)
EXPLAIN ANALYZE
SELECT p.id_pedido, p.pedido_data_pedido, c.cliente_nome
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.id_cliente = 1
ORDER BY p.pedido_data_pedido DESC;

--Consulta 1- Busca por email (índice único)
EXPLAIN ANALYZE
SELECT cliente_nome
FROM cliente
WHERE cliente_email = 'ellen.vitorino@email.com';


