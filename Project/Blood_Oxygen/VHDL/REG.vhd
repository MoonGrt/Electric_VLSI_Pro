library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REG is
    Port (
        clk : in STD_LOGIC;
        laser_ctrl : in STD_LOGIC;
        reg_ctrl : in STD_LOGIC_VECTOR(1 downto 0);
        data_valid : in STD_LOGIC_VECTOR(1 downto 0);
        AC : in STD_LOGIC_VECTOR(7 downto 0);
        DC : in STD_LOGIC_VECTOR(7 downto 0);
        AC_Red : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        DC_Red : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        AC_IR : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        DC_IR : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
    );
end REG;

architecture Behavioral of REG is
    signal Amb : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Mix : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

    -- DC data gen & store
    process(reg_ctrl(0))
    begin
        if rising_edge(reg_ctrl(0)) then
            if data_valid(0) = '1' then
                Mix <= DC;
            else
                Amb <= DC;
            end if;
        end if;
    end process;

    process(reg_ctrl(1))
    begin
        if falling_edge(reg_ctrl(1)) then
            if laser_ctrl = '1' then
                DC_Red <= Mix - Amb;
            else
                DC_IR <= Mix - Amb;
            end if;
        end if;
    end process;

    -- AC data store
    process(reg_ctrl(1))
    begin
        if rising_edge(reg_ctrl(1)) then
            if laser_ctrl = '1' then
                AC_Red <= AC;
            else
                AC_IR <= AC;
            end if;
        end if;
    end process;

end Behavioral;
