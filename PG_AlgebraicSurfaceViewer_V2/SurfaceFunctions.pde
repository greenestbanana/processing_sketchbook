
//==========================================================
// modul: SurfaceFunctions.pde - by Gerd Platl
// implement class PSurface                   
// and some examples of algebraic surface functions       
// v1.0  2011-12-15  inital release
// v1.1  2012-01-04  more surfaces
// v1.2  2012-02-10  more surfaces
// v1.3  2012-03-31  more surfaces
//                   method getInfo added
// v2.0  2012-06-14  more surfaces
// 
// The default function space in x, y and z direction 
// is best viewed within -200 .. +200.
// Positive function values means you are inside the 3d-shape.
//
// How to add a new surface function: 
// - note: replace <XXX> to new surface name
// - add 'new <XXX>Value(),' to 'functions' list
// - create class <XXX>Value as copy of function 'XxxValue' 
// - implement function <XXX>Value
// - use PVector.mult(pos, <scaleFactor>);  for scaling 
//
//==========================================================

int startSurface = 33;    // sketch starting index of surface

//----------------------------------------------------------
// function definition: calculate value at given 3d position 
//----------------------------------------------------------
interface SurfaceFunction 
{ 
  String getName();
  String getInfo();
  float getValue (PVector pos);
}

//----------------------------------------------------------
// set list of all surface functions 
//----------------------------------------------------------
SurfaceFunction[] functions = new SurfaceFunction[]
{ 
  new PlaneValue(), 
  new CylinderValue(), 
  new SphereValue(), 
  new QSphereValue(), 
  new TorusValue(), 
  new BlobValue(), 
  new Chmutov2Value(),
  new PG_C8CubeValue(),
  new PG_C16CubeValue(),
  new TetrahedralValue(), 
  new McMullenValue(), 
  new HeartValue(), 
  new Bretzel2Value(), 
  new Bretzel6Value(),
  new SchwartzValue(),
  new Gyroid1Value(),
  new Gyroid2Value(),
  new SteinerSurface1(),
  new BorromeanRings1(),
  new SchwartzRing_01(),
  new PG_WireCube_2(),
  new PG_RippleCube_2(),
  new PG_Alienship_2(),
  new PG_Tuetue_1(),
  new PG_Icosa_4(),
  new PG_Meteor_898989(),
  new PG_TwistedTorus_3(),
  new PG_DoubleHelix_1(),
  new PG_Isolator_1(),
  new PG_Beasty_1(),
  new BarthsSextik(),
  new BarthsDecic(),
  new GridCylinder1(),
  new PG_GridFruit1(),
  new PG_QuattroGyroid1(),
  new PG_TorusCross_1(),
  new PG_TorusCross_2(),
  new Schwartz_P1(),  
  new PG_BallyBall_1(),
  new PG_EdgeBall_2(),
  new PG_Tetrahedral_1(),
  // fractals
  new Mandelbulb_8Power(),
  new Julia3d() 
//  new XxxValue(),
};

int surfaces = functions.length;       // number of surfaces

//==========================================================
// define class PSurface to handle surfaces
//==========================================================
class PSurface
{
  int index;               // current function index 
  String name;             // surface name
  String info;             // additional surface information
  SurfaceFunction sFunc;   // current surface function

  // set surface function by index
  public PSurface (int functionIndex) 
  { 
    SelectFunction (functionIndex);
  }

  // select surface function by index
  void SelectFunction(int functionIndex) 
  { 
    this.index = (functionIndex + surfaces) % surfaces;
    this.name = functions[index].getName();
    this.info = functions[index].getInfo();
    this.sFunc = functions[index];   // set function call
  }
  
  // get algebraic surface value at given position
  float Value(PVector pos)
  { //println ("getValue: " +  sfunc.getValue(pos));
    return sFunc.getValue(pos);
  }
}


//==========================================================
// define algebraic surface functions
//==========================================================

