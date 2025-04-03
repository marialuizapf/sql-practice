/* ====================================================
   SCRIPT DE CRIAÇÃO E MANIPULAÇÃO DO BANCO DE DADOS
   Marcas, Produtos, Clientes, Pedidos e Itens de Pedido.
   Objetivo: Testar comandos, funções de agregação e joins.
   ==================================================== */

/* ====================================================
   1. TABELAS DE MARCAS E PRODUTOS
   ==================================================== */

-- Tabela de Marcas
CREATE TABLE marcas (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,   -- Identificador único para cada marca
    nome VARCHAR(100) NOT NULL UNIQUE,         -- Nome da marca (único)
    site VARCHAR(100),                         -- Site da marca
    telefone VARCHAR(15)                       -- Telefone de contato
);

-- Tabela de Produtos
CREATE TABLE produtos (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,     -- Identificador único para cada produto
    nome VARCHAR(100) NOT NULL UNIQUE,           -- Nome do produto (único)
    estoque INTEGER DEFAULT 0,                   -- Quantidade em estoque (padrão 0)
    preco REAL                                   -- Preço do produto
);

-- Alterações na tabela de Produtos:
-- 1. Adiciona coluna para referência à marca
ALTER TABLE produtos ADD COLUMN id_marca INT NOT NULL;
-- 2. Amplia o tamanho do campo 'nome' para 150 caracteres
ALTER TABLE produtos MODIFY COLUMN nome VARCHAR(150);
-- 3. Define chave estrangeira relacionando produtos a marcas
ALTER TABLE produtos ADD FOREIGN KEY (id_marca) REFERENCES marcas(id);

-- Cria um índice para melhorar a performance nas buscas por nome do produto
CREATE INDEX idx_produtos_nome ON produtos(nome);

/* ====================================================
   2. INSERÇÃO DE DADOS EM MARCAS E PRODUTOS
   ==================================================== */

-- Inserção de dados na tabela 'marcas'
INSERT INTO marcas (nome, site, telefone)
VALUES
    ('Marca A', 'www.marcaA.com.br', '11 1111-1111'),
    ('Marca B', 'www.marcaB.com.br', '22 2222-2222'),
    ('Marca C', 'www.marcaC.com.br', '33 3333-3333'),
    ('Marca D', 'www.marcaD.com.br', '44 4444-4444'),
    ('Marca E', 'www.marcaE.com.br', '55 5555-5555');

-- Inserção de dados na tabela 'produtos'
INSERT INTO produtos (nome, estoque, preco, id_marca)
VALUES
    ('Produto A', 10, 100.00, 1),
    ('Produto B', 20, 200.00, 2),
    ('Produto C', 30, 300.00, 3),
    ('Produto D', 40, 400.00, 4),
    ('Produto E', 50, 500.00, 5),
    ('Produto F', 60, 600.00, 5);

-- Exemplo de inserção utilizando a ordem padrão das colunas (NULL para auto incremento)
INSERT INTO produtos
VALUES (NULL, 'Produto G', 70, 700.00, 1);

/* ====================================================
   3. TABELAS DE CLIENTES, PEDIDOS E ITENS DE PEDIDO
   ==================================================== */

-- Tabela de Clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,         -- Identificador único para cada cliente
    nome VARCHAR(100) NOT NULL UNIQUE,          -- Nome do cliente (único)
    email VARCHAR(100) NOT NULL UNIQUE,         -- E-mail do cliente (único)
    cidade VARCHAR(100) NOT NULL,               -- Cidade do cliente
    data_nascimento DATE NOT NULL               -- Data de nascimento do cliente
);

