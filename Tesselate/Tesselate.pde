
boolean firstRun;
float curAngle;
int[] vertexConfig;

void setup() {
  size(640, 480, P2D);
  colorMode(RGB, 1);
  stroke(1);
  noFill();
  
  firstRun = true;
  
  vertexConfig = new int[1];
  vertexConfig[0] = 4;
  //vertexConfig[1] = 4;
  //vertexConfig[2] = 4;
  //vertexConfig[3] = 4;
}

void draw() {
  background(0.0);
  
  pushMatrix();
  
  translate(width / 2, height / 2);
  
  pushMatrix();
  
  stroke(0.6);
  line(0, height, 0, -height);
  line(width, 0, -width, 0);

  popMatrix();
  
  stroke(1.0);
  //drawShape(new PVector(0,0), (++curAngle) / 1000.0, 3, 100);
  //drawVertexConfig(new PVector(0,0), (++curAngle) / 1000.0, vertexConfig, 100.0);
  drawVertexConfig(new PVector(0,0), 0.0, vertexConfig, 100.0);
  
  popMatrix();
  
  firstRun = false;
}

void drawVertexConfig(PVector center, float orientation, int[] polygons, float sideLength) {
  pushMatrix();
  float curOrientation = orientation;
  
  for(int i = 0; i < polygons.length; i++) {
    int curShape = polygons[i];
    drawShape(center, curOrientation, curShape, sideLength);
    curOrientation += getInternalAngle(curShape);
  }
  
  popMatrix();
}

void drawShape(PVector startVert, float orientation, int sides, float sideLength) {
  PVector curVert = startVert;
  float internalAngle = getInternalAngle(sides);
  float curAngle = internalAngle + orientation;
  int vertCount = 0;
  
  while(vertCount <= sides)
  {
    if(firstRun) {
      println("Int Angle: " + (internalAngle / PI));
      println("Angle: " + (curAngle / PI));
      println(curVert.x + ", " + curVert.y);
    }
    
    PVector prevVert = curVert;
    curAngle = curAngle + PI + internalAngle;
    curVert = new PVector(curVert.x + sideLength * cos(curAngle), 
                          curVert.y + sideLength * sin(curAngle));
    line(prevVert.x, prevVert.y, curVert.x, curVert.y);
    vertCount++;
  }
}

float getInternalAngle(int sides)
{
  return (((float)(sides - 2)) * PI) / ((float) sides); 
}
