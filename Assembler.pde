//!!!!DO NOT FORMAT WITH CTRL+T!!!!
public static class Assembler {
  private static ArgumentType imm8               = new ArgumentType(true, false, false, false);
  private static ArgumentType imm16              = new ArgumentType(false, true, false, false);
  private static ArgumentType reg                = new ArgumentType(false, false, true, false);
  private static ArgumentType mem                = new ArgumentType(false, false, false, true);
  private static ArgumentType imm8_imm16         = new ArgumentType(true, true, false, false);
  private static ArgumentType imm8_reg           = new ArgumentType(true, false, true, false);
  private static ArgumentType imm8_mem           = new ArgumentType(true, false, false, true);
  private static ArgumentType imm16_reg          = new ArgumentType(false, true, true, false);
  private static ArgumentType imm16_mem          = new ArgumentType(false, true, false, true);
  private static ArgumentType reg_mem            = new ArgumentType(false, false, false, true);
  private static ArgumentType imm8_imm16_reg     = new ArgumentType(true, true, true, false);
  private static ArgumentType imm8_imm16_mem     = new ArgumentType(true, true, false, true);
  private static ArgumentType imm8_reg_mem       = new ArgumentType(true, false, false, true);
  private static ArgumentType imm16_reg_mem      = new ArgumentType(false, true, false, true);
  private static ArgumentType imm8_imm16_reg_mem = new ArgumentType(true, true, true, true);
  
  public static String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";
  
  private static class ArgumentType {
    boolean imm8, imm16, reg, mem;

    public ArgumentType(boolean imm8, boolean imm16, boolean reg, boolean mem) {
      this.imm8 = imm8;
      this.imm16 = imm16;
      this.reg = reg;
      this.mem = mem;
    }

    public boolean match(ArgumentType argument) {
      return (argument.imm8 == imm8) || (argument.imm16 == imm16) || (argument.reg == reg) || (argument.mem == mem);
    }
  }

  private static class ArgumentToken {
    String name;
    char startingChar;
    int len;
    ArgumentType type;

    public ArgumentToken(String name, char startingChar, int len, ArgumentType type) {
      this.name = name;
      this.startingChar = startingChar;
      this.len = len;
      this.type = type;
    }

    public boolean match(String s) {
      return (s.length() - 1 == len) && (s.charAt(0) == startingChar);
    }

    public char[] parse(String in) {
      if (match(in)) {
        if(verbose >= 2) println("Parsing string " + in);
        in = in.substring(1);
        if(verbose >= 2) println("Trimmed string to " + in);
        if (len % 2 != 0) {
          in = "0" + in;
          if(verbose >= 2) println("Padding string with 0");
        }
        if(verbose >= 2) println("Got result: ");
        char[] result = hexStringToByteArray(in);
        for(int i=0;i<result.length;i++) {
          if(verbose >= 2) print(hex(result[i], 2));
        }
        if (verbose >= 2) println();
        return result;
      } else {
        throw new IllegalArgumentException("Incorrect input string (" + in + ") type for argument.");
      }
    }
  }

  private static class TokenType {
    String word;
    char opcode;
    ArgumentType[] arguments;

    public TokenType(String word, int opcode, ArgumentType[] arguments) {
      this.word = word;
      this.opcode = (char)opcode;
      this.arguments = arguments;
    }

    public boolean match(ArgumentType[] arguments) {
      if (arguments.length != this.arguments.length) {
        return false;
      }

      boolean match = true;
      for (int i=0; i<arguments.length; i++) {
        match = match && arguments[i].match(this.arguments[i]);
      }
      return match;
    }

    //#XXXX - imm16
    //#XX - imm8
    //'X' - imm8 (char)
    //RX - reg
    //$XXXX - mem
  }

  private static class Argument {
    ArgumentType type;
    char[] value;

    public Argument(ArgumentType type, char[] value) {
      this.type = type;
      this.value = value;
    }
  }

  private static class Token {
    TokenType type;
    Argument[] args;

    public Token(TokenType type, Argument[] args) {
      this.type = type;
      this.args = args;
    }
    
