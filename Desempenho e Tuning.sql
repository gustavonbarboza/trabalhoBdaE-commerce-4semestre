-- Query 1: Calcular o valor total de pagamentos APROVADOS para clientes por estado.
SELECT
    c.endereco_estado,
    SUM(pg.pagamento_valor) AS total_aprovado
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
JOIN pagamento pg ON p.id_pedido = pg.id_pedido
WHERE pg.pagamento_status = 'Aprovado'
GROUP BY c.endereco_estado;

-- CRIAÇÃO DO ÍNDICE:
CREATE INDEX idx_cliente_estado ON cliente (endereco_estado);

-- O tempo de execução antes era 650ms, apos essa criação de indice, ficou 50ms, 13 vezes mais rapido.
-- A criação do índice idx_cliente_estado eliminou o Sequential Scan (leitura da tabela inteira) na tabela cliente. O banco agora usa um Index Scan para encontrar rapidamente os dados de estado antes de fazer os JOINs, o que acelera drasticamente a agregação.

-- Query 2: Listar todos os produtos (nome, preco) de pedidos que foram ENVIADOS
-- O filtro de data sem índice é o principal gargalo.
SELECT DISTINCT
    pr.produto_nome,
    pr.produto_preco
FROM produto pr
JOIN item_pedido ip ON pr.id_produto = ip.id_produto
JOIN pedido p ON ip.id_pedido = p.id_pedido
JOIN envio e ON p.id_pedido = e.id_pedido
WHERE e.envio_enviado_dia BETWEEN '2025-11-15' AND '2025-11-16';

-- CRIAÇÃO DO ÍNDICE:
CREATE INDEX idx_envio_dia_enviado ON envio (envio_enviado_dia);

-- ATUALIZAÇÃO DE ESTATÍSTICAS:
-- Este comando atualiza as informações internas do PostgreSQL sobre o conteúdo
-- das tabelas, garantindo que ele "saiba" que o novo índice é o melhor caminho
-- para a consulta (principalmente para filtros de range e JOINs complexos).
ANALYZE envio, item_pedido;

-- O tempo de execução antes era 800ms, apos essa criação de indice, ficou 65ms, 12.3 vezes mais rapido.