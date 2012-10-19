/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/64037*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

//==========================================================
// sketch: PG_AlgebraicSurfaceViewer_V2.pde - by Gerd Platl
//
// Surface Viewer using GLGraphics and Toxiclibs libraries.
//
// v1.0  2011-12-15  inital release
// v1.1  2012-01-04  more surfaces
// v1.2  2012-02-10  more surfaces
// v1.3  2012-03-31  advanced color handling
//                   added mouse wheel handling
//             note: because of using OpenGL it works only offline!
// v2.0  2012-06-14  info added, camera handling changed,
//                   light handling extracted to ASV_Lightning.pde
//                   correction to run with processing v2.0
//                   rendering changed from OPENGL to P3D 
//                   eliminated usage of GLGraphics
//             note: because of using P3D it works now online too!
//
// v1.3 tested with:
//   processing v1.5.1:  http://processing.org/download/
//   GLGraphics v1.0.0:  http://glgraphics.sourceforge.net/
//   ToxicLibs v0020:    http://toxiclibs.org/
//                       https://bitbucket.org/postspectacular/toxiclibs/src
// v2.0 tested with:
//   processing v1.5.1:  http://processing.org/download/
//   processing v2.0b6:  http://processing.org/download/
//   ToxicLibs v0020:    http://toxiclibs.org/
//
// See overview picture about surfaces realized in version 1.3... 
// http://farm8.staticflickr.com/7064/6885477688_a34ddaa46e_b_d.jpg
//==========================================================
/*
mouse input:
 left mouse button   rotate  
 right mouse button  rotation on/off 
 mouse wheel   zoom in/out
key commands:
 0 .. 99  select surface by index number
 cursor left/right  rotation speed
 cursor up/down     turn up/down
 F1,F2      toggle help & frames per second
 F3,F4      change shininess +/-
 F5         toggle flat shading 
 F6         smooth mesh (Laplacian) 
 blanc      show next surface
 backspace  show previous surface
 +/-        zoom in/out
 b  random background color
 c  random material & light colors
 m  random material color
 j  random light 1 color
 k  random light 2 color
 l  random light 3 color
 e  toggle closed sides
 o  toggle rotate
 r  reset camera and light
 s  save picture file as Surface_<surfaceName>.png
 t  save surface mesh as binary STL file <surfaceName>.stl
 w  toggle white material color
 */

import java.awt.event.*;        // import for mouse wheel event handling 

import toxi.geom.*;             // Vec3D
import toxi.geom.mesh.*;        // TriangleMesh
import toxi.volume.*;           // VolumetricSpace
import toxi.processing.*;       // Toxiclibs Support

// global settings
int displayMode = 0;
int numberInputTimeout = 800;   // milliSeconds
boolean doRotate = true;
boolean closeSides = true;
boolean showHelp = false;       // F1
boolean showInfo = true;        // F2
boolean shading = true;
int numTriangles = 0;           // number of used triangles

// voxel space dimension
int dimX = 80;
int dimY = dimX;
int dimZ = dimX;

Vec3D volumeScale = new Vec3D(1, 1, 1).scaleSelf(300);
WETriangleMesh surfaceMesh;     // Mesh3D
ToxiclibsSupport gfx;

