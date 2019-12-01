import processing.video.*;
Particle[] particles;
import processing.serial.*;
Serial myPort;
float direc=0;
float a=0;
float last=1;
float direc2;
float vari;

Star[] stars = new Star[800];
float speed;
color trackColor; 



PGraphics buffer1;

PGraphics buffer2;

PImage cooling;
float ystart = 0.0;


int w = 640;
PFont myFont;
int h = 480;



Capture video;
int x=0;
PImage prev;

float threshold = 25;

float motionX = 0;
float motionY = 0;

int cols;
int rows;
float[][] current;// = new float[cols][rows];
float[][] previous;// = new float[cols][rows];

float dampening = 0.99;


float lerpX = 0;
float lerpY = 0;
//PImage frog;
Capture frog;


float p=0;
float q=0;

void setup() {
  size(1280, 720);
  String[] cameras=Capture.list();
  printArray(cameras);
  myPort= new Serial (this, "COM5", 9600);
myPort.bufferUntil ( '\n' );


  video = new Capture(this, width, height);
  video.start();
    prev = createImage(1280, 720, RGB);
    cols = width;
  rows = height;
  current = new float[cols][rows];
  previous = new float[cols][rows];
  
  
    trackColor = color(255, 0, 0);
    for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  
  


  particles = new Particle [2500];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(0);
  
  
    myFont = createFont("System", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  buffer1 = createGraphics(w, h);

  buffer2 = createGraphics(w, h);

  cooling = createImage(w, h, RGB);
  
  
  
}
void captureEvent(Capture video) {
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
  prev.updatePixels();
  video.read();
}
  void draw(){
    if(vari==1){
    
    if(a==0){
    


  fire(12);

  
  cool();

  background(0);

  buffer2.beginDraw();

  buffer1.loadPixels();

  buffer2.loadPixels();

  for (int x = 1; x < w-1; x++) {

    for (int y = 1; y < h-1; y++) {

      int index0 = (x) + (y) * w;

      int index1 = (x+1) + (y) * w;

      int index2 = (x-1) + (y) * w;

      int index3 = (x) + (y+1) * w;

      int index4 = (x) + (y-1) * w;

      color c1 = buffer1.pixels[index1];

      color c2 = buffer1.pixels[index2];

      color c3 = buffer1.pixels[index3];

      color c4 = buffer1.pixels[index4];



      color c5 = cooling.pixels[index0];

      float newC = brightness(c1) + brightness(c2)+ brightness(c3) + brightness(c4);

      newC = newC * 0.25 - brightness(c5);



      buffer2.pixels[index4] = color(newC);

    }

  }

  buffer2.updatePixels();

  buffer2.endDraw();



  // Swap

  PGraphics temp = buffer1;

  buffer1 = buffer2;

  buffer2 = temp;



  image(buffer2, 0, 0);
    fill(256,256,256);
   textSize(50);
   
  text("WELCOME",width/2,height/2-200);

  //image(cooling, w, 0);

}

if(a==1){
   video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 50;


  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(255);
      } else {
        pixels[loc] = color(0);
      }
    }
  }
  updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
    // Draw a circle at the tracked pixel
  }
  
 /* lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 
  
  fill(255, 0, 255);
  strokeWeight(2.0);
  stroke(0);
  ellipse(lerpX, lerpY, 36, 36);*/

  //image(video, 0, 0, 100, 100);
  //image(prev, 100, 0, 100, 100);

  //println(mouseX, threshold);
  }
  else if(a==2){
    video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 50;


  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(255);
      } else {
        pixels[loc] = color(0);
      }
    }
  }
  updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
    // Draw a circle at the tracked pixel
  }
  
  lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 
    previous[(int)lerpX][(int)lerpY] = 1000;

    background(0);
  
  loadPixels();
  for (int i = 1; i < cols-1; i++) {
    for (int j = 1; j < rows-1; j++) {
      current[i][j] = (
        previous[i-1][j] + 
        previous[i+1][j] +
        previous[i][j-1] + 
        previous[i][j+1]) / 2 -
        current[i][j];
      current[i][j] = current[i][j] * dampening;
      int index = i + j * cols;
      pixels[index] = color(current[i][j]);
    }
  }
  updatePixels();

  float[][] temp = previous;
  previous = current;
  current = temp;
  System.out.print(lerpX+"   ");
  System.out.println(lerpY);
  //image(video, 0, 0, 100, 100);
  //image(prev, 100, 0, 100, 100);

  //println(mouseX, threshold);
  }
  else if(a==3)
  {
  video.loadPixels();
  image(video, 0, 0);

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 10) { 
    // Draw a circle at the tracked pixel
   speed = map(closestX, 0, width, 0, 50);
  System.out.println(closestX);

  background(0);
  // I shift the entire composition,
  // moving its center from the top left corner to the center of the canvas.
  translate(width/2, height/2);
  // I draw each star, running the "update" method to update its position and
  // the "show" method to show it on the canvas.
  for (int i = 0; i < stars.length; i++) {
    stars[i].update();
    stars[i].show();
  }
  }
}

