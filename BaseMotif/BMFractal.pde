
public class BMFractal
{
  PVector zeroDegreeLine;
  ArrayList base;
  ArrayList motif;
  ArrayList currentPoints;
  
  boolean needsUpdate;
  int maxIterations;
  
  int sweepType;
  
  final int SWEEP_NONE = 0;
  final int SWEEP_EVEN = 1; 
  final int SWEEP_ODD = 2; 
  final int SWEEP_ALTERNATING_EVEN = 3; 
  final int SWEEP_ALTERNATING_ODD = 4;
  
  color[] spectrum;
  
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
      
      PVector lineStart = (PVector)currentPoints.get(i);
      PVector lineEnd = (PVector)currentPoints.get(i + 1);
      
      PVector transformStart = scalePoint(lineStart, scaleValue * finalScale);
      PVector transformEnd = scalePoint(lineEnd, scaleValue * finalScale);
      
      line(transformStart.x - (minPoint.x * scaleValue * finalScale), transformStart.y - (minPoint.y * scaleValue * finalScale), 
            transformEnd.x - (minPoint.x * scaleValue * finalScale),  transformEnd.y - (minPoint.y * scaleValue * finalScale));
    }
  }
}
