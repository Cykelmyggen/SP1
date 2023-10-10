//audio. ( kræver man har minim installeret. " Skecth - Import Library - Manage Library - Søg efter Minim, installer og genstart programmet og det burde virke. )
import ddf.minim.*;

Minim minim;
AudioPlayer bgm;
boolean isBgmPlaying = false;

//mechanics af spillet
PImage img;
int playerCordinateX = 1920;
int playerCordinateY = 1080;
int playerWidth = 30;
int playerHeight = 20;
int sværhedsGrad = 12; 
int maxLimit = 12;
float highscore = 0;
Bombe[] bomber;
boolean isCollided = false;

//spillet
boolean isGameStarted = false;

//playertrail
PVector[] trail; 
int trailLength = 10; 
int trailAlpha = 80;

//sværhedsgraden opdaterer
int waveChangeDelay = 10000; 
int waveSpawnDelay = 15000; 
long lastWaveChangeTime = 0; 
long lastBomberSpawnTime = 0;


int currentLevel = 1;
int levelDuration = 6000;
int lastTime = 0;
//kodestart

void initBomber(int xMin, int xMax, int yMin, int yMax, int num) {
  bomber = new Bombe[num];
  
  for (int i = 0; i < bomber.length; i++) {
    int x = (int) random(xMin, xMax);
    int y = (int) random(yMin, yMax);
    bomber[i] = new Bombe(x, y, 15, 60);
  }
}

void setup(){
  
  fullScreen();
  frameRate(100);
  background(0);
  
  tint(255,100);
  img = loadImage("city.png");

  initBomber(-100, width + 20, -500, -80, sværhedsGrad);
  
  initMenu();
  
      try {
  minim = new Minim(this);
  bgm = minim.loadFile("rain.mp3"); 
  bgm.loop();
      } catch(Exception e) {
        println("Error loading audio file: " + e.getMessage());
      }
  
  trail = new PVector[trailLength];
  for (int i = 0; i < trailLength; i++) {
  trail[i] = new PVector(playerCordinateX, playerCordinateY);
  }
  
}


void draw() {
  if (isGameStarted) {
    image(img, 0, 0);

    push();
    tint(255, 90);
    drawPlayer();
    pop();
    

  int currentMillis = millis();
  if (currentMillis - lastTime > levelDuration) {
    currentLevel++;
    lastTime = currentMillis;
  }
      if (currentLevel <= 10) {
    displayLevel(currentLevel);
  } else {
    displayCongratulations();
  }

    if (!isCollided) {
      if (millis() - lastWaveChangeTime >= waveChangeDelay) {
        sværhedsGrad += 12;
        maxLimit += 100;
        lastWaveChangeTime = millis();
       
        initBomber(-100, width + 20, -1000, -80, sværhedsGrad);
      }
         

      if (millis() - lastBomberSpawnTime >= waveSpawnDelay) {
        initBomber(-100, width + 20, -1000, -80, sværhedsGrad);
        lastBomberSpawnTime = millis();
      }

      moveBomber();
    } else {
      drawGameOverScreen();
    }
  } else {
    drawMenu();
  }

  if (currentLevel >= 11 && !isBgmPlaying) {
    try {
      minim = new Minim(this);
      bgm = minim.loadFile("Deathmode.WAV");
      bgm.loop();
      isBgmPlaying = true;
    } catch (Exception e) {
      println("Error loading audio file: " + e.getMessage());
    }
  }


  push();
  noStroke();
  fill(200, 200, 200, trailAlpha);
  for (int i = 1; i < trail.length; i++) {
    rect(trail[i].x, trail[i].y, playerWidth, playerHeight);
  }
  drawPlayer();
  updateTrail();
  pop();
}

  
void updateTrail() {
  for (int i = trail.length - 1; i > 0; i--) {
    trail[i].set(trail[i - 1]);
  }
  
  trail[0].set(playerCordinateX, playerCordinateY);
}
  

void drawMenu() {
  background(0);
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Beskyt dig selv mod den onde regn!", width / 2, height / 3);
  rectMode(CENTER);
  fill(150);
  rect(width / 2, height / 2, 200, 80, 10);
  fill(255);
  text("Start Game", width / 2, height / 2);
}

void drawGameOverScreen() {
  background(0);
  fill(255);
  textSize(78);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 3);
  textSize(24);
  text("Highscore: " + (int)highscore, width / 2, height / 2 - 10);
  
    drawRestartButton();
}

void initMenu() {
}




void moveBomber(){
  for(int i = 0; i < bomber.length; i++){
    
    bomber[i].display();
    bomber[i].drop(random(1, 15));
    
    boolean conditionXLeft = bomber[i].xCor + bomber[i].w >= playerCordinateX;
    boolean conditionXRight = bomber[i].xCor <= playerCordinateX + playerWidth;
    boolean conditionUp = bomber[i].yCor + bomber[i].h >= playerCordinateY;
    boolean conditionDown = bomber[i].yCor <= playerCordinateY + playerHeight;
    
    if (conditionXLeft && conditionXRight && conditionUp && conditionDown) {
      isCollided = true;
    }
    
  }
  
  highscore += 0.1;
  
  fill(255, 255, 255);
  text("Highscore: "+(int)highscore, 200, 80);
  textSize(60);
}


void drawPlayer(){
  stroke(255, 32, 0);
  strokeWeight(4);
  fill(222, 222, 222);
  rect(playerCordinateX -2, playerCordinateY -5, playerWidth, playerHeight, 7);
}


void drawRestartButton() {
    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50 &&
        mouseY > height / 2 + 25 && mouseY < height / 2 + 65) {
        fill(200);
    } else {
        fill(150);
    }
    rect(width / 2, height / 2 + 45, 100, 40, 10);
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Restart", width / 2, height / 2 + 45);
}



void mousePressed() {
  if (!isGameStarted && mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
      mouseY > height / 2 - 40 && mouseY < height / 2 + 40) {
    isGameStarted = true;
    initBomber(-100, width + 20, -250, -80, sværhedsGrad);
  }
      if (isCollided && mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
      mouseY > height / 2 + 20 && mouseY < height / 2 + 70) {
    resetGame();
  }
}


void resetGame() {
  currentLevel = 1;
  isCollided = false;
  highscore = 0;
  sværhedsGrad = 12;
  maxLimit = 12;
  initBomber(-100, width + 20, -250, -80, sværhedsGrad);
  playerCordinateX = 600;
  playerCordinateY = 590;
}



void mouseDragged(){
  if(mouseX >= 0 && mouseX <= width - playerWidth + 1){
    playerCordinateX = mouseX;
  }
  if(mouseY >= 0 && mouseY <= height - playerHeight){
    playerCordinateY = mouseY;
  }
}
   
void displayLevel(int level) {
  textSize(32);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Level " + level, width/2, height/2 - 20);
}

void displayCongratulations() {
  textSize(60);
  fill(255, 60, 0);
  textAlign(CENTER, CENTER);
  text("DEATHMODE ACTIVATED", width/2, height/2);
}
   
    // koden er super forvirrende, ik tag jer af det. Skal nok lave bedre kodefordeling i de kommende opgaver. 
