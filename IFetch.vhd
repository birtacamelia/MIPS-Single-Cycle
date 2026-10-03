----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2026 04:39:25 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Sa se inlocuiasca fiecare element xi, dintr-un sir de elemente N cu valoarea xi+x(i+1),
-- unde i=1,N-1 si xN=xN+x1.Sirul se afla in memorie incepand de la adresa 4. N se citeste 
-- de la adresa 0. Pentru verificare se poate adauga o bucla de citire la final.

entity IFetch is
  Port ( clk: in std_logic;
        jump:in std_logic;
        jumpAddress: in std_logic_vector( 31 downto 0);
        PCSrc: in std_logic;
        BranchAddress: in std_logic_vector( 31 downto 0);
        en: in std_logic;
        rst: in std_logic;
        pc_4: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0));
        
end IFetch;

architecture Behavioral of IFetch is
  signal D: std_logic_vector(31 downto 0);
  signal pc:std_logic_vector(31 downto 0):=(others=>'0');
  signal rez_add: std_logic_vector(31 downto 0);
  signal ies_mux1: std_logic_vector(31 downto 0);
  signal addr: std_logic_vector( 4 downto 0);
  type mem_ROM is array( 0 to 31) of std_logic_vector(31 downto 0);
  signal mem: mem_ROM:=(B"001001_00000_00001_0000000000000000", --X"24010000"  00  ADDI $1,$0,0     
                        B"001010_00001_01001_0000000000000000", --X"28290000"  01  lw $9, 0($1)     in $9 am N    
                        B"001010_00000_01000_0000000000000100", --X"28080004"  02  lw $8, 4($0)     in &8 am x1   
                        B"001001_00000_00010_0000000000000001", --X"24020001"  03  addi $2, $0,1    $2-contorul i=1 (fac doar N-1 iterati)  
                        B"001001_00000_00011_0000000000000100", --X"24030004"  04  addi $3, $0,4    adresa curenta ( de unde incepe sirul)  
                        B"001100_00010_01001_0000000000000111", --X"30490007"  05  loop: beq $2,$9,        
                        B"001010_00011_00100_0000000000000000", --X"28640000"  06  lw $4,0($3)      am xi in $4      
                        B"001010_00011_00101_0000000000000100", --X"28650004"  07  lw $5,4($3)      am xi+1 in $5   
                        B"000000_00100_00101_00110_00000_000001",--X"00853001" 08  add $6,$4,$5     xi+xi+1 in $6    
                        B"001011_00011_00110_0000000000000000",  --X"2C660000" 09  sw $6, 0($3)     xi=xi+xi+1       
                        B"001001_00011_00011_0000000000000100",  --X"24630004" 10  addi $3,$3,4     incrementam adresa pt a trece la elementul urmator
                        B"001001_00010_00010_0000000000000001",  --X"24420001" 11  addi $2,$2,1     crestem numarul de iteratii    
                        B"001111_00000000000000000000000101",    --X"3C000005" 12  j loop           salt neconditional la inceputul buclei               
                        B"001010_00011_00100_0000000000000000",  --X"28640000" 13  end_loop: lw $4, 0($3)   -xn in $4    
                        B"000000_00100_01000_00100_00000_000001",--X"00882001" 14  add $4, $4,$8      xn+x1         
                        B"001011_00011_00100_0000000000000000",  --X"2C640000" 15  sw $4, 0($3)       xn=xn+x1       
                        B"001001_00000_01010_0000000000000000",  --X"240A0000" 16  addi $10, $0,0     $10- contor i=0          
                        B"001001_00000_01000_0000000000000100",  --X"24080004" 17  addi $8,$0,4       resetam adresa de citire         
                        B"001100_01010_01001_0000000000000100",  --X"31490004" 18  loop_citire: beq $10,$9,                         
                        B"001010_01000_00111_0000000000000000",  --X"29070000" 19  lw, $7,0($8)      citeste valoarea din $7, xi                   
                        B"001001_01000_01000_0000000000000100",  --X"25080004" 20  addi $8,$8,4      trecem la adresa urmatoare      
                        B"001001_01010_01010_0000000000000001",  --X"254A0001" 21  addi $10,$10,1    crestem numarul de iteratii  
                        B"001111_00000000000000000000010010",    --X"3C000012" 22  j loop_citire     salt la inceputul buclei de citire                              
                        others=>X"00000000");
begin
   process(clk,rst)
        begin
         if rst='1' then
            pc<=(others=>'0');
         elsif rising_edge(clk) then
           if en='1' then
             pc<=D;
           end if;
         end if;
  end process;
  
   pc_4<=pc+4;
   rez_add<=pc+4;
  
  mux1: process(PCSrc,BranchAddress,rez_add)
          begin
            if PCSrc='0' then 
             ies_mux1<=rez_add;
            elsif PCSrc='1' then  
              ies_mux1<=BranchAddress;
            end if;
         end process;
         
  mux2: process(jump,jumpAddress,ies_mux1)
          begin
            if jump='1' then
              D<=jumpAddress;
            else
              D<=ies_mux1;
         end if;
         end process; 
         
  addr<=pc(6 downto 2);
  instruction<=mem(conv_integer(addr));
end Behavioral;
    
