public class Agent{
  float x, y;
  color c;
  float dir;
  float speed;
  float turn_strength;
  float sensor_dist;
  float size;
  int life;
  int max_life;
  boolean can_die;
  Agent(int x, int y, color c, float speed, float turn_strength, float sensor_dist, float size, float dir, int life_amount, boolean can_die){
    this.x = x;
    this.y = y;
    this.c = c;
    this.dir = dir;
    this.speed = speed;
    this.turn_strength = turn_strength;
    this.sensor_dist = sensor_dist;
    this.size = size;
    this.life = life_amount;
    this.max_life = life_amount;
    this.can_die = can_die;
  }

  void update(){
    //Check for food directly in front of the agent
    color m = get(round(sin(dir)+x+size+1), round(cos(dir)+y+size+1));
    float food = (m >> 16) & 0xFF + (col >> 8) & 0xFF + col & 0xFF;
    if(food<.5){//Threshold
      if(life>0)life--;
    }else if(life<max_life) life++;
    if(life<=0 && can_die) return;//skip rest of update if dead
        
    x += sin(dir)*speed;
    y += cos(dir)*speed;
    
    
    float new_dir=dir;
    
    
    //Sensors
    color front = get(round(sin(dir)*sensor_dist+x), round(cos(dir)*sensor_dist+y));
    color left = get(round(sin(dir+HALF_PI/6)*sensor_dist+x), round(cos(dir+HALF_PI/6)*sensor_dist+y));
    color right = get(round(sin(dir-HALF_PI/6)*sensor_dist+x), round(cos(dir-HALF_PI/6)*sensor_dist+y));
    
    //If there is a stronger signal to the left and right randomly choose a direction
    if(right > front && left > front){
      new_dir = dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, HALF_PI/turn_strength);
    }
    else if(right>left){
      new_dir = dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, 0);
    }
      
    else if(left>right){
      new_dir = dir+map(random(0, 5), 0, 5, 0, HALF_PI/turn_strength);
    }
    
    if(x > width || x<0 || y> height || y<0){
      new_dir =dir+map(random(0, 100), 0, 100, 0, TWO_PI);
    }
    
    
    dir = new_dir;

    
  }
  
  
  void render(){
    if(life<=0 && can_die) return;
    fill(c);
    noStroke();
    circle(x, y, size);
    
  }
}
