DELIMITER $$

DROP PROCEDURE IF EXISTS sp_deposito$$

CREATE PROCEDURE sp_deposito(IN p_conta SMALLINT(5) UNSIGNED, p_valor DECIMAL(10 , 2))
BEGIN
	DECLARE descricao varchar(80);
	DECLARE v_saldo , c_conta int;
    SELECT nr_conta INTO c_conta FROM conta WHERE nr_conta = p_conta LIMIT 1;
	SELECT saldo INTO v_saldo FROM conta WHERE c_conta = p_conta LIMIT 1;
	IF (c_conta=p_conta) THEN
		IF (p_valor>0) THEN
			START TRANSACTION;
				SET SQL_SAFE_UPDATES=0;
				UPDATE conta SET saldo = saldo + p_valor WHERE nr_conta = p_conta;
                SELECT CONCAT('Depósito de ',p_valor) INTO descricao;  
				INSERT INTO movimentacao (nr_conta,dtmov_conta,vl_mov,ds_mov) 
					values(c_conta,default,p_valor,descricao);
				SET SQL_SAFE_UPDATES=1;
			COMMIT;
		ELSE
			SELECT 'Valor inválido para a operação.';
		END IF;
	ELSE
		SELECT 'Conta inexistente.';
	END IF;
END$$

DELIMITER ;