//---------------------------------------------------------
// Plane:  z^2 = 0
//---------------------------------------------------------
class PlaneValue implements SurfaceFunction 
{ 
  String getName() { return "Plane: 10-100*z^2"; }
  String getInfo() { return "10-100*z^2"; }
  float getValue(PVector pos)
  {
    return 10-100 * sq(pos.z);
  }
}

//----------------------------------------------------------
// Cylinder:  y^2+z^2 = r^2      r=radius
//----------------------------------------------------------
class CylinderValue implements SurfaceFunction
{ 
  String getName() { return "Cylinder"; }
  String getInfo() { return "r^2-y^2-z^2"; }
  float getValue(PVector pos)
  { 
    return 64.0 - sq(pos.y) - sq(pos.z);
  }
}

//----------------------------------------------------------
// Sphere:  x^2+y^2+z^2 = r^2    r=radius
//----------------------------------------------------------
class SphereValue implements SurfaceFunction
{ 
  String getName() { return "Sphere"; }
  String getInfo() { return "r^2-(x^2+y^2+z^2)"; }
  public float getValue(PVector pos)
  { 
    return 81.0 - (sq(pos.x) + sq(pos.y) + sq(pos.z));
  }
}

//----------------------------------------------------------
// QSphere:  x^8+y^8+z^8 = r^8    r=radius
//----------------------------------------------------------
class QSphereValue implements SurfaceFunction
{ 
  float r = 7.0;  
  float r8 = pow(r,8); 
  String getName() { return "QSphere"; }
  String getInfo() { return "r^8-(^8+y^8+z^8)"; }
  public float getValue(PVector pos)
  { 
    return r8 - (pow(pos.x,8) + pow(pos.y,8) + pow(pos.z,8));
  }
}

//----------------------------------------------------------
// Torus:  R^2 - z^2 - (sqrt(x^2+y^2)-r)^2 = 0
//----------------------------------------------------------
class TorusValue implements SurfaceFunction
{ 
  float tr = 7.6;  // torus radius
  float Rr = 2*2;  // ring radius^2
  String getName() { return "Torus"; }
  String getInfo() { return "R^2-z^2-(sqrt(x^2+y^2)-r)^2"; }
  public float getValue(PVector pos)
  { 
    return Rr - sq(pos.z) - sq (sqrt(sq(pos.x) + sq(pos.y)) - tr);
  }
}

