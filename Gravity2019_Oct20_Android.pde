// Gravity2019_Oct20_Android A. Kozma, T. Lichtenberg, D. Parson
// This version is for creating a display screen 
// for the android devices

ScrollBar scrollbar;
int numItems = 8;

void setup() {
 fullScreen(P2D);
 orientation(LANDSCAPE);
 scrollbar = new ScrollBar(0.2 * height * numItems, 0.1 * width);
 noStroke();
}

void draw() {
 background(255);
 pushMatrix();
 translate(1, scrollbar.translateX);
 for(int i = 0; i < numItems; i++) {
  fill(map(i, 0, numItems - 1, 200, 0));
  rect(20, i * 0.2 * height + 20, width - 40, 0.2 * height - 20);
 }
 popMatrix();
 scrollbar.draw();
}

public void mousePressed() {
 scrollbar.open(); 
}

public void mouseDragged() {
 scrollbar.update(mouseY - pmouseY); 
}

void mouseReleased() {
 scrollbar.close(); 
}

class ScrollBar {
 float totalHeight;
 float translateX;
 float opacity;
 float barWidth;
 
 ScrollBar(float h, float w) {
  totalHeight = h;
  barWidth = w;
  translateX = 0;
  opacity = 0;
 }
 
 void open() {
   opacity = 150;
 }
 
 void close() {
  opacity = 0; 
 }
 
 void update(float dx) {
  if(totalHeight + translateX + dx > height) {
   translateX += dx;
   if(translateX > 0) {
    translateX = 0; 
   }
  }
 }
  void draw() {
   if(0 < opacity) {
    float frac = (height / totalHeight);
    float x = width - 1.5 * barWidth;
    float y = PApplet.map(translateX / totalHeight, -1, 0, height, 0);
    float w = barWidth;
    float h = frac * height;
    pushStyle();
    fill(150, opacity);
    rect(x, y, w, h, 0.2 *w);
    popStyle();
   }  
 }
}
