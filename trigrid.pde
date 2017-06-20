// All measurements are in pixels.

int maxX = 500;
int maxY = 500;
int triangleSideLength = 50;
color backgroundLineColor = color(0x10FF0000);
// Background color must be completely opaque.
color backgroundColor = color(#FFFFFF);
color COLOR_NOT_FOUND = color(#CAFEBA);
/** The colors to cycle through when the user clicks on a triangle. */
color[] triangleColor = {
    // Don't include duplicate entries. 
    // Don't make any value the same as the background color.
    // Don't make any value the same as COLOR_NOT_FOUND.
    // These values must be completely opaque.
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
    // println("Finding new color for " + hex(oldColor));
    color[] newColor = getNewColors(oldColor);
    // println("New color: " + hex(newColor));

    // First erase the old triangle with the opaque background color.

    // We need to erase a slightly larger triangle than what we draw to ensure
    // that the old triangle's border is completely erased.
    if (alpha(newColor[0]) < 255) {
        strokeWeight(2);
        drawTriangle(backgroundColor, backgroundColor,
                coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
    }

    // Now draw the new triangle, which might have nonopaque colors.
    strokeWeight(1);
    drawTriangle(newColor[0], newColor[1],
            coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
}

void drawTriangle(color borderColor, color fillColor, 
        int x1, int y1, int x2, int y2, int x3, int y3) {
    stroke(borderColor);
    fill(fillColor);
    triangle(x1, y1, x2, y2, x3, y3);
}

/** 
 *   Returns the new colors be used.
 *   First element in return value is new line color.
 *   Second element in return value is new fill color.
 */
color[] getNewColors(color oldColor) {
    color[] returnVal = new color[2];
    if (oldColor == backgroundColor) {
        returnVal[0] = triangleColor[0];
        returnVal[1] = triangleColor[0];
        return returnVal;
    } else {
        for (int i = 0; i < triangleColor.length; i++) {
            if (hex(oldColor) == hex(triangleColor[i])) {
                int newIndex = i + 1;
                if (newIndex >= triangleColor.length) {
                    returnVal[0] = backgroundLineColor;
                    returnVal[1] = backgroundColor;
                    return returnVal;
                } else {
                    returnVal[0] = triangleColor[newIndex];
                    returnVal[1] = triangleColor[newIndex];
                    return returnVal;
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
    float[] returnVal = new float[8];
    arrayCopy(bestTriangle, returnVal);
    for (int i = 0; i < returnVal.length; i += 2) {
        returnVal[i] += offsetX;
    }
    return returnVal;
}

