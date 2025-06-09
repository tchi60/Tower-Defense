int numLevel; 
float spawnRate;
ArrayList<Enemy> enemies;
ArrayList<Tower> towers;
Tower preview;
int numPaths;
int baseHealth;
String[] levelTypes = {"a", "b", "c", "d", "e", "f"};
float enemySpeed;
int levelType;
PVector enemyStart;
Level level;
PVector[] path;
ArrayList<Button> buttons;
Button currentButton;
Button recentButton;
boolean placingTower = false;
boolean gameOver = false;

BufferedReader reader;

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

void setup() {
  size(950, 600);
  
  cols = (width - uiWidth) / gridSize;
  rows = height / gridSize;
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  buttons = new ArrayList<Button>();
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
  PVector position = new PVector(width / 2 - gridSize * 2.5, height / 2 - gridSize);
  
  Button button = new Button(position, gridSize * 5, gridSize * 2, "Start", "Start");
  buttons.add(button);
}

void draw() {
  if (!gameOver) {
    background(0);
    
    stroke(30);
    strokeWeight(2);
    noFill();
    
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        rect(uiWidth + x * gridSize, y * gridSize, gridSize, gridSize);
      }
    }
    
    level.draw();
    
    fill(#C1F8FF);
    text(towers.size(), 20, 40);
    text(money, 20, 60);
    
    if (!started) {
      fill(255);
      noStroke();
      rect(0, 0, width, height);
    }
  
    currentButton = null;
    for (Button button : buttons) {
      button.draw();
      if (button.mouseOver()) {
        currentButton = button;
      }
    }
    
    if (!started) {
      fill(255);
      noStroke();
      rect(0, 0, width / 3, height);
      
      fill(0);
      textSize(80);
      textAlign(CENTER, CENTER);
      text("Tower Defense", width / 2, height / 5);
    }
  
    for (Tower tower : towers) {
      tower.display();
      tower.shoot(enemies);  
    }
  
    if (preview != null && mouseX >= uiWidth) {
      PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
      
      preview.setLocation(location);
      
      if (onPath(location) || onTower(location)) {
        preview.invalid();
      } else {
        preview.valid();
      }
      
      preview.display();
    }
    
    for (Enemy enemy : enemies) {
      drawEnemy(enemy);
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
    return new Tower(5,0.25,175,225,place);
  }
  
  if (recentButton.getText().equals("Tower2")){
    return new Tower(0.25,4,125,125,place);
  }
  
  if (recentButton.getText().equals("Tower3")){
    return new Tower(0.25,4,125,125,place);
  }
  
  if (recentButton.getText().equals("Tower4")){
    return new Tower(1,0.5,75,75,place);
  }
  
  if (recentButton.getText().equals("Tower5")){
    return new Tower(3,0.5,175,125,place);
  }
  
  if (recentButton.getText().equals("Tower6")){
    return new Tower(1,5,150,175,place);
  }
  
  if (recentButton.getText().equals("Tower7")){
    return new Tower(256,0.1,350,75,place);
  }
  
  return new Tower(1,1,100,125,place);
}

void mouseClicked() {
  if (placingTower && currentButton == null && mouseX >= uiWidth) {
    PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    
    if (!onTower(location) && !onPath(location)) {
      towers.add(findTowerStats(location));
      preview = null;
      placingTower = false;
    }  
  } else if (currentButton != null) {
    String f = currentButton.function;
    recentButton = currentButton;
    
    if (f.equals("Tower")) {
      preview = new Tower(10, 10, 10, 10, new PVector(0, 0));
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
  Enemy newEnemy = new Enemy(300, 1, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < path.length - 1; i++){
    PVector currPath = path[i];
    for (int k = 0; k < enemies.size(); k++){
      Enemy currEnemy = enemies.get(k);
      
      if (currEnemy.getHealth() <= 0) {
        enemies.remove(currEnemy);
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
