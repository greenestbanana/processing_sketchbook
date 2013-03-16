
LanguageDescription curLanguage;

PVector position;
float curAngle = 0;

float sysAngle = HALF_PI;

int iterations = 4;

String axiom = "F";
HashMap productions; 

void setup() {
  
  frame.setResizable(true);
  
  size(600, 600, P3D);
  colorMode(RGB, 255);
  
  productions = new HashMap();
  productions.put('F', "F+F-F-F-G+F+F+F-F");
  productions.put('G', "GGG");
  
  curLanguage = new LanguageDescription(axiom, productions, sysAngle, iterations); 
  
  /*String expanded = axiom;
  
  for(int it = 0; it < iterations; it++) {
    StringBuilder newProd = new StringBuilder();
    for(int strPos = 0; strPos < expanded.length(); strPos++) {
      char curChar = expanded.charAt(strPos);
      if(productions.containsKey(curChar)) {
        newProd.append(productions.get(curChar));
      } else {
        newProd.append(curChar);
      }
    }
    expanded = newProd.toString();
  }
  
  position = new PVector(width / 3, height / 3);
  PVector oldPos = new PVector(position.x, position.y);
  
  PVector minPoint = new PVector(0,0);
  PVector maxPoint = new PVector(0,0);
  
  int len = 3;
  for(int strPos = 0; strPos < expanded.length(); strPos++) {
    char curChar = expanded.charAt(strPos);
    if(curChar == '+') {
      curAngle += sysAngle;
    } else if (curChar == '-') {
      curAngle -= sysAngle;
    } else if (curChar == 'F') {
      oldPos.set(position.x, position.y, position.z);
      position.x += cos(curAngle) * len;
      position.y += sin(curAngle) * len;
      line(oldPos.x, oldPos.y, position.x, position.y);
    }
  }*/
}

void draw() {
  background(0xaeaeae);
  
  curLanguage.draw();
}

