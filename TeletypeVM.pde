ArrayList<Integer> charRAM = new ArrayList<Integer>();

color[][] screen;
boolean[][] changed;

String charsetName = "newChars";
boolean[][][] chars = new boolean[65][8][8];

String ROM = "type_test";

CPU cpu;

int cycles = 1;//  500000;
static int verbose = 1;

float scale = 2;

ArrayList<Device> devices = new ArrayList<Device>();

PFont font;

//chars
//ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\?:'_;[]{}><%(space)
//0..64

void setup() {
  println(this);
  cpu = new CPU();
  //size(1280, 720);
  surface.setSize(round(1280 * scale), round(640 * scale));
  screen = new color[width/2][height];
  changed = new boolean[width/2][height];
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

  String[] romFile = loadStrings(ROM+".asm");
  Assembler.assemble(romFile);
  devices.add(new Buzzer((char)0xF000, this));

  font = createFont("mono.ttf", 128);
  textFont(font);

  //frameRate(1);
  frameRate(60);
  noSmooth();
  delay(1000);
}

void draw() {
  background(0);
  noStroke();
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
          if (scale > 1) {
            fill((chars[charRAM.get(i)][x][y])?255:0);
            rect((x+curX)*scale, (y+curY-(line*8))*scale, scale, scale);
          } else {
            set(x+curX, y+curY-(line*8), color((chars[charRAM.get(i)][x][y])?255:0));
          }
        }
      }
    }
    curX += 8;
    if (curX == width/(2*scale)) {
      curY += 8;
      curX = 0;
    }
  }
  //cycleDone = false;

  if (frameCount > 10) {
    for (int j=0; j<cycles; j++) {
      if (!cpu.halt) {
        cpu.tick();
      }
      if (charRAM.size() >= 80*80-160) {
        for (int i=0; i<80; i++) {
          charRAM.remove(0);
        }
      }
    }
    for (int i=0; i<devices.size(); i++) {
      devices.get(i).update();
    }
  }

  fill(25);
  rect(640*scale, 0, 640*scale, 640*scale);

  fill(150);
  textSize(16*scale);
  for (int i=0; i<41; i++) {
    int pc = cpu.pc + (i * 4);
    if(pc + 4 < cpu.RAM.length){
      text(hex(pc, 4) + ": " + ramString(pc) + " " + ramString(pc + 1) + " " + ramString(pc + 2) + " " + ramString(pc + 3), 640*scale, i*16*scale);
    }
  }
  
  text("A: " + hex(cpu.a, 4), 640*scale+(320*scale), 16*scale);
  text("B: " + hex(cpu.b, 4), 640*scale+(320*scale), 32*scale);
  text("C: " + hex(cpu.c, 4), 640*scale+(320*scale), 48*scale);
  text("D: " + hex(cpu.d, 4), 640*scale+(320*scale), 64*scale);

  surface.setTitle("FPS: " + frameRate);
}

void keyPressed() {
  if (cpu.keyJumpSet) {
    cpu.d = (char)keyCode;
    cpu.keyJumped = true;
    cpu.keyPC = cpu.keyJump;
  }
  //f5
  if (keyCode == 116) {
    byte[] bytes = new byte[cpu.RAM.length];
    for (int i=0; i<bytes.length; i++) {
      bytes[i] = byte(cpu.RAM[i]);
    }
    saveBytes("ramDump.ram", bytes);
  }
}

String ramString(int index) {
  if(index < cpu.RAM.length) {
    return hex(cpu.RAM[index], 2);
  } 
  return "";
}

void handleCPU() {
  //while(!cpu.halt){
  //  while(cycleDone){}

  //  delay(100);
  //  cycleDone = true;
  //}
}
