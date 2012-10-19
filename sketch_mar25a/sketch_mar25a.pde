
ArrayList fracPoints;

void setup()
{
  size(356, 356);
  smooth();
  
  fracPoints = new ArrayList();
  fracPoints.add(new Point2f(0.0f, 0.0f));
  fracPoints.add(new Point2f(0.5f, 0.0f));
  fracPoints.add(new Point2f(0.5f, 0.5f));
  fracPoints.add(new Point2f(1.0f, 0.5f));
}

void draw()
{
  background(0xaeaeae);
  
  line(pivot.x, pivot.y, bob.x, bob.y);
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
