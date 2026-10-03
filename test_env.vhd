----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2026 04:46:45 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port( clk:in std_logic;
          sw: in std_logic_vector(15 downto 0);
          btn: in std_logic_vector( 4 downto 0);
          led: out std_logic_vector(15 downto 0);
          an: out std_logic_vector(7 downto 0);
          cat:out std_logic_vector(6 downto 0));
end test_env;
 
architecture Behavioral of test_env is
  signal en:std_logic;
  signal pc_4: std_logic_vector(31 downto 0);
  signal Instruction: std_logic_vector(31 downto 0);
  signal digits: std_logic_vector(31 downto 0);
  signal RD1: std_logic_vector(31 downto 0);
  signal RD2: std_logic_vector(31 downto 0);
  signal WD: std_logic_vector( 31 downto 0);
  signal Ext_Imm: std_logic_vector(31 downto 0);
  signal func: std_logic_vector( 5 downto 0);
  signal func_zext: std_logic_vector(31 downto 0);
  signal sa: std_logic_vector( 4 downto 0);
  signal sa_zext: std_logic_vector ( 31 downto 0);
  signal RegDst: std_logic;
  signal ExtOp: std_logic;
  signal ALUSrc: std_logic;
  signal Branch:std_logic;
  signal Br_gtz: std_logic;
  signal Br_gez: std_logic;
  signal Jump: std_logic;
  signal MemWrite: std_logic;
  signal MemtoReg: std_logic;
  signal RegWrite: std_logic;
  signal ALUOp: std_logic_vector( 1 downto 0);
  signal zero: std_logic;
  signal gtz: std_logic;
  signal ALURes: std_logic_vector(31 downto 0);
  signal Branch_Address: std_logic_vector(31 downto 0);
  signal MemData: std_logic_vector(31 downto 0);
  signal ALURes_out: std_logic_vector(31 downto 0);
  signal Jump_Address: std_logic_vector(31 downto 0);
  signal PCSrc: std_logic;
  signal SF:std_logic;

   component MPG is
      Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
   end component;
   
   component SSD is 
     Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
   end component;
   
   component IFetch is
     Port ( clk: in std_logic;
        jump:in std_logic;
        jumpAddress: in std_logic_vector( 31 downto 0);
        PCSrc: in std_logic;
        BranchAddress: in std_logic_vector( 31 downto 0);
        en: in std_logic;
        rst: in std_logic;
        pc_4: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0));
   end component;
   
   component ID is
       Port( clk: in std_logic;
        RegWrite: in std_logic;
        Instr: in std_logic_vector(25 downto 0);
        RegDst: in std_logic;
        en: in std_logic;
        ExtOp: in std_logic;
        WD: in std_logic_vector( 31 downto 0);
        RD1: out std_logic_vector( 31 downto 0);
        RD2: out std_logic_vector(31 downto 0);
        Ext_Imm: out std_logic_vector( 31 downto 0);
        func: out std_logic_vector( 5 downto 0);
        sa: out std_logic_vector( 4 downto 0));
   end component;
   
   component  UC is
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
   end component;
   
   component EX is
      Port ( RD1: in std_logic_vector(31 downto 0);
        ALUSrc: in std_logic;
        RD2: in std_logic_vector(31 downto 0);
        Ext_Imm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector( 5 downto 0);
        ALUOp: in std_logic_vector( 1 downto 0);
        PC_4:in std_logic_vector (31 downto 0);
        zero:out std_logic;
        SF: out std_logic;
        ALURes: out std_logic_vector(31 downto 0);
        Branch_Address: out std_logic_vector(31 downto 0));
  end component ;
  
  component MEM is
        Port( clk: in std_logic;
        en: in std_logic;
        MemWrite: in std_logic;
        Address: in std_logic_vector(31 downto 0);
        WriteData: in std_logic_vector( 31 downto 0);
        ALURes_out: out std_logic_vector(31 downto 0);
        MemData: out std_logic_vector(31 downto 0));
  end component ;
  
begin
  
 monopulse: MPG port map(en,btn(0),clk);
 IFetch_c: IFetch port map(clk,jump,Jump_Address,PCSrc,Branch_Address,en,btn(1),pc_4,Instruction);
 UC_c: Uc port map(Instruction(31 downto 26),RegDst,ExtOp,ALUSrc,Branch,Br_gtz,Br_gez,Jump,MemWrite,MemtoReg,RegWrite,ALUOp);
 ID_c: ID port map(clk,RegWrite,Instruction(25 downto 0),RegDst,en,ExtOp,WD,RD1,RD2,Ext_Imm,func,sa);
 EX_c: EX port map( RD1,ALUSrc,RD2,Ext_Imm,sa,func,ALUOp,pc_4,zero,SF,ALURes,Branch_Address);
 MEM_c: MEM port map (clk,en,MemWrite,ALURes,RD2,ALURes_out,MemData);
 SSD_c: SSD port map (clk, digits,an,cat);
 


  Jump_Address<=pc_4(31 downto 28) & Instruction( 25 downto 0) &"00";
  PCSrc<=(Branch and zero) or (Br_gez and not(SF)) or ( not(SF) and not(zero) and Br_gtz) ;
  
  wd <= ALURes_out when MemtoReg = '0' else MemData;
  led(11 downto 0)<=ALUOp & RegDst & ExtOp & ALUSrc & Branch & Br_gez &Br_gtz & Jump & MemWrite & MemtoReg & RegWrite;
  
  process(sw(7 downto 5),Instruction,pc_4,RD1,RD2,Ext_Imm,ALURes,MemData,wd)
   begin
    case sw(7 downto 5) is
    when "000"=>digits<=Instruction;
    when "001"=>digits<=pc_4;
    when "010"=>digits<=RD1;
    when "011"=>digits<=RD2;
    when "100"=>digits<=Ext_Imm;
    when "101"=>digits<=ALURes;
    when "110"=>digits<=MemData;
    when "111"=>digits<=wd;
    when others => digits <= (others => '0');
    end case;
  end process;
  
 end Behavioral;
