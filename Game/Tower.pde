class Tower{
float damage, rate, cost, range;
String type;
PVector location;
ArrayList<Bullet> bullets;

Tower(float damage, float rate, float cost, float range, PVector location){
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
bullets = new ArrayList<Bullet>();
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

ArrayList<Bullet> getBullets(){
  return bullets;
}


void shoot(Enemy[] list){
  for (Enemy enemy:list){
    if (withinRange(enemy) <= range*range){
      enemy.damage(this);
      Bullet myBullet = new Bullet(this, enemy);
      bullets.add(myBullet);
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
