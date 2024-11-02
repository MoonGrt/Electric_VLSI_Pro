library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALERT is
    Port (
        SAT : in STD_LOGIC_VECTOR(11 downto 0);        -- input saturation data
        threshold : in STD_LOGIC_VECTOR(11 downto 0);  -- threshold value
        Warn : out STD_LOGIC                          -- warning signal
    );
end ALERT;

architecture Behavioral of ALERT is
begin
    -- Warning signal assignment
    Warn <= '1' when unsigned(SAT) > unsigned(threshold) else '0';
end Behavioral;