//----------------------------------------------------------
// Implicit Blob Surface:  1 - 10*(v^2 +cos(4*x) +cos(4*y) +cos(4*z))
//                         v^2 = x^2+y^2+z^2
//----------------------------------------------------------
class BlobValue implements SurfaceFunction
{ 
  String getName() { return "Blob"; }
  String getInfo() { return "1-10*(v^2+cos(4*x)+cos(y)+cos(4*z))"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);   
    return 1 - 10 * (v1.dot(v1) +cos(4*v1.x) +cos(4*v1.y) +cos(4*v1.z));
  }
}
//----------------------------------------------------------
// Chmutov-2 Surface:     
//    1-(x^2*(3-4*x^2)^2
//     + y^2*(3-4*y^2)^2
//     + z^2*(3-4*z^2)^2)
// http://mathworld.wolfram.com/ChmutovSurface.html
//----------------------------------------------------------
class Chmutov2Value implements SurfaceFunction
{ 
  String getName() { return "Chmutov-2"; }
  String getInfo() { return "1-(x^2*(3-4*x^2)^2 +y^2*(3-4*y^2)^2 +z^2*(3-4*z^2)^2)"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);   
    float x2 = v1.x * v1.x;
    float y2 = v1.y * v1.y;
    float z2 = v1.z * v1.z;
    return 1.01 - (x2*sq(3-4*x2) +y2*sq(3-4*y2) +z2*sq(3-4*z2));
  }
}
//----------------------------------------------------------
// PG_C8Cube
//  1 -(27*x^2*(4*x^2*(x^2-1)+1)-1)^2
//    -(27*y^2*(4*y^2*(y^2-1)+1)-1)^2
//    -(27*z^2*(4*z^2*(z^2-1)+1)-1)^2
//----------------------------------------------------------
class PG_C8CubeValue implements SurfaceFunction
{ 
  String getName() { return "PG_C8Cube"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x2 = v1.x * v1.x;   
    float y2 = v1.y * v1.y;   
    float z2 = v1.z * v1.z;   
    return 1.02 -(sq(8*x2*(x2-1) + 1) 
                 +sq(8*y2*(y2-1) + 1) 
                 +sq(8*z2*(z2-1) + 1));
  }
}
//----------------------------------------------------------
// PG_C16Cube
//  1 -(27*x^2*(4*x^2*(x^2-1)+1)-1)^2
//    -(27*y^2*(4*y^2*(y^2-1)+1)-1)^2
//    -(27*z^2*(4*z^2*(z^2-1)+1)-1)^2  
//----------------------------------------------------------
class PG_C16CubeValue implements SurfaceFunction
{ 
  String getName() { return "PG_C16Cube"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  {  
    PVector v1 = PVector.mult(pos, 0.1);
    float x2 = v1.x * v1.x;   
    float y2 = v1.y * v1.y;   
    float z2 = v1.z * v1.z;   
    return 1.02 -sq(27*x2*(4*x2*(x2-1)+1)-1) 
                -sq(27*y2*(4*y2*(y2-1)+1)-1)
                -sq(27*z2*(4*z2*(z2-1)+1)-1);
  }
}

//----------------------------------------------------------
// Tetrahedral Surface:   10*q -(25 +q^2 + 8*x*y*z) = 0
//                         q = v^2 = x^2+y^2+z^2 
// http://www.javaview.de/services/algebraic/index.html
//----------------------------------------------------------
class TetrahedralValue implements SurfaceFunction
{ 
  String getName() { return "Tetrahedral"; }
  String getInfo() { return "10*q-(25+q^2+8*x*y*z); q=(x^2+y^2+z^2)"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.3);   
    float q = v1.dot(v1);     // q = v^2 = (x^2 + y^2 + z^2)
    return 10*q -(25 +q*q +8* v1.x *v1.y *v1.z);
  }
}

//----------------------------------------------------------
// Implicit McMullenK3:   (1+x*x)*(1+y*y)*(1+z*z)+8*x*y*z-k
// http://local.wasp.uwa.edu.au/~pbourke/geometry/mullen/
//----------------------------------------------------------
class McMullenValue implements SurfaceFunction
{
  String getName() { return "McMullen"; }
  String getInfo() { return "1.4-(1+x*x)*(1+y*y)*(1+z*z)-8*x*y*z"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.18);
    float x2 = v1.x*v1.x;
    float y2 = v1.y*v1.y;
    float z2 = v1.z*v1.z;
    return 1.4 - (1+x2)*(1+y2)*(1+z2) - 8 * v1.x * v1.y * v1.z;
  }
}

//----------------------------------------------------------
// Heart   x^2*y^3 +z^2*y^3 -(2*z^2 +x^2 + y^2-1)^3
//----------------------------------------------------------
class HeartValue implements SurfaceFunction
{ 
  String getName() { return "Heart"; }
  String getInfo() { return "x^2*y^3 +0.1*z^2*y^3 -(2*z^2 +x^2 +y^2 -1)^3"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.14);
    float x2 = v1.x*v1.x;
    float y2 = v1.y*v1.y;
    float z2 = v1.z*v1.z;
    float y3 = v1.y*y2;
    return -40 * (x2*y3 + 0.1*z2*y3 + pow(2*z2 +x2 +y2 -1, 3));
  }
}
//----------------------------------------------------------
// Implicit Bretzel2
// http://www.lama.univ-savoie.fr/~simon/Genus2.jpg
// http://virtualmathmuseum.org/Surface/bretzel2/bretzel2.html
//----------------------------------------------------------
class Bretzel2Value implements SurfaceFunction
{ 
  String getName() { return "Bretzel2"; }
  String getInfo() { return "0.01-(x^4+y^4-x^2+y^2)^2-z^2"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x2 = v1.x*v1.x;
    float y2 = v1.y*v1.y;
    float z2 = v1.z*v1.z;
    return 300 * (0.01 - sq(x2*x2 +y2*y2 -x2 +y2) -z2);
  }
}

