library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity converter_2s_to_unsigned is
	port (
		clk             : in  std_logic;
		reset           : in  std_logic;
		number          : in  std_logic_vector(10 downto 0); 
		neg_ena			 : out std_logic;
		unsigned_number : out std_logic_vector(10 downto 0) 
	);
end entity;

architecture Behavioral of converter_2s_to_unsigned is

	signal number_signed    : signed(10 downto 0);
	signal number_abs       : unsigned(10 downto 0);

begin

	number_signed <= signed(number); 

	process(clk, reset)
	begin
		if reset = '0' then
			number_abs <= (others => '0');
		elsif rising_edge(clk) then
			if number_signed(10) = '1' then
				number_abs <= unsigned(not number_signed) + 1;
			else
				number_abs <= unsigned(number_signed);
			end if;
		end if;
	end process;
	
	process(clk, reset)
	begin
		if reset = '0' then
			neg_ena <= '0';
		elsif rising_edge(clk) then
			if number(10) = '1' then
				neg_ena <= '1';
			else
				neg_ena <= '0';
			end if;
		end if;
	end process;

	unsigned_number <= std_logic_vector(number_abs);

end architecture;
