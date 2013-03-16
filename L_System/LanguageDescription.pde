
class LanguageDescription {
  int MIN_MAX_FUNC = 0;
  int DRAW_FUNC = 1;
  
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
    
    minPoint = new PVector(0,0);
    maxPoint = new PVector(0,0);
    
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
  
  void setIterations(int newIterations) {
    iterations = newIterations;
    needsUpdate = true;
  }
  
  void draw() {
    if(needsUpdate) {
      expanded = generateExpanded(axiom, iterations);
      
      println("Expanded: " + expanded);
      
      lineLength = 1;
      calcMinMaxPoints();
      
      println("Max: " + maxPoint.x + ", " + maxPoint.y);
      println("Min: " + minPoint.x + ", " + minPoint.y);
      
      lineLength = min((width - (margin * 2.0)) / (maxPoint.x - minPoint.x), 
                       (height - (margin * 2.0)) / (maxPoint.y - minPoint.y));
      
      needsUpdate = false;
    }
    
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
    PVector position = new PVector();
    if(pointFunc == MIN_MAX_FUNC) {
      position.set(0,0,0);
    } else {
      position.set((-minPoint.x * lineLength) + margin, (-minPoint.y * lineLength) + margin,0);
    }
    PVector oldPos = new PVector(position.x, position.y);
    ArrayList positionStack = new ArrayList();
    float curAngle = 0;
    
    for(int strPos = 0; strPos < expanded.length(); strPos++) {
      char curChar = expanded.charAt(strPos);
      if(curChar == '+') {
        curAngle += sysAngle;
      } else if (curChar == '-') {
        curAngle -= sysAngle;
      } else if (curChar == '[') { 
        pushPosition(positionStack, position, curAngle);
      } else if (curChar == ']') { 
        SavedPosition popPos = popPosition(positionStack);
        if(popPos != null) {
          position = popPos.position;
          curAngle = popPos.angle;
        }
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
  
  void pushPosition(ArrayList positionStack, PVector pushPosition, float pushAngle) {
    SavedPosition newPosition = new SavedPosition(pushPosition, pushAngle);
    positionStack.add(newPosition);
  }
  
  SavedPosition popPosition(ArrayList positionStack) {
    int stackIndex = positionStack.size() - 1;
    SavedPosition poppedPos = null;
    
    if(stackIndex >= 0) {
      poppedPos = (SavedPosition)positionStack.get(stackIndex);
      positionStack.remove(stackIndex);
    }
    
    return poppedPos;
  }
  
  void drawLine(PVector oldPos, PVector newPos) {
    line(((float)Math.floor(oldPos.x)) + 0.5f, ((float)Math.floor(oldPos.y)) + 0.5f, 
         ((float)Math.floor(newPos.x)) + 0.5f, ((float)Math.floor(newPos.y)) + 0.5f);
  }
  
  void minMaxPoint(PVector point) {
    maxPoint.set(max(maxPoint.x, point.x), max(maxPoint.y, point.y), 0.0);
    minPoint.set(min(minPoint.x, point.x), min(minPoint.y, point.y), 0.0); 
  }
}
