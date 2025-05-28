//Instance Variables
class Tower{
float damage, rate, cost, range;
String type;
PVector location;

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


void shoot(Array list){
  for (Enemy enemy:list){
    if (withinRange(enemy) <= range){
      enemy.damage(this);
    }
  }
}

float withinRange(Enemy enemy){
 return sqrt(pow((location.x-enemy.x), 2) + pow((location.y-enemy.y),2));
   
}

}
