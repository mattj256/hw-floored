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

// int TRIANGLE_LEFT = 0;
// int TRIANGLE_RIGHT = 1;
int[][] trianglesInColumn;

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

    trianglesInColumn = getTrianglesInColumn();
    // println(trianglesInColumn);
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

int[][] getTrianglesInColumn() {
    ArrayList pointList = new ArrayList();
    for (int y = 0; y < maxY; y += triangleHeight) {
        // left-facing triangle
        pointList.add({
                // center
                2 / 3 * triangleWidth, y,
                // three vertices
                triangleWidth, y - halfTriangleHeight,
                triangleWidth, y + halfTriangleHeight,
                0, y
        });
        // right-facing triangle
        pointList.add({
                // center
                1 / 3 * triangleWidth, y + halfTriangleHeight,
                // three vertices
                0, y,
                0, y + triangleHeight,
                triangleWidth, y + halfTriangleHeight
        });
    }
    return pointList.toArray(new int[pointList.size()]);
}

void mouseClicked() {
    color c = #0000FF; // get(mouseX, mouseY);
    stroke(c);
    fill(c);
    float[] coords = getNearestTriangle(mouseX, mouseY);
    triangle(coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
    println(x++);
}

float[] getNearestTriangle(int x, int y) {
    int columnNumber = floor(x / triangleWidth);
    int offsetX = columnNumber * triangleWidth;
    int relativeX = x - offsetX;
    int relativeY = y;
    float[] bestTriangle;
    int bestDistance = triangleSideLength * 5;
    for (int i = 0; i < trianglesInColumn.length; i++) {
        int[] triangleCoords = trianglesInColumn[i];
        int centerX = triangleCoords[0];
        int centerY = triangleCoords[1];
        int newDistance = dist(relativeX, relativeY, centerX, centerY);
        if (newDistance < bestDistance) {
            bestDistance = newDistance;
            bestTriangle = triangleCoords;
        }
    }
    // println(bestTriangle);
    float[] returnVal = new float[8];
    arrayCopy(bestTriangle, returnVal);
    returnVal[0] += offsetX;
    returnVal[2] += offsetX;
    returnVal[4] += offsetX;
    returnVal[6] += offsetX;
    return returnVal;
}

