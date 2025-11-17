--SELECT 1: Lista os pedidos com nome do cliente e status do pagamento,cruzando as tabelas pedido, cliente e pagamento.
--SELECT 2: Mostra os produtos comprados em cada pedido, com quantidade e valor total, usando item_pedido e produto.
--SELECT 3: Soma os valores pagos por tipo de pagamento, filtrando apenas os aprovados, agrupando por pagamento_tipo.
--SELECT 4: Exibe os pedidos que ainda não foram entregues, mostrando o estado atual do envio e o nome do cliente.
--SELECT 5: Conta quantos itens de cada produto foram vendidos, agrupando por nome do produto e ordenando por quantidade.

--1
SELECT 
    p.id_pedido,
    c.cliente_nome,
    pg.pagamento_status,
    pg.pagamento_valor
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id_cliente
JOIN pagamento pg ON p.id_pedido = pg.id_pedido;

--2
SELECT 
    p.id_pedido,
    pr.produto_nome,
    ip.item_quantidade,
    ip.item_preco_unitario,
    (ip.item_quantidade * ip.item_preco_unitario) AS valor_total
FROM item_pedido ip
JOIN produto pr ON ip.id_produto = pr.id_produto
JOIN pedido p ON ip.id_pedido = p.id_pedido;

--3
SELECT 
    pagamento_tipo,
    SUM(pagamento_valor) AS total_vendas
FROM pagamento
WHERE pagamento_status = 'Aprovado'
GROUP BY pagamento_tipo;

--4
SELECT 
    p.id_pedido,
    c.cliente_nome,
    e.envio_estado
FROM envio e
JOIN pedido p ON e.id_pedido = p.id_pedido
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE e.envio_estado != 'ENTREGUE';

--5
SELECT 
    pr.produto_nome,
    SUM(ip.item_quantidade) AS total_vendido
FROM item_pedido ip
JOIN produto pr ON ip.id_produto = pr.id_produto
GROUP BY pr.produto_nome
ORDER BY total_vendido DESC;


