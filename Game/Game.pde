class Game{
  int numLevel;
  float spawnRate;
  ArrayList<Enemy> enemies;
  ArrayList<Tower> towers;
  int numPaths;
  int baseHealth;
  ArrayList<String> levelTypes;
  Level level;
  float enemySpeed;
  
  setup(){
    numPaths = 10;
    int indLevelType = (int)(Math.random() * levelTypes.size());
    level = new Level(numPaths, levelTypes.get(indLevelType));
    baseHealth = 100;
    towers = new ArrayList<Tower>();
    enemies = new ArrayList<Enemy>();
    spawnRate = 10;
    level.create();
  }
  
  void draw(){
    updateLevel();
    updateTower();
    if (frameCount % spawnRate == 0){
      addEnemy();
    }
  }
  
  addEnemy(){
    Enemy newEnemy = new Enemy(100, 0.9, 
    
