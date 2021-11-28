//Madeline Feng
//IML 288 Assignment 7 - Animations
//November 5th, 2021

PImage moon;
PImage bg;
float rotation = random(-90, 90);
//Sources from https://openprocessing.org/sketch/934548. Accessed November 5th.
ArrayList<Constellation> constellations = new ArrayList<Constellation>();
Constellation c;

void setup() {
  size(520, 754);
  imageMode(CENTER);
  moon = loadImage("moon.png");
  bg = loadImage("bg.png");
  smooth();
}

void draw() {
  background(0);
  
  loadBackground();
  
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
  //saveFrame("output/animation1_####.png");
}

void mouseClicked(){
  tint(180);
  c = new Constellation();
  constellations.add(c);
}

void loadBackground(){
  //Load the background image
  image(bg, width/2, height/2, width, height);
  
  //Load and spin the moon
  pushMatrix();
    translate(width/2+3, height/2-5);
    rotate(radians(rotation));
    image(moon, 0, 0, width, height);
    rotation += 0.5;
  popMatrix();
}

//Sources from hhttps://openprocessing.org/sketch/934548. Accessed November 5th.
class Constellation{
  PVector position, speed, acceleration;
  float gravity, mass, size;

  Constellation(){
    position = new PVector(mouseX, mouseY);
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    gravity = 0.8;
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
