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

int uiCols = 3;
int uiWidth = gridSize * uiCols;

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
  towers = new ArrayList<Tower>();
  enemies = new ArrayList<Enemy>();
  buttons = new ArrayList<Button>();
  spawnRate = 10;
  level.setup();
  towerButtons();
  settingsButton();
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

  currentButton = null;
  for (Button button : buttons) {
    button.draw();
    if (button.mouseOver()) {
      currentButton = button;
    }
  }

  for (Tower tower : towers) {
    tower.display();
  }

  if (preview != null && mouseX >= uiWidth) {
    PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    preview.setLocation(location);
    preview.display();
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
}


void mouseClicked() {
  if (placingTower && currentButton == null && mouseX >= uiWidth) {
    PVector location = new PVector(mouseX / gridSize * gridSize, mouseY / gridSize * gridSize);
    towers.add(new Tower(10, 10, 10, 10, location));
    preview = null;
    placingTower = false;
    
  } else if (currentButton != null) {
    String f = currentButton.function;
    
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
  
