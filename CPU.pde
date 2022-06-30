public class CPU {
  char[] RAM = new char[65536];

  char a = 0x0000;
  char b = 0x0000;
  char c = 0x0000;
  char d = 0x0000;

  char pc = 0x0000;

  //256 bytes of call stack/regular stack
  char stackPointer = 0x00;
  char callStackPointer = 0x00;

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
    System.err.println("WARNING: CPU.loadASM() is deprecated! Use Assembler.assemble() instead!");
    exit();
  }

  public void tick() {
    if (keyJumped) {
      pc = keyPC;
      keyJumped = false;
      println("jumping to", hex(keyPC, 4));
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
      if (charRAM.size() > 0) {
        charRAM.remove(charRAM.size()-1);
      }
      break;
    case 0x03:
      //JMP
      pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      break;
    case 0x04:
      //MOV (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x05:
      //MOV (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x06:
      //JMPGT (immediate)
      if (a > b) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x07:
      //JMPLT (immediate)
      if (a < b) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x08:
      //JMPZ (immediate)
      if (a == 0) {
        pc = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2])-4);
      }
      break;
    case 0x09:
      //JMPGT (register)
      if (a > b) {
        pc = c;
      }
      break;
    case 0x0A:
      //JMPLT (register)
      if (a < b) {
        pc = c;
      }
      break;
    case 0x0B:
      //JMPZ (register)
      if (a == 0) {
        pc = c;
      }
      break;
    case 0x0C:
      //ADD (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x0D:
      //ADD (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x0E:
      //SUB (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x0F:
      //SUB (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x10:
      //JMPE (immediate)
      //println((int)a, (int)b);
      if (a == b) {
        //println("yup", hex((char)(((RAM[pc + 1] << 8) | (RAM[pc + 2]))-4), 4), hex(RAM[pc + 1], 2), hex(RAM[pc + 2], 2), hex(RAM[pc + 1] << 8), hex(RAM[pc + 2] & 0x00FF));
        char temp = (char)((((RAM[pc + 1] << 8) & 0xFF00) | (RAM[pc + 2]) & 0x00FF)-4);
        //println(hex(a, 4), hex(b, 4), hex(temp, 4), hex(RAM[pc + 1] << 8, 4), hex(RAM[pc + 2] << 0, 4));
        pc = (char)((((RAM[pc + 1] << 8) & 0xFF00) | (RAM[pc + 2]) & 0x00FF)-4);
      } else {
        //println("nope", "a", hex(a, 4), "b", hex(b, 4));
      }
      break;
    case 0x11:
      //JMPE (register)
      //println((int)a, (int)b, (int)c);
      if (a == b) {
        pc = c;
      }
      break;
    case 0x12:
      //KEYSET
      keyJumpSet = true;
      keyJump = (char)((RAM[pc + 1] << 8) | (RAM[pc + 2]));
      break;
    case 0x13:
      //TODO: fix
      //CALL
      //RAM[callStackPointer + 0xFEFF] = (char)((pc << 8) & 0xF);
      //RAM[callStackPointer + 0xFF00] = (char)(pc & 0xF);
      //callStackPointer += 2;
      //pc = (char)((RAM[pc + 1] >> 8) | RAM[pc + 2]);
      break;
    case 0x14:
      //TODO: fix
      //RET
      //pc = (char)((RAM[callStackPointer + 0xFEFF] >> 8) | RAM[callStackPointer + 0xFF00]);
      //callStackPointer -= 2;
      break;
    case 0x15:
      //SHR (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x16:
      //SHR (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x17:
      //SHL (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x18:
      //SHL (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x19:
      //OR (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x1A:
      //OR (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x1B:
      //AND (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x1C:
      //AND (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0x1D:
      //XOR (register)
      {
        char reg1 = (char)(RAM[pc+1] & 0x00FF);
        char reg2 = (char)(RAM[pc+2] & 0x00FF);

        char val = 0x0000;
        switch(reg1) {
        case 0x0A:
          val = a;
          break;
        case 0x0B:
          val = b;
          break;
        case 0x0C:
          val = c;
          break;
        case 0x0D:
          val = d;
          break;
        }
        switch(reg2) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          a = val;
          break;
        case 0x0C:
          a = val;
          break;
        case 0x0D:
          a = val;
          break;
        }
      }
    case 0x1E:
      //XOR (immediate)
      {
        char reg = (char)(RAM[pc+1] & 0x00FF);
        char val = (char)((RAM[pc + 2] << 8) | (RAM[pc + 3]));
        
        switch(reg) {
        case 0x0A:
          a = val;
          break;
        case 0x0B:
          b = val;
          break;
        case 0x0C:
          c = val;
          break;
        case 0x0D:
          d = val;
          break;
        }
        break;
      }
    case 0xFF:
      //HALT
      halt = true;
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
