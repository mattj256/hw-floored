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
    strokeWeight(1);
} 

void draw() {
    if (i > 300) { return; }
    stroke(#FF0000);
    line(i, 0, i, 300);
    i += 20;
}
