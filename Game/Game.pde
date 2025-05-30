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
  spawnRate = 100;
  enemySpeed = 10;
  level.setup();
  path = level.getPath();
  enemyStart = path[0];
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
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
  for (int i = 0; i < enemies.size(); i++){
    drawEnemy(enemies.get(i));
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
    PVector dir = Game.getNextDir(i, path);
    for (int k = 0; k < enemies.size(); k++){
      Enemy currEnemy = enemies.get(k);
      PVector currPos = currEnemy.position;
      if(Math.abs(currPos.x - currPath.x) <= level.gridSize / 2 && Math.abs(currPos.y - currPath.y) <= level.gridSize / 2){
        currPos.add(dir);
      }
    }
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
