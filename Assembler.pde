public static class Assembler {
  private class Argument {
    public Argument() {
      
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
    //new Token("NOP", 0x00, false, false, false),
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
}
