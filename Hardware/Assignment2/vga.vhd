library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
  Port( CLK25: in STD_LOGIC;
	pixel_value: in STD_LOGIC_VECTOR(7 downto 0);
		RST: in STD_LOGIC;	
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
end vga;

architecture Behavioral of vga is

	constant    HD: integer :=639;
	constant   HFP: integer :=16;
	constant   HSP: integer :=96;
	constant   HBP: integer :=46;
    signal hPos: integer := 0;
	signal vPos: integer := 0;
	constant VD: integer :=479;
	constant VFP: integer :=10;
	constant VSP: integer :=2;
	constant VBP: integer :=33;

	signal videoOn: std_logic:= '0';
	
begin

Horizontal_position_counter: process(clk25,RST)
begin
	if(RST='1')then
		hPos<=0;
	elsif(clk25'event and clk25='1')then
		if(hPos =(HD + HFP + HSP + HBP))then
			hPos<=0;
		else	
			hPos<=hPos+1;
		end if;
	end if;
	hpo <= hpos;
end process;

Vertical_position_counter: process(clk25,RST,hPos)
begin
	if(RST='1')then
		vPos<=0;
	elsif(clk25'event and clk25='1')then
		if(hPos =(HD + HFP + HSP + HBP)) then
			if(vPos =(VD + VFP + VSP + VBP))then
				vPos<=0;
			else	
				vPos<=vPos+1;
			end if;
		end if;
	end if;
	vpo <= vpos;
end process;

Horizontal_Synchronisation:process(clk25,RST,hPos)
begin
	if(RST='1')then
	   HSYNC<='0';
	elsif(clk25'event and clk25='1')then
		if(hPos <=(HD+HFP) OR (hPos > HD+ HFP+HSP))then
			HSYNC <='1';
		else 
			HSYNC<='0';
		end if;
	end if;
end process;

Vertical_Synchronisation:process(clk25,RST,vPos)
begin
	if(RST='1')then
		VSYNC <='0';
	elsif(clk25'event and clk25='1')then
		if(vPos <=(VD+VFP) OR (vPos > VD+ VFP+VSP))then
			VSYNC <='1';
		else 
			VSYNC<='0';
		end if;
	end if;
end process;

video_on:process(clk25,RST,hPos,vPos)
begin
	if(RST='1')then
		videoOn <='0';
	elsif(clk25'event and clk25='1')then
		if(hPos <=HD and vPos<=VD)then
			videoOn <='1';
		else
			videoOn <='0';
		end if;
	end if;
end process;

draw:process(clk25,hPos,vPos,videoOn,RST)
begin
	if(RST='1')then
		R0 <= '0';
	    R1 <= '0';
	    R2 <= '0';
	    R3 <= '0';
	    B0 <= '0';
	    B1 <= '0';
	    B2 <= '0';
	    B3 <= '0';
	    G0 <= '0';
	    G1 <= '0';
	    G2 <= '0';
	    G3 <= '0';
	elsif(clk25'event and clk25='1')then
		if(videoOn='1')then
			if((hPos>=10 and hPos <266) and (vPos>=10 and vPos<266))then
				R0 <= pixel_value(4);
				R1 <= pixel_value(5);
				R2 <= pixel_value(6);
				R3 <= pixel_value(7);
				B0 <= pixel_value(4);
				B1 <= pixel_value(5);
				B2 <= pixel_value(6);
				B3 <= pixel_value(7);
				G0 <= pixel_value(4);
				G1 <= pixel_value(5);
				G2 <= pixel_value(6);
				G3 <= pixel_value(7);
		    else
			    R0 <= '0';
                R1 <= '0';
                R2 <= '0';
                R3 <= '0';
                B0 <= '0';
                B1 <= '0';
                B2 <= '0';
                B3 <= '0';
                G0 <= '0';
                G1 <= '0';
                G2 <= '0';
                G3 <= '0';
			end if;
		end if;
	end if;
	
end process;

end Behavioral;
