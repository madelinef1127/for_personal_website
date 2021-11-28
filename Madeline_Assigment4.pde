//Madeline Feng
//IML 288
//October 9th, 2021
//Assignment 4 - Recreating David Hockney's Pool

//Source: https://www.youtube.com/watch?v=BZUdGqeOD0w. Accessed October 9th.
//For the Rippling Effect
int columns;
int rows;
float[][] BufferOne;
float[][] BufferTwo;
float[][] Buffer_temporary;
float dampening = 0.999;
float r = 112;
float g = 173;
float b = 236;

//For landscape 
int Y_AXIS = 1;
color c1, c2;

void setup() {
  size(600, 600);
  columns = width;
  rows = height;
  BufferOne = new float[columns][rows];
  BufferTwo = new float[columns][rows];
  
  background(71, 144, 198);
  
  // Define colors
  c1 = color(255);
  c2 = color(71, 144, 198);
}

void draw() { 
  //background(64, 144, 203);
  loadPixels();
  
  //Source: https://www.youtube.com/watch?v=BZUdGqeOD0w. Accessed October 9th.
  for(int i = 1; i < columns - 1; i++) {
    for(int j = 300; j < rows - 1; j++) {
      
      int index = i + j * columns;
      
      //Apply the same function of one grid to its neighbors, waves spread out
      //Distancing = Buffer2
      //NoisesReduced(i, j) = (Buffer1(i-1, j) + Buffer1(i+1, j) + Buffer1(i, j-1) + Buffer1(i, j+1)) / 4
      //NewHeight(i, j) = NoisesReduced(i, j) * 2 - Distancing
      BufferTwo[i][j] = (BufferOne[i - 1][j] + BufferOne[i][j + 1] +
                         BufferOne[i + 1][j] + BufferOne[i][j - 1]) 
                         / 2 - BufferTwo[i][j];
      BufferTwo[i][j] = BufferTwo[i][j] * dampening;
      
      // Displays the buffer, store the values into pixels
      pixels[index] = color(BufferTwo[i][j] + r, BufferTwo[i][j] + g, BufferTwo[i][j] + b);
    }
  }
  
  //Swap Buffers
  Buffer_temporary = BufferOne;
  BufferOne = BufferTwo;
  BufferTwo = Buffer_temporary;
  
  updatePixels();
 
  //Background - sky
  setGradient(0, 0, width, 300, c1, c2, Y_AXIS);
  
  //Grass
  noStroke();
  fill(64, 153, 82);
  rect(0, 230, 600, 71);
  triangle(0, 300, 240, 300, 0, 375);
  triangle(240, 300, 600, 300, 600, 330);
  
  //Bricks
  stroke(216);
  strokeWeight(17);
  line(0, 380, 240, 305);
  line(0, 396, 240, 321);
  line(0, 412, 240, 337);
  line(240, 305, 600, 337);
  line(240, 320, 600, 353);
  line(240, 335, 600, 369);
  stroke(255);
  strokeWeight(12);
  line(0, 420, 240, 345);
  line(240, 345, 600, 379);
  
  //Bush
  noStroke();
  fill(91, 113, 69);
  rect(334, 241, 58, 28);
  ellipse(363, 240, 58, 43);
  ellipse(363, 220, 48, 48);
  fill(70, 78, 60);
  rect(342, 249, 46, 16);
  ellipse(363, 240, 46, 31);
  ellipse(363, 220, 36, 36);
  
  //Construction
  fill(158, 166, 172);
  rect(380, 200, 220, 70);
  fill(56, 69, 107);
  triangle(380, 200, 475, 200, 475, 165);
  rect(475, 165, 125, 35);
  
  //Trees
  fill(50, 50, 50, 90);
  ellipse(52, 288, 36, 10);
  ellipse(218, 273, 36, 10);
  ellipse(109, 278, 36, 10);
  ellipse(167, 278, 36, 10);
  
  stroke(118, 76, 55);
  strokeWeight(6);
  line(52, 260, 52, 285);
  line(218, 245, 218, 270);
  stroke(139, 90, 68);
  line(109, 250, 109, 275);
  line(167, 250, 167, 275);
  
  noStroke();
  fill(34, 68, 54);
  ellipse(52, 250, 40, 40);
  ellipse(58, 226, 48, 36);
  ellipse(109, 248, 32, 32);
  ellipse(115, 226, 28, 28);
  ellipse(167, 248, 32, 32);
  ellipse(164, 226, 28, 28);
  ellipse(218, 245, 30, 30);
  ellipse(223, 225, 22, 22);
  ellipse(212, 230, 17, 17);
  
  fill(24, 46, 47);
  ellipse(57, 248, 15, 15);
  ellipse(50, 224, 15, 15);
  ellipse(113, 250, 15, 15);
  ellipse(162, 224, 15, 15);
  ellipse(216, 243, 15, 15);
  
  //Blanket
  fill(152, 85, 85);
  rect(115, 302, 42, 22, 12, 12, 4, 4);
  fill(229, 230, 227, 80);
  ellipse(148, 311, 10, 10);
  fill(127, 46, 45);
  quad(125, 325, 150, 325, 84, 345, 56, 345);
  fill(151, 46, 46);
  quad(150, 325, 195, 332, 140, 357, 84, 345);
  stroke(66);
  strokeWeight(3);
  line(56, 345, 84, 345);
  line(84, 345, 138, 356);
  
  //Coffee table
  noStroke();
  fill(150, 150, 150, 200);
  ellipse(402, 325, 46, 10);
  
  stroke(46, 61, 57);
  strokeWeight(6);
  line(402, 295, 402, 322);
  strokeWeight(2);
  fill(255);
  ellipse(402, 295, 46, 10);
  
  //Beach chair
  noStroke();
  fill(150, 150, 150, 180);
  quad(393, 345, 438, 353, 493, 323, 460, 323);
  
  stroke(48);
  strokeWeight(4);
  line(393, 337, 393, 345);
  line(438, 345, 438, 353);
  line(493, 313, 493, 323);
  
  noStroke();
  fill(151, 119, 125);
  rect(445, 280, 50, 30, 10, 10, 0, 0);
  fill(229, 230, 227, 90);
  rect(475, 285, 15, 21, 6);
  
  fill(179, 88, 96);
  quad(445, 310, 495, 310, 442, 338, 390, 332);
  fill(173, 65, 74);
  quad(430, 320, 467, 320, 440, 333, 405, 330);
  fill(109, 73, 80);
  quad(391, 331, 442, 337, 442, 345, 391, 337);
  quad(442, 337, 442, 345, 495, 313, 495, 310);
  
  //Man / Swimmer
  fill(63, 62, 62);
  ellipse(360, 304, 28, 28);
  fill(206, 170, 149);
  quad(347, 311, 343, 320, 369, 320, 373, 311);
  arc(374, 311, 25, 25, PI, PI+HALF_PI);
  
  quad(335, 320, 335, 360, 373, 370, 373, 320);
  ellipse(375, 330, 20, 20);
  quad(373, 337, 382, 357, 394, 365, 384, 325);
  arc(335, 340, 10, 40, HALF_PI, PI+HALF_PI);
  
  ellipse(342, 373, 28, 28);
  ellipse(362, 376, 28, 28);
  stroke(182, 130, 112);
  strokeWeight(2);
  arc(354, 345, 12, 38, HALF_PI+QUARTER_PI, PI+QUARTER_PI);
  arc(352, 373, 12, 25, HALF_PI+QUARTER_PI, PI+QUARTER_PI);
  
  //Greyscale - filter
  noStroke();
  fill(244, 244, 244, 48);
  rect(0, 0, 600, 600);
}

//Draw the background gradient
//https://processing.org/examples/noloop.html. Accessed October 11th.
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y + h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x + w, i);
    }
  }  
}

//Rippling Effect - drag mouth around
void mouseDragged() {
  BufferTwo[mouseX][mouseY] = 255;
}
