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

public class pendulum extends PApplet {

PFont font;

PVector pivot;
PVector bob;
PVector rod;

static float ratio = 100.0f;
float angle;
float angularVelocity = 0;
float angularAccel = 0;
float angularDamper = 0.01f;
static float g = 9.8f;

static int framer = 60;
float dt;

public void setup()
{
  size(356, 356);
  smooth();
  
  frameRate(framer);
  
  pivot = new PVector(356/2, (356/2) - 100);
  bob = new PVector(356/2, (356/2) + 100);
  angle = 0;
  
  font = loadFont("CourierNewPSMT-18.vlw");
  textFont(font, 18);
}

public void draw()
{
  background(0xaeaeae);
  
  ellipseMode(CENTER);
  ellipse(pivot.x, pivot.y, 2, 2);
  ellipse(bob.x, bob.y, 50, 50);
  line(pivot.x, pivot.y, bob.x, bob.y);
  if(mousePressed)
  {
    angle = PVector.angleBetween(rod, new PVector(0, -1)) * (pivot.x >= bob.x ? -1 : 1);
    angularVelocity = 0;
    bob.x = mouseX;
    bob.y = mouseY;
  }
  
  rod = new PVector(pivot.x - bob.x, pivot.y - bob.y);
  float rodLen = rod.mag() / ratio; 
  
  angularAccel = (-(g / rodLen) * sin(angle));
  
  dt = 1 / frameRate;
  
  text(round(rod.mag()) + " - " + round(degrees(angle)) , 10, 30);
  text(round(pivot.x - bob.x) + " - " + round(pivot.y - bob.y), 10, 50);
  text(round(angularAccel * 100) + " - " + round(angularVelocity * 100), 10, 70);
  
  if(!mousePressed)
  {
    angularVelocity += (angularAccel * dt);
    angle = angle + (angularVelocity * dt) + ((abs(angularDamper * dt) <= abs(angularAccel * dt) ? (angularDamper * dt) : (angularAccel * dt)) * (angularAccel < 0 ? -1 : 1));
    //bob.x = (sin(angle) * rod.mag() * (pivot.x >= bob.x ? -1 : 1)) + pivot.x;
    bob.x = (sin(angle) * rod.mag()) + pivot.x;
    bob.y = (cos(angle) * rod.mag()) + pivot.y;
  }
  /*
  else
  {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
  */
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "pendulum" });
  }
}
