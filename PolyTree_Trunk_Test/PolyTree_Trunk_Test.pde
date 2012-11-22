float topRadius;
float bottomRadius;
float middleRadius;

float middlePercent = 0.5;

int segments = 10;

float buffer = 10.0;

void setup() {
  size(640, 480, P2D);
}

void draw() {
  
  float centerPoint = width / 2.0f;
  
  topRadius = centerPoint - (centerPoint  - 64.0f);
  bottomRadius = centerPoint - (centerPoint  - 256.0f);
  middleRadius = centerPoint;
  
  PVector prevPoint = null;
  
  for(int i = 0; i < segments; i++) {
    float p = i / (float)(segments - 1);
    float maxRadius;
    if(p < middlePercent) {
      maxRadius = topRadius;
    } else {
      maxRadius = bottomRadius;
    }
    float curWidth = ((maxRadius - middleRadius) * pow(1 - (p/middlePercent), 2)) + middleRadius;
    PVector curPoint = new PVector(curWidth, ((height - (buffer * 2.0)) * p) + buffer);
      
    if(prevPoint != null) {
      line(prevPoint.x, prevPoint.y, curPoint.x, curPoint.y);
    }
    prevPoint = curPoint;
  }
}
