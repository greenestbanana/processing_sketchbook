

// check keyboard input 

void keyPressed() {
  // key Coded ? 
  if (key == CODED) {
    keyReadSpecialKey ();
  }
  else 
  {
    keyReadNormalKey ();
  }
}

void keyReadNormalKey () {    

  float Radius = 13; 

  // ----------------------------    
  // forward & backward
  if (key == 'w' || key == 'W') {
    // forward : running towards lookat 
    xpos =   Radius*sin(radians(angle)) + xpos;
    zpos =   Radius*cos(radians(angle)) + zpos;
  }
  else if (key == 's' || key == 'S') {
    // backward
    xpos =  xpos- (Radius*sin(radians(angle))) ;
    zpos =  zpos- (Radius*cos(radians(angle))) ;
  }
  // ----------------------------    
  // left & right 
  else if (key == 'a' || key == 'A') {
    // left
    xpos =   xpos- Radius*sin(radians(angle-90)) ;
    zpos =   zpos- Radius*cos(radians(angle-90)) ;
  }
  else if (key == 'D' || key == 'd') {
    // right 
    xpos =   Radius*sin(radians(angle-90)) + xpos;
    zpos =   Radius*cos(radians(angle-90)) + zpos;
  } 
  // ----------------------------    
  // fly up & down 
  else if (key == 'r' || key == 'R') {
    ypos-=4;  // fly up
  }
  else if (key == 'f' || key == 'F') {
    ypos+=4;  // down 
    /*
    if (ypos > floorLevel-120) {  // check Floor
     ypos = floorLevel-120;
     } */
  }     
  // ----------------------------    
  // fly up & down FAST 
  if (key == 't' || key == 'T') {
    // fly high 
    ypos-=400;
  }    
  if (key == 'g' || key == 'G') {
    // go deeper 
    ypos+=400; 
    /*
     if (ypos > floorLevel-120) { // check Floor
     ypos = floorLevel-120;
     }
     */
  }        
  // ----------------------------        
  else if (key == 'i' || key == 'I') {
    // Saves a TIFF file 
    save("Flyerpic.tif");
  }
  // ------------------------------------------------
  // camera stuff: Auto Movement of Camera 
  else if (key == '0') { 
    // cam Mouse
    CheckCamera_Art = CheckCamera_Art_Mouse;
  }    
  else if (key == '1') { 
    // cam circle --- height stays constant 
    Hoehe = ylookat;
    CheckCamera_Art = CheckCamera_Art_CircleSameHeight;
  }        
  else if (key == '2') { 
    // camera: heigth changes up & down (aka spirale)
    Hoehe = ylookat;    
    HoeheAdd = -4; 
    CheckCamera_Art = CheckCamera_Art_CircleSpirale;
  }        
  else if (key == '3') { 
    // Path init: Camera on Path 
    GehtAufEinemPfad = true; 
    PfadWert = 0.0; 
    CheckCamera_Art = CheckCamera_Art_CirclePath;
  }        
  // stuff for using Menger sponge ----------------
  else if (key == '.') { 
    isMenger=!isMenger;
  }
  else if (key == ' ') { 
    bFill=!bFill;
  }
  else if (key == '+') {   
    depthMAX++;
    println(depthMAX);
  }
  else if (key == '-') { 
    depthMAX--;
    if (depthMAX<=1) {
      depthMAX=1;
    }
    println(depthMAX);
  }
  else if (key == '#') { 
    boxType++;
  }
  else 
  {
  // do nothing 
  }
  // if you like, check Boundaries  
  // checkBoundaries ();
}

void keyReadSpecialKey () {
}