-- Tabela de Pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,          -- Identificador único para cada pedido
    data_pedido DATE DEFAULT(NOW()),            -- Data do pedido (padrão: data atual)
    id_cliente INT NOT NULL,                    -- Referência para o cliente que fez o pedido
    valor_total REAL NOT NULL,                  -- Valor total do pedido
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- Tabela de Itens de Pedido (relaciona produtos aos pedidos)
CREATE TABLE itens_pedido (
    id_pedido INT NOT NULL,                     -- Referência para o pedido
    id_produto INT NOT NULL,                    -- Referência para o produto
    quantidade INT NOT NULL,                    -- Quantidade do produto no pedido
    preco_unitario REAL NOT NULL,               -- Preço unitário do produto no pedido
    PRIMARY KEY (id_pedido, id_produto),        -- Chave composta para evitar duplicatas
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

/* ====================================================
   4. INSERÇÃO DE DADOS EM CLIENTES, PEDIDOS E ITENS DE PEDIDO
   ==================================================== */

-- Inserção de dados na tabela 'clientes'
INSERT INTO clientes (nome, email, cidade, data_nascimento)
VALUES 
    ('João', 'joao@gmail.com', 'Rio de Janeiro', '1990-05-21'),
    ('Maria', 'maria@gmail.com', 'São Paulo', '1990-05-21'),
    ('Carlos', 'carlos@gmail.com', 'Belo Horizonte', '1990-05-21'),
    ('Daniela', 'daniela@gmail.com', 'Santa Catarina', '1990-05-21');

-- Inserção de dados na tabela 'pedidos'
INSERT INTO pedidos (id_cliente, valor_total)
VALUES
    (4, 100.00),
    (3, 200.00),
    (2, 300.00),
    (1, 400.00);

-- Inserção de dados na tabela 'itens_pedido'
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
    (1, 1, 2, 500.00),
    (1, 2, 1, 1000.00),
    (2, 3, 3, 660.67),
    (3, 4, 4, 750.00),
    (4, 5, 5, 800.00);

/* ====================================================
   5. EXEMPLOS DE CONSULTAS (SELECT, UPDATE, DELETE)
   ==================================================== */

-- Consulta: Seleciona os produtos com estoque maior ou igual a 50
SELECT id, nome, estoque FROM produtos WHERE estoque >= 50;


-- Exemplo de criação e manipulação de tabela temporária:
-- (Armazena os produtos da 'Marca A')
CREATE TABLE produtos_marca_a (
    id INT,
    nomes VARCHAR(100) NOT NULL UNIQUE, -- Nome do produto (único)
    estoque INT DEFAULT 0
);

INSERT INTO produtos_marca_a (id, nomes, estoque)
SELECT id, nome, estoque FROM produtos WHERE id_marca = 1;

SELECT * FROM produtos_marca_a;  -- Verifica os dados inseridos

TRUNCATE TABLE produtos_marca_a;  -- Limpa os registros da tabela temporária
DROP TABLE produtos_marca_a;       -- Remove a tabela temporária do banco de dados

-- Atualização: Incrementa 100 unidades ao estoque do produto com id = 1
UPDATE produtos SET estoque = estoque + 100 WHERE id = 1;

-- Exclusão: Remove o produto com id = 1
DELETE FROM produtos WHERE id = 1;

-- Reinserção do produto removido para fins de teste
INSERT INTO produtos VALUES (1, 'Produto A', 10, 100.00, 1);

-- Consulta: Verifica o produto com id = 1
SELECT * FROM produtos WHERE id = 1;

-- Consulta com múltiplos filtros:
-- Seleciona produtos com estoque maior que 10, da marca com id 5 e cujo nome inicia com 'Produto'
SELECT *
FROM produtos
WHERE estoque > 10
  AND id_marca = 5
  AND nome LIKE 'Produto%';

-- Consulta: Retorna os 3 produtos mais baratos (ordenação por preço)
SELECT *
FROM produtos
ORDER BY preco ASC
LIMIT 3;

/* ====================================================
   6. CONSULTAS COM JOIN
   ==================================================== */

-- INNER JOIN: Relaciona clientes e seus pedidos
SELECT 
    clientes.nome,
    pedidos.valor_total
FROM clientes
INNER JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- RIGHT JOIN: Exibe todos os pedidos, mesmo que algum cliente não seja encontrado
SELECT 
    clientes.nome,
    pedidos.valor_total
FROM clientes
RIGHT JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- UNION de INNER JOIN e RIGHT JOIN para combinar os resultados
SELECT 
    clientes.nome,
    pedidos.valor_total
FROM clientes
INNER JOIN pedidos ON clientes.id = pedidos.id_cliente
UNION
SELECT 
    clientes.nome,
    pedidos.valor_total
FROM clientes
RIGHT JOIN pedidos ON clientes.id = pedidos.id_cliente;

/* ====================================================
   7. CONSULTAS COM SUBQUERIES
   ==================================================== */

-- Seleciona produtos que pertencem às marcas 'Marca A' ou 'Marca E'
SELECT id, nome, preco, id_marca
FROM produtos
WHERE id_marca IN (
    SELECT id FROM marcas WHERE nome = 'Marca A' OR nome = 'Marca E'
);

/* ====================================================
   8. FUNÇÕES DE AGREGAÇÃO
   ==================================================== */

-- Contagem de clientes por cidade
SELECT cidade, COUNT(*) AS numero_clientes
FROM clientes
GROUP BY cidade;

-- Média de vendas por mês (formato 'YYYY-MM')
SELECT DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
       AVG(valor_total) AS media_vendas
FROM pedidos
GROUP BY mes;

-- Média dos valores totais dos pedidos
SELECT SUM(valor_total)/COUNT(valor_total) AS media_pedidos FROM pedidos;

-- Pedido com maior valor
SELECT MAX(valor_total) AS maior_pedido FROM pedidos;

-- Pedido com menor valor
SELECT MIN(valor_total) AS menor_pedido FROM pedidos;

-- Seleciona produtos com estoque acima da média geral
SELECT nome, estoque
FROM produtos
WHERE estoque > (SELECT AVG(estoque) FROM produtos);

-- Total de vendas por cidade para cidades específicas com filtro HAVING
SELECT c.cidade,
       SUM(p.valor_total) AS total_vendas
FROM clientes c
INNER JOIN pedidos p ON c.id = p.id_cliente
WHERE c.cidade IN ('São Paulo', 'Rio de Janeiro')
GROUP BY c.cidade
HAVING total_vendas < 400;

/* ====================================================
   9. AGREGACÕES ADICIONAIS - EXEMPLOS EXTRA
   ==================================================== */

-- Total de produtos por marca
SELECT m.nome AS Marca,
       COUNT(p.id) AS TotalProdutos
FROM marcas m
LEFT JOIN produtos p ON m.id = p.id_marca
GROUP BY m.nome;

-- Soma do estoque total de produtos por marca
SELECT m.nome AS Marca,
       SUM(p.estoque) AS TotalEstoque
FROM marcas m
LEFT JOIN produtos p ON m.id = p.id_marca
GROUP BY m.nome;

-- Média de preço dos produtos por marca
SELECT m.nome AS Marca,
       AVG(p.preco) AS MediaPreco
FROM marcas m
LEFT JOIN produtos p ON m.id = p.id_marca
GROUP BY m.nome;

-- Total de vendas por cliente
SELECT c.nome AS Cliente,
       SUM(p.valor_total) AS TotalGasto
FROM clientes c
INNER JOIN pedidos p ON c.id = p.id_cliente
GROUP BY c.nome;

-- Total e média de vendas por mês
SELECT DATE_FORMAT(data_pedido, '%Y-%m') AS Mes,
       SUM(valor_total) AS TotalVendas,
       AVG(valor_total) AS MediaVendas
FROM pedidos
GROUP BY Mes;
