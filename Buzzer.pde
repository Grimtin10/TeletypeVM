import processing.sound.*;

public class Buzzer extends Device {
  SqrOsc sqr;
  
  boolean playing;
  
  public Buzzer(char start, TeletypeVM parent){
    super(start);
    sqr = new SqrOsc(parent);
    sqr.amp(0.1);
  }
  
  public void update(){
    if(((cpu.RAM[start] << 8) | (cpu.RAM[start+1])) != 0x0000){
      //println(((cpu.RAM[start]) | (cpu.RAM[start+1] >> 8)));
      sqr.freq(((cpu.RAM[start - 1] << 8) | (cpu.RAM[start])));
        //println("PLAY " + hex((char)((cpu.RAM[start] << 8) | (cpu.RAM[start + 1])), 4));
      if(!playing){
        println("PLAY " + hex(((cpu.RAM[start - 1] << 8) | (cpu.RAM[start])), 4));
        sqr.play();
      }
      playing = true;
    } else {
      if(playing){
        println("STOP");
        sqr.stop();
      }
      playing = false;
    }
  }
}
