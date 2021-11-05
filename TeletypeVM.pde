ArrayList<Integer> charRAM = new ArrayList<Integer>();

color[][] screen;
boolean[][] changed;

String charsetName = "default";
boolean[][][] chars = new boolean[65][8][8];

String ROM = "type_test";

CPU cpu;

int cycles = 100000;

ArrayList<Device> devices = new ArrayList<Device>();

//chars
//ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\?:'_;[]{}><%(space)
//0..64

void setup() {
  println(this);
  cpu = new CPU();
  size(640, 640);
  screen = new color[width][height];
  changed = new boolean[width][height];
  for (int x=0; x<screen.length; x++) {
    for (int y=0; y<screen[0].length; y++) {
      screen[x][y] = color(0, 0, 0);
      changed[x][y] = false;
    }
  }
  for (int i=0; i<80*80; i++) {
    charRAM.add((i%2==0)?64:38);
  }
  String[] temp = loadStrings(charsetName+".charset");
  for (int i=0; i<temp.length; i++) {
    String[] temp2 = temp[i].split(" ");
    for (int j=0; j<temp2.length; j++) {
      for (int k=0; k<temp2[j].length(); k++) {
        chars[i][j][k] = (temp2[j].charAt(k)=='1');
      }
    }
  }
  cpu.loadASM(ROM);
  devices.add(new Buzzer((char)0xFFF0, this));
}

void draw() {
  background(0);
  if (frameCount == 5) {
    charRAM.clear();
  }
  int curX = 0;
  int curY = 0;
  int line = 0;
  //while(!cycleDone && frameCount > 5){}
  for (int i=0; i<charRAM.size(); i++) {
    if (charRAM.get(i) < chars.length-1) {
      for (int x=0; x<chars[0].length; x++) {
        for (int y=0; y<chars[0][0].length; y++) {
          set(x+curX, y+curY-(line*8), color((chars[charRAM.get(i)][x][y])?255:0));
        }
      }
    }
    curX += 8;
    if (curX == width) {
      curY += 8;
      curX = 0;
    }
  }
  //cycleDone = false;
  
  if(frameCount > 10){
    for(int j=0;j<cycles;j++){
      if(!cpu.halt){
        cpu.tick();
      }
      if (charRAM.size() >= 80*80-160) {
        for (int i=0; i<80; i++) {
          charRAM.remove(0);
        }
      }
    }
      for(int i=0;i<devices.size();i++){
        devices.get(i).update();
      }
  }

  surface.setTitle("FPS: " + frameRate);
}

void keyPressed(){
  if(cpu.keyJumpSet){
    cpu.d = (char)keyCode;
    println(hex(cpu.d, 2), key);
    cpu.keyJumped = true;
    cpu.keyPC = cpu.keyJump;
  }
  if(keyCode == 116){
    byte[] bytes = new byte[cpu.RAM.length];
    for(int i=0;i<bytes.length;i++){
      bytes[i] = byte(cpu.RAM[i]);
    }
    saveBytes("ramDump.ram", bytes);
  }
}

void handleCPU() {
  //while(!cpu.halt){
  //  while(cycleDone){}
    
  //  delay(100);
  //  cycleDone = true;
  //}
}