else if(a==4){
  {
  video.loadPixels();
  prev.loadPixels();
  //image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 50;


  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(255);
      } else {
        pixels[loc] = color(0);
      }
    }
  }
  //updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
    // Draw a circle at the tracked pixel
  }
  
  lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 
  
  
 
 
  strokeWeight(50);
  stroke(random(0,255),random(0,255),random(0,255));
  line(p,q,lerpX,lerpY);
  p=lerpX;
  q=lerpY;
 
  //image(video, 0, 0, 100, 100);
  //image(prev, 100, 0, 100, 100);

  //println(mouseX, threshold);
}
}
else if(a==5){
 fire(12);

  
  cool();

  background(0);

  buffer2.beginDraw();

  buffer1.loadPixels();

  buffer2.loadPixels();

  for (int x = 1; x < w-1; x++) {

    for (int y = 1; y < h-1; y++) {

      int index0 = (x) + (y) * w;

      int index1 = (x+1) + (y) * w;

      int index2 = (x-1) + (y) * w;

      int index3 = (x) + (y+1) * w;

      int index4 = (x) + (y-1) * w;

      color c1 = buffer1.pixels[index1];

      color c2 = buffer1.pixels[index2];

      color c3 = buffer1.pixels[index3];

      color c4 = buffer1.pixels[index4];



      color c5 = cooling.pixels[index0];

      float newC = brightness(c1) + brightness(c2)+ brightness(c3) + brightness(c4);

      newC = newC * 0.25 - brightness(c5);



      buffer2.pixels[index4] = color(newC);

    }

  }

  buffer2.updatePixels();

  buffer2.endDraw();



  // Swap

  PGraphics temp = buffer1;

  buffer1 = buffer2;

  buffer2 = temp;



  image(buffer2, 0, 0);
    fill(256,256,256);
   textSize(50);
   
  text("THANK YOU",width/2,height/2-200);

  //image(cooling, w, 0);

}
  }
}
 
void abc(){
}


  void keyPressed(){
  if (key=='a'){
a+=1;
}
  }
  float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}


void serialEvent(Serial myPort) {
  String s=myPort.readStringUntil('\n');
  String[] phones = s.split("\\s+");
  String str1=(String)phones[0];
  String str2=(String)phones[1];
  direc= float(str1);
  direc2= float(str2);
if (direc==0){
  if(a<0)
  
{a-=1;}
if(a<0){
a=4;}
}
if(direc==1){
  if(a<5)
{a+=1;}
if(a>5){
a=1;}
}
if(direc2==5)
{vari=1;}
else if(direc2==4)
{vari=2;}
}


void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}





void cool() {

  cooling.loadPixels();

  float xoff = 0.0; // Start xoff at 0

  float increment = 0.02;

  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value

  for (int x = 0; x < w; x++) {

    xoff += increment;   // Increment xoff 

    float yoff = ystart;   // For every xoff, start yoff at 0

    for (int y = 0; y < h; y++) {

      yoff += increment; // Increment yoff



      // Calculate noise and scale by 255

      float n = noise(xoff, yoff);     

      float bright = pow(n, 3) * 255;



      // Try using this line instead

      //float bright = random(0,255);



      // Set each pixel onscreen to a grayscale value

      cooling.pixels[x+y*w] = color(bright);

    }

  }



  cooling.updatePixels();

  ystart += increment;

}



void fire(int rows) {

  buffer1.beginDraw();

  buffer1.loadPixels();

  for (int x = 0; x < w; x++) {

    for (int j = 0; j < rows; j++) {

      int y = h-(j+1);

      int index = x + y * w;

      buffer1.pixels[index] = color(255);

    }

  }

  buffer1.updatePixels();

  buffer1.endDraw();

}
