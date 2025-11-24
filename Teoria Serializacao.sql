/*Legenda 1 – SELECT ... FOR UPDATE
Esse comando trava a linha do produto selecionado. 
Enquanto o lock estiver ativo, nenhuma outra transação pode alterar o mesmo produto.
Isso evita problemas como dois usuários comprarem o mesmo item ao mesmo tempo e 
gerarem estoque negativo.

Legenda 2 – UPDATE protegido pelo lock
Depois que a linha está travada, faço o UPDATE do estoque. 
Como ninguém mais consegue mexer nessa linha até o COMMIT
O valor atualizado fica sempre correto.

Legenda 3 – COMMIT libera o lock
Quando a transação é finalizada com COMMIT
O banco libera o lock e outras transações podem acessar o produto normalmente.*/




BEGIN;

-- Travar a linha do produto para evitar concorrência
SELECT produto_estoque 
FROM produto 
WHERE id_produto = 1 
FOR UPDATE;

-- Atualizar o estoque com segurança
UPDATE produto
SET produto_estoque = produto_estoque - 1
WHERE id_produto = 1;

COMMIT;

SELECT id_produto, produto_nome, produto_estoque
FROM produto
WHERE id_produto = 1;

