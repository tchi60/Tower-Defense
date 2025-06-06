//Instance Variables
class Tower{
private float damage, rate, cost, range;
private String type;
private PVector location;
private color colour;
private boolean cooldown;

Tower(float damage, float rate, float cost, float range, PVector location){
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
cooldown = false;
colour = color(150, 150, 200);
}


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

color getColor() {
  return colour;
}

void setLocation(PVector l) {
  location = l;
}

void invalid() {
  colour = color(255, 0, 0);
}

void valid() {
  colour = color(0, 255, 0);
}

void shoot(ArrayList<Enemy> list){
  for (Enemy enemy:list){
    if (withinRange(enemy) <= range*range && cooldown == false){
      enemy.damage(this);
      cooldown = true;
      
      if (frameCount % 2 == 0) {
        cooldown = false;
      }
    } else {
      break;
    }
  }
}

float withinRange(Enemy enemy){
    float x = location.x - enemy.getX();
    float y = location.y - enemy.getY();
    return x*x + y*y;
}

void display(){
  fill(colour);
  rect(location.x, location.y, 50, 50);
}
}
