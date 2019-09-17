--Primeiro Projeto - Unidade Logica e aritmetica
----------------------
-- Engenharia de Computacao
-- Ryan Lemes

-- DeclaraÁ„o da biblioteca para utilizaÁ„o dos tipos logicos e realizaÁ„o de operaÁıes atitmÈticas
LIBRARY ieee;
	USE ieee.STD_LOGIC_1164.ALL;     		  -- Pacote necess·rio para utilziaÁ„o dos tipos logic
	USE ieee.STD_LOGIC_UNSIGNED.ALL;			-- Uso de operadores
	USE ieee.NUMERIC_STD.ALL;
	USE ieee.STD_LOGIC_ARITH.ALL;
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENTITY ALU IS
	PORT(
		 -- DeclaraÁ„o das portas de entrada
		 a_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Entrada de dados a
		 b_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Entrada de dados b usada em operaÁıes de dois operandos
		 c_in	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);	  -- Entrada de Carry
		 op_sel	: IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- Entrada de seleÁ„o da operaÁ„o que ser· realizada
		
		 -- DeclaraÁ„o das portas de SaÌda
		 r_out	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);  -- SaÌda do resultado 
		 c_out	: OUT STD_LOGIC;				              -- SaÌda de Carry/Borrow utilizado nas operaÁıes de adiÁ„o e subtraÁ„o como "vai um" e "emprÈstimo" respectivamente
		 z_out	: OUT STD_LOGIC 					            -- SaÌda de Zero. Que serve para sinalizar quando a saÌda for zero
		);
END ENTITY;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE  ArchALU OF ALU IS

SIGNAL resultado : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	WITH op_sel SELECT
	   resultado <= (a_in + b_in)       WHEN "0000",	-- OperaÁ„o ADD
					(a_in + b_in + c_in) 	      WHEN "0001",	-- OperaÁ„o ADDC   
					(a_in- b_in)                WHEN "0010",	-- OperaÁ„o SUB
					(a_in - b_in) 				      WHEN "0011",	-- OperaÁ„o SUBC		
					(a_in AND b_in) 			      WHEN "0100", 	-- OperaÁ„o AND
					(a_in OR b_in )				      WHEN "0101", 	-- OperaÁ„o OR
					(a_in XOR b_in)				      WHEN "0110", 	-- OperaÁ„o XOR
					(NOT a_in) 					        WHEN "0111",	-- OperaÁ„o CMP
				  a_in(6 downto 0) & a_in(7)	WHEN "1000",	-- OperaÁ„o RL	    
				  a_in(0) & a_in(7 downto 1)	WHEN "1001",	-- OperaÁ„o RR
				  a_in(6 downto 0) & c_in(0)	WHEN "1010",	-- OperaÁ„o RLC		
				  c_in(0) & a_in(7 downto 1)  WHEN "1011", 	-- OperaÁ„o RRC 		
				  a_in(6 downto 0) & '0'		  WHEN "1100",	-- OperaÁ„o SLL 
				  '0' & a_in(7 downto 1)		  WHEN "1101",	-- OperaÁ„o SRL
				  a_in(7) & a_in(7 downto 1)	WHEN "1110", 	-- OperaÁ„o SRA
					(b_in)						          WHEN "1111"; 	-- OperaÁ„o PASS_B
	   
		
		c_out <= '1' 	WHEN (op_sel = "0000" AND a_in(0) = '1' AND b_in(0) = '1') OR 
							 (op_sel = "0001" AND a_in(0) = '1' AND b_in(0) = '1') OR 
							 (op_sel = "0001" AND a_in(0) = '0' AND b_in(0) = '1') OR 
							 (op_sel = "0011" AND a_in(0) = '0' AND b_in(0) = '1') ELSE	
							 
				 '0' 	WHEN (op_sel = "0100") OR 
				 (op_sel = "0101") OR (
				 (op_sel = "0110") OR	 
				 (op_sel = "0111") OR 
				 (op_sel = "1111") ELSE									 
		     
		     a_in(7)	WHEN (op_sel = "1000") OR 
		     (op_sel = "1010") OR 
		     (op_sel = "1100") ELSE									 
		     
		     a_in(0) 	WHEN (op_sel = "1001") OR 
		     (op_sel = "1011") OR 
		     (op_sel = "1101") OR	 
		     (op_sel = "1110");
		
		r_out <= resultado;
			
		z_out <= '1' WHEN resultado = "00000000" ELSE '0';
		
END ArchALU;
