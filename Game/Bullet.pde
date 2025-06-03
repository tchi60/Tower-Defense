public class Bullet{
  private PVector location;
  private Enemy target;
  private Tower source;
  private PVector dir;
  private float speed;
  
  public Bullet(Tower mySource, Enemy myTarget){
    source = mySource;
    target = myTarget;
    float dx = source.getLocation().x - target.getX();
    float dy = source.getLocation().y - target.getY();
    
  }
  
  public Tower getSource(){
    return source;
  }
  public Enemy getTarget(){
    return target;
  }
  
  public void updateBullet(){
  }
}
