
BMFractalDescription[] fractalArray;
BMFractal curFractal;
int curFractalIndex;
String infoString = "";
boolean updateText;

XMLElement baseFractalNode;

boolean firstRun;

void setup()
{
  //frame.setResizable(true);

  size(800, 800, P2D);
  smooth();
  colorMode(RGB, 255);

  baseFractalNode = new XMLElement(this, "fracs.xml");
  String[] kids = baseFractalNode.listChildren();

  XMLElement[] elements = baseFractalNode.getChildren("Fractal");
  int fracCount = elements.length;
  fractalArray = new BMFractalDescription[fracCount];

  for (int i = 0; i < elements.length; i++)
  {
    XMLElement currentElement = elements[i];
    String newName = currentElement.getString("name"); 
    int newSweepStyle = currentElement.getInt("sweepStyle");
    int newDefaultIterations = currentElement.getInt("defaultIterations");

    XMLElement baseElement = currentElement.getChild("Base");
    XMLElement[] basePointElements = baseElement.getChildren("Point");
    ArrayList basePoints = new ArrayList();
    for (int j = 0; j < basePointElements.length; j++)
    {
      XMLElement currentBaseElement = basePointElements[j];
      PVector currentPoint = new PVector(currentBaseElement.getFloat("x"), currentBaseElement.getFloat("y"));
      basePoints.add(currentPoint);
    }

    XMLElement motifElement = currentElement.getChild("Motif");
    XMLElement[] motifPointElements = motifElement.getChildren("Point");
    ArrayList motifPoints = new ArrayList();
    for (int j = 0; j < motifPointElements.length; j++)
    {
      XMLElement currentMotifElement = motifPointElements[j];
      PVector currentPoint = new PVector(currentMotifElement.getFloat("x"), currentMotifElement.getFloat("y"));
      motifPoints.add(currentPoint);
    }

    BMFractalDescription newFrac = new BMFractalDescription(newName, newSweepStyle, newDefaultIterations, 
    basePoints, motifPoints);
    fractalArray[i] = newFrac;
  }

  curFractalIndex = 0;
  BMFractalDescription currentDescription = fractalArray[curFractalIndex];

  curFractal = new BMFractal(currentDescription);
  infoString = currentDescription.name;
  updateText = true;

  firstRun = true;

  PFont font = loadFont("ArialMT-12.vlw");
  textFont(font);
}

void draw()
{
  pushMatrix();
  //Flip the coordinate system, then translate it, so the origin is at the lower left corner.
  scale(1.0, -1.0);
  translate(0.0, -height);

  curFractal.draw();
  popMatrix();

  if (updateText) {
    infoString += " - lines: " + (curFractal.currentPoints.size());

    fill(255, 255, 255);
    text(infoString, 5, 10);
    updateText = false;
  }

  firstRun = false;
  /*
  if(frameCount % 60 == 0) {
   println("Lines: " + curFractal.currentPoints.size());  
   println("FPS: " + frameRate);
   println("Stretch: " + curFractal.stretchRatio);  
   println("Spread: " + curFractal.spreadRatio);   
   }*/
}

void keyPressed() 
{
  BMFractalDescription newDescription;
  //37 - left
  //39 - right
  //38 - up
  //40 - downn  

    switch(keyCode)
  {
  case 38:
    curFractal.stretchRatio += 5;
    infoString = "Stretch Ratio: " + (curFractal.stretchRatio / 100.0);
    updateText = true;
    curFractal.needsUpdate = true;
    break;

  case 40:
    curFractal.stretchRatio -= 5;
    infoString = "Stretch Ratio: " + (curFractal.stretchRatio / 100.0);
    updateText = true;
    curFractal.needsUpdate = true;
    break;

  case 37:
    curFractal.spreadRatio += 5;
    infoString = "Spread Ratio: " + (curFractal.spreadRatio / 100.0);
    updateText = true;
    curFractal.needsUpdate = true;
    break;

  case 39:
    curFractal.spreadRatio -= 5;
    infoString = "Spread Ratio: " + (curFractal.spreadRatio / 100.0);
    updateText = true;
    curFractal.needsUpdate = true;
    break;
    //Left Square Bracket key
  case 91:
    curFractalIndex--;
    if (curFractalIndex < 0)
    {
      curFractalIndex = fractalArray.length - 1;
    }

    newDescription = fractalArray[curFractalIndex];
    updateText = true;

    infoString = newDescription.name;
    curFractal = new BMFractal(newDescription);

    break;
    //Right Square Bracket key
  case 93:
    curFractalIndex++;
    if (curFractalIndex >= fractalArray.length)
    {
      curFractalIndex = 0;
    }

    newDescription = fractalArray[curFractalIndex];
    updateText = true;

    infoString = newDescription.name;
    curFractal = new BMFractal(newDescription);

    break;
    //Equal Key
  case 61:
    curFractal.maxIterations++;
    infoString = "Max Iterations: " + curFractal.maxIterations;
    updateText = true;
    curFractal.needsUpdate = true;
    break;
    //Minus key
  case 45:
    curFractal.maxIterations--;
    infoString = "Max Iterations: " + curFractal.maxIterations;
    updateText = true;
    curFractal.needsUpdate = true;
    break;
    //S key
  case 83:
    curFractal.sweepType++;
    if (curFractal.sweepType > 4) {
      curFractal.sweepType = 0;
    }
    infoString = "Sweep Type: " + curFractal.sweepType;
    updateText = true;
    curFractal.needsUpdate = true;
    break;
  default:
    break;
  }
}

