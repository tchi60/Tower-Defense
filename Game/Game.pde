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
ArrayList<Button> buttons;
Button currentButton;
boolean placingTower = false;

int gridSize = 50;
int cols;
int rows;

void setup() {
  size(800, 600);
  
  cols = width / gridSize;
  rows = height / gridSize;
  numPaths = 50;
  levelType = (int)(Math.random() * levelTypes.length);
  level = new Level(numPaths, levelTypes[levelType]);
  baseHealth = 100;
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  buttons = new ArrayList<Button>();
  spawnRate = 10;
  level.setup();
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
  
  for (Button button : buttons) {
    button.draw();
    
    if (button.mouseOver()) {
      currentButton = button;
    } else {
      currentButton = null;
    }
  }
  
  for (Tower tower : towers) {
    tower.display();
  }
  
  if (preview != null) {
    PVector location = new PVector(mouseX - gridSize / 2, mouseY - gridSize / 2);
    
    preview.setLocation(location);
    preview.display();
  }
  
  if (frameCount % spawnRate == 0){
    addEnemy();
  }
  if (frameCount % enemySpeed == 0){
    updateEnemy();
  }
}

void mouseClicked() {
  if (currentButton != null) {
    if (!placingTower) {
      PVector location = new PVector(mouseX - gridSize / 2, mouseY - gridSize / 2);
    
      preview = new Tower(10, 10, 10, 10, location);
    
      placingTower = true;
    } else {
      PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    
      towers.add(new Tower(10, 10, 10, 10, location));
      
      placingTower = false;
    }

  }
}

void addEnemy(){
  Enemy newEnemy = new Enemy(100, 0.9, levelTypes[levelType], enemyStart);
  enemies.add(newEnemy);
}

void updateEnemy(){
  for (int i = 0; i < enemies.size(); i++){
    
  }
}
  
