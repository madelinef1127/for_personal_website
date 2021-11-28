//Madeline Feng
//IML 288 Assignment 7-1 - Animations II
//November 13th, 2021

float rotation = random(-90, 90);
int numStars = 60;
//Source from https://www.youtube.com/watch?v=BjoM9oKOAKY&list=PLRqwX-V7Uu6bgPNQAdxQZpJuJCjeOr7VD&index=6. Accessed November 13th, 2021
FlowField flowfield;
ArrayList<Particle> particles;
boolean debug = false;
float r, g, b;
//Source from https://openprocessing.org/sketch/934548. Accessed November 5th.
ArrayList<Constellation> constellations = new ArrayList<Constellation>();
Constellation c;

void setup() {
  size(520, 754);
  
  //Draw Nebulas
  flowfield = new FlowField(10);
  flowfield.update();

  particles = new ArrayList<Particle>();
  for (int i = 0; i < 10000; i++) {
    PVector start = new PVector(random(width), random(height));
    particles.add(new Particle(start, random(2, 8)));
  }

  smooth();
  frameRate(1200);
}

void draw() {
  background(82, 63, 92);
  
  //Draw Nebulas
  flowfield.update();
  
  if(debug) flowfield.display();
  
  for(Particle p : particles) {
    p.follow(flowfield);
    p.run();
  }
  
  //Draw stars
  pushMatrix();
    for(int i = 0; i < numStars; i++) {
      fill(255, 255, 255, 180);
      ellipse(random(width), random(height), 5, 5);
    }
    filter(BLUR, 1.5); 
  popMatrix();
  
  //Draw and spin moon
  pushMatrix();
    translate(width/2, height/2);
    rotate(radians(rotation));
    drawMoon();
    rotation += 2;
  popMatrix();
  
  //FLoating constellations
  for (int i = 0; i < constellations.size(); i++) {
    for (int k = 0; k < constellations.size(); k++) {
      if (i!=k) {
        PVector f = constellations.get(k).attract(constellations.get(i));
        constellations.get(i).applyForce(f);
        constellations.get(i).link(constellations.get(k));
      }
    }
    constellations.get(i).update();
    constellations.get(i).display();
    constellations.get(i).checkEdges();
    
    //Reset the constellation fork when any key is pressed
    if(keyPressed == true){
      constellations.remove(i);
      tint(255);
    }
  }
  //saveFrame("output/animation2_#####.png");
}

void mouseClicked(){
  //fill(0, 100);
  //rect(0, 0, width, height);
  c = new Constellation();
  constellations.add(c);
}

//Sources from hhttps://openprocessing.org/sketch/934548. Accessed November 5th.
class Constellation{
  PVector position, speed, acceleration;
  float gravity, mass, size;

  Constellation(){
    position = new PVector(mouseX, mouseY);
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    gravity = 1.8;
    mass = random(3, 10);
    size = mass;
  }

  void applyForce(PVector force){
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }

  void update(){
    speed.add(acceleration);
    position.add(speed);
    acceleration.mult(0);
  }

  void display(){
    noStroke();
    fill(255);
    ellipse(position.x, position.y, size, size);
  }

  void link(Constellation c){
    stroke(255, 75);
    PVector dist = PVector.sub(c.position, position);
    if (dist.mag()<150) {
      strokeWeight(1);
      line(position.x, position.y, c.position.x, c.position.y);
    }
  }

  PVector attract(Constellation c){
    PVector force = PVector.sub(position, c.position);
    float distance = force.mag();
    distance = constrain(distance, 20, 25);
    force.normalize();
    float strength = (gravity*mass*c.mass)/(distance*distance);
    force.mult(strength);
    return force;
  }

  void checkEdges(){
    if (position.x < size/2) {
      position.x = size/2;
      speed.x *= -1;
    } else if (position.x > width-size/2){
      speed.x = width-size/2;
      speed.x *= -1;
    }

    if (position.y < size/2) {
      position.y = size/2;
      speed.y *= -1;
    } else if (position.y > height-size/2){
      position.y = height-size/2;
      position.y *= -1;
    }
  }
}

public class Particle {
  PVector position, velocity, acceleration;
  PVector previousPosition;
  float maxSpeed;
   
  Particle(PVector start, float maxspeed) {
    maxSpeed = maxspeed;
    position = start;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    previousPosition = position.copy();
  }
  
  void run() {
    updateParticle();
    checkEdges();
    displayParticle();
  }
  
