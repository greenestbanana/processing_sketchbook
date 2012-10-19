 
float xmag, ymag = 0;
float newXmag, newYmag = 0; 
float phi = (1.0f + sqrt(5.0f)) / 2.0f;

void setup() 
{ 
  size(1024, 768, P3D); 
  noStroke(); 
  colorMode(RGB, 1);
 
 println(acos(1.0/3.0)); 
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
  
  noStroke();
  
  fill(1,0,0);
  sphere(0.1);
  
  beginShape(TRIANGLE_FAN);
  fill(1,1,1);
  vertex(((1.0 / phi) + (-1.0 / phi) + 1 + -1) / 5.0,
         (phi + phi + 1 + 1 + (1.0 / phi)) / 5.0,
         (1 + 1 + phi) / 5.0);
  fill(0,1,0);
  vertex(0, 1.0 / phi, phi);
  fill(1,1,0);
  vertex(1, 1, 1);
  fill(0,0,1);
  vertex(1.0 / phi, phi, 0);
  vertex(-1.0 / phi, phi, 0);
  fill(1,1,0);
  vertex(-1, 1, 1);
  fill(0,1,0);
  vertex(0, 1.0 / phi, phi);
  endShape();
  
  stroke(1);
  
  //rotate(HALF_PI, 0, 0, 1);
  pushMatrix();
  //rotate(PI / 3, 0, 1.0, 0);
  rotate(acos(1.0/3.0), 0, 1.0, 0);
  drawPoly(3, 1);
  popMatrix();
  pushMatrix();
  rotate(TWO_PI / 3.0, 0, 0, 1);
  //rotate(PI / 3, 0, 1.0, 0);
  rotate(acos(1.0/3.0), 0, 1.0, 0);
  drawPoly(3, 1);
  popMatrix();
  pushMatrix();
  rotate((TWO_PI / 3.0) * 2.0, 0, 0, 1);
  //rotate(PI / 3, 0, 1.0, 0);
  rotate(acos(1.0/3.0), 0, 1.0, 0);
  drawPoly(3, 1);
  popMatrix();
  
  popMatrix(); 
}

void drawPoly(int sides, float circumradius) {
  if(sides < 3) {
    println("Woah that's not a polygon!");
    return; 
  }
  
  float step = TWO_PI / sides;
  
  beginShape(TRIANGLE_FAN);
  //vertex(0,0,0);
  for(int i = 0; i < sides; i++) 
  {
    float angle = i * step;
    vertex((cos(angle) * circumradius) - circumradius, sin(angle) * circumradius, 0);
  }
  //vertex(cos(0) * circumradius, sin(0) * circumradius, 0);
  endShape(); 
}


