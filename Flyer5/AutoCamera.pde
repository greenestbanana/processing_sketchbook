
// Behaviour / Movement of the cam 

// const ============================================
// define possible values for cam behaviour 
final int CheckCamera_Art_Mouse = 0;    // default: Mouse 
final int CheckCamera_Art_CircleSameHeight = 1; 
final int CheckCamera_Art_CircleSpirale = 2; 
final int CheckCamera_Art_CirclePath = 3; 

// var ==============================================
// set camera default
int CheckCamera_Art = CheckCamera_Art_Mouse; 

float Winkel = 0.0; // Winkel bei Kreis  
float Hoehe = 0;    // Höhe der Kamera über der Szene 
int HoeheAdd = 2;   // wird bei Spirale zu der Höhe der Kamera addiert
float RadiusForCircle = 1250.0;  // Anfangsradius des Kreises 

// Kamerasteuerung bei Pfad (Art des Kameraverhaltens = 3)
boolean GehtAufEinemPfad = true; 
float PfadWert = 0.0;
float PfadWertMaximal = 2000.0;

// ==========================================================

void CheckCamera () {
  // check value of CheckCamera_Art
  switch (CheckCamera_Art) {
  case CheckCamera_Art_Mouse:
    // 0: Mouse
    CheckCameraMouse (); 
    break; 
  case CheckCamera_Art_CircleSameHeight:
    // circle 
    CheckCameraCircleSameHeight (); 
    break;      
  case CheckCamera_Art_CircleSpirale:
    // circle in spirale 
    CheckCameraCircleSpirale (); 
    break;  
  case CheckCamera_Art_CirclePath:
    // straight path 
    CheckCameraPath (); 
    break; 
  default : 
    // else  
    println ("Cam Error 133"); 
    // exit();
    break;
  }
} 

// ---------------------------------------------------------
// the according Mouse funcs

void CheckCameraMouse () {
  // Mouse  
  // note: Makes use of the values of Robot-Mouse (rmx,rmy,rmz). 
  float Radius = 450.0;  // Anfangsradius des Kreises 

  // command 'map': See Help. 
  angle = map(rmx,width,0,0,359); // left / right 

  // look at 
  xlookat = Radius*sin(radians(angle)) + xpos;        // left / right  
  ylookat = map(rmy,height, 0, ypos+3000,ypos-1270); // look up / down  
  zlookat = Radius*cos(radians(angle)) + zpos;        // left / right 
  
  camera (xpos,ypos,zpos,
  xlookat, ylookat, zlookat,
  0.0, 1.0, 0.0
  );
}

void CheckCameraCircleSameHeight () {
  // circle around and stay in the same height ("Hoehe")
  /*  camera (
   Radius*sin (radians(Winkel)) + 3, Hoehe, Radius* cos (radians(Winkel)) + 3,
   3, 3, 3,
   0.0, 1.0, 0.0); */
  camera (
  RadiusForCircle * sin (radians(Winkel)) + xlookat, 
  Hoehe, 
  RadiusForCircle * cos (radians(Winkel)) + zlookat,
  xlookat, ylookat, zlookat,
  0.0, 1.0, 0.0);
}

void CheckCameraCircleSpirale () {
  // Kreis mit sich ändernder Höhe = Spirale
  camera (
  RadiusForCircle * sin (radians(Winkel)) + xlookat, 
  Hoehe, 
  RadiusForCircle * cos (radians(Winkel)) + zlookat,
  xlookat, ylookat, zlookat,
  0.0, 1.0, 0.0);   // was 3,3,3 instead of  xlookat, ylookat, zlookat, 
  // Wenn Höhe zu groß oder zu klein, wird der Wert, der hinzuaddiert wird, 
  // von positiv zu negativ (oder umgekehrt). Dadurch bleibt Höhe im guten 
  // Bereich. 
  if ((Hoehe>ylookat+520) || (Hoehe<ylookat-520)) { 
    HoeheAdd = HoeheAdd * -1; // turn (up versus down)
  }
  // Höhe verändern 
  Hoehe = Hoehe + HoeheAdd;
}

void CheckCameraPath () {
  // Pfad 
  /*
  int x1 = 15;
   int y1 = 10;
   int z1 = 40;  */

  // lerp bestimmt die Flugbahn von Parameter 1 zu Parameter 2; 
  // Parameter 3 gibt dabei an, wie weit der Flug schon ist. 
  float x = lerp (xpos, 2113, PfadWert/1000.0);
  float y = lerp (ypos, -2163, PfadWert/1000.0);
  float z = lerp (zpos, 2113, PfadWert/1000.0);

  // target reached? 
  if (PfadWert>PfadWertMaximal) { 
    // stop flight on path 
    GehtAufEinemPfad=false;
  }

  camera (
  x,y,z,
  xlookat,ylookat,zlookat,
  0.0, 1.0, 0.0);
}