    char[] toMachineCode() {
      char[] machineCode = new char[4];
      machineCode[0] = type.opcode;
      
      int index = 1;
      for(int i=0;i<args.length;i++) {
        for(int j=0;j<args[i].value.length;j++) {
          machineCode[index] = args[i].value[j];
          index++;
        }
      }
      
      return machineCode;
    }
  }

  //!!!!DO NOT FORMAT WITH CTRL+T!!!!
  static TokenType[] tokens = {
    new TokenType("NOP",     0x00, new ArgumentType[]{}), 
    new TokenType("PSHCHR", 0x01, new ArgumentType[]{imm8}), 
    new TokenType("POPCHR",  0x02, new ArgumentType[]{}), 
    new TokenType("JMP",     0x03, new ArgumentType[]{imm16}), 
    new TokenType("MOV",     0x04, new ArgumentType[]{reg, reg}), 
    new TokenType("MOV",     0x05, new ArgumentType[]{reg, imm16}), 
    new TokenType("JMPGT",   0x06, new ArgumentType[]{imm16}), 
    new TokenType("JMPLT",   0x07, new ArgumentType[]{imm16}), 
    new TokenType("JMPZ",    0x08, new ArgumentType[]{imm16}), 
    new TokenType("JMPGT",   0x09, new ArgumentType[]{}), 
    new TokenType("JMPLT",   0x0A, new ArgumentType[]{}), 
    new TokenType("JMPZ",    0x0B, new ArgumentType[]{}), 
    new TokenType("ADD",     0x0C, new ArgumentType[]{reg, reg}), 
    new TokenType("ADD",     0x0D, new ArgumentType[]{reg, imm16}), 
    new TokenType("SUB",     0x0E, new ArgumentType[]{reg, reg}), 
    new TokenType("SUB",     0x0F, new ArgumentType[]{reg, imm16}), 
    new TokenType("JMPE",    0x10, new ArgumentType[]{imm16}), 
    new TokenType("JMPE",    0x11, new ArgumentType[]{}), 
    new TokenType("KEYSET",  0x12, new ArgumentType[]{imm16}), 
    new TokenType("CALL",    0x13, new ArgumentType[]{imm16}), 
    new TokenType("RET",     0x14, new ArgumentType[]{}), 
    new TokenType("SHR",     0x15, new ArgumentType[]{reg, reg}), 
    new TokenType("SHR",     0x16, new ArgumentType[]{reg, imm16}), 
    new TokenType("SHL",     0x17, new ArgumentType[]{reg, reg}), 
    new TokenType("SHL",     0x18, new ArgumentType[]{reg, imm16}), 
    new TokenType("OR",      0x19, new ArgumentType[]{reg, reg}), 
    new TokenType("OR",      0x1A, new ArgumentType[]{reg, imm16}), 
    new TokenType("AND",     0x1B, new ArgumentType[]{reg, reg}), 
    new TokenType("AND",     0x1C, new ArgumentType[]{reg, imm16}), 
    new TokenType("XOR",     0x1D, new ArgumentType[]{reg, reg}), 
    new TokenType("XOR",     0x1E, new ArgumentType[]{reg, imm16}), 
    new TokenType("HALT",    0xFF, new ArgumentType[]{}), 
  };

  static ArgumentToken[] argumentTokens = {
    new ArgumentToken("imm8", '#', 2, imm8), 
    new ArgumentToken("imm16", '#', 4, imm16), 
    new ArgumentToken("reg", 'R', 1, reg), 
    new ArgumentToken("mem", '$', 4, mem), 
  };

