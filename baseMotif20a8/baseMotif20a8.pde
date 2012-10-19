//XMLElement baseFractalNode;XML baseFractalNode;
BMFractalDescription[] fractalArray;
BMFractal curFractal;
int curFractalIndex;

XML baseFractalNode;

color[] spectrum;

boolean firstRun;

void setup()
{
  println("starting");
  
  //frame.setResizable(true);
  
  size(512, 512, P2D);
  //noSmooth();
  //strokeWeight(4);
  colorMode(RGB, 255);
  
  baseFractalNode = loadXML("fracs.xml");
  String[] kids = baseFractalNode.listChildren();
  
  XML[] elements = baseFractalNode.getChildren("Fractal");
  int fracCount = elements.length;
  fractalArray = new BMFractalDescription[fracCount];
  
  for(int i = 0; i < elements.length; i++)
  {
    XML currentElement = elements[i];
    String newName = currentElement.getString("name"); 
    int newSweepStyle = currentElement.getInt("sweepStyle");
    int newDefaultIterations = currentElement.getInt("defaultIterations");
    
    XML baseElement = currentElement.getChild("Base");
    XML[] basePointElements = baseElement.getChildren("Point");
    ArrayList basePoints = new ArrayList();
    for(int j = 0; j < basePointElements.length; j++)
    {
      XML currentBaseElement = basePointElements[j];
      PVector currentPoint = new PVector(currentBaseElement.getFloat("x"), currentBaseElement.getFloat("y"));
      basePoints.add(currentPoint);
    }
    
    XML motifElement = currentElement.getChild("Motif");
    XML[] motifPointElements = motifElement.getChildren("Point");
    ArrayList motifPoints = new ArrayList();
    for(int j = 0; j < motifPointElements.length; j++)
    {
      XML currentMotifElement = motifPointElements[j];
      PVector currentPoint = new PVector(currentMotifElement.getFloat("x"), currentMotifElement.getFloat("y"));
      motifPoints.add(currentPoint);
    }
    
    BMFractalDescription newFrac = new BMFractalDescription(newName, newSweepStyle, newDefaultIterations, 
                                                            basePoints, motifPoints);
    fractalArray[i] = newFrac;
  }
  
  spectrum = new color[7];
  
  spectrum[0] = #FF0000;
  spectrum[1] = #FFFF00;
  spectrum[2] = #00FF00;
  spectrum[3] = #00FFFF;
  spectrum[4] = #0000FF;
  spectrum[5] = #FF00FF;
  spectrum[6] = #FF0000;
  
  curFractalIndex = 0;
  BMFractalDescription currentDescription = fractalArray[curFractalIndex];
  
  curFractal = new BMFractal(currentDescription);
  
  firstRun = true;
}

void draw()
{
  background(0x000000);
  
  scale(1.0,-1.0);
  translate(0.0,-height);
  
  curFractal.draw();
  
  firstRun = false;
  
  if(frameCount % 60 == 0) {
    println("Lines: " + curFractal.currentPoints.size());  
    println("FPS: " + frameRate);   
  }
}

void keyPressed() 
{
  BMFractalDescription newDescription;
  //37 - left
  //39 - right
  //38 - up
  //40 - down
  switch(keyCode)
  {
    case 37:
      curFractalIndex--;
      if(curFractalIndex < 0)
      {
        curFractalIndex = fractalArray.length - 1;
      }
      println("LEFT: " + curFractalIndex);
      
      newDescription = fractalArray[curFractalIndex];
  
      println(newDescription.defaultMotif.size());
      curFractal = new BMFractal(newDescription);
  
      break;
    case 39:
      curFractalIndex++;
      if(curFractalIndex >= fractalArray.length)
      {
        curFractalIndex = 0;
      }
      println("RIGHT " + curFractalIndex);
      
      newDescription = fractalArray[curFractalIndex];
  
      println(newDescription.defaultMotif.size());
      curFractal = new BMFractal(newDescription);
  
      break;
    case 38:
      println("UP");
      curFractal.maxIterations++;
      curFractal.needsUpdate = true;
      break;
    case 40:
      println("DWOSN");
      curFractal.maxIterations--;
      curFractal.needsUpdate = true;
      break;
    default:
    break;    
  }
}

PVector rotatePoint(PVector originalPoint, float angle)
{
   PVector newPoint = new PVector(originalPoint.x * cos(angle) - originalPoint.y * sin(angle),
                                   originalPoint.x * sin(angle) + originalPoint.y * cos(angle));
   
   return newPoint;                              
}
 

PVector scalePoint(PVector originalPoint, float scaleFactor)
{
  PVector newPoint = new PVector(originalPoint.x * scaleFactor, 
                                 originalPoint.y * scaleFactor);

  return newPoint;
}

color lineColor(int currentSequence, int maxSequence)
{
  int spectrumSlots = spectrum.length - 1;
  
  int lowerIndex = floor(((float)currentSequence / (float)maxSequence) * spectrumSlots);
  int upperIndex = ceil(((float)currentSequence / (float)maxSequence) * spectrumSlots);
  float remainder = upperIndex - (((float)currentSequence / (float)maxSequence) * spectrumSlots);
  remainder = 1.0f - remainder;
  
  int rLower = spectrum[lowerIndex] >> 16 & 0xff;  
  int gLower = spectrum[lowerIndex] >> 8 & 0xff;  
  int bLower = spectrum[lowerIndex] & 0xff;
  
  int rUpper = spectrum[upperIndex] >> 16 & 0xff; 
  int gUpper = spectrum[upperIndex] >> 8 & 0xff;
  int bUpper = spectrum[upperIndex] & 0xff;
  
  int rInterp = ceil((float)(rUpper - rLower) * remainder) + rLower;
  int gInterp = ceil((float)(gUpper - gLower) * remainder) + gLower;
  int bInterp = ceil((float)(bUpper - bLower) * remainder) + bLower;
  
  return color(rInterp, gInterp, bInterp);
}
