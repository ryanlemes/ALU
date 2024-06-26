-- First project - Arithmetic Logic Unit
----------------------
-- Computer Engineering Degree Computer Architecture class
-- Author: Ryan Lemes

-- Library declaration to use it on logic types and arithmetic operetions 
LIBRARY ieee;
	USE ieee.STD_LOGIC_1164.ALL;     		  	-- Package necessary to use logic types
	USE ieee.STD_LOGIC_UNSIGNED.ALL;			-- Package to use Operators
	USE ieee.NUMERIC_STD.ALL;
	USE ieee.STD_LOGIC_ARITH.ALL;
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENTITY ALU IS
	PORT(
		 -- Input ports declaration
		 a_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Data input "a"
		 b_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Data input "b", used in two operand operations
		 c_in	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);	  -- Carry input
		 op_sel	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);   -- Input to select the operation to be performed
		
		 -- Output ports declaration
		 r_out	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Result output 
		 c_out	: OUT STD_LOGIC;				      -- Carry/Borrow output, used in subtraction and addition operations
		 z_out	: OUT STD_LOGIC 					  -- Zero output. Used when the output is zero 
		);
END ENTITY;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE  ArchALU OF ALU IS

SIGNAL result : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	WITH op_sel SELECT
		result <= (a_in + b_in)       	WHEN "0000",	-- ADD operation
			(a_in + b_in + c_in) 	    WHEN "0001",	-- ADDC operation   
			(a_in- b_in)                WHEN "0010",	-- SUB operation
			(a_in - b_in) 				WHEN "0011",	-- SUBC operation		
			(a_in AND b_in) 			WHEN "0100", 	-- ND operation
			(a_in OR b_in )				WHEN "0101", 	-- OR operation
			(a_in XOR b_in)				WHEN "0110", 	-- XOR operation
			(NOT a_in) 					WHEN "0111",	-- CMP operation
			a_in(6 downto 0) & a_in(7)	WHEN "1000",	-- RL  operation	    
			a_in(0) & a_in(7 downto 1)	WHEN "1001",	-- RR operation
			a_in(6 downto 0) & c_in(0)	WHEN "1010",	-- RLC operation		
			c_in(0) & a_in(7 downto 1)  WHEN "1011", 	-- RRC operation 		
			a_in(6 downto 0) & '0'		WHEN "1100",	-- SLL operation 
			'0' & a_in(7 downto 1)		WHEN "1101",	-- SRL operation
			a_in(7) & a_in(7 downto 1)	WHEN "1110", 	-- SRA operation
			(b_in)						WHEN "1111"; 	-- PASS_B operation

		
		c_out <= '1' WHEN (op_sel = "0000" AND a_in(0) = '1' AND b_in(0) = '1') OR 
					(op_sel = "0001" AND a_in(0) = '1' AND b_in(0) = '1') OR 
					(op_sel = "0001" AND a_in(0) = '0' AND b_in(0) = '1') OR 
					(op_sel = "0011" AND a_in(0) = '0' AND b_in(0) = '1') ELSE	
							 
				'0' WHEN (op_sel = "0100") OR 
				 	(op_sel = "0101") OR (
				 	(op_sel = "0110") OR	 
					(op_sel = "0111") OR 
					(op_sel = "1111") ELSE									 
		     
		     	a_in(7)	WHEN (op_sel = "1000") OR 
		     		(op_sel = "1010") OR 
		     		(op_sel = "1100") ELSE									 
		     
		     	a_in(0) WHEN (op_sel = "1001") OR 
				    (op_sel = "1011") OR 
					(op_sel = "1101") OR	 
					(op_sel = "1110");
		
		r_out <= resultado;
			
		z_out <= '1' WHEN resultado = "00000000" ELSE '0';
		
END ArchALU;
