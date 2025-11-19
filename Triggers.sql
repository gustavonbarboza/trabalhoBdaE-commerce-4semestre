-- Triggers
-- Tabela auditoria, registra eventos importante, como insert, delete e update
CREATE TABLE tb_auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    tabela_afetada VARCHAR(50),
    acao VARCHAR(10),
    registro_id INTEGER,
    data_evento TIMESTAMPTZ DEFAULT NOW(),
    usuario_banco TEXT DEFAULT CURRENT_USER
);

--Função da auditoria
CREATE OR REPLACE FUNCTION fn_auditoria_produto()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tb_auditoria (tabela_afetada, acao, registro_id)
    VALUES ('produto', TG_OP, COALESCE(NEW.id_produto, OLD.id_produto));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Triggers para INSERT, UPDATE e DELETE
CREATE TRIGGER trg_auditoria_produto_insert
AFTER INSERT ON produto
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_produto();

CREATE TRIGGER trg_auditoria_produto_update
AFTER UPDATE ON produto
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_produto();

CREATE TRIGGER trg_auditoria_produto_delete
AFTER DELETE ON produto
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_produto();

--Trigger de Validação
--Função 
CREATE OR REPLACE FUNCTION fn_valida_estoque()
RETURNS TRIGGER AS $$
DECLARE
    estoque NUMERIC;
BEGIN
    SELECT produto_estoque INTO estoque
    FROM produto
    WHERE id_produto = NEW.id_produto;

    IF estoque < NEW.item_quantidade THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto %', NEW.id_produto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Trigger 
CREATE TRIGGER trg_valida_estoque
BEFORE INSERT ON item_pedido
FOR EACH ROW
EXECUTE FUNCTION fn_valida_estoque();

--Trigger de Automação
--Função
CREATE OR REPLACE FUNCTION fn_atualiza_status_pedido()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.pagamento_status = 'Aprovado' THEN
        UPDATE pedido
        SET pedido_status = 'ENVIADO'
        WHERE id_pedido = NEW.id_pedido;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Trigger
CREATE TRIGGER trg_atualiza_status_pedido
AFTER UPDATE ON pagamento
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_status_pedido();


--TESTES (INSERIR NO SEU BANCO PARA DEMONSTRAR FUNCIONAMENTO)

--Teste da auditoria
INSERT INTO produto (produto_nome, produto_preco, produto_estoque)
VALUES ('Camiseta Azul', 49.90, 10);

UPDATE produto
SET produto_preco = 59.90
WHERE id_produto = 1;

--É necessário antes fazer o delete também de item_pedido, pois o produto é referenciado pela tabela item_pedido
DELETE FROM item_pedido
WHERE id_produto = 1;

DELETE FROM produto
WHERE id_produto = 1;

SELECT * FROM tb_auditoria;

--Teste da validação de estoque
-- Primeiro inserir um produto com estoque 5
INSERT INTO produto (produto_nome, produto_preco, produto_estoque)
VALUES ('Mouse Gamer', 100, 5);

-- Tenta vender mais que o estoque:
INSERT INTO item_pedido (item_quantidade, item_preco_unitario, id_pedido, id_produto)
VALUES (1000, 100, 1, 2);


--Teste da Automação
-- Cria pedido e pagamento pendente
INSERT INTO pedido (id_cliente) VALUES (1);

INSERT INTO pagamento (pagamento_tipo, pagamento_status, pagamento_valor, id_pedido)
VALUES (
  'BOLETO',
  'Pendente',
  200,
  (SELECT MAX(id_pedido) FROM pedido WHERE id_cliente = 1)
);

select *from pedido;
select *from pagamento;

-- Aprova pagamento
UPDATE pagamento
SET pagamento_status = 'Aprovado'
WHERE id_pedido = (SELECT MAX(id_pedido) FROM pedido WHERE id_cliente = 1);

-- Verifica pedido
select *from pedido;
select *from pagamento;



