
//--------------------------------------------------------
// sketch: ASV_Lightning.pde - by Gerd Platl
//         handle material and lightning properties
// date:   v1.0  2012-06-12
//--------------------------------------------------------
// material syntax: 
//     ambient(color)          // RGB/HSB
//     emissive(color)         // RGB/HSB 
//     specular(color)         // RGB/HSB
//     shininess(float shine)  // degree of shininess >= 0
// light syntax:
//     lights()                       // set default light values
//     noLights()                     // disable lightning
//     lightFalloff(const,lin,quad)   // default (1, 0, 0)
//     lightSpecular(color)           // default (0, 0, 0)
//     ambientLight(color)            // light from all sides
//     directionalLight(color,dir)    // default (128,128,128, 0,0,-1)
//     pointLight(color,pos)          // to add a point light
//     spotLight(color,pos,dir,angle) // to add a spot light
//--------------------------------------------------------

color backgroundColor = color(33,55,111);

// material and light colors 
float fShininess = 20.0;
color cAmbientMaterial, cAmbientLight;
color cSpecularMaterial, cSpecularLight;
color lightColor1, lightColor2, lightColor3;
boolean whiteMaterial = false;

// light directions
PVector light1Direction, light2Direction, light3Direction;

//--------------------------------------------------------
void initLights()
{
  fShininess = 20.0;
  colorMode(RGB, 255);
  cAmbientMaterial  = color (25, 25, 25);
  cAmbientLight     = color (0, 0, 0);
  cSpecularMaterial = color (200, 180, 50);
  cSpecularLight    = color (200, 180, 50);
  lightColor1       = color (140, 110, 50);
  lightColor2       = color (0,0,0);
  lightColor3       = color (0,0,0);
  
  light1Direction  = new PVector(0,400,-400);
  light2Direction  = new PVector(400,-400,-200);
  light3Direction  = new PVector(-400,400,200);
}
//--------------------------------------------------------
// set all kind of lights
//--------------------------------------------------------
void setLights()
{
  if (whiteMaterial)
  { ambient(cAmbientMaterial=color(222));
    lights();
    return;      // ===>
  }  

  noLights();    // turn off standard lights

  // ambient material and light
  ambient(cAmbientMaterial);
  ambientLight(red(cAmbientLight), green(cAmbientLight), blue(cAmbientLight));

  // specular material and light
  specular(red(cSpecularMaterial), green(cSpecularMaterial), blue(cSpecularMaterial));
  shininess(fShininess);
  lightSpecular(red(cSpecularLight), green(cSpecularLight), blue(cSpecularLight));    // color

  // light 1
  directionalLight(red(lightColor1), green(lightColor1), blue(lightColor1), // color
    light1Direction.x, light1Direction.y, light1Direction.z);     // lightning direction

  // light 2
  directionalLight(red(lightColor2), green(lightColor2), blue(lightColor2),
    light2Direction.x, light2Direction.y, light2Direction.z);

  // light 3
  directionalLight(red(lightColor3), green(lightColor3), blue(lightColor3),
    light3Direction.x, light3Direction.y, light3Direction.z);
}
//-----------------------------------
int shininessFrame = 0;
void changeShininess(float delta)
{ 
  fShininess = constrain (fShininess+delta, 1.0, 80.0);
  if (frameCount != shininessFrame)
    text ("shininess=" + nf(fShininess, 0, 2), -60, 180, 60);
  shininessFrame = frameCount;
}
//-----------------------------------
void randomMaterialColors()
{
  println (" random material colors");
  whiteMaterial = false;
  cAmbientMaterial = randomColor (0, 155, 55);
  cSpecularMaterial = randomColor (0, 200, 255);
  cAmbientLight = randomColor (0, 255, 255);
}
//-----------------------------------
void randomLight1Colors()
{
  println (" random light-1 color");
  lightColor1 = randomColor (0, 255, 255);
}
//-----------------------------------
void randomLight2Colors()
{
  println (" random light-2 color");
  lightColor2 = randomColor (0, 255, 255);
}
//-----------------------------------
void randomLight3Colors()
{
  println (" random light-3 color");
  lightColor3 = randomColor (0, 255, 255);
}
//-----------------------------------
void randomColors()
{
  println ("random colors");
  randomMaterialColors();
  randomLight1Colors();
  randomLight2Colors();
  randomLight3Colors();
}

//-----------------------------------
color randomColor(int minValue, int maxValue, int alpha)
{
  return color(minValue + random(maxValue - minValue)  // R
  , minValue + random(maxValue - minValue)  // G
  , minValue + random(maxValue - minValue)  // B
  , alpha); // transparency
}
//-----------------------------------
String colorString(color aColor)
{
  return str(int(red(aColor))) 
    +'-'+str(int(green(aColor))) 
    +'-'+str(int(blue(aColor)))
    +'.'+str(int(alpha(aColor)));
}
//-----------------------------------
void toggleTransparency()
{
  print (colorString(cAmbientMaterial) + "  ");
  if (int(alpha(cAmbientMaterial)) == 255) 
    cAmbientMaterial = color(cAmbientMaterial, 88);
  else cAmbientMaterial = (cAmbientMaterial & 0x00FFFFFF) + 0xFF000000;  // set opaque
  ambient(cAmbientMaterial);
  specular(255,11,0);
  println ('>'+colorString(cAmbientMaterial));
}

