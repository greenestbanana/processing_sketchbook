

// the level stuff - most of it not in use

void plane () {
  // plane aka floor 
  pushMatrix();
  translate(0, floorLevel, 0); 
  fill(222);
  box(1100, 2, 1100);
  popMatrix();
}

void walls () {

  // 4 walls around my level 

  final float height1 = 900; 
  final float wallLong = 7998; 

  stroke(0);

  pushMatrix();
  fill (223,222,223); 
  translate(-4000, floorLevel-(height1/2), 0);
  box(10, height1, wallLong);
  popMatrix(); 

  pushMatrix();
  fill (223,222,223); 
  translate(4000, floorLevel-(height1/2), 0);
  box(10, height1, wallLong);
  popMatrix();   

  // -----------------------------------------------

  pushMatrix();
  fill (223,222,223); 
  translate(0, floorLevel-(height1/2), -4000);
  box(wallLong, height1, 0);
  popMatrix();   

  pushMatrix();
  fill (223,222,223); 
  translate(0, floorLevel-(height1/2), 4000);
  box(wallLong, height1, 0);
  popMatrix();
}

void buildingsOnlyAFew() {

  // the stuff standing around - only a few 

    // mark 0,0,0
  pushMatrix();
  // height1 = 20; 
  fill (10,0,330); 
  translate(0, 0, 0);
  box(10, 22, 10);
  popMatrix();

  // mark middle of floor / plane
  pushMatrix();
  // height1 = 20; 
  fill (10,0,330); 
  translate(0, floorLevel-(22), 0);
  box(10, 64, 10);
  popMatrix();
} 

void buildings() {

  // the stuff standing around  -------------------

  float height1 ; 

  pushMatrix();
  height1 = 155;
  fill (12,12,123);   
  translate(400, floorLevel-(height1/2), -400);
  box(50, height1, 30);
  popMatrix();

  pushMatrix();
  height1 = 200; 
  fill (123,12,123); 
  translate(40, floorLevel-(height1/2), -200);
  box(150, height1, 130);
  popMatrix();  

  pushMatrix();
  height1 = 300; 
  fill (123,12,123); 
  translate(40, floorLevel-(height1/2), -200);
  box(90, height1, 100);
  popMatrix(); 

  pushMatrix();
  height1 = 300; 
  fill (333,32,0); 
  translate(240, floorLevel-(height1/2), 2200);
  box(90, height1, 100);
  popMatrix();   

  pushMatrix();
  height1 = 300; 
  fill (22); 
  translate(-2240, floorLevel-(height1/2), 2200);
  box(90, height1, 100);
  popMatrix();     

  pushMatrix();
  height1 = 600; 
  fill (32); 
  translate(-2240, floorLevel-(height1/2), -2200);
  box(190, height1, 200);
  popMatrix();       

  pushMatrix();
  height1 = 200; 
  fill (43); 
  translate(2240, floorLevel-(height1/2), 2200);
  box(390, height1, 20);
  popMatrix();       

  pushMatrix();
  height1 = 200; 
  fill (0,220,330); 
  translate(2240, floorLevel-(height1/2), -2200);
  box(390, height1, 420);
  popMatrix();

  pushMatrix();
  height1 = 20; 
  fill (10,0,330); 
  translate(0, floorLevel-(height1/2), 0);
  box(10, height1, 10);
  popMatrix();

  // other buildings 
  pawn ( 3,4, colWhite )  ; 
  queen ( 8,8, colBlack )  ;
  king ( 1,1, colBlack )  ; 
  rook ( 7,3, colBlack )  ; 

  knight ( 2,3, colBlack )  ;   
  bishop ( 2,2, colBlack )  ; 
  // knight ( 1,7, colBlack )  ;
}

// ==============================================================
// figures for buildings 

void queen (int i,int j,int col3) {
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));  
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  translate ( MyPVector.x, MyPVector.y, MyPVector.z );
  scale (10); 
  box (20);
  translate ( 0,-17,0 );
  // sphereDetail(11, 11);
  noStroke(); 
  fill(OtherFigureColorQueen(col3));    
  sphere(8); 
  popMatrix();
}

