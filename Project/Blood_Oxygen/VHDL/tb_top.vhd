library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    -- top Parameters
    constant T : time := 30518ns;

    -- top Inputs
    signal AC : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal DC : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal en : STD_LOGIC := '0';
    signal clk : STD_LOGIC := '0';

    -- top Outputs
    signal Red : STD_LOGIC;
    signal IR : STD_LOGIC;
    signal Warn : STD_LOGIC;
    signal tx : STD_LOGIC;

begin

--    -- Clock generation
--    clk_process : process
--    begin
--        loop
--            clk <= '0';
--            wait for T / 2;
--            clk <= '1';
--            wait for T / 2;
--        end loop;
--    end process;
    clk <= not clk after T/2;
    
    -- Stimulus process
    stimulus : process
    begin
        wait for T * 100;
        en <= '1';
        DC <= "10011111"; -- 159
        wait for T * 13200;
        DC <= "01111100"; -- 124
        AC <= "01011001"; -- 89
        wait for T * 10000;
        DC <= "10100011"; -- 163
        wait;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    u_top : entity work.top
        port map (
            AC => AC,
            DC => DC,
            en => en,
            clk => clk,
            Red => Red,
            IR => IR,
            Warn => Warn,
            tx => tx
        );

end Behavioral;
