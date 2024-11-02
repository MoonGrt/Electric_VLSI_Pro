library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DATA_REG is
    Port (
        format_data : in STD_LOGIC_VECTOR(15 downto 0);  -- formatted data input
        threshold : out STD_LOGIC_VECTOR(11 downto 0)   -- threshold output
    );
end DATA_REG;

architecture Behavioral of DATA_REG is
    signal format_data_store : STD_LOGIC_VECTOR(15 downto 0);
begin

    -- Store formatted data
    format_data_store <= format_data;

    -- Assign threshold value
    threshold <= "101111100000";  -- "95" in binary

end Behavioral;