//----------------------------------------------------------
// PG_Bretzel6
// 0.0037-(x*x*x*x +y*y*y*y -x*x +y*y)^2 +z*z -0.01)
//       *(z*z*z*z +y*y*y*y -y*y +z*z)^2 +x*x -0.01)
//       *(x*x*x*x +z*z*z*z -z*z +x*x)^2 +y*y -0.01)-0.00001
//----------------------------------------------------------
class Bretzel6Value implements SurfaceFunction
{ 
  String getName() { return "Bretzel6"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x2 = v1.x*v1.x;   
    float x4 = x2*x2;
    float y2 = v1.y*v1.y;   
    float y4 = y2*y2;
    float z2 = v1.z*v1.z;   
    float z4 = z2*z2;
    return 300 * (0.0037 - (sq(x4 +y4 -x2 +y2) +z2 -0.01)
                          *(sq(z4 +y4 -y2 +z2) +x2 -0.01)
                          *(sq(x4 +z4 -z2 +x2) +y2 -0.01));
  }
}
//----------------------------------------------------------
// endless Schwartz surface
//----------------------------------------------------------
class SchwartzValue implements SurfaceFunction
{ 
  String getName() { return "Schwartz"; }
  String getInfo() { return "0.1-(cos(x)+cos(y)+cos(z))"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 1.22);
    return 0.1 - (cos(v1.x) + cos(v1.y) + cos(v1.z));
  }
}
//----------------------------------------------------------
// endless Gyroid surface 1
//----------------------------------------------------------
class Gyroid1Value implements SurfaceFunction
{ 
  String getName() { return "Gyroid-1"; }
  String getInfo() { return "abs (cos(x)*sin(z) +cos(y)*sin(x) +cos(z)*sin(y)) -1.0"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.6);
    return abs (cos(v1.x)*sin(v1.z) 
               +cos(v1.y)*sin(v1.x) 
               +cos(v1.z)*sin(v1.y)) - 1.01;
  }
}
//----------------------------------------------------------
// endless Gyroid surface 2
//----------------------------------------------------------
class Gyroid2Value implements SurfaceFunction
{ 
  String getName() { return "Gyroid-2"; }
  String getInfo() { return "0.2-abs(cos(x)*sin(z) +cos(y)*sin(x) +cos(z)*sin(y))"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.61);
    return 0.202 - abs (cos(v1.x)*sin(v1.z) 
                     +cos(v1.y)*sin(v1.x) 
                     +cos(v1.z)*sin(v1.y));
  }
}
//----------------------------------------------------------
// SteinerSurface1 9/2007
//----------------------------------------------------------
class SteinerSurface1 implements SurfaceFunction
{ 
  String getName() { return "SteinerSurface1"; }
  String getInfo() { return "0.01 -2*x*y*z -(x*y)^2 -(x*z)^2 -(y*z)^2"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    return 0.01 -2*x*y*z -sq(x*y) -sq(x*z) -sq(y*z);
  }
}
//----------------------------------------------------------
// 3 elliptic rings
//----------------------------------------------------------
class BorromeanRings1 implements SurfaceFunction
{ 
  String getName() { return "BorromeanRings1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.66);
    float x = sq(v1.x);
    float y = sq(v1.y);
    float z = sq(v1.z);
    return -(sq(0.1*x+y+z+2) -9*(0.1*x+y))
           *(sq(0.1*z+x+y+2) -9*(0.1*z+x)) 
           *(sq(0.1*y+z+x+2) -9*(0.1*y+z));
  }
}

//----------------------------------------------------------
// http://k3dsurf.s4.bizhat.com/k3dsurf-ftopic30-0.html
//----------------------------------------------------------
class SchwartzRing_01 implements SurfaceFunction
{ 
  String getName() { return "SchwartzRing_01"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.3);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    return -((cos(x)+ cos(y) + cos(z))
           *((cos(x + sin(x)/4)
            + cos(y + sin(y)/4)
            + cos(z + sin(z)/4)))
            +0.06*sq(sin((y*y)) +sin((x*x)) +sin((z*z))));
  }
}

