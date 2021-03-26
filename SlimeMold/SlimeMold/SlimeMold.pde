ArrayList<Agent> agents1;
ArrayList<Agent> to_remove;

PShader blur;

//////////////////////////////////////////////////////////
//Presets
//Fireworks:num_agents 10k faderate = 1, speed = 1, turn_strength = 3, sensor_dist = 45, size = 2
//Sparks: num_agents 50k faderate = 6, speed = 3, turn_strength = 8, sensor_dist = 45, size = 2, can_die = true, life_amount = 10
//Electricity: num_agents 5k faderate = 2, speed = 8, turn_strength = 3, sensor_dist = 12, size = 2
//Shag Carpet: num_agents 20k, faderate = 5, speed = 2, turn_strength = 20, sensor_dist = 12, size = 7
//Mold: num_agents 30k, faderate = 2, speed = 3, turn_strength = 2, sensor_dist = 12, size = 1, can_die = true or false //Both simulations are interesting
//Currents: num_agents 40k, faderate = 1, speed = 3, turn_strength = 4, sensor_dist = 100, size = 1, can_die = false
//Acient writings: num_agents 5k, faderate = 1, speed = .3, turn_strength = 4, sensor_dist = 3, size = 2
//Slow Growth: num_agents 30 k, faderate = 1, speed = .3, turn_strength = 5, sensor_dist =3, size = 2
/////////////////////////////////////////////////////////
//Settings
////////////////////////////////////////////////////////
int num_agents = 60000; //Number of agents
int faderate = 6;  //How fast the old trails fade out
color col = color(round(random(0, 255)), round(random(0, 255)),round(random(0, 255))); //Color of the simulation
float speed=3; //Speed the agents move 
float turn_strength = 2; //How fast the agents can turn (Higher is slower)
float sensor_dist = 12; //Distance the agents look ahead, should almost always be larger than speed and size
float size = 2; //size of the agent

//Life Settings// 
boolean can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
int life_amount = 1000; //how fast they can die
////////////////////////////////////////

boolean is_paused = false;
boolean released = true;

void setup(){
  size(1000,1000, P2D);
  background(0);
  agents1 = new ArrayList<Agent>(num_agents);
  to_remove = new ArrayList<Agent>();
  for(int i = 0; i<num_agents; i++){
    float facing_direction = i-random(HALF_PI, PI+HALF_PI); //Turn agents towards center of ring, with slight variation
    agents1.add(new Agent(width/2+round(sin(i)*width/random(4,30)), height/2+round(cos(i)*height/random(4,30)), col,speed, turn_strength, sensor_dist, size, facing_direction, life_amount, can_die));
  }  
  blur = loadShader("blur.glsl");
  //noSmooth();
  rectMode(CENTER);
}

void draw(){
  if(!is_paused){
    //Huge performance hit if these loops are merged
    fill(agents1.get(0).c);
    noStroke();
    
    loadPixels();
    
    thread("update");
    if(can_die){//Pulled out of the update loop for threading
      for(Agent a : agents1){
        a.eat();
      }
    }
  
    fade();
    updatePixels();
    filter(blur); //Blur everything
    
    for(Agent agent : agents1){
        agent.render();
    }

  }
  
  //Basic pause function
  if(keyPressed && key == ' ' && released == true){
    is_paused = !is_paused;
    released = false;
  }
  else released = true;
}

void fade(){
  for(int i = 0; i< (width*height); i++){
        int r = (pixels[i] >> 16) & 0xFF; //Seperate RGB out from the pixel
        int g = (pixels[i] >> 8) & 0xFF;
        int b = pixels[i] & 0xFF;
        if(r+g+b<=0) continue;
        r = constrain((r-faderate), 0, 255); //Fade out the color, can be used later for multiple agents with different fade rates
        g = constrain((g-faderate), 0, 255);
        b = constrain((b-faderate), 0, 255);
        //pixels[i] = color(r, g, b);
        int col = (r << 16) ; //Seperate RGB out from the pixel
        col += (g << 8) ;
        col += b ;
        pixels[i] = col;
    }
}

void update(){
     for(Agent agent : agents1){
      agent.update();
    }  
}
