import processing.sound.*;

int numLevel; 
float spawnRate;
ArrayList<Enemy> enemies;
ArrayList<Tower> towers;
ArrayList<Bullet> bullets;
Tower preview;
int numPaths;
int baseHealth;
float enemySpeed;
PVector enemyStart;
Level level;
PVector[] path;
ArrayList<Button> buttons;
Button currentButton;
Button recentButton;
boolean placingTower = false;
boolean gameOver = false;

String[] levelTypes = {"fire", "air", "water", "earth", "metal", "noir"};
int levelType;

color[][] levelPalettes = {
  { color(255, 90, 50), color(235, 220, 210), color(255, 240, 230) },
  { color(160, 230, 220), color(210, 235, 230), color(230, 255, 250) },
  { color(50, 150, 220), color(210, 230, 235), color(230, 250, 255) },
  { color(130, 100, 10), color(230, 220, 200), color(250, 240, 220) },
  { color(180, 190, 190), color(220, 220, 220), color(240, 240, 240) },
  { color(40, 60, 80), color(180, 190, 200), color(200, 210, 220) }
};

int[][] towerPalettes = {
  { 255, 0, 0 }, 
  { 255, 180, 0 }, 
  { 255, 255, 0 }, 
  { 0, 255, 0 }, 
  { 0, 255, 255 }, 
  { 0, 0, 255 }, 
  { 255, 0, 255 }, 
  { 255, 255, 255 }, 
};

color pathColor, gridColor, backgroundColor;

BufferedReader reader;
PrintWriter file;

int gridSize = 50;
int cols;
int rows;

Tower selectedTower = null;
Button upgradeButton;

int uiCols = 3;
int uiWidth = gridSize * uiCols;

int topScore = 0;
boolean topScoreShow = false;
boolean muted = false;
boolean paused = false;

boolean started = false;

int money = 500;
int kills = 0;
boolean increased = false;

SoundFile enemyHit;
SoundFile damage;

