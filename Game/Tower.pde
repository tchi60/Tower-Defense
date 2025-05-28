public class Tower{
private float damage, rate, cost, range;
private String type;
private PVector location;

public Tower(float damage, float rate, float cost, float range, PVector location){
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
}


public float getDamage(){
return damage;
}

public float getRate(){
return rate;
}

public float getCost(){
return cost;
}

public float getRange(){
return range;
}

public PVector getLocation(){
return location;
}
public String getType(){
  return type;
}

public void shoot(ArrayList<Enemy> list){
  for (Enemy enemy:list){
    if (withinRange(enemy) <= range){
      enemy.damage(this);
    }
  }
}

public float withinRange(Enemy enemy){
  return sqrt(pow((location.x - enemy.getX()), 2) + pow((location.y - enemy.getY()),2));
}
}
