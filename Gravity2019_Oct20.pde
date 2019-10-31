// Gravity2019_Oct20 A. Kozma, T. Lichtenberg, D. Parson
// This B version has Parson's integration of Angela's stage 1
// work with Todd's 3D planets, also added ability to add planets on the fly.
// FPDC-funded research project, interactive gravity simulator
// for planetarium dome, initial rough draft.

import java.lang.Math ;  // use double for precision
import java.util.LinkedList ;  // collection of planets. Should they sort() for display?

// Use unitCircle to compute ellipses for planetary orbits.
// Stretch space using scale(X,Y) and rotate(angularOffset),
// followed by modelX() and modelY(), to find points in an
// elliptical orbit. Enclose all of that it pushMatrix()/
// popMatrix(). Use doubles for precision.
// for a demo of how this works.
int stepsInUnitCircle = 1440 ;  // for now. Angles are in radians.
double [] unitCircleX = new double [ stepsInUnitCircle ];
double [] unitCircleY = new double [ stepsInUnitCircle ];
int xcenterOfOrbits, ycenterOfOrbits ; // default width/2, height/2
LinkedList<Planet> bodies = new LinkedList<Planet>();

int size = 10;
int numOne, numTwo, numThree, numFour, numFive, numSix, numSeven, numEight;

//Planet Distance in km
float mercury = 59223859.2;
float venus = 108147916.8;
float earth = 149668992.0;
float mars = 227883110.4;
float jupiter = 778278758.4;
float saturn = 1426683456.0;
float uranus = 2870586892.8;
float neptune = 4498438348.8;

double [] orbits = {
  0.0, 59223859.2, 108147916.8, 149668992.0, 227883110.4, 778278758.4, 1426683456.0, 2870586892.8, 4498438348.8
};
float [] diameter = {1392530, 4879, 12104, 12756, 6792, 142984, 120536, 51118, 49528};
boolean usingSqrt = false;

//camera variables
float xeye, yeye, zeye;
int minimumZ, maximumZ;
// Next 3 variables rotate the world from the camera's point of view.
float worldxrotate = 0.0, worldyrotate = 0.0 ; 
/* , worldzrotate = 0.0 ; ROTATING POV AROUND Z IS CONFUSING */
// Some basic symbolic constants.
final float degree = radians(1.0), around = radians(360.0);

void setup() {
  fullScreen(P3D); // Use P3D for modelX(), modelY() to work. 
  xcenterOfOrbits = width/2 ;
  ycenterOfOrbits = height/2 ;
  background(0);
  maximumZ = 8000;  //height / 2 ;  // front of the scene
  minimumZ = -8000;  //- height / 2 ;  // back of the scene
  rectMode(CENTER);    // align all possibilities to center
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  colorMode(HSB, 360, 100, 100, 100); // saturate for the dome
  for (int unitstep = 0 ; unitstep < unitCircleX.length ; unitstep++) {
    double angle = unitstep * TWO_PI / unitCircleX.length ;
    // sin(angle) = y / hypotenuse = y / 1.0 for unit circle
    // cos(angle) = x / hypotenuse = x / 1.0 for unit circle
    unitCircleX[unitstep] = Math.cos(angle);
    unitCircleY[unitstep] = Math.sin(angle);
    // println("SETUP angle " + angle + ", unitCircleX[unitstep] " + unitCircleX[unitstep] + ", unitCircleY[unitstep] = " + unitCircleY[unitstep]);
  }
  //camera functions
  xeye = width / 2 ;
  yeye = height / 2 ;
  zeye = (height*2) /* / tan(PI*30.0 / 180.0) */ ;
  
}

void draw() {
  background(0);
  pushMatrix();
  // Parson - I moved these here so they come up first time OK, rebuild only as needed. 
  if(squared && ! lastsquared) {
    bodies.clear();
    onePlanet();
    twoPlanet();
    threePlanet();
    fourPlanet();
    fivePlanet();
    sixPlanet();
    sevenPlanet();
    eightPlanet();
    Sqrt();
    lastsquared = true ;
  }
  else if((!squared) && lastsquared) {
    bodies.clear();
    onePlanet();
    twoPlanet();
    threePlanet();
    fourPlanet();
    fivePlanet();
    sixPlanet();
    sevenPlanet();
    eightPlanet();
    Linear(); 
    lastsquared = false ;
  }
  //translate(xcenterOfOrbits, ycenterOfOrbits); // 0,0 is at the heart of the sun
  moveCameraRotateWorldKeys();  // Parson trying to get rotate space working
  translate(xcenterOfOrbits, ycenterOfOrbits); // 0,0 is at the heart of the sun
  // Normally, do real application stuff here.
  for (Planet body : bodies) {
    pushMatrix();
    pushStyle();  // safeguard against planet's grphics spilling out
    body.display();
    body.move();
    popStyle();
    popMatrix();
  }
  
  popMatrix();
  // Apply clipping circle, then end of draw()
}


