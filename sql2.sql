use trabalhoBD_2;



-------- insertes nas tabelas --------
insert cliente(NUMCLIENTE , NOME, IDADE, NIF) values 
		   (152, "joao", 18,159),
		   (753, "jose", 19,528),
           (856, "AMILIO",50,846),
		   (365, "ALBERTO",86,842);
           
insert carros (matricula, marca) values
			(357159, "opel"),
			(158742, "mercedes"),
			(963514, "dacia"),
			(256148, "ferrari");
            
insert FUNCIONARIOS (ID_FUNCIONARIO, nome, idade, morada) values
			(1234, "hugo", 15,"braga"),
            (3564, "ana", 65 ,"porto"),
            (5268, "fabrisio", 42, "viana"),
            (5486, "alex", 17, "anha");
 

insert into cartao(id_cartao,NUMCLIENTE,MATRICULA) values
			(13,152,357159),
            (15,753,158742),
            (35,856,963514),
            (45,365,256148);
            
insert into  saidas  (preco_s)  value (30)  ;
            
            
insert into ENTRADAS ( id_cartao, id_funcionario) values
			(13, 1234 ),
            (15,3564 ),
            (35,5268),
            (45,5486);
            

           
insert into SAIDAS (ID_CARTAO, ID_FUNCIONARIO, preco_s) values
			(13, 1234, 15),
            (15, 3564,5),
            (35, 5268,14),
            (45, 5486,69);
insert into codpostal (codpostal, rua ,cidade)	values 
			(15975368, "rua 25 de abril", "porto" ),
            (14785236, "avenida dos aliados", "lisboa"),
            (85493268,"rua das flores" , "lisboa"),
            (47856958, "rua luis barroso", "famalicao");
            
            
-------- update -------
 
 update funcionarios set idade = 18 where id_funcionario = 1234;
 update saidas set preco_s  = 53 where id_cartao = 13;
 update funcionarios set ganhos = 60 where id_funcionario = 3564;
 update funcionarios set codpostal = 47856958 where id_funcionario =	5486;

 
 -------- consultas --------
 
 select*from cliente where nome like "%o";
 select*from funcionarios where idade between 20 and 70;
 select id_funcionario, ganhos from funcionarios where ganhos is not null;
 select sum(preco_s), max(preco_s) from saidas where id_saidas in (21, 22, 23);
 select*from fatura order by preço desc limit 3;
 
 
 select fu.*, en.id_entradas, en.id_funcionario, en.data_e, sa.id_saidas,sa.id_funcionario, sa.datas_s from funcionarios as fu
inner join entradas as en on fu.ID_funcionario =en.ID_funcionario 
inner join saidas as sa on fu.ID_funcionario =sa.ID_funcionario 
where fu.id_funcionario = sa.id_funcionario and fu.id_funcionario = en.id_funcionario ;

select cl.numcliente, cl.nome ,max(fa.preço) from cliente as cl 
inner join cartao as ca on cl.numcliente = ca.numcliente 
inner join fatura as fa on ca.id_cartao = fa.id_cartao;

select  car.marca, fu.nome, fu.id_funcionario from carros as car
inner join cartao as ca on car.matricula = ca.matricula
inner join saidas as sa on ca.id_cartao =sa.id_cartao 
inner join funcionarios as fu on fu.id_funcionario =sa.id_funcionario
where car.marca = "ferrari";

SELECT cp.cidade FROM codpostal cp
INNER JOIN funcionarios fu ON fu.codpostal = cp.codpostal
GROUP BY (cp.cidade)
HAVING COUNT(*) >= 2;


 
 
-------- alters -------

alter table cartao add saldo float;
alter table funcionarios add ganhos float;
ALTER TABLE ENTRADAS DROP preco_e ;
alter table funcionarios drop MORADA;
alter table funcionarios add codpostal int ;

drop tables entrada_cartao, entrada_funcionario, saida_cartao, saida_funcionario;
            
------------- view -------------------

create view infoclientes as(
select cl.*, car.matricula, car.marca, ca.id_cartao, ca.saldo  from CLIENTE as cl
inner join cartao as ca on cl.numcliente = ca.numcliente
inner join carros as car on car.matricula = ca.matricula
);    
select*from infoclientes;

create view salarios as(
 select id_funcionario, nome, ganhos, dividendos(ganhos) from funcionarios
);
select*from salarios;


drop view  infoentradas, infocartao, infocarros  ;

   
------- transaction -------
   
start transaction; 
	update cartao set saldo = saldo+  150 where numcliente = 152 ;
commit;
            
start transaction;
	update cartao set saldo = saldo - 50 where numcliente =152;
    update funcionarios set ganhos = ganhos + 50 where id_funcionario =1234; 
    update saidas set preco_s = 50 where id_saidas = 1;
commit;
     
-------- funçoens -------



DELIMITER $$
create function dividendos (ganhos float)
	returns float
	DETERMINISTIC
begin
	declare salario float;
    
    set  salario = ganhos * 0.45 ;
    
    RETURN salario;
end$$
DELIMITER ;    


     
-- trigers -------

DELIMITER $$
create trigger crefatura 
after insert
on saidas for each row
begin
	insert into fatura (id_cartao,id_funcionario, id_saidas, preço )
    values ( new.id_cartao, new.ID_FUNCIONARIO, new.ID_SAIDAS, new.preco_s = new.preco_s + ( new.preco_s  * iva));
END$$
DELIMITER ;

