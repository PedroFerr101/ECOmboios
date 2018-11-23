USE comboios;

-- CLIENTES
INSERT INTO cliente(nome, email, nif, password)
VALUES ('Alberto Caeiro', 'albertinho1@gmail.com', 111111111, 'heteronimo'),
	   ('Ricardo Reis', 'reidistotudo@hotmail.com', 222222222, 'souMedico'),
	   ('Álvaro de Campos', 'alvarinho@tinto.com', 333333333, 'EngenheiroSouEu'),
       ('Fernando Pessoa', 'fp@portugalmail.com', 102348201, 'oOriginal'),
       ('Pedro Moreira', 'pedrom@gmail.com', 238881920, 'qwerty123'),
       ('Pedro Ferreira', 'ferreirinha@gmail.com', 231772893, 'asdfg456'),
       ('Diogo Sobral', 'diogosobral@hotmail.com', 182992102, 'zxcvb789'),
       ('Henrique Pereira', 'palmeira@gmail.com', 231983210, 'qazwsx123');
        
SELECT * FROM cliente;
                  
                  
                  
-- ESTACAO
INSERT INTO estacao(nome)
VALUES ('Braga'), ('Porto'), ('Lisboa');

SELECT * FROM estacao;



-- COMBOIO (6 comboios)
INSERT INTO comboio
VALUES (), (), (), (), (), ();

SELECT * FROM comboio;


-- LUGAR
DELIMITER $$
CREATE PROCEDURE adiciona_lugares(IN id_comboio INT) -- PROCEDURE OU FUNCTION ???????????????????????????????
BEGIN
	DECLARE i INT DEFAULT 1;
    
    WHILE (i <= 50) DO
		INSERT INTO lugar(classe, numero, comboio)
		VALUES ('P', i, id_comboio), ('E', i, id_comboio);
        SET i = i+1;
	END WHILE;
	
    WHILE (i <= 200) DO
		INSERT INTO lugar(classe, numero, comboio)
		VALUES ('E', i, id_comboio);
        SET i = i+1;
	END WHILE;
END $$

CALL adiciona_lugares(1);

SELECT * FROM lugar WHERE comboio = 1 ORDER BY classe;

-- VIAGEM
DELIMITER $$
CREATE PROCEDURE adiciona_workday(IN dia DATE) -- PROCEDURE OU FUNCTION ???????????????????????????????
BEGIN
	DECLARE i INT DEFAULT 7;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- BRAGA -> PORTO
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i HOUR),  INTERVAL 20 MINUTE), 10.00, 1, 1, 2),
			   (date_add(dia, INTERVAL i+1 HOUR), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 20 MINUTE), 10.00, 2, 1, 2),
               -- PORTO -> BRAGA
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i HOUR),  INTERVAL 30 MINUTE), 10.00, 2, 2, 1),
			   (date_add(date_add(dia, INTERVAL i+1 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 30 MINUTE), 10.00, 1, 2, 1);
		SET i = i + 2;
    END WHILE;
    
    SET i = 7;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- PORTO -> LISBOA
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 25 MINUTE), 25.00, 3, 2, 3),
			   (date_add(dia, INTERVAL i+2 HOUR), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 25 MINUTE), 25.00, 4, 2, 3),
               -- LISBOA -> PORTO
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 55 MINUTE), 25.00, 4, 3, 2),
			   (date_add(date_add(dia, INTERVAL i+2 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 55 MINUTE), 25.00, 3, 3, 2);
		SET i = i + 4;
    END WHILE;
    
    SET i = 8;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- BRAGA -> LISBOA
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 45 MINUTE), 35.00, 5, 1, 3),
			   (date_add(dia, INTERVAL i+2 HOUR), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 45 MINUTE), 35.00, 6, 1, 3),
               -- LISBOA -> BRAGA
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 55 MINUTE), 35.00, 6, 3, 1),
			   (date_add(date_add(dia, INTERVAL i+2 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 55 MINUTE), 35.00, 5, 3, 1);
		SET i = i + 4;
    END WHILE;
END $$


CALL adiciona_workday('2018-12-01');
DELETE FROM viagem WHERE id_viagem >= 1; 
SELECT TIME(data_partida), TIME(data_chegada) FROM viagem WHERE origem = 3 AND destino = 1;

SELECT v.data_partida, v.data_chegada, v.duracao, eo.nome AS origem, ed.nome AS destino
FROM viagem AS v INNER JOIN estacao AS eo
				 ON v.origem = eo.id_estacao
                 INNER JOIN estacao AS ed
                 ON v.destino = ed.id_estacao;
                 
                 
                 
-- BILHETE
DELIMITER $$
CREATE PROCEDURE adiciona_bilhete(IN id_cliente INT, classe INT, numero INT, id_viagem INT) -- PROCEDURE OU FUNCTION ??????????????????????????????????????????
BEGIN
	INSERT INTO bilhete(data_aquisicao, classe, numero, cliente, viagem)
	VALUES (now(), classe, numero, id_cliente, id_viagem);
END $$
       
SELECT * FROM bilhete;

SELECT c.nome, eo.nome AS origem, ed.nome AS destino, v.duracao, b.preco, b.classe, b.numero, b.id_bilhete
FROM cliente AS c INNER JOIN bilhete AS b
				  ON c.id_cliente = b.cliente
					INNER JOIN viagem AS v
                    ON b.viagem = v.id_viagem
						INNER JOIN estacao AS eo
                        ON v.origem = eo.id_estacao
                        INNER JOIN estacao AS ed
                        ON v.destino = ed.id_estacao;
				
				