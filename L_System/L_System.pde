
LanguageDescription curLanguage;

float sysAngle = THIRD_PI;

int iterations = 2;

String axiom = "F--F--F";
HashMap productions; 

void setup() {
  size(800, 800, P3D);
  colorMode(RGB, 255);
  
  productions = new HashMap();
  productions.put('F', "F+F--F+F");
  
  curLanguage = new LanguageDescription(axiom, productions, sysAngle, iterations); 
}

void draw() {
  background(0xaeaeae);
  
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

