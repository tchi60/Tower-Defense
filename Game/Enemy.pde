public class Enemy{
  private float speed;
  private float health;
  private float defense;
  private String type;
  private PVector position;
  public boolean isAlive;
  
  public Enemy(float mySpeed, float myHealth, float myDefense, String myType, PVector myPosition){
    speed = mySpeed;
    health = myHealth;
    defense = myDefense;
    type = myType;
    position = myPosition;
    isAlive = true;
  }
  public float getSpeed(){
    return speed;
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
  
