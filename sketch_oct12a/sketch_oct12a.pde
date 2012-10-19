Point2f pivot;
Point2f bob;

void setup()
{
  size(356, 356);
  smooth();
  
  pivot = new Point2f(356/2, (356/2) - 100);
  bob = new Point2f(356/2, (356/2) + 100);
}

void draw()
{
  background(0xaeaeae);
  
  ellipseMode(CENTER);
  ellipse(pivot.x, pivot.y, 2, 2);
  ellipse(bob.x, bob.y, 50, 50);
  line(pivot.x, pivot.y, bob.x, bob.y);
  if(mousePressed)
  {
    bob.x = mouseX;
    bob.y = mouseY;
  }
  
  /*
  else
  {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
  */
}

class Point2f
{
  float x;
  float y;
  
  Point2f (float X, float Y)
  {
    x = X;
    y = Y;
  }
}

