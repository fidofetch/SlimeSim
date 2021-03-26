Agent[] agents1;

PShader blur;

//////////////////////////////////////////////////////////
//Presets
//Fireworks:num_agents 10k faderate = 1, speed = 1, turn_strength = 3, sensor_dist = 45, size = 2
//Pinwheel: num_agents 50k faderate = 6, speed = 3, turn_strength = 8, sensor_dist = 45, size = 2
//Electricity: num_agents 5k faderate = 2, speed = 8, turn_strength = 3, sensor_dist = 12, size = 2
//Shag Carpet: num_agents 20k, faderate = 5, speed = 2, turn_strength = 20, sensor_dist = 12, size = 7
//Mold: num_agents 30k, faderate = 2, speed = 3, turn_strength = 2, sensor_dist = 12, size = 1
//Currents: num_agents 40k, faderate = 1, speed = 3, turn_strength = 4, sensor_dist = 100, size = 1
//Acient writings: num_agents 5k, faderate = 1, speed = .3, turn_strength = 4, sensor_dist = 3, size = 2
//Slow Growth: num_agents 30 k, faderate = 1, speed = .3, turn_strength = 5, sensor_dist =3, size = 2
/////////////////////////////////////////////////////////
//Settings
////////////////////////////////////////////////////////
int num_agents = 5000; //Number of agents
int faderate = 2;  //How fast the old trails fade out
color col = color(round(random(0, 255)), round(random(0, 255)),round(random(0, 255))); //Color of the simulation
float speed=8; //Speed the agents move 
float turn_strength = 3; //How fast the agents can turn (Higher is slower)
float sensor_dist = 12; //Distance the agents look ahead, should almost always be larger than speed and size
float size = 2; //size of the agent
////////////////////////////////////////

boolean is_paused = false;
boolean released = true;

void setup(){
  size(800, 800, P2D);
  background(0);
  agents1 = new Agent[num_agents];
  for(int i = 0; i<num_agents; i++){
    float facing_direction = i-random(HALF_PI, PI+HALF_PI); //Turn agents towards center of ring, with slight variation
    agents1[i] = new Agent(width/2+round(sin(i)*width/random(4,30)), height/2+round(cos(i)*height/random(4,30)), col,speed, turn_strength, sensor_dist, size, facing_direction);
  }  
  blur = loadShader("blur.glsl");
}

void draw(){
  if(!is_paused){
    //Huge performance hit if these loops are merged
    for(int i = 0; i<num_agents; i++){
        agents1[i].render();
    }
    for(int i = 0; i<num_agents; i++){
        agents1[i].update();
    }
    
    //Pixel manipulation
    loadPixels();
    for(int i = 0; i< (width*height); i++){
        color col = pixels[i];
        if(col == #000000) continue; //Skip if the pixel is already black
        int r = (col >> 16) & 0xFF; //Seperate RGB out from the pixel
        int g = (col >> 8) & 0xFF;
        int b = col & 0xFF;
        r = constrain((r-faderate), 0, 255); //Fade out the color, can be used later for multiple agents with different fade rates
        g = constrain((g-faderate), 0, 255);
        b = constrain((b-faderate), 0, 255);
        pixels[i] = color(r, g, b);
    }
    updatePixels();
    filter(blur); //Blur everything
  }
  
  //Basic pause function
  if(keyPressed && key == ' ' && released == true){
    is_paused = !is_paused;
    released = false;
  }
  else released = true;
}
