ArrayList<Agent> agents1;

import com.jogamp.opengl.GL;

PShader blur;
PImage fade;

PGraphics pgDraw;
PGraphics pgRead;

//////////////////////////////////////////////////////////
//Presets
//Fireworks:num_agents 10k faderate = 1, speed = 1, turn_strength = 3, sensor_dist = 45, size = 2
//Sparks: num_agents 50k faderate = 6, speed = 3, turn_strength = 8, sensor_dist = 45, size = 2, can_die = true, life_amount = 10
//Electricity: num_agents 5k faderate = 2, speed = 8, turn_strength = 3, sensor_dist = 12, size = 2
//Shag Carpet: num_agents 20k, faderate = 5, speed = 2, turn_strength = 20, sensor_dist = 12, size = 7
//Mold: num_agents 30k, faderate = 3, speed = 2, turn_strength = 2, sensor_dist = 12, size = 1, can_die = true or false //Both simulations are interesting
//Currents: num_agents 40k, faderate = 1, speed = 3, turn_strength = 4, sensor_dist = 100, size = 1, can_die = false
//Acient writings: num_agents 5k, faderate = 1, speed = .3, turn_strength = 4, sensor_dist = 3, size = 2
//Slow Growth: num_agents 30 k, faderate = 1, speed = .3, turn_strength = 5, sensor_dist =3, size = 2
//City Map: num_agents 200, faderate = 0, speed = 2, turn_strength = 15, sensor_dist = 10, size = 1, min_circle = 20, max_circle = 1, face_towards_center = false, can_die = false
/////////////////////////////////////////////////////////
//Settings
////////////////////////////////////////////////////////
int num_agents = 1000000; //Number of agents
int faderate = 8;  //How fast the old trails fade out
color col1 = color(0); //Color of the simulation, set to 0 for random color
color col2 = color(0); //Set to 0 for only col1
float speed=2; //Speed the agents move 
float turn_strength = 2; //How fast the agents can turn (Higher is slower)
float sensor_dist =12; //Distance the agents look ahead, should almost always be larger than speed and size
int size = 1;//Figure out how to reimplement size using pixel calls
float sensor_width = 6; //How far to the sides the agents can see higher is narrower

int min_circle = 30;//size of starting circle as ratio of width and height default: 30, 4
int max_circle = 4;

boolean face_towards_center = true; //Starting facing direction

int x_symmetry_mode = -1; //1 on, -1 off
//Life Settings// 
boolean can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
boolean revive = true; // agents that are dead will come back to life if they are surrounded again
int life_amount = 1; //how fast they can die

//System Settings//
boolean fullscreen = true;
boolean use_threading = true;
float blur_strength = 9;
float blur_sigma = 5.0;
int frame_rate = 120;
////////////////////////////////////////

boolean is_paused = false;
boolean released = true;

void setup(){
  size(1000,1000, P3D);
  //fullScreen(P3D);
  frameRate(frame_rate);
  background(0);
  agents1 = new ArrayList<Agent>(num_agents);
  if(col1==color(0))col1 = color(round(random(0, 255)), round(random(0, 255)),round(random(0, 255)));
  color setcol =  col1;
  for(int i = 0; i<num_agents; i++){
    if(col2 != color(0)){
      if(i%2 == 0) setcol = col1;
      else setcol = col2;
    }
    float facing_direction;
    if(face_towards_center) facing_direction = i-random(HALF_PI, PI+HALF_PI); //Turn agents towards center of ring, with slight variation
    else facing_direction = random(0, TWO_PI);
    
    Agent n = new Agent(width/2+round(sin(i)*width/random(max_circle,min_circle)), height/2+round(cos(i)*height/random(max_circle,min_circle)), setcol,speed, turn_strength, sensor_dist, size, facing_direction, life_amount, can_die);
    agents1.add(n);
  }  
  
  blur = loadShader("blur.glsl");
  blur.set("blurSize", 2);
  blur.set("sigma", 2.0);
  
  pgDraw = createGraphics(width, height);
  pgRead = createGraphics(width, height);
  
  fade = createImage(width, height, ARGB);
  
  for(int i = 0; i<fade.pixels.length; i++){
    fade.pixels[i] = color(255, faderate);
  }
  noStroke();
  noSmooth();
  hint(DISABLE_DEPTH_TEST);
}

void draw(){
  
  pgRead.beginDraw();
  pgRead.image(copy(), 0, 0);
  pgRead.endDraw();
  
  if(!is_paused){
    
    blendMode(SUBTRACT);
    fade();
    blur();

    pgDraw.beginDraw();
    pgDraw.blendMode(ADD);
    pgDraw.background(0, 0, 0, 0);
    pgDraw.loadPixels();
    render();
    pgDraw.updatePixels();
    pgDraw.endDraw();
    
    pgRead.loadPixels();
    if(use_threading) thread("update");
    else update();
    
    blendMode(BLEND);
    image(pgDraw, 0, 0, width, height);
    
  }
  //Basic pause function
  if(keyPressed && key == ' ' && released == true){
    is_paused = !is_paused;
    released = false;
  }
  else released = true;
}

void blur(){
    blur.set("horizontalPass", 0);
    filter(blur); //Blur everything
    blur.set("horizontalPass", 1);
    filter(blur); //Blur everything
}

void fade(){
  image(fade, 0, 0);
}

void update(){
    for(Agent agent : agents1){
       agent.update();
       if(can_die) agent.eat();
    }
}

void render(){
  for(Agent agent : agents1){
           if(agent.life>=0)agent.render();
  } 
}
