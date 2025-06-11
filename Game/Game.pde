PFont title;
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

color pathColor, gridColor, backgroundColor;

BufferedReader reader;
PrintWriter file;

int gridSize = 50;
int cols;
int rows;

int uiCols = 3;
int uiWidth = gridSize * uiCols;

int topScore = 0;
boolean topScoreShow = false;
boolean muted = false;
boolean paused = false;
boolean started = false;

int money = 500;
int kills = 0;

void setup() {
  size(950, 600);
  title = createFont("NotoSansMonoCJKjp-Bold-20.vlw",128);
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
  bullets = new ArrayList<Bullet>();
  spawnRate = 50;
  enemySpeed = 5;
  level.setup();
  towerButtons();
  settingsButton();
  path = level.getPath();
  enemyStart = path[0];
  startPage();
  
  reader = createReader("topScore.txt");
  try {   
    topScore = Integer.parseInt(reader.readLine());
  } catch (IOException e) {
    e.printStackTrace();
    topScore = 0;
  }
}

void towerButtons() {
  for (int i = 0; i < 8; i++) {
    PVector position = new PVector(0, i * gridSize + 3 * gridSize);
    
    Button button = new Button(position, gridSize * 3, gridSize, "Tower" + i, "Tower");
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
      textSize(20);
      text("Towers: " + towers.size(), 10, 30);
      text("Money: " + money, 10, 60);
      text("Kills: " + kills, 10, 90);
    }
    
    if (!started) {
     fill(0, 0, 0, 150);
      noStroke();
      rect(0, 0, width, height);

      fill(255, 215, 0); 
      textSize(80);
      textAlign(CENTER, CENTER);
      textFont(title);
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
    }
    
    if (!paused) {
      for (Bullet b : bullets) {
        b.updateBullet();
        
        if (b.hit()) {
          bullets.remove(b);
          break;
        }
      }
    }
  
    if (paused == false) {
      if (frameCount % spawnRate == 0) {
        addEnemy();
      }
      if (frameCount % enemySpeed == 0) {
        updateEnemy();
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
  if (recentButton.getText().equals("Tower1")){
    return new Tower(5,4,175,225,place);
  }
  
  if (recentButton.getText().equals("Tower2")){
    return new Tower(0.25,.25,125,175,place);
  }
  
  if (recentButton.getText().equals("Tower3")){
    return new Tower(.2,0.1,250,175,place);
  }
  
  if (recentButton.getText().equals("Tower4")){
    return new Tower(1,2.5,75,75,place);
  }
  
  if (recentButton.getText().equals("Tower5")){
    return new Tower(3,2,175,125,place);
  }
  
  if (recentButton.getText().equals("Tower6")){
    return new Tower(1,.5,150,175,place);
  }
  
  if (recentButton.getText().equals("Tower7")){
    return new Tower(100,10,350,75,place);
  }
  
  return new Tower(1,1,100,125,place);
}

void mouseClicked() {
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
  }
}

void addEnemy(){
  Enemy newEnemy = new Enemy(1, 1, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < path.length - 1; i++){
    PVector currPath = path[i];
    for (int k = 0; k < enemies.size(); k++){
      Enemy currEnemy = enemies.get(k);
      
      if (currEnemy.getHealth() <= 0) {
        enemies.remove(currEnemy);
        money += 25;
        kills++;
        
        if (kills > topScore) {
          topScore = kills;
         
          file = createWriter("topScore.txt");
          file.print(topScore);
          file.flush();
          file.close();
        }
      }
      
      PVector currPos = new PVector(currEnemy.getX(), currEnemy.getY());
      if (Math.abs(currPos.x - currPath.x) <= 0 && Math.abs(currPos.y - currPath.y) <= 0){
        PVector myDir = this.getNextDir(i, path);
        currEnemy.setDir(myDir);
      }
      if(Math.abs(currPos.x - currPath.x) <= level.getGridSize() / 2 && Math.abs(currPos.y - currPath.y) <= level.getGridSize() / 2){
        currEnemy.setPosition(currPos.add(currEnemy.getDir()));
        if (i == path.length - 1){
          enemies.remove(currEnemy);
          baseHealth--;
        }
      }
      if(Math.abs(currPos.x - path[path.length - 1].x) <= level.getGridSize() / 2 && Math.abs(currPos.y - path[path.length - 1].y) <= level.getGridSize() / 2){
        enemies.remove(currEnemy);
        baseHealth--;
      }
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