//----------------------------------------------------------
class PG_WireCube_2 implements SurfaceFunction
{ 
  String getName() { return "PG_WireCube_2"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x = v1.x;   
    float y = v1.y;   
    float z = v1.z;   
    return   pow(x,16) + pow(y,16) + pow(z,16)
           -(pow(x,18) + pow(y,18) + pow(z,18))
           -0.06;
  }
}
//----------------------------------------------------------
// http://www.flickr.com/photos/flisp3d/4776634565/
//----------------------------------------------------------
class PG_RippleCube_2 implements SurfaceFunction
{ 
  String getName() { return "PG_RippleCube_2"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    return 0.05 * (0.5 - sq(1-(pow(x,16) + pow(y,16) + pow(z,16))))
           -( sq(2*x) * sq(2*y) * sq(2*z) 
            * sq(x+y) * sq(z+y) * sq(x+z) 
            * sq(x-z) * sq(x-y) * sq(2*y-2*z));
  }
}

//----------------------------------------------------------
// http://k3dsurf.s4.bizhat.com/k3dsurf-ftopic30-0.html
//----------------------------------------------------------
class PG_Alienship_2 implements SurfaceFunction
{ 
  String getName() { return "PG_Alienship_2"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.74);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    return (cos(y) +2*cos(x)*cos(z)
         -(cos(x) + cos(y) + cos(z))
        *((cos(x + sin(x)/2.2)
          +cos(y + sin(y)/2.2)
          +cos(z + sin(z)/2.2)))
         -0.0008*(sq(x*x)+sq(y*y)+sq(z*z)));
  }
}

//----------------------------------------------------------
class PG_Icosa_4 implements SurfaceFunction
{ 
  String getName() { return "PG_Icosa_4"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.7);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float f1 = (1+sqrt(5))/2;
    return 1 - ( cos(x+f1*y) + cos(x-f1*y)
               + cos(y+f1*z) + cos(y-f1*z)
               + cos(z-f1*x) + cos(z+f1*x))*33333
               / (x*x+y*y+z*z)
             - sq(x*x+y*y+z*z);
  }
}   
//----------------------------------------------------------
// http://k3dsurf.s4.bizhat.com/k3dsurf-ftopic30-15.html
//----------------------------------------------------------
class PG_Tuetue_1 implements SurfaceFunction
{ 
  String getName() { return "PG_Tuetue_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.33);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    return 15.0 * (sin(x*y) + sin(y*z) + sin(z*x))
           -(pow(x,4) + pow(y,4) + pow(z,4) - 22);
  }
}

