ArrayList<Byte> result = new ArrayList<Byte>();

String text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-=+,./\\?:'_;[]{}>< ";

String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-=+,./\\?:'_;[]{}>< ";

void setup(){
  text = text.toUpperCase();
  //for(int i=0;i<text.length();i++){
    //int _char = 0;
    for(int j=0;j<65;j++){
      //if(text.charAt(i) == chars.charAt(j)){
      //  _char = j;
      //  j = chars.length();
      //}
      result.add((byte)0x01);
      result.add((byte)j);
      result.add((byte)0x00);
      result.add((byte)0x00);
    }
    //result.add((byte)0x01);
    //result.add((byte)_char);
    //result.add((byte)0x00);
    //result.add((byte)0x00);
  //}
  result.add((byte)0xFF);
  result.add((byte)0x00);
  result.add((byte)0x00);
  result.add((byte)0x00);
  //this is bullshit
  byte[] bytes = new byte[result.size()];
  for(int i=0;i<result.size();i++){
    bytes[i] = result.get(i);
  }
  saveBytes("result.rom", bytes);
}
