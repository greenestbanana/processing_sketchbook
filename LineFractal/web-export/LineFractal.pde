
PVector baseVector;
PVector currentEdgeVector;
float currentAngle;
ArrayList fracPoints;
ArrayList currentPoints;
int maxIterations = 3;

color[] spectrum;

void setup()
{
  frame.setResizable(true);
  
  size(512, 512);
  smooth();
  strokeWeight(1);
  colorMode(RGB, 255);
  
  spectrum = new color[7];
  
  spectrum[0] = #FF0000;
  spectrum[1] = #FFFF00;
  spectrum[2] = #00FF00;
  spectrum[3] = #00FFFF;
  spectrum[4] = #0000FF;
  spectrum[5] = #FF00FF;
  spectrum[6] = #FF0000;

  currentPoints = new ArrayList();
  fracPoints = new ArrayList();
  
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.25f, 0.0f));
  fracPoints.add(new PVector(0.25f, -0.5f));
  fracPoints.add(new PVector(0.5f, -0.5f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.0f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.0f));
  fracPoints.add(new PVector(0.25f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.5f));
  fracPoints.add(new PVector(0.5f, 0.0f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(0.5f, 0.6f));
  fracPoints.add(new PVector(1.0f, 0.5f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  fracPoints.add(new PVector(0.0f, 1.0f));
  fracPoints.add(new PVector(1.0f, 1.0f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(1.0f, 0.5f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(1.0f, 0.5f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.25f, 0.0f));
  fracPoints.add(new PVector(0.25f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.0f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  */
  /*
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.25f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(0.75f, 0.0f));
  fracPoints.add(new PVector(1.0f, 0.0f));
  */

  baseVector = new PVector(1.0f, 0.0f);
  
  firstRun = true;
}

boolean firstRun;

void draw()
{
  background(0x000000);
  
  /*for(int i = 0; i < width; i++)
  {
      stroke(lineColor(i, width));
      line(i, 0, i, height);
  }*/
  
  float scaleValue = min(height,width);
  
  scale(1.0,-1.0);
  translate(0.0,-height);

  if(mousePressed && mouseButton == LEFT)
  {
    PVector movePoint = (PVector)currentPoints.get(0);
    movePoint.x = (float)mouseX / (float)width;
    movePoint.y =  1 - ((float)mouseY / (float)height);
    
    println(movePoint.x + " - " + movePoint.y);
  }
  else if(mousePressed && mouseButton == RIGHT)
  {
    PVector movePoint = (PVector)currentPoints.get(1);
    movePoint.x = (float)mouseX / (float)width;
    movePoint.y = 1 - ((float)mouseY / (float)height);
    
    println(movePoint.x + " - " + movePoint.y);
  }
  //translate(margin, (height - (margin * 2)) + margin);
  //rotate(-PI/3.0);
  
  currentPoints = new ArrayList();
  currentPoints.add(new PVector(0.0f, 0.0f));
  currentPoints.add(new PVector(0.0f, 1.0f));
  currentPoints.add(new PVector(1.0f, 1.0f));
  currentPoints.add(new PVector(1.0f, 0.0f));
  currentPoints.add(new PVector(0.0f, 0.0f));

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
      
      currentAngle = PVector.angleBetween(baseVector, angleVector);
      
      if(angleStartPoint.y > angleEndPoint.y)
      {
        currentAngle = TWO_PI - currentAngle;
      }
      
      int maxVal = (currentPoints.size() - 1) * (fracPoints.size() - 1);
      
      for (int j = 0; j < fracPoints.size() - 1; j++)
      {
        PVector lineStart = (PVector)fracPoints.get(j);
        PVector lineEnd = (PVector)fracPoints.get(j + 1);
        
        PVector transformStart = rotatePoint(scalePoint(lineStart, angleVectorMag), currentAngle);
        PVector transformEnd = rotatePoint(scalePoint(lineEnd, angleVectorMag), currentAngle);
        
        if(j == 0 && i == 0)
        {
          newPoints.add(PVector.add(transformStart, finalPoint));
        }
        
        newPoints.add(PVector.add(transformEnd, finalPoint));
        
        if(j == fracPoints.size() - 2)
        {
          finalPoint = PVector.add(transformEnd, finalPoint);
        }
      }
    }
    currentPoints = newPoints;
    
    iteration++;
  }
  
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
  /*
  println("MIN: " + minPoint.x + ", " + minPoint.y);
  println("MAX: " + maxPoint.x + ", " + maxPoint.y);
  println("DIFF: " + xDiff + ", " + yDiff + " - " + finalScale);
  */
  for(int i = 0; i < currentPoints.size() - 1; i++)
  {
    stroke(lineColor(i, currentPoints.size() - 1));
    
    PVector lineStart = (PVector)currentPoints.get(i);
    PVector lineEnd = (PVector)currentPoints.get(i + 1);
    
    PVector transformStart = scalePoint(lineStart, scaleValue * finalScale);
    PVector transformEnd = scalePoint(lineEnd, scaleValue * finalScale);
    
    //minPoint.x *= scaleValue * finalScale;
    //minPoint.y *= scaleValue * finalScale;
    
    line(transformStart.x - (minPoint.x * scaleValue * finalScale), 5 + transformStart.y - (minPoint.y * scaleValue * finalScale), 
          transformEnd.x - (minPoint.x * scaleValue * finalScale),  5 + transformEnd.y - (minPoint.y * scaleValue * finalScale));
  }
    
  firstRun = false;
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

