public class Enemy{
  private float health;
  private float speed;
  private float oriSpeed;
  private int frozen;
  private String type;
  private PVector position;
  public boolean isAlive;
  public int myColor;
  private PVector dir;
  
  public Enemy(float myHealth, float s, String myType, PVector myPosition){
    health = myHealth;
    speed = s;
    oriSpeed = speed;
    frozen = 0;
    type = myType;
    position = myPosition;
    isAlive = true;
    myColor = (int)(Math.random() * 255);
    dir = new PVector(0,0);
  }
  public float getHealth(){
    return health;
  }
  public float getSpeed(){
    return speed;
  }
  
  public float getOriSpeed(){
    return oriSpeed;
  }
  
  public int getFrozen(){
    return frozen;
  }
  
  public void setFrozen(int f) {
   frozen = f; 
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
    health -= myTower.getDamage();
    if (health <= 0){
      isAlive = false;
    }
  }
  
  public void setSpeed(int n){
    speed = n;
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
