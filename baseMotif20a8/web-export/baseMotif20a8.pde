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
  strokeWeight(4);
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
  
  if(firstRun)
  {
    println(curFractal.currentPoints.size());
  }
  
  firstRun = false;
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

public class BMFractal
{
  PVector baseVector;
  PVector currentEdgeVector;
  float currentAngle;
  ArrayList currentPoints;
  
  PVector zeroDegreeLine;
  ArrayList base;
  ArrayList motif;
  
  boolean needsUpdate;
  int maxIterations;
  
  int sweepType;
  
  final int SWEEP_NONE = 0;
  final int SWEEP_EVEN = 1; 
  final int SWEEP_ODD = 2; 
  final int SWEEP_ALTERNATING_EVEN = 3; 
  final int SWEEP_ALTERNATING_ODD = 4;
  
  color[] spectrum;
  
  BMFractal(BMFractalDescription description)
  {
    this(description.sweepStyle, description.defaultIterations, description.defaultBase, description.defaultMotif);
  }
  
  BMFractal(int theSweepType, int theMaxIterations, ArrayList theBase, ArrayList theMotif)
  {
    base = theBase;
    motif = theMotif;
    maxIterations = theMaxIterations;
    
    sweepType = theSweepType;
    
    zeroDegreeLine = new PVector(1.0f, 0.0f);
    
    spectrum = new color[7];
  
    spectrum[0] = #FF0000;
    spectrum[1] = #FFFF00;
    spectrum[2] = #00FF00;
    spectrum[3] = #00FFFF;
    spectrum[4] = #0000FF;
    spectrum[5] = #FF00FF;
    spectrum[6] = #FF0000;
    
    needsUpdate = true;
  }
  
  void calculate()
  {
    //Start with the basis lines.
    currentPoints = (ArrayList)base.clone();
    
    int iteration = 0;

    while(iteration < maxIterations)
    {
      ArrayList newPoints = new ArrayList();
      
      PVector finalPoint = new PVector(0,0);
      
      for (int i = 0; i < currentPoints.size() - 1; i++)
      {
        PVector angleStartPoint = (PVector)currentPoints.get(i);
        PVector angleEndPoint = (PVector)currentPoints.get(i + 1);
        PVector angleVector = PVector.sub(angleEndPoint, angleStartPoint);
        float angleVectorMag = angleVector.mag();
        
        currentAngle = PVector.angleBetween(zeroDegreeLine, angleVector);
        
        if(angleStartPoint.y > angleEndPoint.y)
        {
          currentAngle = TWO_PI - currentAngle;
        }
        
        int maxVal = (currentPoints.size() - 1) * (motif.size() - 1);
        
        for (int j = 0; j < motif.size() - 1; j++)
        {
          PVector lineStart = ((PVector)motif.get(j)).get();
          PVector lineEnd = ((PVector)motif.get(j + 1)).get();
          
          boolean shouldInvert;
          
          /*
          switch(sweepType)
          {
            case SWEEP_NONE: 
              shouldInvert = false;
              break;
            
            case SWEEP_EVEN:
              shouldInvert = (i % 2 == 0);
              break;
            
            case SWEEP_ODD:
              shouldInvert = (i % 2 != 0);
              break;
            
            case SWEEP_ALTERNATING_EVEN:
              shouldInvert = (i % 2 == iteration % 2);
              break;
            
            case SWEEP_ALTERNATING_ODD:
              shouldInvert = (i % 2 != iteration % 2);
              break;
            
            default:
              shouldInvert = false;
              break;
          }
          */
          
          if(sweepType == SWEEP_NONE) {
              shouldInvert = false;
          } else if (sweepType == SWEEP_EVEN) {
              shouldInvert = (i % 2 == 0);
          } else if (sweepType == SWEEP_ODD) {
              shouldInvert = (i % 2 != 0);
          } else if (sweepType == SWEEP_ALTERNATING_EVEN) {
              shouldInvert = (i % 2 == iteration % 2);
          } else if (sweepType == SWEEP_ALTERNATING_ODD) {
              shouldInvert = (i % 2 != iteration % 2);
          } else {
              shouldInvert = false;
          }
          
          if(shouldInvert)
          {
            lineEnd.y = -lineEnd.y;
          }
          
          PVector transformStart = rotatePoint(scalePoint(lineStart, angleVectorMag), currentAngle);
          PVector transformEnd = rotatePoint(scalePoint(lineEnd, angleVectorMag), currentAngle);
          
          if(j == 0 && i == 0)
          {
            newPoints.add(PVector.add(transformStart, finalPoint));
          }
          
          newPoints.add(PVector.add(transformEnd, finalPoint));
          
          if(j == motif.size() - 2)
          {
            finalPoint = PVector.add(transformEnd, finalPoint);
          }
        }
      }
      currentPoints = newPoints;
      
      iteration++;
    }
    
    this.needsUpdate = false;
  }
  
