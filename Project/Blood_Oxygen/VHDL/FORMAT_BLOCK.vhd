library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FORMAT_BLOCK is
    Port ( clk         : in  STD_LOGIC;
           en          : in  STD_LOGIC;
           din         : in  STD_LOGIC_VECTOR(11 downto 0);
           format_data : out STD_LOGIC_VECTOR(15 downto 0);
           tx          : out STD_LOGIC := '1'
          );
end FORMAT_BLOCK;

architecture Behavioral of FORMAT_BLOCK is
    signal shift_reg     : STD_LOGIC_VECTOR(23 downto 0) := (others => '1');
    signal pack_head     : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    signal pack_tail     : STD_LOGIC_VECTOR(1 downto 0) := "11";
    signal parity        : STD_LOGIC_VECTOR(1 downto 0);
    signal integer_part  : STD_LOGIC_VECTOR(7 downto 0);
    signal fraction_part : STD_LOGIC_VECTOR(7 downto 0);
    signal fraction_full : STD_LOGIC_VECTOR(9 downto 0);
begin

    format_data <= integer_part & fraction_part;
    
    integer_part <= "0" & din(11 downto 5);
    fraction_full <= std_logic_vector(unsigned(din(4 downto 0)) * 100 / 32);
    fraction_part <= fraction_full(7 downto 0);
    
    parity(0) <= integer_part(0) xor integer_part(1) xor integer_part(2) xor integer_part(3) xor 
                 integer_part(4) xor integer_part(5) xor integer_part(6) xor integer_part(7);
                 
    parity(1) <= fraction_part(0) xor fraction_part(1) xor fraction_part(2) xor fraction_part(3) xor 
                 fraction_part(4) xor fraction_part(5) xor fraction_part(6) xor fraction_part(7);

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                shift_reg <= pack_head & integer_part & parity(0) & fraction_part & parity(1) & pack_tail;
            else
                tx <= shift_reg(23);
                shift_reg <= shift_reg(22 downto 0) & '1';  -- left shift
            end if;
        end if;
    end process;

end Behavioral;
