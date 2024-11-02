library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CTRL is
    generic (
        CLK_FREQ : integer := 32768;
        LASER_ON_PARAM : integer := 400;  -- laser on time in ms
        LASER_OFF_PARAM : integer := 100; -- laser off time in ms
        DATA_DELY : integer := 1024       -- data delay
    );
    port (
        en : in STD_LOGIC;
        clk : in STD_LOGIC;
        Red : out STD_LOGIC;
        IR : out STD_LOGIC;
        fA : out STD_LOGIC;
        fB : out STD_LOGIC;
        ADC_clk : out STD_LOGIC;
        laser_ctrl : inout STD_LOGIC;
        data_valid : out STD_LOGIC_VECTOR(1 downto 0);
        reg_ctrl : out STD_LOGIC_VECTOR(1 downto 0);
        EN_divider : out STD_LOGIC;
        EN_format : out STD_LOGIC;
        Format : out STD_LOGIC_VECTOR(1 downto 0) := "00"
    );
end CTRL;

architecture Behavioral of CTRL is

    constant LASER_ON_TIME : integer := CLK_FREQ * LASER_ON_PARAM / 1000;
    constant LASER_OFF_TIME : integer := CLK_FREQ * LASER_OFF_PARAM / 1000;

    signal cnt : unsigned(CLK_FREQ-1 downto 0);
    signal cnt_valid : unsigned(CLK_FREQ-1 downto 0);
begin

    -- Counter process
    process(clk, en)
    begin
        if en = '0' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if cnt = CLK_FREQ-1 then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    -- ADC Block Clock Generator
    fA <= cnt(13);
    fB <= '0';
    ADC_clk <= cnt(4);

    -- ADC Register Controller Generate R/W Signal
    cnt_valid <= cnt - (LASER_ON_TIME + LASER_OFF_TIME) when laser_ctrl = '1' else cnt;
    data_valid(0) <= '1' when (cnt_valid > DATA_DELY and cnt_valid < LASER_ON_TIME - DATA_DELY) else '0';
    data_valid(1) <= '1' when (cnt_valid > DATA_DELY + LASER_ON_TIME and cnt_valid < LASER_ON_TIME + LASER_OFF_TIME - DATA_DELY) else '0';
    reg_ctrl(0) <= '1' when (cnt_valid = LASER_ON_TIME - DATA_DELY - 1 or cnt_valid = LASER_ON_TIME + LASER_OFF_TIME - DATA_DELY - 1) else '0';
    reg_ctrl(1) <= '1' when cnt_valid = LASER_ON_TIME + LASER_OFF_TIME - DATA_DELY - 1 else '0';

    -- IR and Red Controller
    IR <= '1' when en = '1' and cnt < LASER_ON_TIME else '0';
    Red <= '1' when en = '1' and cnt > LASER_ON_TIME + LASER_OFF_TIME and cnt < LASER_ON_TIME * 2 + LASER_OFF_TIME else '0';
    laser_ctrl <= '1' when cnt > LASER_ON_TIME + LASER_OFF_TIME else '0';

    -- Divider and Format Controller (Providing EN, Format Signals)
    EN_divider <= '1' when cnt > LASER_ON_TIME * 2 + LASER_OFF_TIME * 2 - DATA_DELY / 2 - 1 and cnt < LASER_ON_TIME * 2 + LASER_OFF_TIME * 2 - DATA_DELY / 4 - 1 else '0';
    EN_format <= '1' when cnt > LASER_ON_TIME * 2 + LASER_OFF_TIME * 2 - DATA_DELY / 4 - 1 else '0';

end Behavioral;
