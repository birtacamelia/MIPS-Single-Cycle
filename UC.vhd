----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2026 03:21:23 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port( Instr: in std_logic_vector(5 downto 0);
          RegDst: out std_logic;
          ExtOp: out std_logic;
          ALUSrc: out std_logic;
          Branch: out std_logic;
          Br_gtz: out std_logic;
          Br_gez: out std_logic;
          Jump: out std_logic;
          MemWrite: out std_logic;
          MemtoReg: out std_logic;
          RegWrite: out std_logic;
          ALUOp: out std_logic_vector( 1 downto 0));
end UC;

architecture Behavioral of UC is
   
begin
       process(Instr)
          begin
           RegDst<='0';
           ExtOp<='0';
           ALUSrc<='0';
           Branch<='0';
           Br_gtz<='0';
           Br_gez<='0';
           Jump<='0';
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
           ALUOp<="00";
            case Instr is
             when "000000"=>
                RegDst<='1';
                RegWrite<='1';
                ALUOp<="01";
             when "001001"=>
                ExtOp<='1';
                ALUSrc<='1';
                RegWrite<='1';
                ALUOp<="10";
             when "001010"=>
                ExtOp<='1';
                ALUSrc<='1';
                RegWrite<='1';
                MemtoReg<='1';
                ALUOp<="10";
             when "001011"=>
                ExtOp<='1';
                ALUSrc<='1';
                MemWrite<='1';
                ALUOp<="10";
             when "001100"=>
                 ExtOp<='1';
                 Branch<='1';
                 ALUOp<="11";
             when "001101"=>
                 ExtOp<='1';
                 Br_gtz<='1';
                 ALUOp<="11";
             when "001110"=>
                 ExtOp<='1';
                 Br_gez<='1';
                 ALUOp<="11";
             when "001111"=>
                 Jump<='1';
             when others=>null;
             
              end case;
           end process;
  
end Behavioral;
