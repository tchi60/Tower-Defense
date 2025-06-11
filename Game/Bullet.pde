public class Bullet{
  private PVector location;
  private Enemy target;
  private Tower source;
  private PVector dir;
  private float speed = 10;
  private float dx;
  private float dy;
  private float mag;
  
  public Bullet(Tower mySource, Enemy myTarget){
    source = mySource;
    target = myTarget;
    location = source.getLocation().copy();
    dx = target.getX() - source.getLocation().x;
    dy = target.getY() - source.getLocation().y;
    mag = (float)(Math.sqrt(Math.pow(dx, 2) + Math.pow(dy,2)));
    float scale = mag / speed;
    dx /= scale;
    dy /= scale;
    dir = new PVector(dx, dy);
  }
  
  public Tower getSource(){
    return source;
  }
  public Enemy getTarget(){
    return target;
  }
  
  boolean hit(){
    float d = dist(location.x, location.y, target.getX(), target.getY());
    
    if (d < 20 || target.getHealth() <= 0) {
      target.damage(source);
    
      return true;
    }
    
    return false;
  }
  
  public void updateBullet(){
    dx = target.getX() - source.getLocation().x;
    dy = target.getY() - source.getLocation().y;
    mag = (float)(Math.sqrt(Math.pow(dx, 2) + Math.pow(dy,2)));
    float scale = mag / speed;
    dx /= scale;
    dy /= scale;
    dir = new PVector(dx, dy);
    location.add(dir);
    drawBullet();
  }
  
  public void drawBullet(){
    fill(125, 249, 255);
    stroke(125, 249, 255);
    rect(location.x - 2, location.y - 2, 4, 4);
  }
}
