
LanguageDescription curLanguage;

float sysAngle = HALF_PI;

int iterations = 3;

String axiom = "FX";
HashMap productions; 

void setup() {
  size(600, 600, P2D);
  colorMode(RGB, 255);
  
  productions = new HashMap();
  productions.put('X', "X+YF+");
  productions.put('Y', "-FX-Y");
  
  ArrayList constants = new ArrayList();
  constants.add('F');
  
  curLanguage = new LanguageDescription(axiom, productions, sysAngle, iterations, constants, null); 
}

void draw() {
  background(0x000000);
  
  curLanguage.draw();
}


void keyPressed() 
{
  switch(keyCode) {
    //Equal Key
    case 61:
      curLanguage.setIterations(curLanguage.iterations + 1);
      break;
    //Minus key
    case 45:
      curLanguage.setIterations(curLanguage.iterations - 1);
      break;
  }
}

