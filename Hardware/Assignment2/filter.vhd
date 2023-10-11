----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/29/2023 01:59:03 PM
-- Design Name: 
-- Module Name: filter - Behavioral
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

entity filter is
--  Port ( );
    Port(
    clk          : in STD_LOGIC;
    pixel_index  : in INTEGER range -2 to 65535;
    pixel_in     : in std_logic_vector(7 downto 0);
    gradient_out : out std_logic_vector(7 downto 0)
    );
end filter;

architecture Behavioral of filter is
    --signal gradient_y : INTEGER;
    signal pixel_prev, pixel_cur, pixel_next : INTEGER;
    
begin

process(clk)
    begin
        if rising_edge(clk) then
            if pixel_index=-2 then
                NULL;
            elsif pixel_index=-1 then
                NULL;
            elsif pixel_index=0 then 
                --gradient_y <= 0;
                gradient_out <= "00000000";
                pixel_prev<=0;
                pixel_cur<=0;
                pixel_next<=to_integer(unsigned(pixel_in));
                
            elsif pixel_index=1 then 
                --gradient_y <= 0;
                gradient_out <= "00000000";
                pixel_prev<= 0;
                pixel_cur <= pixel_next;
                pixel_next<=to_integer(unsigned(pixel_in));
                
            else
                if (pixel_index mod 256 > 2 or pixel_index mod 256 = 0) then
                    pixel_prev <= pixel_cur;
                    pixel_cur <= pixel_next;
                    pixel_next <= to_integer(unsigned(pixel_in));
                    if (pixel_prev - 2*pixel_cur + pixel_next<0) then
                        gradient_out <= "00000000";
                    elsif(pixel_prev - 2*pixel_cur + pixel_next>255) then
                        gradient_out <= "11111111";
                    else
                        gradient_out <= std_logic_vector(to_unsigned((-2)*pixel_cur + pixel_prev + pixel_next, 8));
                           
                    end if;
                elsif (pixel_index mod 256 = 2) then
                    pixel_prev <= pixel_cur;
                    pixel_cur <= pixel_next;
                    pixel_next <= to_integer(unsigned(pixel_in));
                    if ((-2)*pixel_cur+pixel_next <0) then
                        gradient_out <= "00000000";
                    elsif((-2)*pixel_cur+pixel_next >255) then   
                        gradient_out <= "11111111";
                    else
                        gradient_out <= std_logic_vector(to_unsigned((-2)*pixel_cur + pixel_next, 8));
                    end if;
                    
                elsif (pixel_index mod 256 = 1) then
                    pixel_prev <= pixel_cur;
                    pixel_cur <= pixel_next;
                    pixel_next <= to_integer(unsigned(pixel_in));
                    if((-2)*pixel_cur + pixel_prev<0) then
                        gradient_out <= "00000000";
                    elsif((-2)*pixel_cur + pixel_prev>255) then 
                        gradient_out <= "11111111";
                    else
                        gradient_out <= std_logic_vector(to_unsigned((-2)*pixel_cur + pixel_prev, 8));
                    end if;
                
                end if;
                
                --if gradient_y<0 then
                    --gradient_y <= 0;
                    --gradient_y <= 0;
                 --   report integer'image(gradient_y);
                --if gradient_y > 255 then
                    --gradient_y <= 255;
                --end if;
                --gradient_out <= std_logic_vector(to_unsigned(gradient_y,8));
            end if;
        end if;    
     end process;


end Behavioral;
