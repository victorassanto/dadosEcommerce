--criar tabela cliente
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
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




--criar tabela produto
create table product(
    idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids boolean default false,
    category enum( 'Eletrônico' 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'),
    avaliação float default 0,
    size varchar(10),
    constraint unique_cpf_client unique (CPF)
);

CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    amount FLOAT,
    paymentDate DATE,
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
    CONSTRAINT fk_order_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

CREATE TABLE entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    [status] VARCHAR(20),
    codigoRastreio VARCHAR(50),
    entregaDate DATE,
    FOREIGN KEY (idOrder) REFERENCES pedido(idOrder)
);

-- criar tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(ll) not null,
    constraint unique_supplier unique (CNPJ)
);

--criar tabela vendedor
create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(ll) not null,
    constraint unique_cnpj_supplier unique (CNPJ),
    constraint unique_cpf_supplier unique (CPF),
);


create table productSeller(
    idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseIIer, idPproduct),
    constraint fk_product_seller foreign key (idSeller) references selIer(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);
create table storageLocation(
    idLproduct int,
    idLstorage int,
    [location] varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references orders(productSeIIer)
);
create table productsupplier(
    idPsSuppIier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSuppIier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idpsSuppIier) references suppIier(idSuppIier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);