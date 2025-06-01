int numLevel; 
float spawnRate;
ArrayList<Enemy> enemies;
ArrayList<Tower> towers;
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

int gridSize = 50;
int cols = width / gridSize;
int rows = height / gridSize;


void setup() {
  size(800, 600);
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  buttons = new ArrayList<Button>();
  spawnRate = 100;
  enemySpeed = 1;
  level.setup();
  towerButtons();
  path = level.getPath();
  enemyStart = path[0];
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
  towerButtons();
}

void towerButtons() {
  for (int i = 0; i < 5; i++) {
    PVector position = new PVector(0, i * gridSize);
    Button button = new Button(position, gridSize * 2, gridSize, "button");
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
      rect(x * gridSize, y * gridSize, gridSize, gridSize);
    }
  }

  level.draw();
  for (int i = 0; i < enemies.size(); i++){
    drawEnemy(enemies.get(i));
  }
  for (Button button : buttons) {
    button.draw();
    
    if (button.mouseOver()) {
      currentButton = button;
    }
  }
  if (frameCount % spawnRate == 0){
    addEnemy();
  }
  if (frameCount % enemySpeed == 0){
    updateEnemy();
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
        PVector myDir = Game.getNextDir(i, path);
        currEnemy.setDir(myDir);
      }
      if(Math.abs(currPos.x - currPath.x) <= level.getGridSize() / 2 && Math.abs(currPos.y - currPath.y) <= level.getGridSize() / 2){
        currEnemy.setPosition(currPos.add(currEnemy.getDir()));
      }
    }
  }
}

void drawEnemy(Enemy myEnemy){
  PVector position = new PVector(myEnemy.getX(), myEnemy.getY());
  fill(myEnemy.myColor, 0, 0);
  stroke(myEnemy.myColor, 0, 0);
  rect(position.x, position.y, 10, 20);
}
  
public static PVector getNextDir(int i, PVector[] paths){
  PVector curr = paths[i];
  PVector next = paths[i + 1];
  PVector out = new PVector(0,0);
  PVector N = new PVector(0, -1);
  PVector E = new PVector(1, 0);
  PVector S = new PVector(0, 1);
  PVector W = new PVector(-1,0);
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
