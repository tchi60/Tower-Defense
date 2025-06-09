class Button {
  private PVector position;
  private int w, h;
  private String text;
  private String function;
  private color c;
  
  Button(PVector p, int wid, int hei, String t, String f) {
    position = p;
    w = wid;
    h = hei;
    text = t;
    function = f;
    c = color(255);
  }
  
  String getText() {
    return text;
  }
  
  void setPosition(PVector p) {
    position = p; 
  }
  
  boolean mouseOver() {
    if (mouseX >= position.x && mouseY >= position.y && mouseX <= position.x + w && mouseY <= position.y + h) {
      c = color(200);
      return true;
      
    }
    c = color(255);
    return false;
  }
  
  void draw() {
    stroke(0);
    fill(c);
    strokeWeight(3);
    rect(position.x, position.y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(text, position.x + w / 2, position.y + h / 2);
  }
}
