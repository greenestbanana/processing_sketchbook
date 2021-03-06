
class LanguageDescription {
  int MIN_MAX_FUNC = 0;
  int DRAW_FUNC = 1;
  
  float systemAngle;
  float lineLength;
  int iterations;
 
  String axiom;
  String expanded;
  HashMap productions; 
  ArrayList drawConstants;
  ArrayList skipConstants;
  
  color[] spectrum;
  float margin = 5.0f;
  
  boolean needsUpdate;
  
  LanguageRange range;
  LanguageLine lineDrawer;
  
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
    
    drawConstants = theDrawConstants;
    if(drawConstants == null) {
      drawConstants = new ArrayList();
      drawConstants.add('F');
    }
    
    skipConstants = theSkipConstants;
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
      
      println("Max: " + range.maxPoint.x + ", " + range.maxPoint.y);
      println("Min: " + range.minPoint.x + ", " + range.minPoint.y);
      
      lineLength = min((width - (margin * 2.0)) / (range.maxPoint.x - range.minPoint.x), 
                       (height - (margin * 2.0)) / (range.maxPoint.y - range.minPoint.y));
      
      background(0x000000);
      
      lineDrawer = new LanguageLine(range.pointCount);
      PVector startPoint = new PVector((-range.minPoint.x * lineLength) + margin, 
                                       (-range.minPoint.y * lineLength) + margin);
      traverseSystem(startPoint, lineDrawer);
      
      needsUpdate = false;
    }
  }
  
  void calcMinMaxPoints() {
    range = new LanguageRange();
    traverseSystem(new PVector(0, 0), range);
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
  
  void traverseSystem(PVector position, LanguageOperation operation) {
    int totalLineCount = 0;
    int currentLineIndex = 0;
    //PVector position = new PVector();
    
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
        
        operation.languageIterated(oldPos, position, currentLineIndex);
        currentLineIndex++;
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
}
