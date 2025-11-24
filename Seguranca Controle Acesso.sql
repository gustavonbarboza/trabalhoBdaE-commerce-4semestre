-- Criar usuários
CREATE USER admin_user WITH PASSWORD 'admin123';
CREATE USER operador_user WITH PASSWORD 'operador123';
CREATE USER auditor_user WITH PASSWORD 'auditor123';

--Permissões do Administrador
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;

--Permissões do Operador
--O operador só pode inserir pedidos e itens do pedido.
--Remover qualquer permissão prévia (boa prática)
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM operador_user;

-- operador pode inserir pedidos
GRANT INSERT ON pedido TO operador_user;

-- operador pode inserir itens do pedido
GRANT INSERT ON item_pedido TO operador_user;

-- operador pode consultar produtos (para ver preço e estoque ao registrar pedido)
GRANT SELECT ON produto TO operador_user;

--Permissões do Auditor
--O auditor deve ter somente leitura, jamais alterações.

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM auditor_user;
GRANT SELECT ON pedido, item_pedido, produto, categoria, pagamento, envio
TO auditor_user;

--Criar View Restrita para Auditoria
--O auditor não deve ver dados sensíveis como CPF, e-mail, telefone.
--Criamos uma visão com dados essenciais dos pedidos:

CREATE VIEW vw_auditoria_pedidos AS
SELECT 
    p.id_pedido,
    p.pedido_data_pedido,
    p.pedido_status,
    c.cliente_nome,
    cat.categoria_nome,
    pr.produto_nome,
    ip.item_quantidade,
    ip.item_subtotal
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN produto pr ON pr.id_produto = ip.id_produto
JOIN categoria cat ON cat.id_categoria = pr.id_categoria;

--Conceder acesso somente ao auditor:
GRANT SELECT ON vw_auditoria_pedidos TO auditor_user;

--A seguir estão exemplos reais de falhas que acontecem quando o usuário tenta fazer algo não permitido.

--Operador tentando atualizar pedido
SET ROLE operador_user;
UPDATE pedido SET pedido_status = 'ENVIADO' WHERE id_pedido = 1;
--Erro esperado(ERROR:  permission denied for table pedido)

--Auditor tentando inserir dados
SET ROLE auditor_user;

INSERT INTO cliente (cliente_nome, endereco_logradouro, endereco_cep,
                     endereco_cidade, endereco_estado)
VALUES ('Maria', 'Rua X', '12345-000', 'São Paulo', 'SP');
--Erro esperado(ERROR: permission denied for table cliente)

--O auditor não deve ter SELECT direto na tabela cliente.
REVOKE ALL PRIVILEGES ON cliente FROM auditor_user;

--Auditor tentando acessar dados sensíveis
SET ROLE auditor_user;
SELECT cliente_cpf FROM cliente;

--Operador inserindo pedido:
SET ROLE operador_user;

INSERT INTO pedido (id_cliente) VALUES (1);

INSERT INTO item_pedido (item_quantidade, item_preco_unitario, id_pedido, id_produto)
VALUES (2, 49.90, 1, 3);


