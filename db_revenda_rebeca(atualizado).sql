create database db_revenda_rebeca;

create table clientes(
    id serial primary key,
    nome varchar(100) not null,
    email varchar(100) unique not null,
    telefone varchar(20),
    data_cadastro timestamp default current_timestamp
);
alter table clientes alter column email drop not null;

create table enderecos(
    id serial primary key,
    cliente_id int not null references clientes(id),
    cep varchar(10) not null,
    rua varchar(150) not null,
    numero varchar(10) not null,
    cidade varchar(100) not null
);

create table fornecedores(
    id serial primary key,
    nome varchar(100) not null unique,
    cnpj varchar(18) unique not null,
    telefone varchar(20),
    pais_origem varchar(50) default 'Brasil'
);

create table produtos(
    id serial primary key,
    fornecedor_id int not null references fornecedores(id),
    nome varchar(100) not null,
    preco decimal(10,2) not null check (preco > 0),
    estoque int not null check (estoque >= 0),
    genero  varchar(50) not null
);

create table vendas(
    id serial primary key,
    cliente_id int not null references clientes(id),
    data_venda timestamp default current_timestamp,
    valor_total decimal(10,2) not null check (valor_total >= 0),
    status varchar(20) default 'pendente'
);

create table venda_produto(
    venda_id int not null references vendas(id),
    produto_id int not null references produtos(id),
    quantidade int not null check (quantidade > 0),
    primary key (venda_id, produto_id)
);

create view vw_vendas_clientes as select v.id venda_id, c.nome cliente, v.data_venda, v.valor_total, v.status from vendas v join clientes c on v.cliente_id = c.id;

create view vw_vendas_produtos as select v.id venda_id, p.nome produto, vp.quantidade, p.preco, vp.quantidade * p.preco as subtotal from venda_produto vp join vendas v on vp.venda_id = v.id join produtos p on vp.produto_id = p.id;

insert into clientes(nome, email, telefone) values
('Ana Souza', 'ana@email.com', '119999999'),
('Carlos Silva', 'carlos@email.com', '119888888'),
('Fernanda Lima', 'fernanda@email.com', '219777777'),
('João Pedro', 'joao@email.com', '319666666'),
('Mariana Costa', 'mariana@email.com', '219555555'),
('Rodrigo Alves', 'rodrigo@email.com', '319444444'),
('Patrícia Gomes', 'patricia@email.com', '119333333'),
('Gabriel Martins', 'gabriel@email.com', '219222222'),
('Juliana Rocha', 'juliana@email.com', '119111111'),
('Ricardo Dias', 'ricardo@email.com', '119000000');

insert into enderecos(cliente_id, cep, rua, numero, cidade) values
(1, '01001-000', 'Rua A', '100', 'São Paulo'),
(2, '22041-001', 'Av Atlântica', '200', 'Rio de Janeiro'),
(3, '30110-002', 'Rua B', '300', 'Belo Horizonte'),
(4, '40020-003', 'Rua C', '400', 'Salvador'),
(5, '70030-004', 'Rua D', '500', 'Brasília'),
(6, '80040-005', 'Rua E', '600', 'Curitiba'),
(7, '90050-006', 'Rua F', '700', 'Porto Alegre'),
(8, '64000-007', 'Rua G', '800', 'Teresina'),
(9, '59000-008', 'Rua H', '900', 'Natal'),
(10, '66000-009', 'Rua I', '1000', 'Belém');

insert into fornecedores(nome, cnpj, telefone, pais_origem) values
('Editora Globo', '00.111.222/0001-33', '33111111', 'Brasil'),
('Editora Galera', '11.222.333/0001-44', '44112222', 'Brasil'),
('Editora Pé da Letra', '22.333.444/0001-55', '55113333', 'Brasil'),
('Editora Intrinseca', '33.444.555/0001-66', '66114444', 'Brasil'),
('Editora Seguinte', '44.555.666/0001-77', '77115555', 'Brasil'),
('Editora Harlequin', '55.666.777/0001-88', '88116666', 'Brasil'),
('Editora L&PM pocket', '66.777.888/0001-99', '99117777', 'Brasil'),
('Editora Dark Side', '77.888.999/0001-11', '11118888', 'Brasil'),
('Editora Rocco', '88.999.000/0001-22', '22119999', 'Brasil'),
('Editora Arqueiro', '99.000.111/0001-33', '33110000', 'Brasil');

