----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/29/2023 03:13:44 PM
-- Design Name: 
-- Module Name: filter_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter_tb is
--  Port ( );
end filter_tb;

architecture Behavioral of filter_tb is

signal clk : std_logic := '0';
signal rdaddress : std_logic_vector(15 downto 0) := (others => '0');
signal weaddress : std_logic_vector(15 downto 0) := (others => '0');
signal data : std_logic_vector(7 downto 0) := (others => '0');
signal final_output : std_logic_vector(7 downto 0):= (others => '0');
signal gradient_out : std_logic_vector(7 downto 0):= (others => '0');
signal pixel_index  : INTEGER range -2 to 65535 := -2;

COMPONENT dist_mem_gen_0
PORT(
    clk : IN STD_LOGIC;
    a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;

COMPONENT filter
Port(
    clk          : in STD_LOGIC;
    pixel_index  : in INTEGER range -2 to 65535;
    pixel_in     : in std_logic_vector(7 downto 0);
    gradient_out : out std_logic_vector(7 downto 0)
);
END COMPONENT; 

COMPONENT RAM
Port ( 
    clk : in STD_LOGIC ; 
    we : in STD_LOGIC ;
    re : in STD_LOGIC ;
    addr : in STD_LOGIC_VECTOR( 15 downto 0 ) ; 
    din : in STD_LOGIC_VECTOR( 7 downto 0 ) ; 
    dout : out STD_LOGIC_VECTOR( 7 downto 0 )
    
   );
END COMPONENT; 

begin

uut1: dist_mem_gen_0 PORT MAP (
clk => clk,
spo => data,
a => rdaddress
);

uut2: filter PORT MAP (
clk => clk,
pixel_index => pixel_index,
pixel_in => data,
gradient_out => gradient_out
);

uut3: RAM PORT MAP (
clk => clk,
we => '1',
re => '0',
addr => weaddress,
din => gradient_out,
dout => final_output
);

clock :process
begin
    clk <= '0';
        wait for 1ns;
    clk <= '1';
        wait for 1ns;
end process;

--pixel_index <= -2;

process(clk)
begin
    --wait for 0.5ns;
    if (pixel_index<=65533) then
        if (rising_edge(clk)) then
            if (pixel_index=-2) then
                rdaddress <= std_logic_vector(to_unsigned(0, 16));
            elsif (pixel_index=-1) then
                rdaddress <= std_logic_vector(to_unsigned(1, 16));
            else
                rdaddress <= std_logic_vector(to_unsigned(pixel_index + 2, 16));
                weaddress <= std_logic_vector(to_unsigned(pixel_index , 16));
            end if;
            pixel_index <= pixel_index + 1;
        end if;
    end if;
end process;
    
end Behavioral;
