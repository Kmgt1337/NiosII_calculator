	component nios2 is
		port (
			clk_clk       : in  std_logic                     := 'X';             -- clk
			input_export  : in  std_logic_vector(10 downto 0) := (others => 'X'); -- export
			output_export : out std_logic_vector(10 downto 0);                    -- export
			reset_reset_n : in  std_logic                     := 'X'              -- reset_n
		);
	end component nios2;

	u0 : component nios2
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --    clk.clk
			input_export  => CONNECTED_TO_input_export,  --  input.export
			output_export => CONNECTED_TO_output_export, -- output.export
			reset_reset_n => CONNECTED_TO_reset_reset_n  --  reset.reset_n
		);