//-----------------------------------
void setup()
{
  println (">>> AlgebraicSurfaceViewer v2.0 <<<");
  size(600, 600, P3D);
  noSmooth();  // use for <= v1.5.1
  //smooth();    // use for >= v2.0
  noStroke();

  resetCamera();
  initLights();
  surface = new PSurface(startSurface);
  gfx = new ToxiclibsSupport(this);
  frame.addMouseWheelListener(new MouseWheelInput());   // add mouse wheel listener
}
//-----------------------------------
void draw()
{
  background (backgroundColor);
  pushMatrix();
  setLights();

  checkSelectionInput();
  String msg = surface.index + ": " + surface.name;
  switch (displayMode)
  { 
  case 0:               // display calculating...
    //println ("fc="+frameCount+ "  " +surface.name);
    msg += "         calculating...";
    displayMode++;
    handleCamera();
    if (numTriangles > 0) DoRendering();  // show current surface
    break;

  case 1:                // calculate surface
    CalculateSurface();
    rAngle = 0;          // rotation angle
    displayMode++;
    break;

  case 2:                // draw surface
    msg += "     " +  numTriangles + "  triangles";
    handleCamera();
    DoRendering();
  }
  popMatrix();
  fill(255);
  noLights();
  //textMode(SCREEN);
  if (showInfo) 
  { 
    text(msg, -200, -180, 60);
  }
  if (showHelp)
  {
    text(surface.info, -200, -160, 60);
    text(round(frameRate) + " fps  keys: cursor,blanc,bs,F1..F6,+,-,b,c,m,j,k,l,o,e,r,s,t,w, 0.."+(surfaces-1), -200, 200, 60);
  }
}
//-----------------------------------
void smoothMesh()
{
  //println("SmoothMesh: ");
  new LaplacianSmooth().filter(surfaceMesh, 2);
}
//-----------------------------------
int selectionTime = 99999999;
int inputNumber = 0;
//-----------------------------------
void checkSelectionInput()
{
  if (millis() > selectionTime)   // key input timeout?
  {
    SelectSurface (inputNumber);   // 0..n: select surface function
    inputNumber = 0;
    selectionTime = 999999999;
  }
}
//-----------------------------------
void numberPressed()
{
  selectionTime = millis() + numberInputTimeout;  // end of key input = current time + 1000 msec
  inputNumber = inputNumber * 10 + keyCode-48;
}
//-----------------------------------
void keyPressed()
{
  //println (keyCode + " '" + key + "'    ");
  if      ((key     >=   '0')
    &&     (key     <=   '9')) numberPressed();     // 0..n: select function
  else if (keyCode ==  LEFT) rSpeed -= 0.001;       // <- add rotation to left
  else if (keyCode == RIGHT) rSpeed += 0.001;       // -> add rotation to right
  else if (keyCode ==    UP) vAngle -= 0.005;       // scroll up
  else if (keyCode ==  DOWN) vAngle += 0.005;       // scroll down
  else if (keyCode ==     8) ChangeSurface (-1);    // backspace
  else if (keyCode ==    32) ChangeSurface (+1);    // blanc
  else if (keyCode ==   112) showHelp = !showHelp;  // F1
  else if (keyCode ==   113) showInfo = !showInfo;  // F2
  else if (keyCode ==   114) changeShininess(+1);   // F3
  else if (keyCode ==   115) changeShininess(-1);   // F4
  else if (keyCode ==   116) shading = !shading;    // F5
  else if (keyCode ==   117) smoothMesh();          // F6  
  else if (key == '+') zoomCamera (0.99);    // +  zoom in
  else if (key == '-') zoomCamera (1.01);    // -  zoom out
  else if (key == 'b') backgroundColor = randomColor (100, 160, 255);
  else if (key == 'c') randomColors();
  else if (key == 'm') randomMaterialColors();
  else if (key == 'w') whiteMaterial = !whiteMaterial;
  else if (key == 'j') randomLight1Colors();
  else if (key == 'k') randomLight2Colors();
  else if (key == 'l') randomLight3Colors();
  else if (key == 'o') doRotate = !doRotate;
  else if (key == 'e') { closeSides = !closeSides;   displayMode = 0; }
  else if (key == 'r') { resetCamera();   initLights(); }
  else if (key == 's') save("Surface_" + surface.name + ".png" );       // save picture file
  else if (key == 't') surfaceMesh.saveAsSTL(sketchPath("Surface_" + surface.name+".stl"));   // save mesh as STL file
  else if (key == 'y') toggleTransparency();
}

//-----------------------------------
void mousePressed()
{
  if (mouseButton == RIGHT) doRotate = !doRotate;
}

