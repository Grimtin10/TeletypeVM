boolean charsetEdit = true;
String charsetName = "newChars";
boolean load = true;
int curChar = 0;
boolean[][][] chars = new boolean[64][8][8];

void setup(){
  size(500, 500);
  if(load){
    String[] temp = loadStrings(charsetName+".charset");
    for(int i=0;i<temp.length;i++){
      String[] temp2 = temp[i].split(" ");
      for(int j=0;j<temp2.length;j++){
        for(int k=0;k<temp2[j].length();k++){
          chars[i][j][k] = (temp2[j].charAt(k)=='1');
        }
      }
    }
  }
}

void draw(){
  if(charsetEdit){
    for(int x=0;x<8;x++){
      for(int y=0;y<8;y++){
        stroke(128);
        fill((chars[curChar][x][y])?255:0);
        rect(x*width/8, y*height/8, width/8, height/8);
      }
    }
    fill(200, 200);
    rect((mouseX/(width/8))*width/8, (mouseY/(height/8))*height/8, width/8, height/8);
  }
  surface.setTitle("Current Char: " + curChar);
}

void mousePressed(){
  saveChars("autosave");
  chars[curChar][(mouseX/(width/8))][(mouseY/(height/8))] = !chars[curChar][(mouseX/(width/8))][(mouseY/(height/8))];
}

void keyPressed(){
  if(keyCode == LEFT && curChar > 0){
    curChar--;
    saveChars(charsetName);
  }
  if(keyCode == RIGHT && curChar < chars.length-1){
    curChar++;
    saveChars(charsetName);
  }
  if(keyCode == ENTER){
    saveChars(charsetName);
  }
}

//idk like make this proper
void saveChars(String name){
  ArrayList<String> the = new ArrayList<String>();
  for(int i=0;i<chars.length;i++){
    String temp = "";
    for(int x=0;x<chars[0].length;x++){
      for(int y=0;y<chars[0][0].length;y++){
        temp += (chars[i][x][y])?"1":"0";
      }
      temp += " ";
    }
    the.add(temp);
  }
  saveStrings(name+".charset", the.toArray(new String[the.size()]));
}