void Sqrt() {
  pushMatrix();
  noFill();
  double maxWidth = width/2 - 50.0; //width-10.0 ;
  double diaWidth = width/80;
  double sqrtMax = Math.sqrt(orbits[orbits.length-1]);
  double diaMax = Math.sqrt(diameter[diameter.length-1]);
  for (int i = 0 ; i < orbits.length ; i++) {
    float sqrtDistance = (float)((Math.sqrt(orbits[i])/sqrtMax) * maxWidth) ;
    float sqrtDiameter = (float)((Math.sqrt(diameter[i])/diaMax)* diaWidth); 
      ellipse(0, 0, sqrtDistance, sqrtDistance);
      println("i is: " + i);
      /*
      Planet(int Hue, int Sat, int Bright, float mass, float size, float speed,
      float directionx, float directiony, float locationx, float locationy,
      boolean isInOrbit, int stepInOrbit, float xOrbitDistanceFromSun,
      float yOrbitDistanceFromSun, float orbitAngle) {
      */
      if(i == 0) {
      //Sun
      bodies.add(new Planet(57, 95, 99, 1.0, sqrtDiameter, -.75, 1.0, 1.0, 1.0, 1.0,
        true, 0, 0, 0, 0));
      }
      else if(i == 1 && numOne == 1) {
        println("In Mercury Sqrt");
      //Mercury 
      bodies.add(new Planet(31, 61, 66, 1.0, sqrtDiameter, -4.787, 1.0, 1.0, 1.0, 1.0,
        true, 0, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 2 && numTwo == 2) {
      //Venus
      bodies.add(new Planet(31, 92, 81, 1.0, sqrtDiameter, -3.502, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/4, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 3 && numThree == 3) {
      //Earth
      bodies.add(new Planet(205, 76, 94, 1.0, sqrtDiameter, -2.978, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/3, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 4 && numFour == 4) {
      //Mars
      bodies.add(new Planet(10, 90, 80, 1.0, sqrtDiameter, -2.4077, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/2, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 5 && numFive == 5) {
      //Jupiter
      bodies.add(new Planet(41, 64, 88, 1.0, sqrtDiameter, -1.307, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/3, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 6 && numSix == 6) {
      //Saturn
      bodies.add(new Planet(53, 75, 91, 1.0, sqrtDiameter, -.969, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/6, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 7 && numSeven == 7) {
      //Uranus 
      bodies.add(new Planet(181, 35, 97, 1.0, sqrtDiameter, -.681, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/5, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
      else if(i == 8 && numEight == 8) {
      //Neptune
      bodies.add(new Planet(220, 79, 91, 1.0, sqrtDiameter, -.543, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/4, sqrtDistance, sqrtDistance, HALF_PI / -20.0));
      }
    }
  popMatrix();
}

void Linear() {
  pushMatrix();
  noFill();
  double maxWidth = width - 10.0; //width-10.0 ;
  double diaWidth = width/80;
  double linearRatio = maxWidth / orbits[orbits.length-1];
  double diaRatio = diaWidth / diameter[diameter.length-1];
  for (int i = 0 ; i < orbits.length ; i++) {
    float linearDistance = (float)(linearRatio*orbits[i]);
    float linearDiameter = (float)(diaRatio * diameter[i]);
    float sunDiameter = (float)((diaRatio * diameter[0])/2);
      ellipse(0, 0, linearDistance, linearDistance);
      /*
      Planet(int Hue, int Sat, int Bright, float mass, float size, float speed,
      float directionx, float directiony, float locationx, float locationy,
      boolean isInOrbit, int stepInOrbit, float xOrbitDistanceFromSun,
      float yOrbitDistanceFromSun, float orbitAngle) {
      */
      if(i == 0) {
      //Sun
      bodies.add(new Planet(57, 95, 99, 1.0, linearDiameter, -.75, 1.0, 1.0, 1.0, 1.0,
        true, 0, linearDistance, linearDistance, 0));
      }
      if(i == 1 && numOne == 1) {
      //Mercury 
      bodies.add(new Planet(31, 61, 66, 1.0, linearDiameter, -4.787, 1.0, 1.0, 1.0, 1.0,
        true, 0, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 2 && numTwo == 2) {
      //Venus
      bodies.add(new Planet(31, 92, 81, 1.0, linearDiameter, -3.502, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/4, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 3 && numThree == 3) {
      //Earth
      bodies.add(new Planet(205, 76, 94, 1.0, linearDiameter, -2.978, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/3, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 4 && numFour == 4) {
      //Mars
      bodies.add(new Planet(10, 90, 80, 1.0, linearDiameter, -2.4077, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/2, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 5 && numFive == 5) {
      //Jupiter
      bodies.add(new Planet(41, 64, 88, 1.0, linearDiameter, -1.307, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/3, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 6 && numSix == 6) {
      //Saturn
      bodies.add(new Planet(53, 75, 91, 1.0, linearDiameter, -.969, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/6, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 7 && numSeven == 7) {
      //Uranus 
      bodies.add(new Planet(181, 35, 97, 1.0, linearDiameter, -.681, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/5, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
      if(i == 8 && numEight == 8) {
      //Neptune
      bodies.add(new Planet(220, 79, 91, 1.0, linearDiameter, -.543, 1.0, 1.0, 1.0, 1.0,
        true, stepsInUnitCircle/4, linearDistance + sunDiameter, linearDistance + sunDiameter, HALF_PI / -20.0));
      }
    }
  popMatrix();
}

void onePlanet() {
  if(one == true) {
    numOne = 1;
  }
  else if(one == false) {
    numOne = 0;
  }
}

void twoPlanet() {
  if(two == true) {
    numTwo = 2;
  }
  else if(two == false) {
    numTwo = 0;
  }
}

void threePlanet() {
  if(three == true) {
    numThree = 3;
  }
  else if(three == false) {
    numThree = 0;
  }
}

void fourPlanet() {
  if(four == true) {
    numFour = 4;
  }
  else if(four == false) {
    numFour = 0;
  }
}

void fivePlanet() {
  if(five == true) {
    numFive = 5;
  }
  else if(five == false) {
    numFive = 0;
  }
}

void sixPlanet() {
  if(six == true) {
    numSix = 6;
  }
  else if(six == false) {
    numSix = 0;
  }
}

void sevenPlanet() {
  if(seven == true) {
    numSeven = 7;
  }
  else if(seven == false) {
    numSeven = 0;
  }
}

void eightPlanet() {
  if(eight == true) {
    numEight = 8;
  }
  else if(eight == false) {
    numEight = 0;
  }
}