//----------------------------------------------------------
class PG_Meteor_898989 implements SurfaceFunction
{ 
  String getName() { return "PG_Meteor_898989"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.2);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float f1 = cos(4*x)*sin(4*y) +cos(4*y)*sin(4*z) +cos(4*z)*sin(4*x);
    float f2 = cos(8*x)*cos(9*y) +cos(8*y)*cos(9*z) +cos(8*z)*cos(9*x);
    float f3 = cos(x) +cos(y) +cos(z);
    float f4 = cos(x+sin(x)/4) +cos(y+sin(y)/4) +cos(z+sin(z)/4);
    return f1 + 0.5*f2 + f3*f4 -4;
  }
}
//----------------------------------------------------------
class PG_TwistedTorus_3 implements SurfaceFunction
{ 
  String getName() { return "PG_TwistedTorus_3"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.66);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float f1 = sqrt(x*x+y*y)-5;
    float f2 = atan2(x,y);
    return -1.0 * ( pow(f1*cos(f2) - z*sin(f2), 8)
                   +pow(f1*sin(f2) + z*cos(f2), 8) - 1
                  );
  }
}
//----------------------------------------------------------
// Double Helix 1
// 1.0 - (sqrt(x^2+y^2)-5)^2
//     - (atan((z*cos(y)-x*sin(y))/(x*cos(y)+z*sin(y))))^2
//----------------------------------------------------------
class PG_DoubleHelix_1 implements SurfaceFunction
{ 
  String getName() { return "PG_DoubleHelix_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.7);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float sinY = sin(y);
    float cosY = cos(y);
    return 1.0 - sq(sqrt(x*x+z*z) - 5.0)
               - sq(atan( (z*cosY - x*sinY) / (x*cosY + z*sinY)));
  }
}
//----------------------------------------------------------
class PG_Isolator_1 implements SurfaceFunction
{ 
  String getName() { return "PG_Isolator_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.2);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float xyz = x*y*z;
    return 1 - (x*x+3)*(y*y+3)*(z*z+3) + 33*(xyz+0.96) + sin(xyz*11);
  }
}
//----------------------------------------------------------
class PG_Beasty_1 implements SurfaceFunction
{ 
  String getName() { return "PG_Beasty_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.8);
    float x = sq(v1.x);
    float y = sq(v1.y);
    float z = sq(v1.z);
    return 4*x*y*(1-z) - sq(x+y-z) +222;
  }
}
//----------------------------------------------------------
// Barths Sextik Surface
// http://cage.ugent.be/~hs/barth/barth.html
// 4*(k*x^2-y^2)*(k*y^2-z^2)*(k*z^2-x^2) 
//   - (1+2j)*(x^2+y^2+z^2-1)^2 = 0
//----------------------------------------------------------
class BarthsSextik implements SurfaceFunction
{ 
  float j = (1+sqrt(5))/2;
  float k = sq(j);
  String getName() { return "BarthsSextik"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.3);
    float x2 = sq(v1.x);
    float y2 = sq(v1.y);
    float z2 = sq(v1.z);
    return 4*(k*x2-y2)
            *(k*y2-z2)
            *(k*z2-x2)
  -(1+2*j) * sq(x2+y2+z2-1);
  }
}
//----------------------------------------------------------
// Barths Decic Surface
// http://cage.ugent.be/~hs/barth/barth.html
// http://mathworld.wolfram.com/BarthDecic.html
// 8*(x2-k*y2)*(y2-k*z2)*(z2-k*x2) 
//    * (x4+y4+z4 -2*x2*y2 -2*y2*z2 - 2*z2*x2)
//    + (3+5*j)*(x2+y2+z2-1)^2 * (x2+y2+z2-(2-j))^2 = 0
//
//----------------------------------------------------------
class BarthsDecic implements SurfaceFunction
{ 
  String getName() { return "BarthsDecic"; }
  String getInfo() { return ""; }

