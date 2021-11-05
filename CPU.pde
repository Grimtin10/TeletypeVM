public class CPU {
  char[] RAM = new char[65536];

  char a = 0x0000;
  char b = 0x0000;
  char c = 0x0000;
  char d = 0x0000;

  char pc = 0x0000;

  ArrayList<Character> stack = new ArrayList<Character>();
  
  ArrayList<Character> callStack = new ArrayList<Character>();
  
  boolean halt;

  char keyJump = 0x0000;
  boolean keyJumpSet = false;
  char keyPC = 0x0000;
  boolean keyJumped = false;

  public CPU() {
  }

  public void loadROM(String name) {
    byte[] chars = loadBytes(name+".rom");
    if (chars.length <= RAM.length/2) {
      println("Loading ROM " + name + ".rom Size: " + chars.length + " chars.");
    } else {
      System.err.println("Aborting! Max ROM size is " + RAM.length/2 + " chars. ROM is " + chars.length + " chars.");
      exit();
    }
    for (int i=0; i<chars.length; i++) {
      RAM[i] = (char)((int)chars[i]);
    }
  }

  public void loadASM(String name) {
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";
    ArrayList<Character> result = new ArrayList<Character>();
    HashMap<String, Character> labelMap = new HashMap<String, Character>();
    String[] file = loadStrings(name+".asm");
    //label processing
    char pos = 0x0000;
    for (int i=0; i<file.length; i++) {
      if (file[i].length() > 0) {
        if (file[i].charAt(0) == ':') {
          if (!labelMap.containsKey(file[i]) && !labelMap.containsValue(pos)) {
            labelMap.put(file[i], pos);
          } else {
            System.err.println("Duplicate label " + file[i] + " at pos " + hex(pos, 4));
          }
        } else if(file[i].charAt(0) != ';'){
          pos += 0x0004;
        }
      } else {
        pos += 0x0004;
      }
    }
    for (int i=0; i<file.length; i++) {
      String[] line = file[i].split(" ");
      switch(line[0]) {
      case "NOP":
        result.add((char)0x00);
        result.add((char)0x00);
        result.add((char)0x00);
        result.add((char)0x00);
        break;
      case "PSHCHR":
        {
          if (line[1].charAt(0) == '#') {
            result.add((char)0x01);
            result.add(hexStringToByteArray(line[1])[0]);
            result.add((char)0x00);
            result.add((char)0x00);
          } else if (line[1].charAt(0) == '\'') {
            char _char = 0x00;
            boolean charFound = false;
            for (char j=0x00; j<chars.length(); j++) {
              if (line[1].length() > 1) {
                if (chars.charAt(j) == line[1].charAt(1)) {
                  _char = j;
                  charFound = true;
                }
              } else if (line.length > 2) {
                if (line[2].charAt(0) == '\'') {
                  _char = (char)(chars.length()-1);
                  charFound = true;
                }
              }
            }
            if (charFound) {
              result.add((char)0x01);
              result.add(_char);
              result.add((char)0x00);
              result.add((char)0x00);
            }
          }
        }
        break;
      case "POPCHR":
        result.add((char)0x02);
        result.add((char)0x00);
        result.add((char)0x00);
        result.add((char)0x00);
        break;
      case "JMP":
        {
          if (line[1].charAt(0) == '#') {
            result.add((char)0x03);
            result.add(hexStringToByteArray(line[1])[0]);
            result.add(hexStringToByteArray(line[1])[1]);
            result.add((char)0x00);
          } else if (line[1].charAt(0) == ':') {
            result.add((char)0x03);
            result.add((char)(labelMap.get(line[1]) >> 8));
            result.add((char)(labelMap.get(line[1]) & 0x00FF));
            result.add((char)0x00);
          }
        }
        break;
      case "MOV":
        //TODO: add proper implementation
        if (line[1].charAt(0)=='R') {
          if(line[1].charAt(1)=='A'){
            result.add((char)0x04);
            result.add((char)0x01);
            result.add(hexStringToByteArray(line[2])[0]);
            result.add(hexStringToByteArray(line[2])[1]);
          } else if(line[1].charAt(1)=='B'){
            result.add((char)0x04);
            result.add((char)0x02);
            result.add(hexStringToByteArray(line[2])[0]);
            result.add(hexStringToByteArray(line[2])[1]);
          } else if(line[1].charAt(1)=='C'){
            result.add((char)0x04);
            result.add((char)0x03);
            result.add(hexStringToByteArray(line[2])[0]);
            result.add(hexStringToByteArray(line[2])[1]);
          } else if(line[1].charAt(1)=='D'){
            result.add((char)0x04);
            result.add((char)0x04);
            result.add(hexStringToByteArray(line[2])[0]);
            result.add(hexStringToByteArray(line[2])[1]);
          } else {
            System.err.println("Invalid register!");
          }
        } else {
          result.add((char)0x04);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[2])[0]);
          result.add(hexStringToByteArray(line[2])[1]);
        }
        break;
      case "JMPGT":
        if (line[1].charAt(0) == '#') {
          result.add((char)0x05);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((char)0x00);
        } else if (line[1].charAt(0) == ':') {
          result.add((char)0x05);
          result.add((char)(labelMap.get(line[1]) >> 8));
          result.add((char)(labelMap.get(line[1]) & 0x00FF));
          result.add((char)0x00);
        } else {
          result.add((char)0x08);
          result.add((char)0x00);
          result.add((char)0x00);
          result.add((char)0x00);
        }
        break;
      case "JMPLT":
        if (line[1].charAt(0) == '#') {
          result.add((char)0x06);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((char)0x00);
        } else if (line[1].charAt(0) == ':') {
          result.add((char)0x06);
          result.add((char)(labelMap.get(line[1]) >> 8));
          result.add((char)(labelMap.get(line[1]) & 0x00FF));
          result.add((char)0x00);
        } else {
          result.add((char)0x09);
          result.add((char)0x00);
          result.add((char)0x00);
          result.add((char)0x00);
        }
        break;
      case "JMPZ":
        if (line[1].charAt(0) == '#') {
          result.add((char)0x07);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((char)0x00);
        } else if (line[1].charAt(0) == ':') {
          result.add((char)0x07);
          result.add((char)(labelMap.get(line[1]) >> 8));
          result.add((char)(labelMap.get(line[1]) & 0x00FF));
          result.add((char)0x00);
        } else {
          result.add((char)0x0A);
          result.add((char)0x00);
          result.add((char)0x00);
          result.add((char)0x00);
        }
        break;
      case "ADD":
        //TODO: add proper implementation
        result.add((char)0x0B);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[2])[0]);
        result.add(hexStringToByteArray(line[2])[1]);
        break;
      case "SUB":
        //TODO: add proper implementation
        result.add((char)0x0C);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[2])[0]);
        result.add(hexStringToByteArray(line[2])[1]);
        break;
      case "JMPE":
        if (line[1].charAt(0) == '#') {
          result.add((char)0x0D);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((char)0x00);
        } else if (line[1].charAt(0) == ':') {
          if(labelMap.containsKey(line[1])){
            result.add((char)0x0D);
            result.add((char)(labelMap.get(line[1]) >> 8));
            result.add((char)((labelMap.get(line[1])) & 0x00FF));
            result.add((char)0x00);
          } else {
            System.err.println("Invalid label " + line[1]);
            exit();
          }
        } else {
          result.add((char)0x0E);
          result.add((char)0x00);
          result.add((char)0x00);
          result.add((char)0x00);
        }
        break;
      case "KEYSET":
        if (line[1].charAt(0) == '#') {
          result.add((char)0x0F);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((char)0x00);
        } else if (line[1].charAt(0) == ':') {
          result.add((char)0x0F);
          result.add((char)(labelMap.get(line[1]) >> 8));
          result.add((char)(labelMap.get(line[1]) & 0x00FF));
          result.add((char)0x00);
        }
        break;
      case "HALT":
        result.add((char)0xFF);
        result.add((char)0x00);
        result.add((char)0x00);
        result.add((char)0x00);
        break;
      }
    }
    byte[] bytes = new byte[result.size()];
    for (int i=0; i<bytes.length; i++) {
      bytes[i] = (byte)(char)result.get(i);
    }

    saveBytes("assembled.rom", bytes);

    if (bytes.length <= RAM.length/2) {
      println("Loading Assembly File " + name + ".asm Size: " + bytes.length + " chars.");
    } else {
      System.err.println("Aborting! Max ROM size is " + RAM.length/2 + " chars. Assembled ROM is " + bytes.length + " chars.");
      exit();
    }

    for (int i=0; i<result.size(); i++) {
      RAM[i] = result.get(i);
    }
  }

  public void tick() {
    if (keyJumped) {
      pc = keyPC;
      keyJumped = false;
    }
    char opcode = (char)(RAM[pc] & 0x00FF);
    switch(opcode) {
    case 0x00:
      //NOP
      break;
    case 0x01:
      //PSHCHR
      //println("yo1");
      charRAM.add((int)RAM[pc+1]);
      break;
    case 0x02:
      //POPCHR
      if(charRAM.size() > 0){
        charRAM.remove(charRAM.size()-1);
      }
      break;
    case 0x03:
      //JMP
      pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      break;
    case 0x04:
      //MOV
      {
        char operation = (char)(RAM[pc+1] & 0x00FF);
        switch(operation) {
        case 0x00:
          println("mov", hex((char)((RAM[pc + 2] << 8) | (RAM[pc + 3])), 4));
          a = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
          println("a", hex(a,4));
          break;
        case 0x01:
          b = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
          break;
        case 0x02:
          c = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
          break;
        case 0x03:
          d = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
          break;
        case 0x04:
          b = a;
          break;
        case 0x05:
          c = a;
          break;
        case 0x06:
          d = a;
          break;
        case 0x07:
          a = b;
          break;
        case 0x08:
          c = b;
          break;
        case 0x09:
          d = b;
          break;
        case 0x0A:
          a = c;
          break;
        case 0x0B:
          b = c;
          break;
        case 0x0C:
          d = c;
          break;
        case 0x0D:
          a = d;
          break;
        case 0x0E:
          b = d;
          break;
        case 0x0F:
          c = d;
          break;
        case 0x10:
          a = (char)((RAM[b] << 8) | (RAM[c]));
          break;
        case 0x11:
          println("MOV a: " + hex(a, 4) + " to " + hex((char)((RAM[pc + 2] << 8) | (RAM[pc + 3])), 4));
          RAM[(char)((RAM[pc + 2] << 8) | (RAM[pc + 3]))] = a;
          println(hex(RAM[(char)((RAM[pc + 2] << 8) | (RAM[pc + 3]))], 4), hex(RAM[pc+2] << 8, 4), hex(RAM[pc+3], 4));
        case 0x12:
          RAM[(char)((RAM[pc + 2] << 8) | (RAM[pc + 3]))] = b;
        case 0x13:
          RAM[(char)((RAM[pc + 2] << 8) | (RAM[pc + 3]))] = c;
        case 0x14:
          RAM[(char)((RAM[pc + 2] << 8) | (RAM[pc + 3]))] = d;
          break;
        default:
          System.err.println("Invalid register operation " + hex(RAM[pc+1], 2));
          break;
        }
        break;
      }
    case 0x05:
      //JMPGT (immediate)
      if (a > b) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x06:
      //JMPLT (immediate)
      if (a < b) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x07:
      //JMPZ (immediate)
      if (a == 0) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x08:
      //JMPGT (register)
      if (a > b) {
        pc = c;
      }
      break;
    case 0x09:
      //JMPLT (register)
      if (a < b) {
        pc = c;
      }
      break;
    case 0x0A:
      //JMPZ (register)
      if (a == 0) {
        pc = c;
      }
      break;
    case 0x0B:
      //ADD
      {
        char operation = (char)(RAM[pc+1] & 0x00FF);
        switch(operation) {
        case 0x00:
          a += a;
        case 0x01:
          a += b;
        case 0x02:
          a += c;
        case 0x03:
          a += d;
        case 0x04:
          b += a;
        case 0x05:
          b += b;
        case 0x06:
          b += c;
        case 0x07:
          b += d;
        case 0x08:
          c += a;
        case 0x09:
          c += b;
        case 0x0A:
          c += c;
        case 0x0B:
          c += d;
        case 0x0C:
          d += a;
        case 0x0D:
          d += b;
        case 0x0E:
          d += c;
        case 0x0F:
          d += d;
        case 0x10:
          a += (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x11:
          b += (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x12:
          c += (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x13:
          d += (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        }
      }
      break;
    case 0x0C:
      //SUB
      {
        char operation = (char)(RAM[pc+1] & 0x00FF);
        switch(operation) {
        case 0x00:
          a -= a;
        case 0x01:
          a -= b;
        case 0x02:
          a -= c;
        case 0x03:
          a -= d;
        case 0x04:
          b -= a;
        case 0x05:
          b -= b;
        case 0x06:
          b -= c;
        case 0x07:
          b -= d;
        case 0x08:
          c -= a;
        case 0x09:
          c -= b;
        case 0x0A:
          c -= c;
        case 0x0B:
          c -= d;
        case 0x0C:
          d -= a;
        case 0x0D:
          d -= b;
        case 0x0E:
          d -= c;
        case 0x0F:
          d -= d;
        case 0x10:
          a -= (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x11:
          b -= (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x12:
          c -= (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        case 0x13:
          d -= (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        }
      }
      break;
    case 0x0D:
      //JMPE (immediate)
      if (a == b) {
        //println("yup", hex((char)(((RAM[pc + 1] << 8) | (RAM[pc + 2]))-4), 4), hex(RAM[pc + 1], 2), hex(RAM[pc + 2], 2), hex(RAM[pc + 1] << 8), hex(RAM[pc + 2] & 0x00FF));
        char temp = (char)((((RAM[pc + 1] << 8) & 0xFF00) | (RAM[pc + 2]) & 0x00FF)-4);
        //println(hex(a, 4), hex(b, 4), hex(temp, 4), hex(RAM[pc + 1] << 8, 4), hex(RAM[pc + 2] << 0, 4));
        pc = (char)((((RAM[pc + 1] << 8) & 0xFF00) | (RAM[pc + 2]) & 0x00FF)-4);
      } else {
        //println("nope", "a", hex(a, 4), "b", hex(b, 4));
      }
      break;
    case 0x0E:
      //JMPE (register)
      if (a == b) {
        pc = c;
      }
      break;
    case 0x0F:
      //KEYSET
      keyJumpSet = true;
      keyJump = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2]));
      break;
      case (char)0xFF:
      //HALT
      halt = true;
      break;
    case 0x10:
      //CALL
      break;
    default:
      System.err.println("Invalid opcode " + hex(RAM[pc], 2));
      break;
    }
    pc+=4;
  }
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
