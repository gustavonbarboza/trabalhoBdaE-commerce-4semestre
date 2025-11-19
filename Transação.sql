BEGIN;

-- Variáveis de exemplo (Em um sistema real, seriam passadas pelo código da aplicação)
-- Substitua pelos IDs reais para testar a funcionalidade
-- ID do Cliente (exemplo: Ellen Vitorino)
-- ID do Produto (exemplo: Camiseta Branca)
-- Quantidade comprada

-- insere um novo pedido (wimulando uma nova compra para o cliente 1)
INSERT INTO pedido (pedido_observacao, id_cliente) VALUES
('Pedido de teste para demonstrar COMMIT', 1);

-- pega o ID do pedido recém-criado
SELECT currval('pedido_id_pedido_seq') INTO id_novo_pedido;
-- se fosse em um código de aplicação, você obteria o ID_pedido retornado.
-- vamos assumir que o novo ID é o 11 para o exemplo (já que temos 10 inseridos)

-- insere o item_pedido (1 unidade do produto 1, preço R$ 49.90)
INSERT INTO item_pedido (item_quantidade, item_preco_unitario, id_pedido, id_produto) VALUES
(1, 49.90, 11, 1);

-- atualiza o estoque do Produto 1 (Camiseta Branca): Estoque = 100 - 1 = 99
UPDATE produto
SET produto_estoque = produto_estoque - 1
WHERE id_produto = 1;

-- tenta inserir o pagamento (se tudo correu bem até agora)
INSERT INTO pagamento (pagamento_tipo, pagamento_status, pagamento_valor, id_pedido) VALUES
('PIX', 'Aprovado', 49.90, 11);

-- confirma a transação, se todas as etapas acima funcionaram, elas são salvas.
COMMIT;

-- Se o estoque fosse insuficiente ou houvesse qualquer erro, faríamos:
-- ROLLBACK;