  void updateParticle() {
    position.add(velocity);
    velocity.limit(maxSpeed);
    velocity.add(acceleration);
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force); 
  }
  
  void displayParticle() {
    
    //Change colors of nebulas
    if (position.y < position.x*(-0.8) + height/5*3) {
      r = 219;
      g = 105;
      b = 255;
    } else if(position.y > position.x*(-0.8) + height/5*3 && position.y < position.x*(-0.8) + height + 50) {
      r = 246;
      g = 150;
      b = 147;
    } else {
      r = 255;
      g = 181;
      b = 108;
    }
    
    stroke(r, g, b, 8);
    strokeWeight(8);
    line(position.x, position.y, previousPosition.x, previousPosition.y);
    updatePreviousPosition();
  }
  
  void checkEdges() {
    if (position.x > width) {
      position.x = 0;
      updatePreviousPosition();
    }
    if (position.x < 0) {
      position.x = width;    
      updatePreviousPosition();
    }
    if (position.y > height) {
      position.y = 0;
      updatePreviousPosition();
    }
    if (position.y < 0) {
      position.y = height;
      updatePreviousPosition();
    }
  }
  
  void updatePreviousPosition() {
    this.previousPosition.x = position.x;
    this.previousPosition.y = position.y;
  }
  
  void follow(FlowField flowfield) {
    int x = floor(position.x / flowfield.scale);
    int y = floor(position.y / flowfield.scale);
    int index = x + y * flowfield.cols;
    
    PVector force = flowfield.vectors[index];
    applyForce(force);
  }
}

public class FlowField {
  PVector[] vectors;
  int cols, rows;
  float increment = 0.1;
  float zoff = 0;
  int scale;
  
  FlowField(int res) {
    scale = res;
    cols = floor(width / res) + 1;
    rows = floor(height / res) + 1;
    vectors = new PVector[cols * rows];
  }
  
  void update() {
    float xoff = 0;
    for (int y = 0; y < rows; y++) { 
      float yoff = 0;
      for (int x = 0; x < cols; x++) {
        float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
        
        PVector v = PVector.fromAngle(angle);
        v.setMag(1);
        int index = x + y * cols;
        vectors[index] = v;
       
        xoff += increment;
      }
      yoff += increment;
    }
    zoff += 0.004;
  }
  
  void display() {
    for (int y = 0; y < rows; y++) { 
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        PVector v = vectors[index];
        
        stroke(255, 255, 255, 40);
        strokeWeight(0.1);
        pushMatrix();
          translate(x * scale, y * scale);
          rotate(v.heading());
          line(0, 0, scale, 0);
        popMatrix();
      }
    }
  }
}

void drawMoon() {  
  noStroke();
  fill(226, 208, 150);
  ellipse(0, 0, 262, 262); 
  shadeMoon();
  
  //Draw the craters
  drawCraters(40, -30, 38);
  drawCraters(60, -95, 45);
  drawCraters(15, -60, 18);
  drawCraters(-20, 15, 30);
  drawCraters(-60, -50, 65);
  drawCraters(35, 70, 50);
  drawCraters(-5, 102, 18);
  drawCraters(-55, 55, 40);
  drawCraters(-95, 30, 18);
  drawCraters(85, 35, 30);
  drawCraters(100, -10, 18);
  drawCraters(-30, -118, 30);
  drawCraters(92, 88, 20);
  drawCraters(-125, -15, 28);
  drawCraters(-40, 115, 30);
  drawCraters(115, -40, 30);
}

//Source from https://openprocessing.org/sketch/1281744. Accessed November 13th, 2021.
void shadeMoon() {
  noFill();
  strokeWeight(1.2); 
  stroke (91, 70, 59, 12);
  
  int diameter = 130; 
  
  for (int i = 30; i < 2200; i++){
    strokeWeight (random (0.25, 1)); 
    float angle1 = random (TWO_PI), angle2 = random (TWO_PI);
    PVector p1 = new PVector (cos(angle1) * diameter, sin(angle1) * diameter); 
    PVector p2 = new PVector (cos(angle2) * diameter, sin(angle2) * diameter);
    
    line (p1.x, p1.y, p2.x, p2.y);
  }
}

void drawCraters(int x, int y, int r) {
  noStroke();
  fill(91, 70, 59, 80);
  ellipse(x+5, y+3, r, r);
  fill(227, 208, 152);
  ellipse(x, y, r, r);
  fill(159, 141, 110, 120);
  ellipse(x, y, r-(r*0.32), r-(r*0.32));
  noFill();
  stroke(255, 255, 255, 100);
  strokeWeight(r*0.12);
  arc(x, y, r-(r*0.16), r-(r*0.16), HALF_PI+QUARTER_PI, PI+HALF_PI);
  stroke(91, 70, 59, 40);
  strokeWeight(r*0.08);
  arc(x, y, r-(r*0.4), r-(r*0.4), QUARTER_PI, PI+HALF_PI);
  stroke(202, 140, 121, 80);
  strokeWeight(r*0.16);
  arc(x, y, r-(r*0.16), r-(r*0.16), 0, HALF_PI+QUARTER_PI);
}
