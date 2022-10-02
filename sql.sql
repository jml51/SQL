create database if not exists trabalhoBD_2;
use trabalhoBD_2;

create table IF NOT EXISTS CLIENTE(
	NUMCLIENTE INT primary key not null,
    NOME varchar(150) not null,
    IDADE INT not null check ( idade>18),
    NIF INT
);


select*from infoclientes;

create table IF NOT EXISTS CARROS(
	MATRICULA INT primary key not null,
    MARCA VARCHAR(150) not null
);


create table IF NOT EXISTS FUNCIONARIOS(
	ID_FUNCIONARIO INT primary key not null,
    NOME VARCHAR(150) not null,
    IDADE INT not null check (idade > 18),
    MORADA VARCHAR(150) not null
);


create table if not exists codpostal(
	codpostal int primary key,
    rua varchar(150),
    cidade varchar (150)
);

select*from infofuncionario;

create table IF NOT EXISTS CARTAO(
	ID_CARTAO INT primary key not null,
    NUMCLIENTE INT not null,
    MATRICULA INT not null,
    foreign key(NUMCLIENTE) references CLIENTE(NUMCLIENTE),
    foreign key(MATRICULA) references CARROS(MATRICULA)
);


create table IF NOT EXISTS ENTRADAS(
	ID_ENTRADAS INT primary key auto_increment ,
    ID_CARTAO int not null,
    ID_FUNCIONARIO INT not null,
    data_e DATETIME default current_timestamp,
    foreign key(ID_CARTAO) references CARTAO(ID_CARTAO),
    foreign key (ID_FUNCIONARIO) references FUNCIONARIOS(ID_FUNCIONARIO)
);


create table IF NOT EXISTS SAIDAS(
	ID_SAIDAS INT primary key auto_increment ,
    ID_CARTAO int not null,
    ID_FUNCIONARIO INT not null,
    datas_s DATETIME default current_timestamp,
    preco_s float  ,
    foreign key(ID_CARTAO) references CARTAO(ID_CARTAO),
    foreign key (ID_FUNCIONARIO) references FUNCIONARIOS(ID_FUNCIONARIO)
);


create table if not exists fatura(
	id_fatura int primary key auto_increment,
    id_cartao int ,
	id_funcionario int,
	id_saidas int,
	preço float,
    iva float default 0.15,
    foreign key (id_cartao) references SAIDAS(ID_CARTAO),
	foreign key (id_funcionario) references funcionarios( ID_FUNCIONARIO),
    foreign key (id_saidas) references SAIDAS( ID_SAIDAS)
);
