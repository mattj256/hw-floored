// All measurements are in pixels.

int maxX = 500;
int maxY = 500;
int triangleSideLength = 50;
color backgroundLineColor = color(#FF0000); //  color(0x10FF0000);
color backgroundColor = color(#FFFFFF);

// Equilateral triangles are oriented with left or right side vertical:
//
//  *
//  *  *
//  *     *
//  *        *
//  *     *  *
//  *  *     *
//  *        *
//  *  *     *
//  *     *  *
//  *        *
//  *     *
//  *  *
//  *

int triangleHeight = triangleSideLength;
int halfTriangleHeight = triangleHeight * 0.5;
int triangleWidth = triangleSideLength * sqrt(3) / 2;
int x;

int TRIANGLE_LEFT = 0;
int TRIANGLE_RIGHT = 1;
// int[][] triangleCentersInColumn;

void setup() {
    background(backgroundColor);
    
    // canvas size
    size(maxX, maxY); 
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
    
    // set the width of the line. 
    strokeWeight(1);

    triangleCentersInColumn = getTriangleCentersInColumn();
    println(triangleCentersInColumn);
    drawBackgroundTriangles();
}

void drawBackgroundTriangles() {

    stroke(backgroundLineColor);
    int column = 0;
    for (int x = 0; x < maxX; x += triangleWidth) {
        column++;
        int y;
        if (column % 2 != 0) {
            y = 0
        } else {
            y = -1 * halfTriangleHeight;
        }

        for (; y < maxY; y+= triangleHeight) {
            // println(x + ", " + y);

            triangle(
                    x, y, 
                    x, y + triangleHeight, 
                    x + triangleWidth, y + halfTriangleHeight
            );
        }
    }
}

int[][] getTriangleCentersInColumn() {
    ArrayList pointList = new ArrayList();
    for (int y = 0; y < maxY; y += triangleHeight) {
        pointList.add({y, 2 / 3 * triangleWidth, TRIANGLE_LEFT});
        pointList.add({y + halfTriangleHeight, 1 / 3 * triangleWidth, TRIANGLE_RIGHT});
    }
    return pointList.toArray(new int[pointList.size()]);
}

/*
int[] getTriangleCorners(int[] triangleCenterAndOrientation) {
    int centerX = triangleCenterAndOrientation[0];
    int centerY = triangleCenterAndOrientation[1];
    int orientation = triangleCenterAndOrientation[2];

    if (orientation == TRIANGLE_LEFT) {
        return {centerX - triangleWidth };
    } //
}
*/

void mouseClicked() {
    color c = get(mouseX, mouseY);
    stroke(c);
    fill(c);
    triangle(0, 0, 0, triangleHeight, halfTriangleHeight, triangleWidth);
    println(x++);
}

/*
int[] getNearestTriangleCenter(int x, int y) {
    int leftX = floor(x / triangleWidth);
    int relativeX = x - leftX;
    int relativeY = y;
    for (int testY = 0; testY <
}
*/

/*
int integerDivide(int a, int b) {
    float quotient = a / b;
    return quotient > 0 ? floor(quotient) : ceiling(quotient);
}
*/
