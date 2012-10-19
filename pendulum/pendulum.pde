PFont font;

PVector pivot;
PVector bob;
PVector rod;

static float ratio = 100.0;
float angle;
float angularVelocity = 0;
float angularAccel = 0;
float MAX_ANGULAR_DAMPER = 0.2f;
static float g = 0.8;

static int framer = 60;
float dt;

PScrollbar frictionBar;

void setup()
{
  size(356, 356);
  smooth();
  
  frameRate(framer);
  
  pivot = new PVector(356/2, (356/2) - 100);
  bob = new PVector(356/2, (356/2) + 100);
  angle = 0;
  
  frictionBar = new PScrollbar(0, height - 20, width, 10);
  
  font = loadFont("CourierNewPSMT-18.vlw");
  textFont(font, 18);
}

void draw()
{
  background(0xaeaeae);
  
  frictionBar.update();
  frictionBar.display();
  
  float angularDamper = MAX_ANGULAR_DAMPER * (frictionBar.getPos() / frictionBar.sWidth);
  
  fill(255,255,255);
  
  ellipseMode(CENTER);
  ellipse(pivot.x, pivot.y, 2, 2);
  ellipse(bob.x, bob.y, 50, 50);
  line(pivot.x, pivot.y, bob.x, bob.y);
  if(mousePressed && !frictionBar.isLocked())
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
  text(MAX_ANGULAR_DAMPER * (frictionBar.getPos() / frictionBar.sWidth), 10, 50);
  //text(round(angularAccel * 100) + " - " + round(angularVelocity * 100), 10, 70);
  
  if(!mousePressed || frictionBar.isLocked())
  {
    float sign = (angularAccel < 0.0f ? -1.0f : 1.0f);
    angularVelocity += (angularAccel * dt) + min(angularAccel * dt * sign, angularDamper * dt * sign);
    
    float finalVelocity = (abs(angularDamper * dt) <= abs(angularVelocity * dt) ? 
                           (angularDamper * dt) : 
                           (angularVelocity * dt));
    //float sign = (angularAccel < 0.0f ? -1.0f : 1.0f);
    //angularVelocity += angularDamper * sign;
    //float sign = (angularAccel < 0.0f ? -1.0f : 1.0f);
    
    //angle = angle + (angularVelocity * dt) + (finalVelocity * sign);
    angle = angle + (angularVelocity * dt);
    text(round(angularAccel * 100) + " - " + round(angularVelocity * 100), 10, 70);
    text(round(angle * 100) + " - " + round(((angularAccel * dt) + min(angularAccel * dt * sign, angularDamper * dt * sign)) * 1000) + " - " + 
    round((angularAccel * dt) * 1000), 10, 90);
    //bob.x = (sin(angle) * rod.mag() * (pivot.x >= bob.x ? -1 : 1)) + pivot.x;
    bob.x = (sin(angle) * rod.mag()) + pivot.x;
    bob.y = (cos(angle) * rod.mag()) + pivot.y;
  }
}

class PScrollbar
{
  public int sWidth, sHeight;
  public int x, y;
  public float sliderPos;
  public int sliderMin, sliderMax;
  public boolean over;
  public boolean locked;
//  float aspectRatio;
  
  public boolean isOver()
  {
    return over;
  }
  
  public boolean isLocked()
  {
    return locked;
  }
  
  PScrollbar(int X, int Y, int SWidth, int SHeight)
  {
    this.x = X;
    this.y = Y - (SHeight / 2);
    this.sWidth = SWidth;
    this.sHeight = SHeight;
    this.sliderPos = (x + (sWidth / 2)) - (sHeight / 2);
    this.sliderMin = x;
    this.sliderMax = x + sWidth - sHeight; 
  }
  
  void update()
  {
    if(over())
    {
      over = true;
    }
    else
    {
      over = false;
    }
    
    if(mousePressed && over)
    {
      locked = true;
    }
    
    if(!mousePressed)
    {
      locked = false;
    }
    
    if(locked)
    {
      sliderPos = clamp(mouseX - sHeight / 2, sliderMin, sliderMax);
    }
  }
  
  int clamp(int val, int minval, int maxval)
  {
    return min(max(val, minval), maxval);
  }
  
  boolean over()
  {
    if(mouseX > x && mouseX < x + sWidth &&
       mouseY > y && mouseY < y + sHeight)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void display()
  {
    fill(255);
    rect(x, y, sWidth, sHeight);
    if(over || locked)
    {
      fill(153, 102, 0);
    }
    else
    {
      fill(102, 102, 102);
    }
    
    rect (sliderPos, y, sHeight, sHeight);
  }
  
  float getPos()
  {
    return sliderPos * ((float) sWidth / (float) (sWidth - sHeight));
  }
}

