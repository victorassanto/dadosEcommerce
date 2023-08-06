-- Script SQL para criação do esquema do banco de dados

-- Criação das tabelas

CREATE TABLE clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(100) NOT NULL
);

CREATE TABLE mecanicos (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL
);

CREATE TABLE veiculos (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    placa VARCHAR(10) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

CREATE TABLE ordens_servico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    idVeiculo INT,
    dataEmissao DATE NOT NULL,
    valorEstimado FLOAT NOT NULL,
    status VARCHAR(20) NOT NULL,
    dataConclusao DATE,
    FOREIGN KEY (idVeiculo) REFERENCES veiculos(idVeiculo)
);

CREATE TABLE servicos (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE referencia_mao_obra (
    idServico INT,
    valorMaoObra FLOAT NOT NULL,
    FOREIGN KEY (idServico) REFERENCES servicos(idServico)
);

CREATE TABLE pecas (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE pecas_os (
    idOS INT,
    idPeca INT,
    quantidade INT NOT NULL,
    FOREIGN KEY (idOS) REFERENCES ordens_servico(idOS),
    FOREIGN KEY (idPeca) REFERENCES pecas(idPeca)
);

CREATE TABLE servicos_os (
    idOS INT,
    idServico INT,
    FOREIGN KEY (idOS) REFERENCES ordens_servico(idOS),
    FOREIGN KEY (idServico) REFERENCES servicos(idServico)
);

-- Inserção de dados de exemplo

INSERT INTO clientes (nome, endereco) VALUES
    ('João Silva', 'Rua A, 123'),
    ('Maria Santos', 'Av. B, 456'),
    ('Pedro Oliveira', 'Rua C, 789');

INSERT INTO mecanicos (codigo, nome, endereco, especialidade) VALUES
    ('M001', 'Carlos Souza', 'Rua X, 111', 'Motor'),
    ('M002', 'Ana Costa', 'Av. Y, 222', 'Freios'),
    ('M003', 'Luiz Ferreira', 'Rua Z, 333', 'Suspensão');

INSERT INTO veiculos (idCliente, placa, modelo, ano) VALUES
    (1, 'ABC1234', 'Fiat Uno', 2018),
    (2, 'XYZ5678', 'VW Gol', 2020),
    (3, 'DEF9999', 'Ford Fiesta', 2019);

INSERT INTO ordens_servico (idVeiculo, dataEmissao, valorEstimado, status, dataConclusao) VALUES
    (1, '2023-08-01', 500.00, 'Em andamento', NULL),
    (2, '2023-08-02', 800.00, 'Concluído', '2023-08-05'),
    (3, '2023-08-03', 300.00, 'Aguardando peças', NULL);

INSERT INTO servicos (descricao) VALUES
    ('Troca de óleo'),
    ('Troca de pastilhas de freio'),
    ('Alinhamento e balanceamento');

INSERT INTO referencia_mao_obra (idServico, valorMaoObra) VALUES
    (1, 100.00),
    (2, 150.00),
    (3, 80.00);

INSERT INTO pecas (descricao) VALUES
    ('Filtro de óleo'),
    ('Pastilhas de freio dianteiras'),
    ('Amortecedores dianteiros');

INSERT INTO pecas_os (idOS, idPeca, quantidade) VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 2);

INSERT INTO servicos_os (idOS, idServico) VALUES
    (1, 1),
    (2, 2),
    (3, 3);


--Recuperações simples com SELECT Statement:
-- Recupera todos os clientes
SELECT * FROM clientes;

-- Recupera todos os mecânicos
SELECT * FROM mecanicos;

-- Recupera todos os veículos
SELECT * FROM veiculos;

-- Recupera todas as ordens de serviço
SELECT * FROM ordens_servico;

-- Recupera todos os serviços
SELECT * FROM servicos;

-- Recupera todas as peças
SELECT * FROM pecas;

--Filtros com WHERE Statement:
-- Recupera as ordens de serviço concluídas
SELECT * FROM ordens_servico WHERE status = 'Concluído';

-- Recupera os veículos do cliente com ID 2
SELECT * FROM veiculos WHERE idCliente = 2;

-- Recupera os mecânicos especializados em suspensão
SELECT * FROM mecanicos WHERE especialidade = 'Suspensão';

--Crie expressões para gerar atributos derivados:
-- Calcula o valor total de cada ordem de serviço somando o valor estimado dos serviços e das peças
SELECT os.idOS, os.valorEstimado + SUM(ref.valorMaoObra * (SELECT COUNT(*) FROM servicos_os WHERE idOS = os.idOS)) AS ValorTotal
FROM ordens_servico os
LEFT JOIN referencia_mao_obra ref ON os.idOS = ref.idServico
LEFT JOIN pecas_os po ON os.idOS = po.idOS
GROUP BY os.idOS;

--Defina ordenações dos dados com ORDER BY:
-- Recupera os veículos ordenados por ano em ordem decrescente
SELECT * FROM veiculos ORDER BY ano DESC;

-- Recupera os clientes ordenados por nome em ordem crescente
SELECT * FROM clientes ORDER BY nome;

--Condições de filtros aos grupos – HAVING Statement:
-- Recupera os serviços e seus respectivos valores de mão-de-obra quando o valor estimado for superior a 500
SELECT s.descricao, SUM(ref.valorMaoObra) AS ValorMaoObra
FROM servicos s
LEFT JOIN referencia_mao_obra ref ON s.idServico = ref.idServico
LEFT JOIN servicos_os so ON s.idServico = so