  float j = (1+sqrt(5))/2;
  float k = sq(j*j);
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.22);
    float x2 = sq(v1.x);
    float y2 = sq(v1.y);
    float z2 = sq(v1.z);
    return -8*(x2-k*y2)*(y2-k*z2)*(z2-k*x2) 
            *(x2*x2+y2*y2+z2*z2 -2*x2*y2 -2*y2*z2 - 2*z2*x2)
           - (3+5*j)*sq(x2+y2+z2-1) * sq(x2+y2+z2-(2-j));
  }
}
//----------------------------------------------------------
// GridCylinder1
// http://k3dsurf.s4.bizhat.com/k3dsurf-ftopic108-75.html
// 0.05 -2*(sqrt(x^2+z^2)-2)^2 -(cos(16*atan2(z,x))/3+cos(4*y)/4)^2
//----------------------------------------------------------
class GridCylinder1 implements SurfaceFunction
{ 
  String getName() { return "GridCylinder1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.45);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    return 0.05 - 0.9*sq(sqrt(x*x+z*z)-3)
           - sq(cos(14*atan2(z,x))*0.33333+cos(4*y)*0.25);
  }
}
//----------------------------------------------------------
// PG_GridFruit1  6/2012   
//----------------------------------------------------------
class PG_GridFruit1 implements SurfaceFunction
{ 
  String getName() { return "PG_GridFruit1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.5);
    float x = v1.x;  float x2 = x*x; 
    float y = v1.y;  float y2 = y*y;
    float z = v1.z;  float z2 = z*z;
    return 0.05 - 0.9*sq(sqrt(x2+y2+z2)-3.5)
           - sq(cos(16*atan2(z,x))/3+cos(4*y)/4)*0.1*z2
           + x2/(0.2+x2+z2);    
  }
}
//----------------------------------------------------------
// PG_QuattroGyroid1  8/2010   
//----------------------------------------------------------
class PG_QuattroGyroid1 implements SurfaceFunction
{ 
  String getName() { return "PG_QuattroGyroid1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.24);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    float s = 0.02*(sq(x*x)+sq(y*y)+sq(z*z));
    return 4.5 
           - ( cos(x/s) * sin(y/s)
              +cos(y/s) * sin(z/s)
              +cos(z/s) * sin(x/s))
           - 1.2*(sq(x)+sq(y)+sq(z));
  }
}
//----------------------------------------------------------
// PG_TorusCross_1  12/2007   
//----------------------------------------------------------
class PG_TorusCross_1 implements SurfaceFunction
{ 
  String getName() { return "PG_TorusCross_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 1.2);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    float s = cos(x)+cos(y)+cos(z);
    return 6 -z*z -sq(sqrt(x*x+y*y)-7) 
           -8*(cos(x)+cos(y)+cos(z))
           +8*cos(x)*cos(y)*cos(z);
  }
}
//----------------------------------------------------------
// PG_TorusCross_2  6/2012   
//----------------------------------------------------------
class PG_TorusCross_2 implements SurfaceFunction
{ 
  String getName() { return "PG_TorusCross_2"; }
  String getInfo() { return "6-z*z-sq(sqrt(x*x+y*y)-7+3.3*cos(x)*cos(y)*cos(z))"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 1.2);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    return 6 -z*z -sq(sqrt(x*x+y*y)-7 +3.3*cos(x)*cos(y)*cos(z));
  }
}
//----------------------------------------------------------
//  schwartz surface with 'thickness'
//----------------------------------------------------------
class Schwartz_P1 implements SurfaceFunction
{ 
  String getName() { return "Schwartz_P1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.65);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    return -(cos(x) + cos(y) + cos(z))
          *((cos(x - sin(x)/2.3)
            +cos(y - sin(y)/2.3)
            +cos(z - sin(z)/2.3)));
  }
}
//----------------------------------------------------------
// PG_BallyBall_1  8/2007 
//----------------------------------------------------------
class PG_BallyBall_1 implements SurfaceFunction
{ 
  String getName() { return "PG_BallyBall_1"; }
  String getInfo() { return "abs(sin(x))+abs(sin(y))+abs(sin(z)) -0.05*(x*x+y*y+z*z-33)"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 1.0);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    return 1.65 + abs(sin(x)) +abs(sin(y)) +abs(sin(z)) -0.05*(x*x+y*y+z*z);    
  }
}
//----------------------------------------------------------
// PG_EdgeBall_2  8/2007 
//----------------------------------------------------------
class PG_EdgeBall_2 implements SurfaceFunction
{ 
  String getName() { return "PG_EdgeBall_2"; }
  String getInfo() { return "33-(abs(sin(x))+abs(sin(y))+abs(sin(z))+0.1*(x*x+y*y+z*z))"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 2.0);
    float x = v1.x; 
    float y = v1.y;
    float z = v1.z;
    return 33 -(abs(sin(x)) +abs(sin(y)) +abs(sin(z)) +0.1*(x*x+y*y+z*z));
  }
}

