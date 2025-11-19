-- View 1
CREATE VIEW detalhes_pedidos_view AS
SELECT
    p.id_pedido,
    c.cliente_nome,
    p.pedido_data_pedido,
    p.pedido_status AS status_geral_pedido,
    pag.pagamento_tipo,
    pag.pagamento_status AS status_pagamento,
    pag.pagamento_valor AS valor_total_pago,
    e.envio_estado AS status_envio,
    e.envio_enviado_dia,
    e.envio_entregue_dia
FROM
    pedido p
JOIN
    cliente c ON p.id_cliente = c.id_cliente
JOIN
    pagamento pag ON p.id_pedido = pag.id_pedido
JOIN
    envio e ON p.id_pedido = e.id_pedido
ORDER BY
    p.id_pedido;

-- View 2
CREATE VIEW produtos_em_estoque_view AS
SELECT
    pr.produto_nome,
    pr.produto_preco,
    pr.produto_estoque,
    ca.categoria_nome
FROM
    produto pr
JOIN
    categoria ca ON pr.id_categoria = ca.id_categoria
WHERE
    pr.produto_estoque > 0
ORDER BY
    pr.produto_estoque DESC;

-- Teste view 1
SELECT * FROM detalhes_pedidos_view;

-- Teste view 2
SELECT * FROM produtos_em_estoque_view;