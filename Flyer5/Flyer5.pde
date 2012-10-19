/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/28947*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */


// see http://forum.processing.org/topic/1st-person-perspective 
// but in 3D

// First person flies around in a scene.
// It won't work in the applet, i.e. online (uses Robot). 
// Change size when offline. 
// Move mouse down at beginning. 
// 1st Person Game / First Person Game.
// Runs best with OPENGL - P3D has to many issues. 

// credits: toxi, rbrauer.

// Makes use of Robot now, so you can endlessly 
// turn around yourself now. 

// use mouse to look around.  
// use WASD to move. You fly where you look at! But the height is constant.
// Use r/f to change your height 
// (or t/g for FAST height change).
// use 0 for cam steering via mouse (default)
// use 1,2,3 for cam auto movement (circle, spirale, path)
// use . for menger sponge on / off. 
// for menger sponge you have:
//         + and - toggle depth 
//         # change box type / sphere 
//         space-key toggle fill 

// imports
import processing.opengl.*;
import java.awt.Robot;  

//import peasy.org.apache.commons.math.*;
//import peasy.*;
//import peasy.org.apache.commons.math.geometry.*;

// ----------------------------------------------------------
// issues: collision detection missing; clipping; initially the mouse should be centered. 
//         to be done: LookUp-Table for sin / cos (search for initSinCos). 
// solved issues: Makes use of Robot now, so you can endlessly turn around yourself now. 
// ----------------------------------------------------------

// Menger sponge: yes / no
boolean isMenger = false; 

// Floor has y-value 
final float floorLevel = 500.0; 

// camera / where you are 
float xpos,ypos,zpos, xlookat,ylookat,zlookat; 
float angle=0.0; // (angle left / right; 0..359)

// Menger 
int boxType = 0;

// player is crouching yes / no 
// boolean isCrouching = false; 

// -------------------------------------------------------------
// virtual mouse 
// Code by rbrauer.
// It won't work in the applet, ie online. 
// Copy the source code and try it from the PDE.

Robot robot;  
float rmx, rmy;   // virtual mouse values 

// -------------------------------------------------------------
// Buildings

// Buildings: color for figures 
color colWhite = 253;
color colBlack = 72; 

// Buildings: values for position of figures on the screen 
int calculationForScreenPositionX = 0;  // 
int calculationForScreenPositionY = 46; // 
int calculationForScreenPositionZ = 0;  // 

// -------------------------------------------------------------

/**
 sincoslookup taken from http://wiki.processing.org/index.php/Sin/Cos_look-up_table
 @author toxi (http://www.processinghacks.com/user/toxi)
 */

// declare arrays and params for storing sin/cos values 
float sinLUT[];
float cosLUT[];
// set table precision to 0.5 degrees
float SC_PRECISION = 0.5f;
// caculate reciprocal for conversions
float SC_INV_PREC = 1/SC_PRECISION;
// compute required table length
int SC_PERIOD = (int) (360f * SC_INV_PREC);

// -------------------------------------------------------------

void setup () {

  // size (800,800,OPENGL);
  // size( screen.width, screen.height, OPENGL );   // BEST 
  size( screen.width, screen.height, P3D );  

  background(0);

  //noStroke();

  //Following lines create the java "Robot" used to control mouse pos.
  //It has to be in a try / catch block because its possible for it  
  //to throw an exception:  
  try { 
    robot = new Robot();
  }  
  catch(Throwable e) {
    println("Robot class not supported by your system!");    
    exit();
  }  

  /*
  // Might need to confine to sketch's window...  
   int xx = width / 2; // (1 + 2) % width;  
   int yy = 3100; //  height / 2; //(1 + 2) % height;
   robot.mouseMove(xx, yy);  
   */

  stroke(13);
  fill(102);
  noCursor();

  xpos = width/2.0; 
  ypos = 0; 
  zpos = 0 ;  

  P1 = new PVector(-110, -110, -50);

  /* xlookat = xpos ; 
   ylookat = -120 ; 
   zlookat = zpos - 300;*/

  // important call to initialize lookup tables
  // initSinCos(); // not in use

  CheckVirtualMouse ();
  CheckCameraMouse ();
} // setup

void draw () {

  fill(101);
  background(0);

  plane();  // Floor 
  // walls () ; 
  buildingsOnlyAFew(); 
  // buildings() ;

  if (isMenger) {
    stroke (255); 
    DrawMenger ( P1,400,1 );
  }

  stroke (0); 
  Boxes1 (-2820) ; // by toxi 
  Boxes1 (2820) ;

  Winkel=Winkel+.5;
  if (GehtAufEinemPfad) { 
    PfadWert=PfadWert+1;
  }

  // very important that this is last in draw()
  CheckVirtualMouse (); 
  CheckCamera(); 
  // CheckCameraMouse ();
}

// ===========================================================================================

void CheckVirtualMouse () {

  // Code by rbrauer.
  // it won't work in the applet, ie online. 
  // Copy the source code and try it from the PDE.

  //line moves mouse pos to center of canvas  
  //frame.getX() is the horizontal pos of the window top left (or so)  
  //this.getX (or just getX()) gets offset from window frame to canvas  
  //required because robot's coords are global not relative to canvas  
  robot.mouseMove(
  frame.getX()+this.getX()+round(width/2),  
  frame.getY()+this.getY()+round(height/2)); 

  //mouse pos is locked in center of canvas;   
  //lines subtract the centering, get whatever offset from  
  //center user creates by moving mouse before robot resets it, then  
  //continously adds that to our new mouse pos variables  
  rmx += mouseX-width/2;  
  rmy += mouseY-height/2;  

  //these lines are just shortened conditionals to handle  
  //wrapping of our mouse pos variables when they go outside canvas  
  //first one:  
  //if rmx>width? set rmx to rmx-width else : set rmx to rmx  
  rmx = rmx>width?rmx-width:rmx;  
  rmx = rmx<0?width+rmx:rmx;  
  /*  // check ceiling 
   if (rmy<-300) {
   rmy= -300;
   }
   // check floor
   if (rmy>floorLevel-20) {
   rmy= floorLevel-20;
   } */
} // CheckVirtualMouse 

// -----------------------------------------------------------

void checkBoundaries () {

  if (xpos<-3995) {
    xpos=-3995;
  }
  else if (xpos>3995) {
    xpos=3995;
  }
  if (zpos<-3995) {
    zpos=-3995;
  }
  else if (zpos>3995) {
    zpos=3995;
  }
}

// ===========================================================================================
// not in use 

void initSinCos_____________() { // not in use 
  // init sin/cos tables wi*/th values
  // should be called from setup()
  sinLUT = new float[SC_PERIOD];
  cosLUT = new float[SC_PERIOD];
  for (int i = 0; i < SC_PERIOD; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SC_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SC_PRECISION);
  }
} // initSinCos

// -------------------------------------------------------------------------------

