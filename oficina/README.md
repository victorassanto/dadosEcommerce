# Sistema de Controle e Gerenciamento de Ordens de Serviço em uma Oficina Mecânica

## Descrição

Este projeto consiste em um sistema de controle e gerenciamento de execução de ordens de serviço em uma oficina mecânica. O sistema permite que clientes levem seus veículos à oficina para serem consertados ou para passarem por revisões periódicas. Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma Ordem de Serviço (OS) com a data de entrega prevista.

## Funcionalidades

O sistema possui as seguintes funcionalidades:

1. Cadastro de Clientes: Permite o cadastro e a manutenção dos dados dos clientes da oficina, incluindo nome e endereço.

2. Cadastro de Mecânicos: Permite o cadastro e a manutenção dos dados dos mecânicos da oficina, incluindo código, nome, endereço e especialidade.

3. Cadastro de Veículos: Permite o cadastro e a manutenção dos dados dos veículos atendidos pela oficina, associando-os aos clientes correspondentes.

4. Ordem de Serviço: Permite a criação e o gerenciamento das ordens de serviço, com informações como número da OS, data de emissão, valor estimado, status (em andamento, concluído, aguardando peças, etc.) e data de conclusão dos trabalhos.

5. Cadastro de Serviços: Permite o cadastro e a manutenção dos serviços oferecidos pela oficina.

6. Cadastro de Peças: Permite o cadastro e a manutenção das peças utilizadas na execução dos serviços.

7. Referência de Mão-de-Obra: Permite o registro dos valores de mão-de-obra para cada serviço, que são utilizados para calcular o valor estimado das ordens de serviço.

## SQL - Estrutura do Banco de Dados

O banco de dados é composto pelas seguintes tabelas:

- `clientes`: Armazena os dados dos clientes da oficina.
- `mecanicos`: Armazena os dados dos mecânicos da oficina.
- `veiculos`: Armazena os dados dos veículos atendidos pela oficina, associando-os aos clientes.
- `ordens_servico`: Armazena as informações das ordens de serviço, incluindo data de emissão, valor estimado, status e data de conclusão.
- `servicos`: Armazena os serviços oferecidos pela oficina.
- `referencia_mao_obra`: Tabela auxiliar que registra os valores de mão-de-obra para cada serviço.
- `pecas`: Armazena as peças utilizadas na execução dos serviços.
- `pecas_os`: Tabela auxiliar que relaciona as peças utilizadas em cada ordem de serviço.
- `servicos_os`: Tabela auxiliar que relaciona os serviços realizados em cada ordem de serviço.

## Queries SQL

A seguir, algumas queries SQL para exemplificar o uso do banco de dados:

1. Recuperação de todos os clientes:

```sql
SELECT * FROM clientes;
Recuperação das ordens de serviço concluídas:
sql
Copy code
SELECT * FROM ordens_servico WHERE status = 'Concluído';
Cálculo do valor total de cada ordem de serviço:
sql
Copy code
SELECT os.idOS, os.valorEstimado + SUM(ref.valorMaoObra * (SELECT COUNT(*) FROM servicos_os WHERE idOS = os.idOS)) AS ValorTotal
FROM ordens_servico os
LEFT JOIN referencia_mao_obra ref ON os.idOS = ref.idServico
LEFT JOIN pecas_os po ON os.idOS = po.idOS
GROUP BY os.idOS;
Recuperação dos serviços e seus respectivos valores de mão-de-obra quando o valor estimado for superior a 500:
sql
Copy code
SELECT s.descricao, SUM(ref.valorMaoObra) AS ValorMaoObra
FROM servicos s
LEFT JOIN referencia_mao_obra ref ON s.idServico = ref.idServico
LEFT JOIN servicos_os so ON s.idServico = so.idServico
LEFT JOIN ordens_servico os ON so.idOS = os.idOS
GROUP BY s.descricao
HAVING os.valorEstimado > 500;
Recuperação das ordens de serviço com os detalhes do cliente, veículo, mecânico responsável e serviços realizados:
sql
Copy code
SELECT os.idOS, c.nome AS Cliente, v.placa AS Veiculo, m.nome AS Mecanico, GROUP_CONCAT(s.descricao) AS Servicos
FROM ordens_servico os
LEFT JOIN veiculos v ON os.idVeiculo = v.idVeiculo
LEFT JOIN clientes c ON v.idCliente = c.idCliente
LEFT JOIN mecanicos m ON os.idOS = m.idMecanico
LEFT JOIN servicos_os so ON os.idOS = so.idOS
LEFT JOIN servicos s ON so.idServico = s.idServico
GROUP BY os.idOS, c.nome, v.placa, m.nome;
Considerações Finais
Este projeto é uma demonstração do esquema do banco de dados e das funcionalidades básicas do sistema de controle e gerenciamento de ordens de serviço em uma oficina mecânica. É importante lembrar que, para implementar um sistema completo, será necessário desenvolver a lógica de negócio e as interfaces de usuário adequadas, além de outras funcionalidades adicionais, como autenticação, permissões de acesso, entre outras.

Espero que este projeto seja útil para entender a estrutura básica de um sistema de oficina mecânica e possa servir como ponto de partida para o desenvolvimento de um sistema completo e funcional.
```
