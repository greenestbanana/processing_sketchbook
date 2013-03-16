
class LanguageDescription {
  int MIN_MAX_FUNC = 0;
  int DRAW_FUNC = 1;
  
  PVector position;
  PVector minPoint;
  PVector maxPoint;
  float systemAngle;
  float lineLength;
  int iterations;
 
  String axiom;
  String expanded;
  HashMap productions; 
  ArrayList drawConstants;
  ArrayList skipConstants;
  
  float margin = 5.0f;
  
  boolean needsUpdate;
  
  LanguageDescription(String theAxiom, HashMap theProductions, float theAngle, int defaultIterations) {
    this(theAxiom, theProductions, theAngle, defaultIterations, null, null);
  }
  
  LanguageDescription(String theAxiom, HashMap theProductions, float theAngle, int defaultIterations, 
                      ArrayList theDrawConstants, ArrayList theSkipConstants) {
    axiom = theAxiom;
    systemAngle = theAngle;
    lineLength = 1;
    iterations = defaultIterations;
    productions = theProductions;
    
    position = new PVector(0,0);
    minPoint = new PVector(0,0);
    maxPoint = new PVector(0,0);
    curAngle = 0;
    
    if(drawConstants == null) {
      drawConstants = new ArrayList();
      drawConstants.add('F');
    }
    
    if(skipConstants == null) {
      skipConstants = new ArrayList();
      skipConstants.add('G');
    }
    
    needsUpdate = true;
  }
  
  void draw() {
    if(needsUpdate) {
      expanded = generateExpanded(axiom, iterations);
      
      lineLength = 1;
      calcMinMaxPoints();
      
      lineLength = min((width - (margin * 2.0)) / (maxPoint.x - minPoint.x), 
                       (height - (margin * 2.0)) / (maxPoint.y - minPoint.y));
      println("MAX X: " + (maxPoint.x) + " Y: " + (maxPoint.y));
      println("MIN X: " + (minPoint.x) + " Y: " + (minPoint.y));
      println("Length: " + lineLength);
      
      needsUpdate = false;
    }
    
    position.set((-minPoint.x * lineLength) + margin, (-minPoint.y * lineLength) + margin, 0);
    
    traverseSystem(DRAW_FUNC);
  }
  
  void calcMinMaxPoints() {
    minPoint.set(0,0,0);
    maxPoint.set(0,0,0);
    
    traverseSystem(MIN_MAX_FUNC);
  }
  
  String generateExpanded(String expandAxiom, int expandIterations) {
    String returnExpansion = expandAxiom;
    
    for(int it = 0; it < expandIterations; it++) {
      StringBuilder newExpansion = new StringBuilder();
      for(int strPos = 0; strPos < returnExpansion.length(); strPos++) {
        char curChar = returnExpansion.charAt(strPos);
        if(productions.containsKey(curChar)) {
          newExpansion.append(productions.get(curChar));
        } else {
          newExpansion.append(curChar);
        }
      }
      returnExpansion = newExpansion.toString();
    }
    
    return returnExpansion;
  }
  
  void traverseSystem(int pointFunc) {
    PVector oldPos = new PVector(position.x, position.y);
    float curAngle = 0;
    
    for(int strPos = 0; strPos < expanded.length(); strPos++) {
      char curChar = expanded.charAt(strPos);
      if(curChar == '+') {
        curAngle += sysAngle;
      } else if (curChar == '-') {
        curAngle -= sysAngle;
      } else if (drawConstants.contains(curChar)) {
        oldPos.set(position.x, position.y, position.z);
        position.x += cos(curAngle) * lineLength;
        position.y += sin(curAngle) * lineLength;
        if(pointFunc == MIN_MAX_FUNC) {
          minMaxPoint(position);
        } else if (pointFunc == DRAW_FUNC) {
          drawLine(oldPos, position);
        }
      } else if (skipConstants.contains(curChar)) {
        position.x += cos(curAngle) * lineLength;
        position.y += sin(curAngle) * lineLength;
      }
    }
  }
  
  void drawLine(PVector oldPos, PVector newPos) {
    line(Math.floor(oldPos.x) + 0.5f, Math.floor(oldPos.y) + 0.5f, Math.floor(newPos.x) + 0.5f, Math.floor(newPos.y) + 0.5f);
  }
  
  void minMaxPoint(PVector point) {
    maxPoint.set(max(maxPoint.x, point.x), max(maxPoint.y, point.y), 0.0);
    minPoint.set(min(minPoint.x, point.x), min(minPoint.y, point.y), 0.0); 
  }
}
