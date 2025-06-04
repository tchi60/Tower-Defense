int numLevel; 
float spawnRate;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Tower> towers = new ArrayList<Tower>();
ArrayList<Button> buttons = new ArrayList<Button>();
Tower preview;
int numPaths;
int baseHealth;
String[] levelTypes = {"a", "b", "c", "d", "e", "f"};
float enemySpeed;
int levelType;
PVector enemyStart;
Level level;
PVector[] path;
Button currentButton;
Tower currentTower;
boolean placingTower = false;
boolean gameOver = false;

int gridSize = 50;
int cols;
int rows;

int uiCols = 3;
int uiWidth = gridSize * uiCols;

int money = 500;
int topScore = 0;
boolean topScoreShow = false;
boolean muted = false;
boolean paused = false;

void setup() {
  size(950, 600);
  
  cols = (width - uiWidth) / gridSize;
  rows = height / gridSize;
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  spawnRate = 50;
  enemySpeed = 5;
  level.setup();
  towerButtons();
  settingsButton();
  path = level.getPath();
  enemyStart = path[0];
  addEnemy();
}

void towerButtons() {

  for (int i = 0; i < 3; i++) {
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
  
    currentButton = null;
    for (Button button : buttons) {
      button.display();
      if (button.mouseOver()) {
        currentButton = button;
      }
    }
  
  fill(#C1F8FF);
  text(towers.size(), 20, 40);
  text(money, 20, 60);

   for (Tower t : towers) {
     t.display();
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

    for (Button button : buttons) {
    button.display();
    if (button.mouseOver()) {
      currentButton = button;
    }
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
      rect(width / 4, height / 4, width / 2, height / 2);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Top Score: " + topScore, width / 2, height / 2);
    }
  } else {
    fill(255, 255, 255, 200);
    rect(width / 4, height / 4, width / 2, height / 2);
    fill(0);
    textAlign(CENTER, CENTER);
    text("GAMEOVER", width / 2, height / 2);
  }
}

Tower findTowerStats(PVector place){
if (currentButton.getText().equals("Tower1")){
return new Tower(20,20,20,20,place);
}

if (currentButton.getText().equals("Tower2")){
return new Tower(30,30,30,30,place);
}
return new Tower(10,10,10,10,place);
}


boolean onPath(PVector location) {
  for (PVector tile : path) {    
    if (location.x >= tile.x - gridSize / 2 && location.x <= tile.x + gridSize / 2 && location.y >= tile.y - gridSize / 2 && location.y <= tile.y + gridSize / 2) {
      return true;
    }
  }
  
  return false;
}

boolean isOnPath(Level level){
  PVector[] pathLocation = level.getPathTowers();
  PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));
  for (PVector blocks: pathLocation){
    if(place.x == blocks.x && place.y == blocks.y){
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


void mouseClicked() {
if (currentButton != null) {
    String f = currentButton.function;
        PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));  
        
    if (f.equals("Tower")) {
      if (!isOnPath(level) && !currentButton.mouseOver() && mouseX >= uiWidth && !onTower(place)){
         currentTower = findTowerStats(place);
         preview = currentTower;
         towers.add(currentTower);
         this.money -= currentTower.getCost();
        placingTower = true;
      } 
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
  }
}


void addEnemy(){
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < path.length - 1; i++){
    PVector currPath = path[i];
    for (int k = 0; k < enemies.size(); k++){
      Enemy currEnemy = enemies.get(k);
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

/* OLD CODE: 

Level level;
ArrayList<Tower> towers = new ArrayList<Tower>();
ArrayList<Button> buttons = new ArrayList<Button>();
Button currentButton;
Tower preview;
Tower currentTower;
boolean placingTower = false;

  int money = 500;
  int gridSize = 50;
  int cols;
  int rows;
  int uiCols = 3;
  int uiWidth = gridSize * uiCols;


void setup() {

  size(950, 600);
  cols = (width - uiWidth) / gridSize;
  rows = height / gridSize;
  level = new Level(50, "test");
  level.setup();
  towerButtons();

}



void towerButtons() {

  for (int i = 0; i < 3; i++) {
    PVector position = new PVector(0, i * gridSize + 3 * gridSize);
    Button button = new Button(position, gridSize * 3, gridSize, "Tower" + i);
    buttons.add(button);
  }
}



void draw() {
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

   for (Tower t : towers) {
     t.display();
   }



    if (preview != null && mouseX >= uiWidth) {
    PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    preview.setLocation(location);
    preview.display();
  }



  for (Button button : buttons) {
    button.display();
    if (button.mouseOver()) {
      currentButton = button;
    }
  }
}



Tower findTowerStats(PVector place){
if (currentButton.getText().equals("Tower1")){
return new Tower(20,20,20,20,place);
}

if (currentButton.getText().equals("Tower2")){
return new Tower(30,30,30,30,place);
}
return new Tower(10,10,10,10,place);
}



void mouseClicked(){
    if (!isOnPath(level) && !currentButton.mouseOver() && mouseX >= uiWidth){
    PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));
      currentTower = findTowerStats(place);
      towers.add(currentTower);
      this.money -= currentTower.getCost();
    }

}      



boolean isOnPath(Level level){
  PVector[] pathLocation = level.getPathTowers();
  PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));
  for (PVector blocks: pathLocation){
    if(place.x == blocks.x && place.y == blocks.y){
      return true;
    }
  }
  return false;
}

*/
