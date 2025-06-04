library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_neg_in is
	port
	(
		neg_ena_in  : in std_logic;
		hex	  		: out std_logic_vector(7 downto 0)
	);
end entity;

architecture Behavioral of seven_seg_neg_in is
begin

	hex <= "10011101" when neg_ena_in = '1' else "11111111";
	
end architecture;