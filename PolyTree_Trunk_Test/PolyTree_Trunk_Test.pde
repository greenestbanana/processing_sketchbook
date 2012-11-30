float topRadius;
float bottomRadius;
float middleRadius;

float middlePercent = 0.5;

int segments = 10;

float buffer = 10.0;

void setup() {
  size(640, 480, P2D);
  colorMode(RGB, 1);
}

void draw() {
  background(0.75);
  middlePercent = mouseY / (float)height;
  println(middlePercent);
  
  float centerPoint = width / 2.0f;
  
  //topRadius = centerPoint - (centerPoint  - 64.0f);
  //bottomRadius = centerPoint - (centerPoint  - 256.0f);
  topRadius = centerPoint - (centerPoint  - (mouseX / 3.0));
  bottomRadius = centerPoint - (centerPoint  - (mouseX / 2.0));
  middleRadius = centerPoint;
  
  PVector prevPoint = null;
  
  for(int i = 0; i < segments; i++) {
    float yPercent = i / (float)(segments - 1); 
    float p;
    float midPoint;
    float maxRadius;
    if(yPercent < middlePercent) {
      maxRadius = topRadius;
      p = yPercent;
      midPoint = middlePercent;
    } else {
      maxRadius = bottomRadius;
      p = 1.0 - yPercent;
      midPoint = 1.0 - middlePercent;
    }
    
    float curWidth = ((maxRadius - middleRadius) * pow(1 - (p/midPoint), 2)) + middleRadius;
    PVector curPoint = new PVector(curWidth, ((height - (buffer * 2.0)) * yPercent) + buffer);
      
    if(prevPoint != null) {
      line(prevPoint.x, prevPoint.y, curPoint.x, curPoint.y);
    }
    prevPoint = curPoint;
  }
}
