import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class LineFractal extends PApplet {


PVector baseVector;
PVector currentEdgeVector;
float currentAngle;
ArrayList fracPoints;
ArrayList currentPoints;
int maxIterations = 5;

int[] spectrum;

public void setup()
{
  frame.setResizable(true);
  
  size(512, 512);
  smooth();
  colorMode(RGB, 255);
  
  spectrum = new int[7];
  
  spectrum[0] = 0xffFF0000;
  spectrum[1] = 0xffFFFF00;
  spectrum[2] = 0xff00FF00;
  spectrum[3] = 0xff00FFFF;
  spectrum[4] = 0xff0000FF;
  spectrum[5] = 0xffFF00FF;
  spectrum[6] = 0xffFF0000;

  currentPoints = new ArrayList();
  fracPoints = new ArrayList();
   
  currentPoints.add(new PVector(0.0f, 0.1f));
  currentPoints.add(new PVector(1.0f, 0.1f));
  
  fracPoints.add(new PVector(0.0f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.0f));
  fracPoints.add(new PVector(0.5f, 0.5f));
  fracPoints.add(new PVector(1.0f, 0.5f));
  
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

public void draw()
{
  background(0xaeaeae);
  
  /*for(int i = 0; i < width; i++)
  {
      stroke(lineColor(i, width));
      line(i, 0, i, height);
  }*/
  
  float scaleValue = min(height,width);
  
  scale(1.0f,-1.0f);
  translate(0.0f,-height);

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
  currentPoints.add(new PVector(0.0f, 0.1f));
  currentPoints.add(new PVector(1.0f, 0.1f));

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
        
        //stroke(lineColor(int (i * (fracPoints.size() - 1)) + j, ((currentPoints.size() - 1) * (fracPoints.size() - 1)) - 1));
        
        PVector lineStart = (PVector)fracPoints.get(j);
        PVector lineEnd = (PVector)fracPoints.get(j + 1);
        
        //PVector transformStart = rotatePoint(scalePoint(lineStart, angleVectorMag * scaleValue), currentAngle);
        //PVector transformEnd = rotatePoint(scalePoint(lineEnd, angleVectorMag * scaleValue), currentAngle);
        
        PVector transformStart = rotatePoint(scalePoint(lineStart, angleVectorMag), currentAngle);
        PVector transformEnd = rotatePoint(scalePoint(lineEnd, angleVectorMag), currentAngle);
        
        if(j == 0 && i == 0)
        {
          //println("First thing: "  + (transformStart.x + angleStartPoint.x) + ", " + (transformStart.y + angleStartPoint.y));
          //newPoints.add(PVector.add(transformStart, angleStartPoint));
          println("First thing: "  + (transformStart.x + finalPoint.x) + ", " + (transformStart.y + finalPoint.y));
          newPoints.add(PVector.add(transformStart, finalPoint));
        }
        
        //println("This thing: " + (transformEnd.x + angleStartPoint.x) + ", " + (transformEnd.y + angleStartPoint.y));
        //newPoints.add(PVector.add(transformEnd, angleStartPoint));        
        println("This thing: " + (transformEnd.x + finalPoint.x) + ", " + (transformEnd.y + finalPoint.y));
        newPoints.add(PVector.add(transformEnd, finalPoint));
        
        if(j == fracPoints.size() - 2)
        {
          finalPoint = PVector.add(transformEnd, finalPoint);
        }
        
        /*
        transformStart = scalePoint(transformStart, scaleValue);
        transformEnd = scalePoint(transformEnd, scaleValue);
        
        transformStart.x = transformStart.x + (angleStartPoint.x * scaleValue);
        transformStart.y = transformStart.y + (angleStartPoint.y * scaleValue);
        transformEnd.x = transformEnd.x + (angleStartPoint.x * scaleValue);
        transformEnd.y = transformEnd.y + (angleStartPoint.y * scaleValue);
        
        line(transformStart.x, transformStart.y, transformEnd.x, transformEnd.y);
        */
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
  
  println("MIN: " + minPoint.x + ", " + minPoint.y);
  println("MAX: " + maxPoint.x + ", " + maxPoint.y);
  println("DIFF: " + xDiff + ", " + yDiff + " - " + finalScale);
  
  for(int i = 0; i < currentPoints.size() - 1; i++)
  {
    stroke(lineColor(i, currentPoints.size() - 1));
    
    PVector lineStart = (PVector)currentPoints.get(i);
    PVector lineEnd = (PVector)currentPoints.get(i + 1);
    
    PVector transformStart = scalePoint(lineStart, scaleValue * finalScale);
    PVector transformEnd = scalePoint(lineEnd, scaleValue * finalScale);
    
    xDiff *= scaleValue * finalScale;
    yDiff *= scaleValue * finalScale;
    
    /*transformStart.x = transformStart.x + (angleStartPoint.x * scaleValue);
    transformStart.y = transformStart.y + (angleStartPoint.y * scaleValue);
    transformEnd.x = transformEnd.x + (angleStartPoint.x * scaleValue);
    transformEnd.y = transformEnd.y + (angleStartPoint.y * scaleValue);*/
    
    //println("Point: " + i + " - " + transformStart.x + ", " + transformStart.y);
    
    line(transformStart.x + (width / 2), transformStart.y, transformEnd.x + (width / 2), transformEnd.y);
  }
    
  firstRun = false;
}

public PVector rotatePoint(PVector originalPoint, float angle)
{
   PVector newPoint = new PVector(originalPoint.x * cos(angle) - originalPoint.y * sin(angle),
                                   originalPoint.x * sin(angle) + originalPoint.y * cos(angle));
   
   return newPoint;                              
}
 

public PVector scalePoint(PVector originalPoint, float scaleFactor)
{
  PVector newPoint = new PVector(originalPoint.x * scaleFactor, 
                                 originalPoint.y * scaleFactor);

  return newPoint;
}

public int lineColor(int currentSequence, int maxSequence)
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "LineFractal" });
  }
}
