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
towers.add(new Tower(10,10,10,10,place));
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
