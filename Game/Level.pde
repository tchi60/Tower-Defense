class Level {
  private int pathBlocks;
  private int gridSize = 50;
  private String type;
  private int w = width / gridSize, h = height / gridSize;
  private ArrayList<int[]> path = new ArrayList<int[]>();
  
  public Level(int pb, String t) {
    pathBlocks = pb;
    type = t;
  }
  
  public void draw() {
    int[] start = {0, gridSize};
    int[][] directions = {{-gridSize * 2, 0}, {gridSize * 2, 0}, {0, -gridSize * 2}, {0, gridSize * 2}};
    int[] last = start;
    
    for (int i = 0; i < pathBlocks; i++) {
      for (int[] direction : directions) {
        if ((last[0] - direction[0] >= 0) && (last[0] - direction[0] <= width - gridSize) && (last[1] - direction[1] >= 0) && (last[1] - direction[1] <= height - gridSize)) {
        
        }
      }
    }
  }
  
  
}
