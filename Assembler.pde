public static class Assembler {  
  public static char[] assemble(String[] file) {
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$^&*()-=+,.%/\\?:'_;[]{}><% ";
    ArrayList<Character> result = new ArrayList<Character>();
    HashMap<String, Character> labelMap = new HashMap<String, Character>();
    
    char pos = 0x0000;
    for(int i=0;i<file.length;i++){
      if(file[i].trim().length() > 0){
        if(file[i].trim().charAt(0) == ':'){
          labelMap.put(file[i].trim().substring(1), pos);
          if(verbose) {
            println("Parser.LabelFinder: found label " + file[i].trim() + " at " + hex(pos, 4));
          }
        }
        if(file[i].trim().charAt(0) != ';'){
          pos += 0x0004;
        }
      }
    }
    
    return null;
  }
}
