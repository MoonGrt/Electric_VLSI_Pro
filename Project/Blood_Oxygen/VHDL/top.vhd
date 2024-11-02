library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    port (
        AC : in STD_LOGIC_VECTOR(7 downto 0);
        DC : in STD_LOGIC_VECTOR(7 downto 0);
        en : in STD_LOGIC;
        clk : in STD_LOGIC;
        fA : out STD_LOGIC;
        fB : out STD_LOGIC;
        ADC_clk : out STD_LOGIC;
        Red : out STD_LOGIC;
        IR : out STD_LOGIC;
        Warn : out STD_LOGIC;
        tx : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    -- Parameters
    constant CLK_FREQ : integer := 32768;
    constant LASER_ON_PARAM : integer := 400;
    constant LASER_OFF_PARAM : integer := 100;
    constant DATA_DELY : integer := 1000;

    signal Format : STD_LOGIC_VECTOR(1 downto 0);
    signal EN_divider, EN_format : STD_LOGIC;
    signal sat : STD_LOGIC_VECTOR(11 downto 0);
    signal sat_data : STD_LOGIC_VECTOR(11 downto 0);
    signal laser_ctrl : STD_LOGIC;
    signal AC_Red, DC_Red, AC_IR, DC_IR : STD_LOGIC_VECTOR(7 downto 0);
    signal data_valid, reg_ctrl : STD_LOGIC_VECTOR(1 downto 0);
    signal threshold : STD_LOGIC_VECTOR(11 downto 0);
    signal format_data : STD_LOGIC_VECTOR(15 downto 0);

begin

    reg_inst : entity work.REG
        port map (
            AC => AC,
            DC => DC,
            laser_ctrl => laser_ctrl,
            reg_ctrl => reg_ctrl,
            data_valid => data_valid,
            clk => clk,
            AC_Red => AC_Red,
            DC_Red => DC_Red,
            AC_IR => AC_IR,
            DC_IR => DC_IR
        );

    ctrl_inst : entity work.ctrl
        generic map (
            CLK_FREQ => CLK_FREQ,
            LASER_ON_PARAM => LASER_ON_PARAM,
            LASER_OFF_PARAM => LASER_OFF_PARAM,
            DATA_DELY => DATA_DELY
        )
        port map (
            en => en,
            clk => clk,
            Red => Red,
            IR => IR,
            fA => fA,
            fB => fB,
            ADC_clk => ADC_clk,
            laser_ctrl => laser_ctrl,
            data_valid => data_valid,
            reg_ctrl => reg_ctrl,
            EN_divider => EN_divider,
            EN_format => EN_format,
            Format => Format
        );

    divider_inst : entity work.divider
        port map (
            AC_Red => AC_Red,
            DC_Red => DC_Red,
            AC_IR => AC_IR,
            DC_IR => DC_IR,
            EN => EN_divider,
            Format => Format,
            sat => sat
        );

    format_block_inst : entity work.format_block
        port map (
            clk => clk,
            din => sat,
            en => EN_format,
            format_data => format_data,
            tx => tx
        );

    alert_inst : entity work.Alert
        port map (
            SAT => sat,
            threshold => threshold,
            Warn => Warn
        );

    data_reg_inst : entity work.data_reg
        port map (
            format_data => format_data,
            threshold => threshold
        );

end Behavioral;
