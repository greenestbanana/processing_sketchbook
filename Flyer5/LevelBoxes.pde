
// by toxi 
// see his TileSaver Test

void Boxes1 (int zValue) { 

  int distance1=1300; 
  // hier werden die Würfel gemalt 
  for(int y=0; y<6; y++) {
    for(int x=0; x<6; x++) {
      pushMatrix();
      translate((x-3)*distance1,(y-3)*distance1,zValue);
      fill(y*64,x*16,(6-x)*64+zValue);
      box(200);
      popMatrix();
    }
  }
} // func 

