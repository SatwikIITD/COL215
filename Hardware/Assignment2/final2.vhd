----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2023 02:39:18 PM
-- Design Name: 
-- Module Name: final2 - Behavioral
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

entity final2 is
    Port (  clk : IN STD_LOGIC;
               HSYNC: out STD_LOGIC;
               VSYNC: out STD_LOGIC;
                  R0: out STD_LOGIC;
                  R1: out STD_LOGIC;
                  R2: out STD_LOGIC;
                  R3: out STD_LOGIC;
                  B0: out STD_LOGIC;
                  B1: out STD_LOGIC;
                  B2: out STD_LOGIC;
                  B3: out STD_LOGIC;
                  G0: out STD_LOGIC;
                  G1: out STD_LOGIC;
                  G2: out STD_LOGIC;
                  G3: out STD_LOGIC);
end final2;

architecture Behavioral of final2 is

signal   clk25: std_logic:= '0';
signal   clk50: std_logic:= '0';
signal   we: std_logic:= '1';
signal   re: std_logic:= '0';
signal hPos: integer:=0;
signal vPos: integer:=0;
signal ram_op : STD_LOGIC := '1';
signal rst : STD_LOGIC := '1';
signal rdaddress : std_logic_vector(15 downto 0) := (others => '0');
signal weaddress : std_logic_vector(15 downto 0) := (others => '0');
signal data : std_logic_vector(7 downto 0) := (others => '0');
signal final_output : std_logic_vector(7 downto 0):= (others => '0');
signal gradient_out : std_logic_vector(7 downto 0):= (others => '0');
signal pixel_index  : INTEGER range -2 to 65535*2 := -2;

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

COMPONENT vga
Port (         RST: in STD_LOGIC;
    	       CLK25: in STD_LOGIC;
       pixel_value: in STD_LOGIC_VECTOR( 7 downto 0);
	         HSYNC: out STD_LOGIC;
	         VSYNC: out STD_LOGIC;
                R0: out STD_LOGIC;
                R1: out STD_LOGIC;
                R2: out STD_LOGIC;
                R3: out STD_LOGIC;
                B0: out STD_LOGIC;
                B1: out STD_LOGIC;
                B2: out STD_LOGIC;
                B3: out STD_LOGIC;
                G0: out STD_LOGIC;
                G1: out STD_LOGIC;
                G2: out STD_LOGIC;
                G3: out STD_LOGIC;
                hPo: out integer;
	            vPo: out integer);
END COMPONENT; 

begin

uut1: dist_mem_gen_0 PORT MAP (
clk => clk25,
spo => data,
a => rdaddress
);

uut2: filter PORT MAP (
clk => clk25,
pixel_index => pixel_index,
pixel_in => data,
gradient_out => gradient_out
);

uut3: RAM PORT MAP (
clk => clk25,
we => we,
re => re,
addr => weaddress,
din => gradient_out,
dout => final_output
);

uut4: vga PORT MAP ( 
CLK25 => clk25,
RST => rst,
pixel_value => final_output,
HSYNC => HSYNC,
VSYNC => VSYNC,
R0 => R0,
R1 => R1,
R2 => R2,
R3 => R3,
B0 => B0,
B1 => B1,
B2 => B2,
B3 => B3,
G0 => G0,
G1 => G1,
G2 => G2,
G3 => G3,
hpo => hpos,
vpo => vpos
);

clk_div: process(CLK)
begin
	if(CLK'event and CLK='1') then
		clk50 <=not clk50;
	end if;

end process;

clk_div2: process(CLK50)
begin
	if(CLK50'event and CLK50='1') then
		clk25 <=not clk25;
	end if;

end process;

process(clk25)
begin
    if (rising_edge(clk25)) then
        if (pixel_index<=65537) then
            if (pixel_index=-2) then
                rdaddress <= std_logic_vector(to_unsigned(0, 16));
            elsif (pixel_index=-1) then
                rdaddress <= std_logic_vector(to_unsigned(1, 16));
            elsif (pixel_index < 2) then
                rdaddress <= std_logic_vector(to_unsigned(pixel_index + 2, 16));
            elsif (pixel_index <=65533) then
                rdaddress <= std_logic_vector(to_unsigned(pixel_index + 2, 16));    
                weaddress <= std_logic_vector(to_unsigned(pixel_index - 2, 16));
            else
                weaddress <= std_logic_vector(to_unsigned(pixel_index - 2 , 16));
                if (pixel_index = 65537) then
                    we <= '0';
                    re <= '1';
                   end if;
            end if;
            pixel_index <= pixel_index + 1;
        
        elsif (pixel_index >= 65538) then
            if (pixel_index = 65539) then
                rst <= '0';
            end if;
            weaddress <= std_logic_vector(to_unsigned(pixel_index-65538, 16));
            if (hpos >= 9 and hpos<265 and vpos >= 10 and vpos <266) then
                pixel_index <= pixel_index+1;
            elsif (pixel_index < 65539) then
                pixel_index <= pixel_index+1;
            end if;
        end if;
    end if;
end process;

end Behavioral;