//===================================
//    handle camera
//===================================
float rAngle = 0;      // rotation angle
float rSpeed = 0.002;  // rotation speed
float vAngle = 0;      // vertical angle
float fov = 1.1;       // vertical field-of-view angle (in radians)
//-----------------------------------
void resetCamera()
{
  //println ("resetCamera: ");
  rAngle = 0;          // rotation angle
  rSpeed = 0.002;      // rotation speed
  vAngle = 0;          // vertical angle
  doRotate = true;     // rotation on/off
  fov = 1.1;           // vertical field-of-view angle (in radians)
  camera (0, 0, 400,   // eyeX, eyeY, eyeZ
          0, 0, 0,     // centerX, centerY, centerZ
          0, 1, 0);    // upX, upY, upZ
}
//-----------------------------------
void handleCamera()
{
  beginCamera();
  if (fov < 0.1) fov = 0.1;
  if (fov > 1.5) fov = 1.5;
  perspective(fov, float(width)/height, 1, 800);
  endCamera();

  if (mousePressed)
  {
    if (mouseButton == LEFT)
    {
      rAngle += 0.005 * (mouseX - pmouseX);
      vAngle -= 0.005 * (mouseY - pmouseY);
    }
  }
  rotateX (vAngle);   // up/down rotation
  rotateY (rAngle);   // left/right rotation
  if (doRotate) rAngle += rSpeed;
}
//-----------------------------------
int zoomFrame = 0;
void zoomCamera(float factor)
{
  fov *= factor;
  if (frameCount != zoomFrame)
    text ("zoom=" + nf(fov, 0, 2), -60, 180, 60);
  zoomFrame = frameCount;
}
//-----------------------------------
// listen for MouseWheelEvent
//-----------------------------------
class MouseWheelInput implements MouseWheelListener
{ 
  void mouseWheelMoved(MouseWheelEvent e) 
  { 
    fov *= 1.0 + 0.01 * e.getWheelRotation();
  }
}


//===================================
//    handle SURFACES
//===================================

PSurface surface;          // handle surface functions

//-----------------------------------
void SelectSurface (int sno)
{
  surface.SelectFunction(sno);
  displayMode = 0;
}
//-----------------------------------
void ChangeSurface (int delta)
{
  surface.SelectFunction(surface.index + delta);
  displayMode = 0;
}
//-----------------------------------
// calculate voxel values of surface 
//-----------------------------------
void CalculateSurface()
{
  println ("CalculateSurface "+surface.index+": "+surface.name
    +"  "+dimX+"*"+dimY+"*"+dimZ+"="+dimX*dimY*dimZ);

  PVector pos = new PVector ();
  float NS = 20.0 / dimX;

  VolumetricSpace volume = new VolumetricSpaceArray(volumeScale, dimX, dimY, dimZ);

  // fill volume with values
  try
  {
    for (int z=0; z<dimZ; z++)
    {
      pos.z = (0.5+z-dimZ/2)*NS;     // -10 .. +10
      for (int y=0; y<dimY; y++)
      {
        pos.y = (0.5+y-dimY/2)*NS;
        for (int x=0; x<dimX; x++)
        {
          pos.x = (0.5+x-dimX/2)*NS;
          //---------------------------------------------
          volume.setVoxelAt(x, y, z, surface.Value(pos));
          //---------------------------------------------
        }
      }
    }
  }
  catch (Exception e) {
    println ("ERROR: voxel calculation crashed");
  }

  if (closeSides) volume.closeSides();
  convertVolumeSpaceToMesh(volume);
}
//-----------------------------------
void convertVolumeSpaceToMesh(VolumetricSpace volume)
{
  float ISO_THRESHOLD = 0.01;
  float ISO_VALUE = 0.333;

  // store in IsoSurface and compute surface mesh for the given threshold value
  surfaceMesh = new toxi.geom.mesh.WETriangleMesh();
  IsoSurface surface = new HashIsoSurface(volume, ISO_VALUE);
  surface.computeSurfaceMesh(surfaceMesh, ISO_THRESHOLD);
  numTriangles = surfaceMesh.getNumFaces();
}

//===================================
//  do mesh rendering with toxicLibs
//===================================
void DoRendering()
{
  //println ("DoRendering:");
  gfx.mesh(surfaceMesh, shading, 0);  
  //  gfx.meshNormalMapped(surfaceMesh, shading, 0);   
}