void setup() {
  size(950, 600);
  cols = (width - uiWidth) / gridSize;
  rows = height / gridSize;
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  pathColor = levelPalettes[levelType][0];
  gridColor = levelPalettes[levelType][1];
  backgroundColor = levelPalettes[levelType][2];
  level = new Level(numPaths, levelPalettes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  buttons = new ArrayList<Button>();

  spawnRate = 100;

  bullets = new ArrayList<Bullet>();

  enemySpeed = 1;
  level.setup();
  towerButtons();
  settingsButton();
  path = level.getPath();
  enemyStart = path[0];

  startPage();
  
  enemyHit = new SoundFile(this, "EnemyHit.wav");
  damage = new SoundFile(this, "Damage.wav");
  
  reader = createReader("topScore.txt");
  try {   
    topScore = Integer.parseInt(reader.readLine());
  } catch (IOException e) {
    e.printStackTrace();
    topScore = 0;
  }
}

void towerButtons() {
  String[] costs = {"100", "175", "125", "250", "75", "175", "150", "350"};
  for (int i = 0; i < 8; i++) {
    PVector position = new PVector(0, i * gridSize + 3 * gridSize);
    
    Button button = new Button(position, gridSize * 3, gridSize, "Tower " + i + " ($" + costs[i] + ")", "Tower");
    buttons.add(button);
  }
}


void settingsButton() {
  String[] types = {"Top Score", "Mute", "Pause"};
  
  for (int i = 0; i < 3; i++) {
    PVector position = new PVector(gridSize * i, height - gridSize);
    
    Button button = new Button(position, gridSize, gridSize, types[i], types[i]);
    buttons.add(button);
  }
}

void startPage() {
  paused = true;
  PVector position = new PVector(width/2 - gridSize*2.5, height/2 + gridSize/2 - 50);
  
  Button button = new Button(position, gridSize*5, gridSize*2, "Start", "Start");
  buttons.add(button);
}

void draw() {
  if (!gameOver) {
    background(backgroundColor);
    
    stroke(gridColor);
    strokeWeight(2);
    noFill();
    
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        rect(uiWidth + x * gridSize, y * gridSize, gridSize, gridSize);
      }
    }
    
    level.draw();
    
  if (started) {
      fill(255, 255, 255, 200);
      stroke(0);
      rect(0, 0, gridSize * 3, gridSize * 5);
      fill(0);
      textAlign(LEFT, CENTER);
      textSize(15);
      text("Towers: " + towers.size(), 10, 20);
      text("Enemies: " + enemies.size(), 10, 45);
      text("Health: " + baseHealth, 10, 70);
      text("Money: " + money, 10, 95);
      text("Kills: " + kills, 10, 120);
    }
    
    if (!started) {
     fill(0, 0, 0, 150);
      noStroke();
      rect(0, 0, width, height);

      fill(255, 215, 0); 
      textSize(80);
      textAlign(CENTER, CENTER);
      text("TOWER DEFENSE", width/2, height/3);
    }
  
    currentButton = null;
    for (Button button : buttons) {
      if (started || button.function.equals("Start")) {
        button.draw();
        if (button.mouseOver()) {
          currentButton = button;
        }
      }
    }
    

  
    for (Tower tower : towers) {
      tower.display();
      if (!paused) {
        tower.shoot(enemies);  
      }
    }
    
    if (selectedTower != null) {
      PVector loc = selectedTower.getLocation();
      float boxX = loc.x;
      float boxY = loc.y - 90;
      float boxW = 150;
      float boxH = 50;
    
      fill(255, 255, 200);
      stroke(0);
      rect(boxX, boxY, boxW, boxH);
    
      fill(0);
      textSize(12);
      textAlign(LEFT, TOP);
      text("Damage: " + selectedTower.getDamage(), boxX + 5, boxY + 5);
      text("Rate: " + selectedTower.getRate(), boxX + 5, boxY + 20);
      text("Range: " + selectedTower.getRange(), boxX + 5, boxY + 35);
      
      float buttonH = 30;
      
      PVector buttonPos = new PVector(boxX, boxY + boxH + 5);
      upgradeButton = new Button(buttonPos, (int)boxW, (int)buttonH, "+25% Damage ($50)", "upgrade");
      upgradeButton.draw();
      
    }
  
    if (preview != null && mouseX >= uiWidth) {
      PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
      
      preview.setLocation(location);
      
      if (onPath(location) || onTower(location) || money < preview.getCost()) {
        preview.invalid();
        fill(255, 0, 0, 50);
        stroke(255, 0, 0);
      } else {
        preview.valid();
        fill(0, 255, 0, 50);
        stroke(0, 255, 0);
      }
      
      circle(mouseX / gridSize * gridSize + gridSize / 2, mouseY / gridSize * gridSize + gridSize / 2, preview.getRange() * 1.75);
      
      preview.display();
    }
    
    for (Enemy enemy : enemies) {
      drawEnemy(enemy);
      
      if (enemy.getFrozen() > 0) {
        enemy.setFrozen(enemy.getFrozen() - 1);
        
        if (enemy.getFrozen() <= 0) {
          enemy.setSpeed((int)enemy.getOriSpeed());
        }
      }
      
      if (enemy.getSpeed() == 0 && enemy.getFrozen() == 0) {
        enemy.setFrozen(75);
      }
    }
    
    if (!paused) {
      if (kills % 10 == 0 && kills != 0){
        if (!increased){
          if (spawnRate > 40){
            spawnRate -= 10;
            increased = true;
          }
          if (enemySpeed < 2){
            enemySpeed += 0.25;
          }
        }
      }
      if (kills % 10 == 1 && kills != 1){
        increased = false;
      }
      
      for (Bullet b : bullets) {
        b.updateBullet();
        
        if (b.hit()) {
          if (!muted){
            enemyHit.play();
          }
          bullets.remove(b);
          break;
        }
      }
    }
    
  
    if (paused == false) {
      
      if (frameCount % spawnRate == 0 && frameCount >= 100) {
        addEnemy();
      }
      for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        
        if (frameCount % 1 == 0) {
          updateEnemy(enemy);
        }
      }
    }
  
    if (topScoreShow) {
      fill(255, 255, 255, 200);
      stroke(0);
      rect(width / 4, height / 4, width / 2, height / 2);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Top Score: " + topScore, width / 2, height / 2);
    }
    if (baseHealth <= 0){
    gameOver = true;
  }
  } else {
    fill(255, 255, 255, 200);
    stroke(0);
    rect(width / 4, height / 4, width / 2, height / 2);
    fill(0);
    textAlign(CENTER, CENTER);
    text("GAMEOVER", width / 2, height / 2);
  }
}