  void draw()
  {
  
    if(needsUpdate)
    {
      this.calculate();
    }
    
    float scaleValue = min(height,width);
    
    PVector initPoint = (PVector)currentPoints.get(0);
    PVector minPoint = new PVector(initPoint.x, initPoint.y);
    PVector maxPoint = new PVector(initPoint.x, initPoint.y);
    
    for(int i = 0; i < currentPoints.size(); i++)
    {
      PVector currentPoint = (PVector)currentPoints.get(i);
      minPoint.x = min(currentPoint.x, minPoint.x);
      minPoint.y = min(currentPoint.y, minPoint.y);
      maxPoint.x = max(currentPoint.x, maxPoint.x);
      maxPoint.y = max(currentPoint.y, maxPoint.y);
    }
    
    float xDiff = maxPoint.x - minPoint.x;
    float yDiff = maxPoint.y - minPoint.y;
    float finalScale = 1.0f / max(xDiff, yDiff);
    
    for(int i = 0; i < currentPoints.size() - 1; i++)
    {
      stroke(lineColor(i, currentPoints.size() - 1));
      fill(lineColor(i, currentPoints.size() - 1));
      
      PVector lineStart = (PVector)currentPoints.get(i);
      PVector lineEnd = (PVector)currentPoints.get(i + 1);
      
      PVector transformStart = scalePoint(lineStart, scaleValue * finalScale);
      PVector transformEnd = scalePoint(lineEnd, scaleValue * finalScale);
      
      line(floor(transformStart.x - (minPoint.x * scaleValue * finalScale)), 
           floor(transformStart.y - (minPoint.y * scaleValue * finalScale)), 
           floor(transformEnd.x - (minPoint.x * scaleValue * finalScale)), 
           floor(transformEnd.y - (minPoint.y * scaleValue * finalScale)));
      //point(transformStart.x - (minPoint.x * scaleValue * finalScale), transformStart.y - (minPoint.y * scaleValue * finalScale));
      //point(transformEnd.x - (minPoint.x * scaleValue * finalScale),  transformEnd.y - (minPoint.y * scaleValue * finalScale));
      //ellipse(transformEnd.x - (minPoint.x * scaleValue * finalScale),  transformEnd.y - (minPoint.y * scaleValue * finalScale),3,3);
    }
  }
}

public class BMFractalDescription
{
  String name;
  int sweepStyle;
  int defaultIterations;
  ArrayList defaultBase;
  ArrayList defaultMotif;
  
  BMFractalDescription (String theName, int theSweepStyle, int theDefaultIterations, 
                        ArrayList theDefaultBase, ArrayList theDefaultMotif)
  {
    this.name = theName;
    this.sweepStyle = theSweepStyle;
    this.defaultIterations = theDefaultIterations;
    this.defaultBase = theDefaultBase;
    this.defaultMotif = theDefaultMotif;
  }
}

