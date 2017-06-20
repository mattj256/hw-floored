// Pressing Control-R will render this sketch.

int i = 0; 
int x = 0;
int y = 0;

void setup() {  // this is run once.   
    
    // set the background color
    background(255);
    
    // canvas size (Integers only, please.)
    size(300, 300); 
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
    
    // set the width of the line. 
    strokeWeight(12);
} 

void mouseClicked() {
    stroke(0, 0, random(255), 255);
    int newX = mouseX;
    int newY = mouseY;
    line(x, y, newX, newY);
    x = newX;
    y = newY;
}