boolean onPath(PVector location) {
  for (PVector tile : path) {    
    if (location.x >= tile.x - gridSize / 2 && location.x <= tile.x - gridSize / 2 && location.y >= tile.y - gridSize / 2 && location.y <= tile.y - gridSize / 2) {
      return true;
    }
  }
  
  return false;
}

boolean onTower(PVector location) {
  for (Tower tower : towers) {    
    if (location.x >= tower.getLocation().x && location.x < tower.getLocation().x + gridSize && location.y >= tower.getLocation().y && location.y < tower.getLocation().y + gridSize) {
      return true;
    }
  }
  
  return false;
}

Tower findTowerStats(PVector place){
  if (recentButton.getText().equals("Tower 1 ($100)")){
    return new Tower(5,4,175,225,place, "n", towerPalettes[1]);
  }
  
  if (recentButton.getText().equals("Tower 2 ($175)")){
    return new Tower(0.25,.25,125,175,place, "n", towerPalettes[2]);
  }
  
  if (recentButton.getText().equals("Tower 3 ($125)")){
    return new Tower(.2,0.1,250,175,place, "n", towerPalettes[3]);
  }
  
  if (recentButton.getText().equals("Tower 4 ($75)")){
    return new Tower(1,2.5,75,75,place, "aoe", towerPalettes[4]);
  }
  
  if (recentButton.getText().equals("Tower 5 ($175)")){
    return new Tower(3,2,175,125,place, "aoe", towerPalettes[5]);
  }
  
  if (recentButton.getText().equals("Tower 6 ($150)")){
    return new Tower(1,.5,150,175,place, "freeze", towerPalettes[6]);
  }
  
  if (recentButton.getText().equals("Tower 7 ($350)")){
    return new Tower(100,10,350,75,place, "n", towerPalettes[7]);
  }
  
  return new Tower(1,1,100,125,place, "n", towerPalettes[0]);
}

void mouseClicked() {
  if (upgradeButton != null && upgradeButton.mouseOver() && selectedTower != null && money >= 50) {
    selectedTower.setDamage(selectedTower.getDamage() * 1.25);
    money -= 50;
    return;
  }
  
  if (placingTower && currentButton == null && mouseX >= uiWidth) {
    PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    
    if (!onTower(location) && !onPath(location) && !(money < findTowerStats(location).getCost())) {
      Tower toAdd = findTowerStats(location);
      
      towers.add(toAdd);
      money -= toAdd.getCost();
    }
    
    preview = null;
    placingTower = false;
  } else if (currentButton != null) {
    String f = currentButton.function;
    recentButton = currentButton;
    
    if (f.equals("Tower")) {
      preview = findTowerStats(new PVector(0, 0));
      placingTower = true;
    } 
    else if (f.equals("Top Score")) {
      topScoreShow = !topScoreShow;
    } 
    else if (f.equals("Mute")) {
      muted = !muted;
    } 
    else if (f.equals("Pause")) {
      paused = !paused;
    } 
    else if (f.equals("Start")) {
      recentButton.setPosition(new PVector(10000, 10000));
      paused = false;
      started = true;
    }
  } else {
  for (Tower tower : towers) {
    PVector l = tower.getLocation();
    
    if (mouseX >= l.x && mouseX < l.x + gridSize && mouseY >= l.y && mouseY < l.y + gridSize) {
      selectedTower = tower;
      return;
    }
  }

  selectedTower = null;
}

}

