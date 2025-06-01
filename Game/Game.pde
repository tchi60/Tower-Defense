
Level level;
ArrayList<Tower> towers = new ArrayList<Tower>();
ArrayList<Button> buttons = new ArrayList<Button>();
Button currentButton;
Tower currentTower;

  int money = 500;
  int gridSize = 50;
  int cols = width / gridSize;
  int rows = height / gridSize;
  int uiCols = 3;
  int uiWidth = gridSize * uiCols;

void setup() {
  size(800, 600);
  level = new Level(50, "test");
  level.setup();
  towerButtons();
}

void towerButtons() {
  for (int i = 0; i < 3; i++) {
    PVector position = new PVector(0, i * gridSize + 3 * gridSize);
    
    Button button = new Button(position, gridSize * 2, gridSize, "Tower" + i);
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
   
  for (Button button : buttons) {
    button.display();
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
PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));

for (Button button : buttons) {
    if (button.isClicked()){
      currentButton = button;
      println(currentButton.getText());
    }
}

//println(currentButton.isClicked());
println(isOnPath(level));
}

/*
    if (!isOnPath(level))){
      currentTower = findTowerStats(place);
      towers.add(currentTower);
      this.money -= currentTower.getCost();
      println(currentTower.getCost());
      }
      */
      
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



//check is place is on path before adding
/*  if (!isOnPath(level)){
     towers.add(currentTower);
     this.money -= currentTower.getCost();
     PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));
  }
*/



// PREVIOUS CODE
/*
Level level;
ArrayList<Tower> towers = new ArrayList<Tower>();

  int money = 500;
  int gridSize = 50;
  int cols = width / gridSize;
  int rows = height / gridSize;


void setup() {
  size(800, 600);
  level = new Level(50, "test");
  level.setup();
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
  
  fill(#C1F8FF);
  text(towers.size(), 20, 40);
  text(money, 20, 60);
  
   for (Tower t : towers) {
     t.display();
   }
}


void mouseClicked(){
PVector place = new PVector(gridSize * (mouseX/gridSize), gridSize * (mouseY/gridSize));
//check is place is on path before adding
if (!isOnPath(level)){
Tower t = new Tower(10,10,10,10,place);
towers.add(t);
this.money -= t.getCost();
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
