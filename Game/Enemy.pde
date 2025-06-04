public class Enemy{
  private float health;
  private float defense;
  private String type;
  private PVector position;
  public boolean isAlive;
  public int myColor;
  private PVector dir;
  
  public Enemy(float myHealth, float myDefense, String myType, PVector myPosition){
    health = myHealth;
    defense = myDefense;
    type = myType;
    position = myPosition;
    isAlive = true;
    myColor = (int)(Math.random() * 255);
    dir = new PVector(0,0);
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
}
