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
