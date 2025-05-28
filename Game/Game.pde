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
  int levelType;
  PVector enemyStart;
  
  setup(){
    numPaths = 10;
    levelType = (int)(Math.random() * levelTypes.size());
    level = new Level(numPaths, levelTypes.get(levelType));
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
    if (frameCount % enemySpeed == 0){
      updateEnemy();
    }
  }
  
  addEnemy(){
    Enemy newEnemy = new Enemy(100, 0.9, levelTypes.get(levelType), enemyStart);
  }
  
  updateEnemy(){
    for (int i = 0; i < enemies.size(); i++){
      