void addEnemy(){
  int random = (int)random(1, 7);
  
  switch (random) {
    case 1:
      float[] stats1 = {1, 1.25};
      
      Enemy e1 = new Enemy(kills / 25 + stats1[0], stats1[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e1);
      break;
    case 2:
      float[] stats2 = {3, 1};
      
      Enemy e2 = new Enemy(kills / 25 + stats2[0], stats2[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e2);
      break;
    case 3:
      float[] stats3 = {10, 0.5};
      
      Enemy e3 = new Enemy(kills / 25 + stats3[0], stats3[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e3);
      break;
    case 4:
      float[] stats4 = {20, 0.25};
      
      Enemy e4 = new Enemy(kills / 25 + stats4[0], stats4[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e4);
      break;
    case 5:
      float[] stats5 = {0.5, 3};
      
      Enemy e5 = new Enemy(kills / 25 + stats5[0], stats5[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e5);
      break;
    case 6:
      float[] stats6 = {0.25, 2.5};
      
      Enemy e6 = new Enemy(kills / 25 + stats6[0], stats6[1] * enemySpeed, levelTypes[levelType], enemyStart);
      enemies.add(e6);
      break;
  }
}

void updateEnemy(Enemy currEnemy){
  for (int i = 0; i < path.length - 1; i++){
    if (currEnemy.getHealth() <= 0) {
      enemies.remove(currEnemy);
      money += 5;
      kills++;
      
      if (kills > topScore) {
        topScore = kills;
       
        file = createWriter("topScore.txt");
        file.print(topScore);
        file.flush();
        file.close();
      }
      
      return;
    }
    
    PVector currPath = path[i];   
    PVector currPos = new PVector(currEnemy.getX(), currEnemy.getY());
    if (Math.abs(currPos.x - currPath.x) <= 5 && Math.abs(currPos.y - currPath.y) <= 5){
      PVector myDir = this.getNextDir(i, path);
      currEnemy.setDir(myDir);
    }
    if(Math.abs(currPos.x - currPath.x) <= level.getGridSize() / 2 && Math.abs(currPos.y - currPath.y) <= level.getGridSize() / 2){
      currEnemy.setPosition(currPos.add(currEnemy.getDir()));
      if (i == path.length - 1){
        if (!muted){
          damage.play();
        }
        enemies.remove(currEnemy);
        baseHealth--;
      }
    }
    if(Math.abs(currPos.x - path[path.length - 1].x) <= level.getGridSize() / 2 && Math.abs(currPos.y - path[path.length - 1].y) <= level.getGridSize() / 2){
      enemies.remove(currEnemy);
      if (!muted){
        damage.play();
      }
      baseHealth--;
    }
  }
}

void drawEnemy(Enemy myEnemy){
  PVector position = new PVector(myEnemy.getX() - 5, myEnemy.getY() - 5);
  fill(myEnemy.myColor, 0, 0);
  stroke(myEnemy.myColor, 0, 0);
  rect(position.x, position.y, 10, 10);
}
  
public PVector getNextDir(int i, PVector[] paths){
  PVector curr = paths[i];
  PVector next = paths[i + 1];
  PVector out = new PVector(0,0);
  PVector N = new PVector(0, -1 * enemySpeed);
  PVector E = new PVector(enemySpeed, 0);
  PVector S = new PVector(0, enemySpeed);
  PVector W = new PVector(-1 * enemySpeed,0);
  if (next.x > curr.x){
    out = E;
  }
  if (next.x < curr.x){
    out = W;
  }
  if (next.y > curr.y){
    out = S;
  }
  if (next.y < curr.y){
    out = N;
  }
  return out;
}
  
