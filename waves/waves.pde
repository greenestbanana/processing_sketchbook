
PVector midPoint;
float maxLen;
float changer;

void setup() { 
  size(400, 400, P2D); 
  noStroke(); 
  colorMode(RGB, 1);
  
  changer = 0;

  midPoint = new PVector(width / 2, height / 2);
  maxLen = midPoint.dist(new PVector(0,0));
} 

void draw() {
  //midPoint = new PVector(width / 2, height / 2);
  PVector curPoint = new PVector();
  
  loadPixels();
  for(int i = 0; i < width; i++) {
    for(int j = 0; j < height; j++) {
      curPoint.x = i;
      curPoint.y = j;
      float len = midPoint.dist(curPoint);
      float colorVal = ((sin((len + (changer / 4.0)) / 25) + 1.0) + (sin((len + changer) / 2) + 1.0) + (sin((len - (changer * 2)) / 5) + 1.0)) / 6.0;
      pixels[i + (width * j)] = color(colorVal);
    }
  }
  updatePixels();
  
  changer += 0.5;
  
    if(frameCount % 60 == 0) {
     println("FPS: " + frameRate);
  }
}
