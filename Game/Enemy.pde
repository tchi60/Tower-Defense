public class Enemy{
  private float health;
  private float defense;
  private String type;
  private PVector position;
  public boolean isAlive;
  public int myColor;
  private PVector dir;
  private float enemySpeed;
  
  public Enemy(float myHealth, float myDefense, float mySpeed, String myType, PVector myPosition){
    health = myHealth;
    defense = myDefense;
    type = myType;
    position = myPosition;
    isAlive = true;
    myColor = (int)(Math.random() * 255);
    dir = new PVector(0,0);
    enemySpeed = mySpeed;
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

  public void damage(Tower myTower){
    health -= myTower.getDamage() * defense;
    if (health <= 0){
      isAlive = false;
    }
  }

  public void setPosition(PVector x){
    position = x;
  }
  public PVector getDir(){
    return dir;
  }
  public void setDir(PVector x){
    dir = x;
  }
  public PVector getNextDir(int i, PVector[] paths){
  PVector curr = paths[i];
  PVector next = paths[i + 1];
  PVector out = new PVector(0,0);
  PVector N = new PVector(0, -1 * enemySpeed);
  PVector E = new PVector(enemySpeed, 0);
  PVector S = new PVector(0, enemySpeed);
  PVector W = new PVector(-1 * enemySpeed,0);
  if (next.x > curr.x){
    out = E;
  }
  if (next.x < curr.x){
    out = W;
  }
  if (next.y > curr.y){
    out = S;
  }
  if (next.y < curr.y){
    out = N;
  }
  return out;
}

}