insert into produtos(fornecedor_id, nome, preco, estoque, genero) values
(1, 'Assistente do Vilão', 50.00, 10, 'Fantasia'),
(2, 'O Amor Não é Óbvio', 62.00, 15, 'Romance'),
(3, 'Um Estudo em Vermelho', 70.00, 20, 'Mistério'),
(4, 'O Primeiro a Morrer no Final', 70.00, 12, 'Suspense psicológico'),
(5, 'O Mundo de Sofia', 50.00, 25, 'Mistério'),
(6, 'O Despertar da Lua Caída', 53.00, 18, 'Fantasia'),
(7, 'Assassinato no Expresso Oriente', 78.00, 8, 'Ficção Policial'),
(8, 'Saboroso Cadaver', 60.00, 14, 'Terror'),
(9, 'A Hora da Estrela', 67.00, 11, 'Ficção'),
(10, 'A Hipótese do Amor', 90.00, 5, 'Romance');

insert into vendas(cliente_id, valor_total, status) values
(1, 1470.00, 'pago'),
(2, 850.00, 'pendente'),
(3, 900.00, 'pago'),
(4, 530.00, 'pago'),
(5, 1200.00, 'pendente'),
(6, 700.00, 'pago'),
(7, 1500.00, 'pago'),
(8, 600.00, 'pago'),
(9, 450.00, 'pendente'),
(10, 780.00, 'pago');

insert into venda_produto(venda_id, produto_id, quantidade) values (1, 1, 1), (1, 2, 1), (2, 1, 1), (3, 10, 1), (4, 6, 1), (5, 4, 2), (6, 5, 1), (7, 7, 2), (8, 8, 1), (9, 5, 1);

select * from vw_vendas_clientes;
select * from vw_vendas_produtos;

select * from clientes c where nome like 'A%';
	explain select * from clientes where nome like 'A%';
create index idx_clientes_nome on clientes(nome);
	explain select * from clientes where nome like 'E%';
alter table clientes alter column telefone set data type int;
alter table clientes alter column id set data type varchar(20);
create user rebeca with password 'senha123';
grant all privileges on all tables in schema public to rebeca;
create user lola with password 'senha456';
grant select on clientes to lola;
update clientes set email = null where id < 5;
select c.nome, e.rua from clientes c inner join enderecos e on c.id = e.cliente_id;
select c.nome, e.rua from clientes c left join enderecos e on c.id = e.cliente_id;
select c.nome, e.rua from clientes c right join enderecos e on c.id = e.cliente_id;
select c.nome, v.id as venda_id, v.valor_total from clientes c inner join vendas v on c.id = v.cliente_id;
select v.id as venda_id, p.nome as produto, vp.quantidade from vendas v inner join venda_produto vp on v.id = vp.venda_id
inner join produtos p on vp.produto_id = p.id;
select p.nome, f.nome as fornecedor, p.preco from produtos p inner join fornecedores f on p.fornecedor_id = f.id;
select c.nome, v.id as venda_id, v.valor_total from clientes c left join vendas v on c.id = v.cliente_id;
select c.nome, v.id as venda_id, v.valor_total from clientes c right join vendas v on c.id = v.cliente_id;
select v.id as venda_id, p.nome as produto, vp.quantidade from vendas v left join venda_produto vp on v.id = vp.venda_id 
left join produtos p on vp.produto_id = p.id;
select v.id as venda_id, p.nome as produto, vp.quantidade from vendas v right join venda_produto vp on v.id = vp.venda_id 
right join produtos p on vp.produto_id = p.id;
select p.nome, f.nome as fornecedor, p.preco from produtos p left join fornecedores f on p.fornecedor_id = f.id;
select p.nome, f.nome as fornecedor, p.preco from produtos p right join fornecedores f on p.fornecedor_id = f.id;








