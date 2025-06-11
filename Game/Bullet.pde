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
    location.x += 25;
    location.y += 25;
    dx = target.getX() - 25 - source.getLocation().x;
    dy = target.getY() - 25 - source.getLocation().y;
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
    float e = dist(source.getLocation().x, source.getLocation().y, target.getX(), target.getY());
    
    if (d < 20 || target.getHealth() <= 0 || location.dist(source.getLocation()) > min(e * 1.25, e + 25)) {
      target.damage(source);
    
      return true;
    }
    
    return false;
  }
  
  public void updateBullet(){
    dx = target.getX() - 25 - source.getLocation().x;
    dy = target.getY() - 25 - source.getLocation().y;
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
