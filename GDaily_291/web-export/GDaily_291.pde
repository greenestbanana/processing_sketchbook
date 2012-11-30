/*
float triLineWidth = 200;
int startX = 150;
int stepAmt = 10;
int steps = 70;
*/
float triLineWidth = 125;
int startX = 75;
int stepAmt = 5;
int steps = 90;
float revolutions = 1.346;
float rotateStep = (TWO_PI * revolutions) / (float)steps;

color[] spectrum;

boolean firstRun;

void setup() { 
  size(640, 200, P2D); 
  colorMode(RGB, 1);
  
  spectrum = new color[7];
  
  spectrum[0] = #FF0000;
  spectrum[1] = #FFFF00;
  spectrum[2] = #00FF00;
  spectrum[3] = #00FFFF;
  spectrum[4] = #0000FF;
  spectrum[5] = #FF00FF;
  spectrum[6] = #FF0000;
  
  background(0);
  
  strokeWeight(1);
  stroke(0.2,0.5,0.56);
  for(int i = 0; i < steps; i++) {
    pushMatrix();
    
    stroke(lineColor(i, steps));
    
    scale(1.0,-1.0);
    
    translate(0.0,-(height - (height / 2.0)));
    
    float curAngle = -rotateStep * i;
    
    translate(startX + (stepAmt * i), 0);
    
    rotate(curAngle);
    
    float right = triLineWidth / 2.0;
    float left = -triLineWidth / 2.0;
    float top = (triLineWidth * sin(PI / 3.0f)) / 1.4;
    float bottom = (-triLineWidth * sin(PI / 3.0f)) / 2.6;
    
    line(left, bottom, right, bottom);
    line(left, bottom, 0, top);
    line(right, bottom, 0, top);
    
    popMatrix();
  }
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

