-- Foram inseridos 10 registros em cada tabela do e-commerce
-- Simulando clientes, produtos, pedidos e transações. 
-- Os dados refletem um fluxo completo de compra, pagamento e envio.

-- Inserção de 10 Clientes
INSERT INTO cliente (
    cliente_nome, cliente_cpf, cliente_telefone, cliente_email,
    endereco_logradouro, endereco_cep, endereco_cidade, endereco_estado, endereco_pais
) VALUES
('Ellen Vitorino', '12345678901', '61999990001', 'ellen.vitorino@email.com', 'Rua das Acácias', '70000000', 'Brasília', 'DF', 'Brasil'),
('Gustavo Barboza', '23456789012', '61999990002', 'gustavo.barboza@email.com', 'Av. Central', '70000001', 'Brasília', 'DF', 'Brasil'),
('Letícia Oliveira', '34567890123', '61999990003', 'leticia.oliveira@email.com', 'Rua A', '70000002', 'Brasília', 'DF', 'Brasil'),
('Felipe Santiago', '45678901234', '61999990004', 'felipe.santiago@email.com', 'Rua B', '70000003', 'Brasília', 'DF', 'Brasil'),
('Mariana Costa', '56789012345', '61999990005', 'mariana.costa@email.com', 'Rua C', '70000004', 'Brasília', 'DF', 'Brasil'),
('Rafael Torres', '67890123456', '61999990006', 'rafael.torres@email.com', 'Rua D', '70000005', 'Brasília', 'DF', 'Brasil'),
('Camila Rocha', '78901234567', '61999990007', 'camila.rocha@email.com', 'Rua E', '70000006', 'Brasília', 'DF', 'Brasil'),
('Lucas Martins', '89012345678', '61999990008', 'lucas.martins@email.com', 'Rua F', '70000007', 'Brasília', 'DF', 'Brasil'),
('Juliana Alves', '90123456789', '61999990009', 'juliana.alves@email.com', 'Rua G', '70000008', 'Brasília', 'DF', 'Brasil'),
('Bruno Ferreira', '01234567890', '61999990010', 'bruno.ferreira@email.com', 'Rua H', '70000009', 'Brasília', 'DF', 'Brasil');

-- Insert de Categoria 
INSERT INTO categoria (categoria_nome, categoria_descricao) VALUES
('Camisetas', 'Roupas casuais para o dia a dia'),
('Calças', 'Modelos jeans, sarja e moletom'),
('Vestidos', 'Vestidos para diversas ocasiões'),
('Jaquetas', 'Jaquetas leves e pesadas'),
('Shorts', 'Shorts jeans e de tecido'),
('Saias', 'Saias curtas e longas'),
('Blusas', 'Blusas femininas variadas'),
('Regatas', 'Regatas masculinas e femininas'),
('Moletom', 'Conjuntos e peças avulsas'),
('Acessórios', 'Bonés, cintos e bolsas');


--Insert de Produto 
INSERT INTO produto (produto_nome, produto_descricao, produto_preco, produto_estoque, id_categoria) VALUES
('Camiseta Branca', '100% algodão', 49.90, 100, 1),
('Calça Jeans Azul', 'Modelagem reta', 129.90, 50, 2),
('Vestido Floral', 'Estampa primavera', 89.90, 30, 3),
('Jaqueta Preta', 'Couro sintético', 199.90, 20, 4),
('Short Jeans', 'Com rasgos', 69.90, 40, 5),
('Saia Longa', 'Tecido leve', 79.90, 25, 6),
('Blusa de Seda', 'Estilo social', 99.90, 35, 7),
('Regata Esportiva', 'Ideal para treino', 39.90, 60, 8),
('Moletom Cinza', 'Com capuz', 149.90, 45, 9),
('Boné Preto', 'Ajustável', 29.90, 80, 10);

--Insert de pedidos
INSERT INTO pedido (pedido_observacao, id_cliente) VALUES
('Primeira compra', 1),
('Pedido de presente', 2),
('Compra para viagem', 3),
('Roupa de treino', 4),
('Look completo', 5),
('Promoção de verão', 6),
('Pedido urgente', 7),
('Roupa de trabalho', 8),
('Presente de aniversário', 9),
('Pedido com acessórios', 10);

-- Insert de Item_pedido 
INSERT INTO item_pedido (item_quantidade, item_preco_unitario, id_pedido, id_produto) VALUES
(2, 49.90, 1, 1),
(1, 129.90, 1, 2),
(1, 89.90, 2, 3),
(1, 39.90, 3, 8),
(2, 149.90, 4, 9),
(1, 69.90, 5, 5),
(1, 99.90, 6, 7),
(1, 79.90, 7, 6),
(1, 199.90, 8, 4),
(2, 29.90, 9, 10);

--Insert de Pagamentos 
INSERT INTO pagamento (pagamento_tipo, pagamento_status, pagamento_valor, id_pedido) VALUES
('PIX', 'Aprovado', 229.70, 1),
('CARTAO', 'Aprovado', 89.90, 2),
('BOLETO', 'Pendente', 39.90, 3),
('PIX', 'Aprovado', 299.80, 4),
('CARTAO', 'Aprovado', 69.90, 5),
('PIX', 'Cancelado', 99.90, 6),
('BOLETO', 'Aprovado', 79.90, 7),
('CARTAO', 'Aprovado', 199.90, 8),
('PIX', 'Aprovado', 59.80, 9),
('BOLETO', 'Pendente', 29.90, 10);

--Insert de Envio
INSERT INTO envio (envio_enviado_dia, envio_entregue_dia, envio_estado, id_pedido) VALUES
('2025-11-15', '2025-11-16 10:00:00', 'ENTREGUE', 1),
('2025-11-16', NULL, 'EM ROTA', 2),
('2025-11-16', NULL, 'PREPARANDO', 3),
('2025-11-15', '2025-11-17 14:00:00', 'ENTREGUE', 4),
('2025-11-16', NULL, 'EM ROTA', 5),
('2025-11-17', NULL, 'PREPARANDO', 6),
('2025-11-17', NULL, 'PREPARANDO', 7),
('2025-11-15', '2025-11-16 18:00:00', 'ENTREGUE', 8),
('2025-11-16', NULL, 'EM ROTA', 9),
('2025-11-17', NULL, 'PREPARANDO', 10);
