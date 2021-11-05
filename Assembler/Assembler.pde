String name = "type_test";

String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";

void setup() {
  ArrayList<Byte> result = new ArrayList<Byte>();
  HashMap<String, Character> labelMap = new HashMap<String, Character>();
  String[] file = loadStrings("code.asm");
  //label processing
  char pos = 0;
  for (int i=0; i<file.length; i++) {
    if (file[i].charAt(0) == ':') {
      labelMap.put(file[i], pos);
    } else {
      pos += 4;
    }
  }
  for (int i=0; i<file.length; i++) {
    String[] line = file[i].split(" ");
    switch(line[0]) {
    case "NOP":
      result.add((byte)0x00);
      result.add((byte)0x00);
      result.add((byte)0x00);
      result.add((byte)0x00);
      break;
    case "PSHCHR":
      {
        if (line[1].charAt(0) == '#') {
          result.add((byte)0x01);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add((byte)0x00);
          result.add((byte)0x00);
        } else if (line[1].charAt(0) == '\'') {
          byte _char = 0x00;
          boolean charFound = false;
          for (byte j=0x00; j<chars.length(); j++) {
            if (line[1].length() > 1) {
              if (chars.charAt(j) == line[1].charAt(1)) {
                _char = j;
                charFound = true;
              }
            } else if (line.length > 2) {
              if (line[2].charAt(0) == '\'') {
                _char = (byte)(chars.length()-1);
                charFound = true;
              }
            }
          }
          if (charFound) {
            result.add((byte)0x01);
            result.add(_char);
            result.add((byte)0x00);
            result.add((byte)0x00);
          }
        }
      }
      break;
    case "POPCHR":
      result.add((byte)0x02);
      result.add((byte)0x00);
      result.add((byte)0x00);
      result.add((byte)0x00);
      break;
    case "JMP":
      {
        if (line[1].charAt(0) == '#') {
          result.add((byte)0x03);
          result.add(hexStringToByteArray(line[1])[0]);
          result.add(hexStringToByteArray(line[1])[1]);
          result.add((byte)0x00);
        } else if(line[1].charAt(0) == ':'){
          result.add((byte)0x03);
          result.add((byte)(labelMap.get(line[1]) << 8));
          result.add((byte)(labelMap.get(line[1]) << 0));
          result.add((byte)0x00);
        }
      }
      break;
    case "MOV":
      //TODO: add proper implementation
      result.add((byte)0x04);
      result.add(hexStringToByteArray(line[1])[0]);
      result.add(hexStringToByteArray(line[2])[0]);
      result.add(hexStringToByteArray(line[2])[1]);
      break;
    case "JMPGT":
      if (line[1].charAt(0) == '#') {
        result.add((byte)0x05);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[1])[1]);
        result.add((byte)0x00);
      } else {
        result.add((byte)0x08);
        result.add((byte)0x00);
        result.add((byte)0x00);
        result.add((byte)0x00);
      }
      break;
    case "JMPLT":
      if (line[1].charAt(0) == '#') {
        result.add((byte)0x06);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[1])[1]);
        result.add((byte)0x00);
      } else {
        result.add((byte)0x09);
        result.add((byte)0x00);
        result.add((byte)0x00);
        result.add((byte)0x00);
      }
      break;
    case "JMPZ":
      if (line[1].charAt(0) == '#') {
        result.add((byte)0x07);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[1])[1]);
        result.add((byte)0x00);
      } else {
        result.add((byte)0x0A);
        result.add((byte)0x00);
        result.add((byte)0x00);
        result.add((byte)0x00);
      }
      break;
    case "ADD":
      //TODO: add proper implementation
      result.add((byte)0x0B);
      result.add(hexStringToByteArray(line[1])[0]);
      result.add(hexStringToByteArray(line[2])[0]);
      result.add(hexStringToByteArray(line[2])[1]);
      break;
    case "SUB":
      //TODO: add proper implementation
      result.add((byte)0x0C);
      result.add(hexStringToByteArray(line[1])[0]);
      result.add(hexStringToByteArray(line[2])[0]);
      result.add(hexStringToByteArray(line[2])[1]);
      break;
    case "JMPE":
      if (line[1].charAt(0) == '#') {
        result.add((byte)0x0D);
        result.add(hexStringToByteArray(line[1])[0]);
        result.add(hexStringToByteArray(line[1])[1]);
        result.add((byte)0x00);
      } else {
        result.add((byte)0x0E);
        result.add((byte)0x00);
        result.add((byte)0x00);
        result.add((byte)0x00);
      }
      break;
    case "KEYSET":
      result.add((byte)0x0F);
      result.add(hexStringToByteArray(line[1])[0]);
      result.add(hexStringToByteArray(line[1])[1]);
      result.add((byte)0x00);
      break;
    case "HALT":
      result.add((byte)0xFF);
      result.add((byte)0x00);
      result.add((byte)0x00);
      result.add((byte)0x00);
      break;
    }
  }
  byte[] bytes = new byte[result.size()];
  for (int i=0; i<bytes.length; i++) {
    bytes[i] = result.get(i);
  }
  saveBytes(name+".rom", bytes);
}

/* s must be an even-length string. */
public static byte[] hexStringToByteArray(String s) {
  int len = s.length();
  byte[] data = new byte[len / 2];
  for (int i = 0; i < len; i += 2) {
    data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
      + Character.digit(s.charAt(i+1), 16));
  }
  return data;
}
