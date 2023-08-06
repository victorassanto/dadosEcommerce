-- criar tabela cliente
CREATE TABLE cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(14),
    [Address] VARCHAR(39),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT check_pj_pf_client CHECK (
        (CPF IS NOT NULL AND CNPJ IS NULL) OR
        (CPF IS NULL AND CNPJ IS NOT NULL)
    )
);

-- criar tabela produto
CREATE TABLE produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'),
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(10)
);

CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    amount FLOAT,
    paymentDate DATE,
    FOREIGN KEY (idClient) REFERENCES cliente(idCliente)
);

CREATE TABLE payment_methods (
    idMethod INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(50)
);

CREATE TABLE payment_methods_mapping (
    idPayment INT,
    idMethod INT,
    PRIMARY KEY (idPayment, idMethod),
    FOREIGN KEY (idPayment) REFERENCES payments(idPayment),
    FOREIGN KEY (idMethod) REFERENCES payment_methods(idMethod)
);

-- criar tabela pedido
CREATE TABLE pedido (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idOrderClient) REFERENCES cliente(idCliente)
);

CREATE TABLE entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    status VARCHAR(20),
    codigoRastreio VARCHAR(50),
    entregaDate DATE,
    FOREIGN KEY (idOrder) REFERENCES pedido(idOrder)
);

-- criar tabela estoque
CREATE TABLE estoque (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- criar tabela fornecedor
CREATE TABLE fornecedor (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criar tabela vendedor
CREATE TABLE vendedor (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    FOREIGN KEY (idPseller) REFERENCES vendedor(idSeller),
    FOREIGN KEY (idPproduct) REFERENCES produto(idProduto)
);

CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    FOREIGN KEY (idPOproduct) REFERENCES produto(idProduto),
    FOREIGN KEY (idPOorder) REFERENCES pedido(idOrder)
);

CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    FOREIGN KEY (idLproduct) REFERENCES produto(idProduto),
    FOREIGN KEY (idLstorage) REFERENCES productSeller(idPseller)
);

CREATE TABLE productsupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    FOREIGN KEY (idPsSupplier) REFERENCES fornecedor(idSupplier),
    FOREIGN KEY (idPsProduct) REFERENCES produto(idProduto)
);

--Perguntas e Respostas
--Quantos pedidos foram feitos por cada cliente?
SELECT idOrderClient, COUNT(idOrder) AS NumberOfOrders
FROM pedido
GROUP BY idOrderClient;

--Algum vendedor também é fornecedor?
SELECT COUNT(*) AS contador
FROM vendedor v
JOIN fornecedor f ON v.CNPJ = f.CNPJ;

--Relação de produtos fornecedores e estoques;
SELECT 
    p.idProduto AS ProductID,
    p.Pname AS ProductName,
    f.idSupplier AS SupplierID,
    f.SocialName AS SupplierName,
    e.idProdStorage AS StockID,
    e.storageLocation AS StockLocation,
    e.quantity AS StockQuantity
FROM produto p
LEFT JOIN productsupplier ps ON p.idProduto = ps.idPsProduct
LEFT JOIN fornecedor f ON ps.idPsSupplier = f.idSupplier
LEFT JOIN estoque e ON p.idProduto = e.idProdStorage;

--Relação de nomes dos fornecedores e nomes dos produtos;
SELECT
    f.SocialName AS SupplierName,
    p.Pname AS ProductName
FROM fornecedor f
JOIN productsupplier ps ON f.idSupplier = ps.idPsSupplier
JOIN produto p ON ps.idPsProduct = p.idProduto;
