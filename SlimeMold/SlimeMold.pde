ArrayList<Agent> agents1;

import com.jogamp.opengl.GL;

PShader blur;
PImage fade;

PGraphics pgDraw;
PGraphics pgRead;

//Presets
//0: nothing
//1: fireworks
//2: Sparks
//3: Electricity
//4: Mold
//5: Currents
//6: City Map
//7: Mold2
//Enter a preset to overwrite settings 0 will not overwrite, colors are not overwritten
int preset = 7;
/////////////////////////////////////////////////////////
//Settings
////////////////////////////////////////////////////////
int num_agents = 100000; //Number of agents
int faderate = 5;  //How fast the old trails fade out
color col1 = color(0); //Color of the simulation, set to 0 for random color
color col2 = color(0); //Set to 0 for only col1
float speed=2; //Speed the agents move 
float turn_strength = 2; //How fast the agents can turn (Higher is slower)
float sensor_dist =12; //Distance the agents look ahead, should almost always be larger than speed and size
int size = 1;//Figure out how to reimplement size using pixel calls
float sensor_width = 6; //How far to the sides the agents can see higher is narrower

boolean chaotic = true; //Change how agents act when turning, false agents will go straight, true agents will steer randomly

int min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
int max_circle = 40;

boolean face_towards_center = true; //Starting facing direction

int x_symmetry_mode = -1; //1 on, -1 off
//Life Settings// 
boolean can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
boolean revive = true; // agents that are dead will come back to life if they are surrounded again
int life_amount = 1; //how fast they can die

//System Settings//
boolean use_threading = true;
float blur_strength = 2; //Not working, Shaders seem to preload so variables do not work
float blur_sigma = 2.0;
int frame_rate = 120;
////////////////////////////////////////

boolean is_paused = false;
boolean released = true;

void setup(){
  
  preset(preset);
  
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
  colorMode(RGB, 500);
  for(int i = 0; i<fade.pixels.length; i++){
    fade.pixels[i] = color(500, faderate);
  }
  colorMode(RGB);
  noStroke();
  noSmooth();
  hint(DISABLE_DEPTH_TEST);
}

void draw(){
  
  pgRead.beginDraw();
  pgRead.image(copy(), 0, 0);
  pgRead.endDraw();
  
  if(!is_paused){

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
    
    blendMode(SUBTRACT);
    fade();
    blendMode(BLEND);
    image(pgDraw, 0, 0, width, height);
    blur();
    
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
