// All measurements are in pixels.

int maxX = 500;
int maxY = 500;
int triangleSideLength = 50;
color backgroundLineColor = color(0x10FF0000);
color backgroundColor = color(#FFFFFF);
color COLOR_NOT_FOUND = color(#CAFEBA);
/** The colors to cycle through when the user clicks on a triangle. */
color[] triangleColor = {
    // Don't include duplicate entries. 
    // Don't make any value the same as the background color.
    // Don't make any value the same as COLOR_NOT_FOUND.
    #FF0000,
    #00FF00,
    #0000FF
};

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
int[][] trianglesInEvenColumn;
int[][] trianglesInOddColumn;

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

    trianglesInEvenColumn = getTrianglesInEvenColumn();
    trianglesInOddColumn = getTrianglesInOddColumn();

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

int[][] getTrianglesInEvenColumn() {
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

int[][] getTrianglesInOddColumn() {
    int[][] returnVal = getTrianglesInEvenColumn();
    for (int i = 0; i < returnVal.length; i++) {
        for (int j = 0; j < returnVal[i].length; j += 2) {
            returnVal[i][j] = triangleWidth - returnVal[i][j];
        }
    }
    return returnVal;
}

void mouseClicked() {
    float[] coords = getNearestTriangle(mouseX, mouseY);
    int centerX = coords[0];
    int centerY = coords[1];
    color oldColor = get(centerX, centerY);
    println("Finding new color for " + hex(oldColor));
    color newColor = getNewColor(oldColor);
    println("New color: " + hex(newColor));
    // color c = triangleColor[0]; // #0000FF; // get(mouseX, mouseY);
    stroke(newColor);
    fill(newColor);

    triangle(coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
    println(x++);
}

color getNewColor(color oldColor) {
    if (oldColor == backgroundColor) {
        return triangleColor[0];
    } else {
        for (int i = 0; i < triangleColor.length; i++) {
            println("  comparing " + hex(oldColor) + " to " + hex(triangleColor[i]));
            if (hex(oldColor) == hex(triangleColor[i])) {
                int newIndex = i + 1;
                if (newIndex >= triangleColor.length) {
                    return backgroundColor;
                } else {
                    return triangleColor[newIndex];
                }
            }
        }
    }
    return COLOR_NOT_FOUND;
}

float[] getNearestTriangle(int x, int y) {
    int columnNumber = floor(x / triangleWidth);
    int offsetX = columnNumber * triangleWidth;
    int relativeX = x - offsetX;
    int relativeY = y;
    float[] bestTriangle;
    int bestDistance = triangleSideLength * 5;
    int[][] trianglesToSearch;

    if (columnNumber % 2 == 0) {
        trianglesToSearch = trianglesInEvenColumn;
    } else {
        trianglesToSearch = trianglesInOddColumn;
    }
    
    for (int i = 0; i < trianglesToSearch.length; i++) {
        int[] triangleCoords = trianglesToSearch[i];
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
    for (int i = 0; i < returnVal.length; i += 2) {
        returnVal[i] += offsetX;
    }
    return returnVal;
}

