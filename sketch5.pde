// Pressing Control-R will render this sketch.

int maxX = 500;
int maxY = 500;
int backgroundLineColor = 0x10FF0000;
int backgroundLineSpacing = 50; // number of pixels between lines/triangles.
float sin60 = sin(radians(60));
int x = 0;

void setup() {  // this is run once.   
    
    // set the background color
    background(255);
    
    // canvas size (Integers only, please.)
    size(maxX, maxY); 
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
    
    // set the width of the line. 
    strokeWeight(1);

    drawBackgroundLines();
    // println("foo");
}

void drawBackgroundLines() {
    drawBackgroundLineGroup();

    rotate(radians(120));

    drawBackgroundLineGroup();

    rotate(radians(120));
    
    drawBackgroundLineGroup();

    popMatrix();
    popMatrix();    
}

void drawBackgroundLineGroup() {
    for (int i = -600; i < 600; i+= backgroundLineSpacing) {
        stroke(backgroundLineColor);
        line(i, maxX * -2, i, maxX * 2);
    }
}

void draw() {
}

void mouseClicked() {
    // println("mouse clicked " + x++);
    if (x == 0) {
        stroke(#FF0000);
        fill(#FF0000);
        x++;
    } else {
        stroke(#FFFFFF);
        fill(#FFFFFF);
        x--;
    }
    triangle(100, 100, 100, 200, 100 + 100*sin60, 150);
}
