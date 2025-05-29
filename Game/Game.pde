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

void setup() {
  size(800, 600);
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  spawnRate = 5;
  enemySpeed = 5;
  level.setup();
  path = level.getPath();
  enemyStart = path[0];
}

void draw() {
  background(0);

  int gridSize = level.gridSize;
  int cols = width / gridSize;
  int rows = height / gridSize;

  stroke(30);
  strokeWeight(2);
  noFill();

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      rect(x * gridSize, y * gridSize, gridSize, gridSize);
    }
  }

  level.draw();
  if (frameCount % spawnRate == 0 && frameCount > 10){
    addEnemy();
  }
  if (frameCount % enemySpeed == 0 && frameCount > 10){
    updateEnemy();
  }
}

void addEnemy(){
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < enemies.size(); i++){
    Enemy currEnemy = enemies.get(i);
    PVector currPos = currEnemy.position;
    int currPath = currEnemy.getPathBlock(path, level.gridSize / 2);
    PVector dir = Game.getNextDir(currPath, path);
    currPos.add(dir);
    currEnemy.position = currPos;
    drawEnemy(currEnemy);
  }
}

void drawEnemy(Enemy myEnemy){
  PVector position = myEnemy.position;
  fill(255, 0, 0);
  stroke(255, 0, 0);
  rect(position.x, position.y, 50, 10);
}
  
public static PVector getNextDir(int i, PVector[] paths){
  PVector curr = paths[i];
  PVector next = paths[i + 1];
  PVector out = new PVector(0,0);
  PVector N = new PVector(0, -10);
  PVector E = new PVector(10, 0);
  PVector S = new PVector(0, 10);
  PVector W = new PVector(-10,0);
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