//----------------------------------------------------------
// PG_Tetrahedral_1  11/2009  
//----------------------------------------------------------
class PG_Tetrahedral_1 implements SurfaceFunction
{ 
  String getName() { return "PG_Tetrahedral_1"; }
  String getInfo() { return ""; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.32);
    float x2 = sq(v1.x); 
    float y2 = sq(v1.y);
    float z2 = sq(v1.z);
    float v2 = x2+y2+z2;
    return v2 -4*( 0.7*x2 -y2 ) *(0.7* y2 -z2 ) *(0.7* z2 -x2 )
    -sq( v2*v2 - 10.5*v2 + 2.6 * v1.x * v1.y * v1.z + 22);
  }
}


//=======================
//       Fractals
//=======================

//---------------------------------------------------------
// Mandelbulb Surface 
// http://www.skytopia.com/project/fractal/2mandelbulb.html#formula
//---------------------------------------------------------
float cosX = 0.0;
float sinX = 0.0;

class Mandelbulb_8Power implements SurfaceFunction
{ 
  String getName() { return "Mandelbulb_8Power"; }
  String getInfo() { return ""; }

  int iterations = 4;
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.11);
    float x = v1.x;
    float y = v1.z;
    float z = v1.y;
    float sinT8, cosT8;
    float r = 0.0;
    for (int ni=0; ni < iterations; ni++)
    {
      // convert (x,y,z) to polar coordinates (r, th, ph)
      float w2 = x*x + y*y;
      float w = sqrt(w2);
      float r2 = w2 + z*z;
      r = sqrt(r2);
      if (r >= 2.0) break;         //===>

      // raise (r, th, ph) to the 8th power
      MandelBulb_8th (w, z, r);   sinT8 = sinX;  cosT8 = cosX;   
      MandelBulb_8th (y, x, w); 

      //(r, th, ph) <- c + (r, th, ph)^8
      float r8 = r2 * r2 * r2 * r2;
      x = v1.x + r8 * sinT8 * cosX;
      y = v1.z + r8 * sinT8 * sinX;
      z = v1.y + r8 * cosT8;
    }
    return 2.0 - r;
  }
}
//---------------------------------------------------------
// Compute sin(8t) & cos(8t) given r*sin(t), r*cos(t) & r
//---------------------------------------------------------
void MandelBulb_8th (float ps, float pc, float r)
{
  sinX = ps;
  cosX = pc;
  if (r > 0.000001)
  {
    float s = ps / r;
    float c = pc / r;
    // iterate formula for sin(2t) & cos(2t) 3 times to get sin(8t) & cos(8t)
    float t = 2.0*s*c;   c = c*c - s*s;   s = t;
          t = 2.0*s*c;   c = c*c - s*s;   s = t;
          t = 2.0*s*c;   c = c*c - s*s;   s = t;
    sinX = s;
    cosX = c;
  }
}

//----------------------------------------------------------
// http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/msg8470/#msg8470
//----------------------------------------------------------
class Julia3d implements SurfaceFunction
{
  String getName() { return "Julia3d"; }
  String getInfo() { return ""; }

  private float maxRadius = 1000.0;
  float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.12);
    float x = v1.x;
    float y = v1.y;
    float z = v1.z;
    float radius = 0.0;
    float ny,nx,nz;
    for(int ni = 0; ni < 45; ni++)
    {
      nx = x*x - z*z - 0.27;      nz = 2*x*z;        // variant 1
//      nx = x*x-z*z-0.285;         nz = 2*x*z-0.1;    // variant 2
//      nx = x*x-z*z-0.27;          nz = 3*x*z;        // variant 3
//      nx = x*x-z*z-0.25;          nz = 16*x*y*z-0.2; // variant 4
      ny = y;
      x = nz;
      y = -nx;
      z = -ny;
      radius = x*x + y*y + z*z;
      if (radius > maxRadius) break;
    }
    return maxRadius - radius;
  }
}
//----------------------------------------------------------
//  use this draft to create your surface function...
//----------------------------------------------------------
class XxxValue implements SurfaceFunction
{ 
  String getName() { return "?surfacename?"; }
  String getInfo() { return "?formula?"; }
  public float getValue(PVector pos)
  { 
    PVector v1 = PVector.mult(pos, 0.42);
    return cos(v1.x)+cos(v1.y)+cos(v1.z) - 0.99;
  }
}

