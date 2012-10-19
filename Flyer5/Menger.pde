


// Menger's Sponge
// http://www.angelfire.com/art2/stw/


// VARS  ==================================================
PVector P1; 
// PeasyCam cam; 
// float angleMenger=0.3; 
boolean bPaint=true; 
boolean bFill=true; 
int depthMAX=2; 

// End Vars ================================================


void DrawMenger (PVector P1, float size1, int depth1) {

  // Recursive function. 
  // calls itself until depthMax is reached, then paints 
  // boxes.

  float size13 = size1/3;

  for (int x = 0; x < 3; x = x+1) {
    for (int y = 0; y < 3; y = y+1) {
      for (int z = 0; z < 3; z = z+1) {

        if (depth1 == depthMAX) {
          if (bFill) { 
            noStroke();
            //fill(2,2,230);
            //fill ((y+2)*50,(z+2)*50,(x+2)*50);
            // fill (Z*3, (y+2)*50, (x+1)*8);
            // fill ((Z*3) % 255, 23, 8);
            fill (22, (P1.x+x*size13) % 200, 28);
            // fill ( int (random (10,255)), int (random (10,255)), int (random (10,255))  );
          }
          else 
          {
            // no filling
            stroke(200,200,200);
            noFill();
          }
          pushMatrix();
          translate(P1.x+x*size13,P1.y+y*size13,P1.z+z*size13); 
          if ((x==1)&&(y==1)) {
            noFill();
          } 
          else if ((z==1)&&(x==1)) {
            noFill();
          } 
          else if ((z==1)&&(y==1)) {
            noFill();
          }  
          switch (boxType) {    
          case 0: 
            // normal: Best  
            //noStroke(); 
            box(size13);
            break; 
          case 1:
            // spheres 
            //noStroke(); 
            sphereDetail(4); 
            sphere (size13/2); 
            break; 
          case 2: 
            MyCube ( size13 ) ; 
            break; 
          default: 
            // else 
            boxType = 0;
            //noStroke(); 
            box(size13);
            break;
          } // switch 
          popMatrix();
        }          
        else {
          bPaint=true; //true;   
          if ((x==1)&&(y==1)) {
            bPaint=false;
          } 
          else if ((z==1)&&(x==1)) {
            bPaint=false;
          } 
          else if ((z==1)&&(y==1)) {
            bPaint=false;
          }     
          /* if ((x==1)&&(y==1)&&(z==1)) {
           bPaint=true;//false
           }     */
          if (bPaint) {
            PVector P_New1 = new PVector(P1.x+x*size13,P1.y+y*size13,P1.z+z*size13);
            DrawMenger ( P_New1,size13,depth1+1 );
          }
        }
      }
    }
  }
} // func

void MyCube (float size13) {

  // colorMode(RGB, 1); 
  // float diff = xmag-newXmag;
  /* if (abs(diff) >  0.01) { 
   xmag -= diff/4.0;
   }*/
  /*  diff = ymag-newYmag;
   if (abs(diff) >  0.01) { 
   ymag -= diff/4.0;
   }
   rotateX(-ymag); 
   rotateY(-xmag); 
   */

  float factor=.33; 

  if (bFill) {
    noStroke();
  } 
  else 
  {
    stroke(250);
  }

  scale(size13);

  beginShape(QUADS);

  if (bFill) {
    fill ( 255,0,0 );
  }
  //fill(0, 1, 1); 
  vertex(-1*factor,  1*factor,  1*factor);
  // fill(1, 1, 1); 
  vertex( 1*factor,  1*factor,  1*factor);
  // fill(1, 0, 1); 
  vertex( 1*factor, -1*factor,  1*factor);
  // fill(0, 0, 1); 
  vertex(-1*factor, -1*factor,  1*factor);

  if (bFill) {
    fill ( 0,255,0 );
  }
  // fill(1, 1, 1); 
  vertex( 1*factor,  1*factor,  1*factor);
  // fill(1, 1, 0); 
  vertex( 1*factor,  1*factor, -1*factor);
  // fill(1, 0, 0); 
  vertex( 1*factor, -1*factor, -1*factor);
  // fill(1, 0, 1); 
  vertex( 1*factor, -1*factor,  1*factor);

  if (bFill) {
    fill ( 0,0,255 );
  }
  // fill(1, 1, 0); 
  vertex( 1*factor,  1*factor, -1*factor);
  // fill(0, 1, 0); 
  vertex(-1*factor,  1*factor, -1*factor);
  // fill(0, 0, 0); 
  vertex(-1*factor, -1*factor, -1*factor);
  // fill(1, 0, 0); 
  vertex( 1*factor, -1*factor, -1*factor);

  if (bFill) {
    fill ( 100,0,255 );
  }
  // fill(0, 1, 0); 
  vertex(-1*factor,  1*factor, -1*factor);
  // fill(0, 1, 1); 
  vertex(-1*factor,  1*factor,  1*factor);
  // fill(0, 0, 1); 
  vertex(-1*factor, -1*factor,  1*factor);
  // fill(0, 0, 0); 
  vertex(-1*factor, -1*factor, -1*factor);

  if (bFill) {
    fill ( 100,100,255 );
  }
  // fill(0, 1, 0); 
  vertex(-1*factor,  1*factor, -1*factor);
  // fill(1, 1, 0); 
  vertex( 1*factor,  1*factor, -1*factor);
  // fill(1, 1, 1); 
  vertex( 1*factor,  1*factor,  1*factor);
  // fill(0, 1, 1); 
  vertex(-1*factor,  1*factor,  1*factor);

  if (bFill) {
    fill ( 100,255,255 );
  }
  // fill(0, 0, 0); 
  vertex(-1*factor, -1*factor, -1*factor);
  // fill(1, 0, 0); 
  vertex( 1*factor, -1*factor, -1*factor);
  // fill(1, 0, 1); 
  vertex( 1*factor, -1*factor,  1*factor);
  // fill(0, 0, 1); 
  vertex(-1*factor, -1*factor,  1*factor);

  endShape();

  // popMatrix();
}

