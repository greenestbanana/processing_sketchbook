
int flowerCount = 7;
int pedalCount = 5;

void setup() { 
  size(640, 640, P2D); 
  colorMode(RGB, 1);
  
  background(1.0,0.97,0.95); 
  drawFlower();
}

void draw() {
  //background(1.0,0.97,0.95); 
}

void drawFlower() {
  stroke(0.4, 0.7, 0.6);
  
  translate(width / 2, height / 2);
  
  strokeWeight(2);
  
  fill(1.0,0.97,0.95);
  
  float maxHeight = (height/2);
  float maxWidth = (width/4);
  
  for(int i = 0; i < flowerCount; i++) {
    float rhomLength = maxHeight * (flowerCount - i);
    float rhomWidth = maxWidth * (flowerCount - i);
    float jitterOffset = ((TWO_PI / (2 * (rhomLength / rhomWidth))) / (pedalCount * 2));
    
    rotate(TWO_PI * random(1));
    
    for(int j = 0; j < pedalCount; j++) {
      pushMatrix();
      float jitter = random(-1, 1) * jitterOffset;
      
      rotate((TWO_PI / pedalCount) * j);
      rotate(jitter);
      drawRhom(rhomLength, rhomWidth);
      popMatrix();    
    }
  }
}

void drawRhom(float rhomLength, float rhomWidth) {
  beginShape();
  vertex(0,0);
  vertex(rhomWidth * 0.5, rhomLength * 0.5);
  vertex(0.0, rhomLength);
  vertex(-rhomWidth * 0.5, rhomLength * 0.5);
  endShape(CLOSE);  
}
