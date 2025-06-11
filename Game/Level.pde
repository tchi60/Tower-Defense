<<<<<<< HEAD
class Level {
  private int pathBlocks;
  private int gridSize = 50;
=======

class Level {
  private int pathBlocks;
  private int gridSize = 50;
  private int uiCols = 3;
>>>>>>> 632d5e38d83fc22bc6308a6562a62f28e552b8cd
  private String type;
  private int w, h;
  private PVector[] path;
  private int pathIndex;

  Level(int pb, String t) {
    pathBlocks = pb;
    type = t;
    w = width / gridSize;
    h = height / gridSize;
    path = new PVector[pathBlocks];
  }
  
  int getGridSize() {
    return gridSize;
  }

  void setup() {
    boolean success = false;

    while (success == false) {
      pathIndex = 0;
      int startY = int(random(3, h - 3));
      PVector start = new PVector(uiCols, startY);
      path[pathIndex] = start;
      pathIndex++;
      success = create(start, 1);
    }
  }

  boolean create(PVector current, int amount) {
    if (amount == pathBlocks) {
      return current.x == w - 1;
    }

    int[][] dirs = {
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1}
    };

    int first = int(random(0, 4));
    int second = int(random(0, 4));
    int third = int(random(0, 4));
    int fourth = int(random(0, 4));

    while (second == first) {
      second = int(random(0, 4));
    }

    while (third == first || third == second) {
      third = int(random(0, 4));
    }

    while (fourth == first || fourth == second || fourth == third) {
      fourth = int(random(0, 4));
    }

    int[] order = {first, second, third, fourth};

    for (int i = 0; i < 4; i++) {
      int newX = int(current.x) + dirs[order[i]][0];
      int newY = int(current.y) + dirs[order[i]][1];

      if (newX < uiCols || newY < 0 || newX >= w || newY >= h)
        continue;
      if (visited(newX, newY))
        continue;
      if (block(newX, newY))
        continue;

      PVector next = new PVector(newX, newY);
      path[pathIndex] = next;
      pathIndex++;

      if (create(next, amount + 1))
        return true;

      pathIndex--;
    }

    return false;
  }

  boolean visited(int x, int y) {
    for (int i = 0; i < pathIndex; i++) {
      if (x == path[i].x && y == path[i].y)
        return true;
    }

    return false;
  }

  boolean block(int x, int y) {
    boolean up = visited(x, y - 1);
    boolean down = visited(x, y + 1);
    boolean left = visited(x - 1, y);
    boolean right = visited(x + 1, y);
    boolean upLeft = visited(x - 1, y - 1);
    boolean upRight = visited(x + 1, y - 1);
    boolean downRight = visited(x + 1, y + 1);  
    boolean downLeft = visited(x - 1, y + 1);

    if (up && left && upLeft)
      return true;

    if (down && left && downLeft)
      return true;

    if (down && right && downRight)
      return true;

    if (up && right && upRight)
      return true;

    return false;
  }
  PVector[] getPath() {
    PVector[] centers = new PVector[pathBlocks];

    for (int i = 0; i < pathBlocks; i++) {
      centers[i] = new PVector(path[i].x * gridSize + gridSize / 2, path[i].y * gridSize + gridSize / 2);
    }
    
    return centers;
  }
<<<<<<< HEAD
  
    PVector[] getPathTowers() {
=======

  PVector[] getPathTowers() {
>>>>>>> 632d5e38d83fc22bc6308a6562a62f28e552b8cd
    PVector[] centers = new PVector[pathBlocks];
    
    for (int i = 0; i < pathBlocks; i++) {
      centers[i] = new PVector(path[i].x * gridSize, path[i].y * gridSize);
    }
    
    return centers;
  }
<<<<<<< HEAD
=======

>>>>>>> 632d5e38d83fc22bc6308a6562a62f28e552b8cd

  void draw() {
    noStroke();
    
    for (int i = 0; i < pathBlocks; i++) {
      fill((80 + 175 / pathBlocks * i) - 30);
      rect(path[i].x * gridSize - 2, path[i].y * gridSize - 2, gridSize + 4, gridSize + 4);
    }
    
    for (int i = 0; i < pathIndex; i++) {
      fill(80 + 175 / pathBlocks * i);
      rect(path[i].x * gridSize, path[i].y * gridSize, gridSize, gridSize);
    }
  }
}
