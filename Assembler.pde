//!!!!DO NOT FORMAT!!!!
public static class Assembler {
  private static Argument imm8               = new Argument(true, false, false, false);
  private static Argument imm16              = new Argument(false, true, false, false);
  private static Argument reg                = new Argument(false, false, true, false);
  private static Argument mem                = new Argument(false, false, false, true);
  private static Argument imm8_imm16         = new Argument(true, true, false, false);
  private static Argument imm8_reg           = new Argument(true, false, true, false);
  private static Argument imm8_mem           = new Argument(true, false, false, true);
  private static Argument imm16_reg          = new Argument(false, true, true, false);
  private static Argument imm16_mem          = new Argument(false, true, false, true);
  private static Argument reg_mem            = new Argument(false, false, false, true);
  private static Argument imm8_imm16_reg     = new Argument(true, true, true, false);
  private static Argument imm8_imm16_mem     = new Argument(true, true, false, true);
  private static Argument imm8_reg_mem       = new Argument(true, false, false, true);
  private static Argument imm16_reg_mem      = new Argument(false, true, false, true);
  private static Argument imm8_imm16_reg_mem = new Argument(true, true, true, true);
  
  private static class Argument {
    boolean imm8, imm16, reg, mem;

    public Argument(boolean imm8, boolean imm16, boolean reg, boolean mem) {
      this.imm8 = imm8;
      this.imm16 = imm16;
      this.reg = reg;
      this.mem = mem;
    }
  }
  
  private static class ArgumentToken {
    char startingChar;
    int len;
    Argument type;
    
    public ArgumentToken(char startingChar, int len, Argument type) {
      this.startingChar = startingChar;
      this.len = len;
      this.type = type;
    }
  }

  private static class Token {
    String word;
    byte opcode;
    Argument[] argTypes;
    char[][] argValues;

    public Token(String word, int opcode, Argument[] argTypes) {
      this.word = word;
      this.opcode = (byte)opcode;
      this.argTypes = argTypes;
      this.argValues = new char[argTypes.length][3];
    }

    //#XXXX - imm16
    //#XX - imm8
    //'X' - imm8 (char)
    //RX - reg
    //$XXXX - mem
  }
  
  //!!!!DO NOT FORMAT!!!!
  static Token[] tokens = {
    new Token("NOP",     0x00, new Argument[]{}), 
    new Token("PUSHCHR", 0x01, new Argument[]{imm8}), 
    new Token("POPCHR",  0x02, new Argument[]{}), 
    new Token("JMP",     0x03, new Argument[]{imm16}), 
    new Token("MOV",     0x04, new Argument[]{reg, reg}), 
    new Token("MOV",     0x05, new Argument[]{reg, imm16}),
    new Token("JMPGT",   0x06, new Argument[]{imm16}), 
    new Token("JMPLT",   0x07, new Argument[]{imm16}), 
    new Token("JMPZ",    0x08, new Argument[]{imm16}), 
    new Token("JMPGT",   0x09, new Argument[]{}),
    new Token("JMPLT",   0x0A, new Argument[]{}), 
    new Token("JMPZ",    0x0B, new Argument[]{}), 
    new Token("ADD",     0x0C, new Argument[]{reg, reg}), 
    new Token("ADD",     0x0D, new Argument[]{reg, imm16}), 
    new Token("SUB",     0x0E, new Argument[]{reg, reg}), 
    new Token("SUB",     0x0F, new Argument[]{reg, imm16}), 
    new Token("JMPE",    0x10, new Argument[]{imm16}), 
    new Token("JMPE",    0x11, new Argument[]{}), 
    new Token("KEYSET",  0x12, new Argument[]{imm16}), 
    new Token("CALL",    0x13, new Argument[]{imm16}), 
    new Token("RET",     0x14, new Argument[]{}), 
    new Token("SHR",     0x15, new Argument[]{reg, reg}),
    new Token("SHR",     0x16, new Argument[]{reg, imm16}), 
    new Token("SHL",     0x17, new Argument[]{reg, reg}), 
    new Token("SHL",     0x18, new Argument[]{reg, imm16}), 
    new Token("OR",      0x19, new Argument[]{reg, reg}), 
    new Token("OR",      0x1A, new Argument[]{reg, imm16}), 
    new Token("AND",     0x1B, new Argument[]{reg, reg}), 
    new Token("AND",     0x1C, new Argument[]{reg, imm16}), 
    new Token("XOR",     0x1D, new Argument[]{reg, reg}), 
    new Token("XOR",     0x1E, new Argument[]{reg, imm16}), 
    new Token("HALT",    0xFF, new Argument[]{}), 
  };
  
  static ArgumentToken[] argumentTokens = {
    new ArgumentToken('#', 2, imm8),
    new ArgumentToken('#', 4, imm16),
    new ArgumentToken('R', 2, reg),
    new ArgumentToken('$', 4, mem),
  };

  public static char[] assemble(String[] file) {
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";
    ArrayList<Character> result = new ArrayList<Character>();
    HashMap<String, Character> labelMap = new HashMap<String, Character>();

    ArrayList<Token> foundTokens = new ArrayList<Token>();

    char pos = 0x0000;
    for (int i=0; i<file.length; i++) {
      if (file[i].trim().length() > 0) {
        if (file[i].trim().charAt(0) == ':') {
          labelMap.put(file[i].trim().substring(1), pos);
          if (verbose) {
            println("Parser.LabelFinder: found label " + file[i].trim() + " at " + hex(pos, 4));
          }
        }
        if (file[i].trim().charAt(0) != ';') {
          pos += 0x0004;
        }
      }
    }

    for (int i=0; i<file.length; i++) {
      String line = file[i].trim();
      if(line.length() > 0) {
        String[] words = file[i].split(" ");
        
        for(int j=0;j<tokens.length;j++) {
          if(tokens[j].word.equals(words[0])) {
            println("Parser.Tokenizer: Found token " + words[0] + " on line " + i + " (opcode: " + hex(tokens[j].opcode, 2) + ")");
            break;
          }
        }
      }
    }

    return null;
  }

  /* s must be an even-length string. */
  public static char[] hexStringToByteArray(String s) {
    s = s.replace("#", "");
    int len = s.length();
    char[] data = new char[len / 2];
    for (int i = 0; i < len; i += 2) {
      data[i / 2] = (char) ((Character.digit(s.charAt(i), 16) << 4)
        + Character.digit(s.charAt(i+1), 16));
    }
    return data;
  }
}
