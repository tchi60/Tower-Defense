class Button {
  private PVector position;
  private int w, h;
  private String text;
  private color c;
  
  Button(PVector p, int wid, int hei, String t) {
    position = p;
    w = wid;
    h = hei;
    text = t;
    c = color(255);
  }
  
  String getText(){
  return text;
  }
  
  boolean mouseOver() {
    if (mouseX >= position.x && mouseY >= position.y && mouseX <= position.x + w && mouseY <= position.y + h) {
      c = color(200);
      return true;
      
    }
    c = color(255);
    return false;
  }
  
  void display() {
    stroke(0);
    fill(c);
    strokeWeight(3);
    rect(position.x, position.y, w, h);
    fill(0);
    textAlign(CENTER);
    text(text, position.x + w / 2, position.y + h / 2);
  }
  
  boolean isClicked() {
    // Check if mouse is within the button's boundaries
    if (mouseX >= position.x && mouseX <= position.x + width && mouseY >= position.y && mouseY <= position.y + height) {
      return true; // Return true if clicked
    } else {
      return false; // Return false if not clicked
    }
  }
  
}
