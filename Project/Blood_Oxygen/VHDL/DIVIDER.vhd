library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIVIDER is
    Port (
        AC_Red : in  STD_LOGIC_VECTOR(7 downto 0);
        DC_Red : in  STD_LOGIC_VECTOR(7 downto 0);
        AC_IR  : in  STD_LOGIC_VECTOR(7 downto 0);
        DC_IR  : in  STD_LOGIC_VECTOR(7 downto 0);
        EN     : in  STD_LOGIC;
        Format : in  STD_LOGIC_VECTOR(1 downto 0);
        sat    : out STD_LOGIC_VECTOR(11 downto 0)
    );
end entity DIVIDER;

architecture Behavioral of DIVIDER is
begin
    process(AC_Red, DC_Red, AC_IR, DC_IR, EN)
    variable temp_AC_Red : integer;
    variable temp_DC_Red : integer;
    variable temp_AC_IR  : integer;
    variable temp_DC_IR  : integer;
    variable temp_result : integer;
    begin
        if EN = '1' then
            if AC_Red /= x"00" and DC_Red /= x"00" and AC_IR /= x"00" and DC_IR /= x"00" then
                -- Convert STD_LOGIC_VECTOR to integer
                temp_AC_Red := to_integer(unsigned(AC_Red));
                temp_DC_Red := to_integer(unsigned(DC_Red));
                temp_AC_IR  := to_integer(unsigned(AC_IR));
                temp_DC_IR  := to_integer(unsigned(DC_IR));

                -- Perform the division
                temp_result := (temp_AC_Red / temp_DC_Red) / (temp_AC_IR / temp_DC_IR);

                -- Convert the result back to STD_LOGIC_VECTOR
                sat <= std_logic_vector(to_unsigned(temp_result, sat'length));
            else
                sat <= (others => '0');
            end if;
        else
            sat <= (others => '0');
        end if;
    end process;
end architecture Behavioral;
