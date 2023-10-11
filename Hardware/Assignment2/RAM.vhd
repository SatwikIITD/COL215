----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2022 12:15:52 AM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
  Port ( 
    clk : in STD_LOGIC ; 
    we : in STD_LOGIC ;
    re : in STD_LOGIC ;
    addr : in STD_LOGIC_VECTOR( 15 downto 0 ); 
    din : in STD_LOGIC_VECTOR( 7 downto 0 ); 
    dout : out STD_LOGIC_VECTOR( 7 downto 0 )
    );
end RAM;

architecture Behavioral of RAM is
TYPE mem_type IS ARRAY(0 TO 65535 ) OF std_logic_vector( 7 DOWNTO 0);
    signal RAM : mem_type ;  
    --signal valStore : STD_LOGIC_VECTOR( 7 downto 0 ) ; 

begin

process( clk )
begin
    if( rising_edge(clk) and we = '1' ) then
        RAM( to_integer( unsigned(addr))) <= din ; 
    end if ;
end process ;

process(clk) 
begin 
    if( rising_edge(clk) and re = '1' ) then 
        dout <= RAM(to_integer(unsigned(addr))) ;
    end if ; 
end process ;
--dout <= valStore ;  
end Behavioral;
