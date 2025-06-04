library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_neg is
	port
	(
		neg_ena : in std_logic;
		hex	  : out std_logic_vector(7 downto 0)
	);
end entity;

architecture Behavioral of seven_seg_neg is
begin

	hex <= "10111111" when neg_ena = '1' else "11111111";
	
end architecture;