  public static char[] assemble(String[] file) {
    HashMap<String, Character> labelMap = new HashMap<String, Character>();

    ArrayList<Token> foundTokens = new ArrayList<Token>();

    char pos = 0x0000;
    for (int i=0; i<file.length; i++) {
      if (file[i].trim().length() > 0) {
        if (file[i].trim().charAt(0) == ':') {
          labelMap.put(file[i].trim().substring(1), pos);
          if(verbose >= 1) println("Assembler.LabelFinder: found label " + file[i].trim().substring(1) + " at " + hex(pos, 4));
        }
        if (file[i].trim().charAt(0) != ';' && file[i].trim().charAt(0) != ':') {
          pos += 0x0004;
        }
      }
    }

    for (int i=0; i<file.length; i++) {
      String line = file[i].trim();
      if (line.length() > 0) {
        String[] _words = file[i].split(" ");
        
        ArrayList<String> processedWords = new ArrayList<String>();
        
        //label pre-processing
        for(int j=0;j<_words.length;j++) {
          boolean good = true;
          
          if(_words[j].trim().length() > 0) {
            if(_words[j].charAt(0) == ':') {
              if(verbose >= 1) print("Assembler.Preprocessor: Found label word. Converting from " + _words[j]);
              _words[j] = "#" + hex(labelMap.get(_words[j].substring(1)), 4);
              if(verbose >= 1) println(" to " + _words[j]);
            }
            
            if(_words[j].charAt(0) == '\'') {
              if(verbose >= 1) print("Assembler.Preprocessor: Found character word. Converting from " + _words[j]);
              
              //assume that if it's empty it's a space that got split
              if(j < _words.length-1) {
                if(_words[j].substring(1).length() == 0 && _words[j+1].charAt(0) == '\'') {
                  _words[j] = "' '";
                  _words[j+1] = "";
                }
              }
              
              if(_words[j].charAt(0) == ';') {
                for(int k=j;k<_words.length;k++) {
                  _words[k] = "";
                }
                good = false;
              }
              
              _words[j] = "#" + hex(findCharIndex(_words[j].charAt(1)), 2);
              if(verbose >= 1) println(" to " + _words[j]);
            }
            
            //everythings good, add it
            if(good) {
              processedWords.add(_words[j]);
            }
          }
        }
        
        String[] words = processedWords.toArray(new String[processedWords.size()]);
        
        ArrayList<ArgumentToken> arguments = new ArrayList<ArgumentToken>();
        ArrayList<Integer> indices = new ArrayList<Integer>();
        
        //get all argument tokens
        for (int j=1; j<words.length; j++) {
          for (int k=0; k<argumentTokens.length; k++) {
            if (argumentTokens[k].match(words[j])) {
              arguments.add(argumentTokens[k]);
              indices.add(j);
              if(verbose >= 1) println("Assembler.Tokenizer: Found argument " + argumentTokens[k].name + " on line " + i);
            }
          }
        }
        
        //get argument types
        ArgumentType[] args = new ArgumentType[arguments.size()];
        for (int j=0; j<args.length; j++) {
          args[j] = arguments.get(j).type;
        }

        boolean foundToken = false;
        boolean foundWord = false;
        
        //get argument values
        Argument[] argumentValues = new Argument[args.length];
        for (int j=0; j<argumentValues.length; j++) {
          argumentValues[j] = new Argument(args[j], arguments.get(j).parse(words[indices.get(j)]));
        }
        
        //get main token
        for (int j=0; j<tokens.length; j++) {          
          if (tokens[j].word.equals(words[0]) && tokens[j].match(args)) {
            if(verbose >= 1) println("Assembler.Tokenizer: Found token " + words[0] + " on line " + i + " (opcode: " + hex(tokens[j].opcode, 2) + ")");
            foundTokens.add(new Token(tokens[j], argumentValues));
            foundToken = true;
            break;
          } else if(tokens[j].word.equals(words[0])) {
            foundWord = true;
          }
        }

        if (!foundToken) {
          if(verbose >= 1) println("Could not find any tokens on line " + line + " (line " + i + ")");
          if(verbose >= 1) { print("(processed line: "); for(int j=0;j<words.length;j++) {print(words[j] + ((j == words.length-1)?"":" "));} println(")");}
        }
        
        if(!foundToken && foundWord) {
          System.err.println("Invalid arguments on line " + i + " (text: " + line + ")");
          System.exit(1);
        }
      }
    }
    
    char[] result = new char[foundTokens.size()*4];
    
    for(int i=0;i<foundTokens.size();i++) {
      char[] machineCode = foundTokens.get(i).toMachineCode();
      for(int j=0;j<machineCode.length;j++) {
        result[i*4+j] = machineCode[j];
      }
    }

    return result;
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
  
  public static char findCharIndex(char c) {    
    for(char i=0;i<chars.length();i++) {
      if(chars.charAt(i) == c) {
        return i;
      }
    }
    return 0xFF;
  }
}
