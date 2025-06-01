<<<<<<< HEAD
public class Tower{
private float damage, rate, cost, range;
private String type;
private PVector location;

public Tower(float damage, float rate, float cost, float range, PVector location){
=======
//Instance Variables
class Tower{
float damage, rate, cost, range;
String type;
PVector location;

Tower(float damage, float rate, float cost, float range, PVector location){
>>>>>>> main
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
}


<<<<<<< HEAD
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
=======
float getDamage(){
return damage;
}

float getRate(){
return rate;
}

float getCost(){
return cost;
}

float getRange(){
return range;
}

PVector getLocation(){
return location;
}


void shoot(Array list){
>>>>>>> main
  for (Enemy enemy:list){
    if (withinRange(enemy) <= range){
      enemy.damage(this);
    }
  }
}

<<<<<<< HEAD
public float withinRange(Enemy enemy){
  return sqrt(pow((location.x - enemy.getX()), 2) + pow((location.y - enemy.getY()),2));
}
=======
float withinRange(Enemy enemy){
  return sqrt(pow((location.x-enemy.x), 2) + pow((location.y-enemy.y),2));
   
}

>>>>>>> main
}
