public class Enemy{
  private float health;
  private float defense;
  private String type;
  public PVector position;
  public boolean isAlive;
  
  public Enemy(float myHealth, float myDefense, String myType, PVector myPosition){
    health = myHealth;
    defense = myDefense;
    type = myType;
    position = myPosition;
    isAlive = true;
  }
  public float getHealth(){
    return health;
  }
  public float getDefense(){
    return defense;
  }
  public String getType(){
    return type;
  }
  public float getX(){
    return position.x;
  }
  public float getY(){
    return position.y;
  }
  public int getPathBlock(PVector[] paths, int gridSize){
  int currPath = 0;
  for (int i = 0; i < paths.length; i++){
    currPath = i;
    if (position.x <= paths[i].x + gridSize && position.x >= paths[i].x - gridSize){
      if (position.y <= paths[i].y + gridSize && position.y >= paths[i].y - gridSize){
        break;
      }
    }
  }
  return currPath;
  }
  public void damage(Tower myTower){
    health -= myTower.getDamage() * defense;
    if (health <= 0){
      isAlive = false;
    }
  }
}
