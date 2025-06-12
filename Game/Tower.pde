
//Instance Variables
class Tower{
private float damage, rate, cost, range;
private String type;
private PVector location;
private color colour;

Tower(float damage, float rate, float cost, float range, PVector location, String t, int[] c){
this.damage = damage;
this.rate = rate;
this.cost = cost;
this.range = range;
this.location = location;
type = t;
colour = color(c[0], c[1], c[2]);
}


float getDamage(){
return damage;
}

float getRate(){
return rate;
}

void setDamage(float d) {
  damage = d;
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
    if (withinRange(enemy) <= range*range && 0 == frameCount % (rate * 30)){
      Bullet b = new Bullet(this, enemy);
      bullets.add(b);
      
      if (type.equals("freeze")) {
        freeze(enemy);
      } else if (type.equals("aoe")) {
        aoe(enemy);
      }
      
      break;
    }
  }
}

void freeze(Enemy e) {
  e.setSpeed(0);
}

void aoe(Enemy e) {
  float radius = 75;
  
  fill(255, 100, 100);
  noStroke();
  circle(e.getX(), e.getY(), 75);
  fill(255, 180, 100);
  noStroke();
  circle(e.getX(), e.getY(), 50);
  fill(255, 255, 100);
  noStroke();
  circle(e.getX(), e.getY(), 25);
  
  for (Enemy other : enemies) {
    if (!other.isAlive) continue;
    
    float dx = e.getX() - other.getX();
    float dy = e.getY() - other.getY();
    float d = dx * dx + dy * dy;

    if (d <= radius * radius) {
      other.damage(this);
    }
  }
}

float withinRange(Enemy enemy){
    float x = location.x + gridSize / 2 - enemy.getX();
    float y = location.y + gridSize / 2 - enemy.getY();
    return x*x + y*y;
}

void display(){
  fill(colour);
  rect(location.x, location.y, 50, 50);
}
}
