-- Índices essenciais (execute uma vez)
CREATE INDEX IF NOT EXISTS idx_itempedido_id_produto ON item_pedido(id_produto);
CREATE INDEX IF NOT EXISTS idx_itempedido_id_pedido ON item_pedido(id_pedido);
CREATE INDEX IF NOT EXISTS idx_pedido_id_cliente ON pedido(id_cliente);
CREATE INDEX IF NOT EXISTS idx_pedido_data ON pedido(pedido_data_pedido);
CREATE INDEX IF NOT EXISTS idx_pagamento_id_pedido ON pagamento(id_pedido);
CREATE INDEX IF NOT EXISTS idx_pagamento_status_dia ON pagamento(pagamento_status, pagamento_dia);
CREATE INDEX IF NOT EXISTS idx_produto_categoria ON produto(id_categoria);

-- Atualiza estatísticas do PostgreSQL (importantíssimo antes de medir)
ANALYZE;

-- Consulta A: vendas por categoria (todos os pagamentos "Aprovado")
SELECT
  c.id_categoria,
  c.categoria_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_vendido,
  AVG(ip.item_preco_unitario) AS preco_medio
FROM categoria c
JOIN produto prod ON prod.id_categoria = c.id_categoria
JOIN item_pedido ip ON ip.id_produto = prod.id_produto
JOIN pedido p ON p.id_pedido = ip.id_pedido
JOIN pagamento pay ON pay.id_pedido = p.id_pedido
WHERE pay.pagamento_status = 'Aprovado'
GROUP BY c.id_categoria, c.categoria_nome
ORDER BY total_vendido DESC;

-- Plano estimado (não executa a query)
EXPLAIN
SELECT
  c.id_categoria,
  c.categoria_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_vendido,
  AVG(ip.item_preco_unitario) AS preco_medio
FROM categoria c
JOIN produto prod ON prod.id_categoria = c.id_categoria
JOIN item_pedido ip ON ip.id_produto = prod.id_produto
JOIN pedido p ON p.id_pedido = ip.id_pedido
JOIN pagamento pay ON pay.id_pedido = p.id_pedido
WHERE pay.pagamento_status = 'Aprovado'
GROUP BY c.id_categoria, c.categoria_nome
ORDER BY total_vendido DESC;

-- Plano com execução real e I/O
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT
  c.id_categoria,
  c.categoria_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_vendido,
  AVG(ip.item_preco_unitario) AS preco_medio
FROM categoria c
JOIN produto prod ON prod.id_categoria = c.id_categoria
JOIN item_pedido ip ON ip.id_produto = prod.id_produto
JOIN pedido p ON p.id_pedido = ip.id_pedido
JOIN pagamento pay ON pay.id_pedido = p.id_pedido
WHERE pay.pagamento_status = 'Aprovado'
GROUP BY c.id_categoria, c.categoria_nome
ORDER BY total_vendido DESC;


-- Consulta B: Mostrar clientes com pelo menos 1 pedido aprovado
SELECT
  cl.id_cliente,
  cl.cliente_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_gasto,
  AVG(pag.pagamento_valor) AS media_pagamento_por_pedido,
  MAX(p.pedido_data_pedido) AS ultima_data_pedido
FROM cliente cl
JOIN pedido p ON p.id_cliente = cl.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN pagamento pag ON pag.id_pedido = p.id_pedido
WHERE pag.pagamento_status = 'Aprovado'
GROUP BY cl.id_cliente, cl.cliente_nome
HAVING COUNT(DISTINCT p.id_pedido) >= 1
ORDER BY total_gasto DESC;


--mostra como o PostgreSQL planejou executar a consulta.
EXPLAIN
SELECT
  cl.id_cliente,
  cl.cliente_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_gasto,
  AVG(pag.pagamento_valor) AS media_pagamento_por_pedido,
  MAX(p.pedido_data_pedido) AS ultima_data_pedido
FROM cliente cl
JOIN pedido p ON p.id_cliente = cl.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN pagamento pag ON pag.id_pedido = p.id_pedido
WHERE pag.pagamento_status = 'Aprovado'
GROUP BY cl.id_cliente, cl.cliente_nome
HAVING COUNT(DISTINCT p.id_pedido) >= 1
ORDER BY total_gasto DESC;


--ANALYZE(Executa a consulta de verdade) | BUFFERS (Mostra como o banco acessou os dados na memória/disk:) | TIMING (Mostra o tempo gasto em cada operação do plano) 
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT
  cl.id_cliente,
  cl.cliente_nome,
  COUNT(DISTINCT p.id_pedido) AS numero_pedidos,
  SUM(ip.item_quantidade * ip.item_preco_unitario) AS total_gasto,
  AVG(pag.pagamento_valor) AS media_pagamento_por_pedido,
  MAX(p.pedido_data_pedido) AS ultima_data_pedido
FROM cliente cl
JOIN pedido p ON p.id_cliente = cl.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN pagamento pag ON pag.id_pedido = p.id_pedido
WHERE pag.pagamento_status = 'Aprovado'
GROUP BY cl.id_cliente, cl.cliente_nome
HAVING COUNT(DISTINCT p.id_pedido) >= 1
ORDER BY total_gasto DESC;