void king (int i,int j,int col3) {
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));  
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  translate ( MyPVector.x, MyPVector.y, MyPVector.z );
  scale (10); 
  box (20);
  translate ( 0,-15,0 );
  rotateY(radians(45));
  box (10);
  popMatrix();
}

void pawn (int i,int j,int col3) {
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));  
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  translate ( MyPVector.x, MyPVector.y, MyPVector.z );
  scale (10); 
  box (17);
  noStroke();
  popMatrix();
}

void rook (int i,int j,int col3) {
  // tower, marquess, rector, 
  // and comes, and 
  // non-players still 
  // often call it a "castle". 
  // (from Wikipedia)
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));  
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  translate ( MyPVector.x, MyPVector.y, MyPVector.z );
  scale (10); 
  box (25);
  popMatrix();
}

void bishop (int i,int j,int col3) {
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));  
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  translate ( MyPVector.x, MyPVector.y, MyPVector.z );
  scale (10); 
  rotateY(radians(45));
  box (5,25,25);
  rotateY(radians(90));
  box (5,25,25);  
  noStroke();
  popMatrix();
}

void knight (int i,int j,int col3) {
  int col1 = 103; 
  int col2 = 11;   
  fill(col3);
  stroke(OtherFigureColor(col3));
  pushMatrix();
  PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
  MyPVector =  GetValuePVector (i,j);
  // scale (10); 
  translate ( MyPVector.x-5, MyPVector.y+5, MyPVector.z-4 );
  ShowL (col3); 
  rotateY(radians(180));
  translate ( -100.1,-100.21,-100.1 );
  // translate ( -MyPVector.x-5, -MyPVector.y+5, -MyPVector.z-4 );  
  ShowL (col3); 
  popMatrix();
}

// ----------------------------------------------------------

void ShowL (int col3) {
  // help-sub for the knight
  int col1 = 103; 
  int col2 = 11;   
  int Size1 = 10; 
  fill(col3);
  stroke(OtherFigureColor(col3));
  pushMatrix();
  scale (10); 
  box (Size1);
  translate ( Size1,0.0,0.01 );
  box (Size1);  
  translate ( 0.01,0.0,Size1 );
  box (Size1);  
  noStroke();
  popMatrix();
}

int OtherFigureColor (int col3) {
  // This gives you a similar color 
  // for the figure's color. 
  // E.g. you have a white figure 
  // you here get another white-ish color
  // for the stroke lines of the figure.
  // For a black figure you get another 
  // shade of black or dark gray.

  int Buffer=0;

  if (col3==colWhite) 
  {
    Buffer=colWhite-60;
  } 
  else 
  {
    Buffer=50;
  };

  return(Buffer);
}

int OtherFigureColorQueen (int col3) {
  // QUEEN -----------------
  // This gives you a similar color 
  // for the figure's color. 
  // E.g. you have a white figure 
  // you here get another white-ish color
  // for the stroke lines of the figure.
  // For a black figure you get another 
  // shade of black or dark gray.

  int Buffer=0;

  if (col3==colWhite) 
  {
    Buffer=colWhite-17;
  } 
  else 
  {
    Buffer=70;
  };

  return(Buffer);
}

// ------------------------------------------------------------------------

PVector GetValuePVector ( int x1, int y1 ) {
  // here the calculation for the positions of 
  // figures is made. 
  if (false) {
    PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
    /* MyPVector.set ( moveRunningX_ScreenFrom,160,moveRunningY_ScreenFrom);*/
    return(MyPVector);
  } 
  else {
    PVector MyPVector = new PVector( 0.0, 0.0, 0.0 );
    MyPVector.set (  440*x1 + calculationForScreenPositionX,
    500 - calculationForScreenPositionY,
    440*(7-y1)  + calculationForScreenPositionZ );
    return(MyPVector);
  }
}

