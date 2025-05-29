class Button {
  private PVector position;
  private int w, h;
  private String text;
  
  Button(PVector p, int wid, int hei, String t) {
    position = p;
    w = wid;
    h = hei;
    text = t;
  }
  
  boolean mouseOver() {
    if (mouseX >= position.x && mouseY >= position.y && mouseX <= position.x + w && mouseY <= position.y + h) {
      return true;
    }
    return false;
  }
  
  void draw() {
    stroke(0);
    fill(255);
    strokeWeight(3);
    rect(position.x, position.y, w, h);
    fill(0);
    textAlign(CENTER);
    text(text, position.x + w / 2, position.y + h / 2);
  }
}
