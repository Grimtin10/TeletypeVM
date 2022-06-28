public static class Assembler {
  private static class Argument {
    boolean imm8, imm16, reg, mem;
    
    public Argument(boolean imm8, boolean imm16, boolean reg, boolean mem) {
      this.imm8 = imm8;
      this.imm16 = imm16;
      this.reg = reg;
      this.mem = mem;
    }
  }
  
  private class Token {
    String word;
    byte opcode;
    Argument[] args;
    
    public Token(String word, int opcode, Argument[] args) {
      this.word = word;
      this.opcode = (byte)opcode;
    }
    
    public void setArg(String arg, int index) {
      
    }
    
    byte[] convertToMachineCode() {
      byte[] code = new byte[4];
      code[0] = opcode;
      //code[1] = args[0];
      //code[1] = args[1];
      //code[1] = args[2];
      
      return code;
    }
  }
  
  Token[] tokens = {
    new Token("NOP",     0x00, new Argument[]{}),
    new Token("PUSHCHR", 0x01, new Argument[]{}),
    new Token("POPCHR",  0x02, new Argument[]{}),
    new Token("JMP",     0x03, new Argument[]{}),
    new Token("MOV",     0x04, new Argument[]{}),
    new Token("JMPGT",   0x05, new Argument[]{}),
    new Token("JMPLT",   0x06, new Argument[]{}),
    new Token("JMPZ",    0x07, new Argument[]{}),
    new Token("JMPGT",   0x08, new Argument[]{}),
    new Token("JMPLT",   0x09, new Argument[]{}),
    new Token("JMPZ",    0x0A, new Argument[]{}),
    new Token("ADD",     0x0B, new Argument[]{}),
    new Token("SUB",     0x0C, new Argument[]{}),
    new Token("JMPE",    0x0D, new Argument[]{}),
    new Token("JMPE",    0x0E, new Argument[]{}),
    new Token("KEYSET",  0x0F, new Argument[]{}),
    new Token("CALL",    0x10, new Argument[]{}),
    new Token("RET",     0x11, new Argument[]{}),
    new Token("SHR",     0x12, new Argument[]{}),
    new Token("SHL",     0x13, new Argument[]{}),
    new Token("OR",      0x14, new Argument[]{}),
    new Token("AND",     0x15, new Argument[]{}),
    new Token("XOR",     0x16, new Argument[]{}),
    new Token("HALT",    0xFF, new Argument[]{}),
  };
  
  public static char[] assemble(String[] file) {
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";
    ArrayList<Character> result = new ArrayList<Character>();
    HashMap<String, Character> labelMap = new HashMap<String, Character>();
    
    ArrayList<Token> foundTokens = new ArrayList<Token>();
    
    char pos = 0x0000;
    for(int i=0;i<file.length;i++){
      if(file[i].trim().length() > 0){
        if(file[i].trim().charAt(0) == ':'){
          labelMap.put(file[i].trim().substring(1), pos);
          if(verbose) {
            println("Parser.LabelFinder: found label " + file[i].trim() + " at " + hex(pos, 4));
          }
        }
        if(file[i].trim().charAt(0) != ';'){
          pos += 0x0004;
        }
      }
    }
    
    return null;
  }
  
  private static Argument imm8               = new Argument(true,  false, false, false);
  private static Argument imm16              = new Argument(false, true,  false, false);
  private static Argument reg                = new Argument(false, false, true,  false);
  private static Argument mem                = new Argument(false, false, false, true);
  private static Argument imm8_imm16         = new Argument(true,  true,  false, false);
  private static Argument imm8_reg           = new Argument(true,  false, true,  false);
  private static Argument imm8_mem           = new Argument(true,  false, false, true);
  private static Argument imm16_reg          = new Argument(false, true,  true,  false);
  private static Argument imm16_mem          = new Argument(false, true,  false, true);
  private static Argument reg_mem            = new Argument(false, false, false, true);
  private static Argument imm8_imm16_reg     = new Argument(true,  true,  true,  false);
  private static Argument imm8_imm16_mem     = new Argument(true,  true,  false, true);
  private static Argument imm8_reg_mem       = new Argument(true,  false, false, true);
  private static Argument imm16_reg_mem      = new Argument(false, true,  false, true);
  private static Argument imm8_imm16_reg_mem = new Argument(true,  true,  true,  true);
}
