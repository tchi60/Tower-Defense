Level level;

void setup() {
  size(800, 600);
  level = new Level(50, "test");
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
}
