 
float xmag, ymag = 0;
float newXmag, newYmag = 0; 
float phi = (1.0f + sqrt(5.0f)) / 2.0f;

void setup() 
{ 
  size(1024, 768, P3D); 
  noStroke(); 
  colorMode(RGB, 1); 
} 

void draw() 
{ 
  background(0.0);
  
  pushMatrix(); 
 
  translate(width/2, height/2, -30); 
  
  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;
  
  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { xmag -= diff/4.0; }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { ymag -= diff/4.0; }
  
  rotateX(-ymag); 
  rotateY(-xmag); 
  
  scale(200);
  beginShape(POINTS);
  
  stroke(1);
  
  stroke(1.0,1.0,0.0);
  vertex(1, 1, 1);
  vertex(1, 1, -1);
  vertex(1, -1, -1);
  vertex(-1, 1, -1);
  vertex(1, -1, 1);
  vertex(-1, 1, 1);
  vertex(-1, -1, 1);
  vertex(-1, -1, -1);
  
  stroke(0.0,1.0,0.0);
  vertex(0, 1.0 / phi, phi);
  vertex(0, -1.0 / phi, phi);
  vertex(0, 1.0 / phi, -phi);
  vertex(0, -1.0 / phi, -phi);
  
  stroke(0.0,0.0,1.0);
  vertex(1.0 / phi, phi, 0);
  vertex(-1.0 / phi, phi, 0);
  vertex(1.0 / phi, -phi, 0);
  vertex(-1.0 / phi, -phi, 0);
  
  stroke(1.0,0.0,0.0);
  vertex(phi, 0, 1.0 / phi);
  vertex(-phi, 0, 1.0 / phi);
  vertex(phi, 0, -1.0 / phi);
  vertex(-phi, 0, -1.0 / phi);
  
  endShape();
  
  popMatrix(); 
}



