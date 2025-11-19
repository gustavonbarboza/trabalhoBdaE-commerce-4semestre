-- Funcao 1 (Atualizar o status dos pedidos)
CREATE OR REPLACE FUNCTION atualizar_status_pedido(
    p_id_pedido INTEGER,
    novo_status status_pedido_enum
)
RETURNS VOID AS $$
BEGIN
    UPDATE pedido
    SET pedido_status = novo_status
    WHERE id_pedido = p_id_pedido;

    RAISE NOTICE 'O status do pedido % foi atualizado para %.', p_id_pedido, novo_status;

END;
$$ LANGUAGE plpgsql;

-- TESTE
-- Executa a função para mudar o status do Pedido 5 para PENDENTE.
SELECT atualizar_status_pedido(5, 'PENDENTE');

-- Confirmação: Verifica o status atualizado do Pedido 5.
SELECT id_pedido, pedido_status
FROM pedido
WHERE id_pedido = 5;

-- Funcao 2 (Calcular valor total dos pedidos)
CREATE OR REPLACE FUNCTION calcular_valor_total_pedido(
    p_id_pedido INTEGER
)
RETURNS NUMERIC AS $$
DECLARE
    total_pedido NUMERIC;
BEGIN
    SELECT
        COALESCE(SUM(item_subtotal), 0) INTO total_pedido
    FROM
        item_pedido
    WHERE
        id_pedido = p_id_pedido;

    RETURN total_pedido;
END;
$$ LANGUAGE plpgsql;

-- Teste
-- Executa a função para obter o valor total do Pedido 4.
SELECT calcular_valor_total_pedido(4) AS valor_total_pedido_4;