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

void setup() {
  size(800, 600);
  numPaths = 10;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  spawnRate = 10;
  level.setup();
}

void draw() {
  background(0);

  int gridSize = 50;
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
  /*if (frameCount % spawnRate == 0){
    addEnemy();
  }
  if (frameCount % enemySpeed == 0){
    updateEnemy();
  }*/
}

/*void addEnemy(){
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes.get(levelType), enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < enemies.size(); i++){
    enemies.get(i).getX();
  }
}*/
  
      
