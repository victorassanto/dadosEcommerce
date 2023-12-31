# Esquema de Banco de Dados para E-commerce

Este repositório contém o script SQL para criar o esquema de banco de dados para um e-commerce. O esquema inclui tabelas para gerenciar clientes, produtos, pedidos, pagamentos, entregas, fornecedores e vendedores. Ele fornece uma estrutura básica para armazenar e gerenciar dados em uma plataforma de e-commerce.

## Tabela de Conteúdos

- [Iniciando](#iniciando)
- [Tabelas](#tabelas)
- [Relações](#relações)
- [Contribuição](#contribuição)
- [Licença](#licença)

## Iniciando

Para usar este esquema de banco de dados, você precisará de um sistema de gerenciamento de banco de dados relacional (RDBMS) que suporte SQL, como o MySQL ou o PostgreSQL. Basta executar o script SQL fornecido neste repositório para criar as tabelas e relacionamentos.

## Tabelas

### `cliente`

- `idCliente` (Chave Primária, INT): Identificador único para cada cliente.
- `Fname` (VARCHAR(10)): Primeiro nome do cliente.
- `Minit` (CHAR(3)): Inicial do meio do nome do cliente.
- `Lname` (VARCHAR(20)): Sobrenome do cliente.
- `CPF` (CHAR(11)): Número do Cadastro de Pessoa Física (CPF) do Brasil.
- `CNPJ` (CHAR(14)): Número do Cadastro Nacional de Pessoa Jurídica (CNPJ) do Brasil.
- `Address` (VARCHAR(39)): Endereço do cliente.
- `unique_cpf_client` (Restrição UNIQUE): Garante que cada CPF seja único na tabela.
- `unique_cnpj_client` (Restrição UNIQUE): Garante que cada CNPJ seja único na tabela.
- `check_pj_pf_client` (Restrição CHECK): Garante que cada cliente possa ser uma pessoa física (CPF) ou uma pessoa jurídica (CNPJ), mas não ambos.

### `produto`

- `idProduto` (Chave Primária, INT): Identificador único para cada produto.
- `Pname` (VARCHAR(10) NOT NULL): Nome do produto.
- `classification_kids` (BOOLEAN DEFAULT FALSE): Indica se o produto é adequado para crianças.
- `category` (ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis')): Categoria do produto.
- `avaliacao` (FLOAT DEFAULT 0): Avaliação média do produto.
- `size` (VARCHAR(10)): Tamanho do produto.

### `payments`

- `idPayment` (Chave Primária, INT): Identificador único para cada pagamento.
- `idClient` (INT): Chave estrangeira referenciando o `idCliente` na tabela `cliente`.
- `amount` (FLOAT): Valor do pagamento.
- `paymentDate` (DATE): Data do pagamento.

### `payment_methods`

- `idMethod` (Chave Primária, INT): Identificador único para cada método de pagamento.
- `methodName` (VARCHAR(50)): Nome do método de pagamento.

### `payment_methods_mapping`

- `idPayment` (INT): Chave estrangeira referenciando o `idPayment` na tabela `payments`.
- `idMethod` (INT): Chave estrangeira referenciando o `idMethod` na tabela `payment_methods`.
- A combinação de `idPayment` e `idMethod` serve como chave primária.

### `pedido`

- `idOrder` (Chave Primária, INT): Identificador único para cada pedido.
- `idOrderClient` (INT): Chave estrangeira referenciando o `idCliente` na tabela `cliente`.
- `orderStatus` (ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento'): Status do pedido.
- `orderDescription` (VARCHAR(255)): Descrição ou informações adicionais sobre o pedido.
- `sendValue` (FLOAT DEFAULT 10): Custo de envio ou valor relevante associado ao pedido.
- `paymentCash` (BOOLEAN DEFAULT FALSE): Indica se o pagamento foi feito em dinheiro.

### `entrega`

- `idEntrega` (Chave Primária, INT): Identificador único para cada entrega.
- `idOrder` (INT): Chave estrangeira referenciando o `idOrder` na tabela `pedido`.
- `status` (VARCHAR(20)): Status da entrega.
- `codigoRastreio` (VARCHAR(50)): Código de rastreamento associado à entrega para fins de rastreamento de pacotes.
- `entregaDate` (DATE): Data da entrega.

### `estoque`

- `idProdStorage` (Chave Primária, INT): Identificador único para cada armazenamento de produto.
- `storageLocation` (VARCHAR(255)): Localização do produto no estoque.
- `quantity` (INT DEFAULT 0): Quantidade do produto no estoque.

### `fornecedor`

- `idSupplier` (Chave Primária, INT): Identificador único para cada fornecedor.
- `SocialName` (VARCHAR(255) NOT NULL): Nome social do fornecedor.
- `CNPJ` (CHAR(15) NOT NULL): Número do Cadastro Nacional de Pessoa Jurídica (CNPJ) do Brasil.
- `contact` (CHAR(11) NOT NULL): Informações de contato do fornecedor.
- `unique_supplier` (Restrição UNIQUE): Garante que cada CNPJ seja único na tabela.

### `vendedor`

- `idSeller` (Chave Primária, INT): Identificador único para cada vendedor.
- `SocialName` (VARCHAR(255) NOT NULL): Nome social do vendedor.
- `AbstName` (VARCHAR(255)): Nome abreviado do vendedor.
- `CNPJ` (CHAR(15)): Número do Cadastro Nacional de Pessoa Jurídica (CNPJ) do Brasil.
- `CPF` (CHAR(9)): Número do Cadastro de Pessoa Física (CPF) do Brasil.
- `location` (VARCHAR(255)): Localização do vendedor.
- `contact` (CHAR(11) NOT NULL): Informações de contato do vendedor.
- `unique_cnpj_seller` (Restrição UNIQUE): Garante que cada CNPJ seja único na tabela.
- `unique_cpf_seller` (Restrição UNIQUE): Garante que cada CPF seja único na tabela.

### `productSeller`

- `idPseller` (INT): Chave estrangeira referenciando o `idSeller` na tabela `vendedor`.
- `idPproduct` (INT): Chave estrangeira referenciando o `idProduto` na tabela `produto`.
- `prodQuantity` (INT DEFAULT 1): Quantidade do produto vendida pelo vendedor.
- A combinação de `idPseller` e `idPproduct` serve como chave primária.

### `productOrder`

- `idPOproduct` (INT): Chave estrangeira referenciando o `idProduto` na tabela `produto`.
- `idPOorder` (INT): Chave estrangeira referenciando o `idOrder` na tabela `pedido`.
- `poQuantity` (INT DEFAULT 1): Quantidade do produto no pedido.
- `poStatus` (ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível'): Status do produto no pedido.
- A combinação de `idPOproduct` e `idPOorder` serve como chave primária.

### `storageLocation`

- `idLproduct` (INT): Chave estrangeira referenciando o `idProduto` na tabela `produto`.
- `idLstorage` (INT): Chave estrangeira referenciando o `idPseller` na tabela `productSeller`.
- `location` (VARCHAR(255) NOT NULL): Localização do produto no estoque.
- A combinação de `idLproduct` e `idLstorage` serve como chave primária.

### `productsupplier`

- `idPsSupplier` (INT): Chave estrangeira referenciando o `idSupplier` na tabela `fornecedor`.
- `idPsProduct` (INT): Chave estrangeira referenciando o `idProduto` na tabela `produto`.
- `quantity` (INT NOT NULL): Quantidade do produto fornecida pelo fornecedor.
- A combinação de `idPsSupplier` e `idPsProduct` serve como chave primária.
