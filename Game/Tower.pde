//Instance Variables
class Tower{
float damage, rate, cost, range;
String type;
PVector location;
private color colour;

Tower(float damage, float rate, float cost, float range, PVector location){
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
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
    if (withinRange(enemy) <= range*range){
      enemy.damage(this);
    }
  }
}

float withinRange(Enemy enemy){
    float x = location.x - enemy.getX();
    float y = location.y - enemy.getY();
    return x*x + y*y;
}


void display(){
  fill(#C1F8FF);
  rect(location.x, location.y, 50, 50);
}
}
