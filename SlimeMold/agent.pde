public class Agent extends Thread{
  float oldX, oldY, x, y;
  color c;
  color deadc = 0;
  float dir;
  float speed;
  float turn_strength;
  float sensor_dist;
  float size;
  int life;
  int max_life;
  boolean can_die;
  
  PShape agent;
  
  Agent(int x, int y, color c, float speed, float turn_strength, float sensor_dist, float size, float dir, int life_amount, boolean can_die){
    this.x = x;
    this.oldX = x;
    this.oldY = y;
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
    
    agent = createShape(RECT, 0, 0, size, size);
    agent.setStroke(0);
    agent.setStrokeWeight(0);
    agent.setFill(c);
    agent.translate(x,y);
  }
  
  void update(){        
        
    calcNewPos();
    dir = sense(dir);
    
  }
  
  void eat(){
    color m = 0;
    //Check for food directly in front of the agent
    //color m = get(round(sin(dir)+x+size+1), round(cos(dir)+y+size+1));
    int face = round((cos(dir)+y+size+1))*width + round((sin(dir)+x+size+1));
    if(face > 0 && face < width*height) m = pixels[face];
    else return;
    float food = (m >> 16) & 0xFF + (col >> 8) & 0xFF + col & 0xFF;
    if(food<.5){//Threshold 
      if(life>0)life--;
    }else if(life<max_life) life++;
    if(life<=0)
    {
      agent.setFill(0);
      return;//skip rest of update if dead
    }
    agent.setFill(c);
  }
  
  float sense(float new_dir){
    //Sensors
    color frontc = -999999999, leftc=-999999999, rightc = -999999999;
    int front = round((cos(dir)*sensor_dist+y))*width + round((sin(dir)*sensor_dist+x));
    if(front > 0 && front < width*height) frontc = pixels[front];
    int left = round((cos(dir+HALF_PI/6)*sensor_dist+y))*width+round((sin(dir+HALF_PI/6)*sensor_dist+x));
    if(left > 0 && left < width*height) leftc = pixels[left];
    int right = round((cos(dir-HALF_PI/6)*sensor_dist+y))*width+round((sin(dir-HALF_PI/6)*sensor_dist+x));
    if(right > 0 && right < width*height) rightc = pixels[right];    
    
    //If there is a stronger signal to the left and right randomly choose a direction
    if(rightc > frontc && leftc > frontc){
      return dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, HALF_PI/turn_strength);
    }
    else if(rightc>leftc){
      //return dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, 0);
      return dir-HALF_PI/turn_strength;
    }
      
    else if(leftc>rightc){
      //return dir+map(random(0, 5), 0, 5, 0, HALF_PI/turn_strength);
      return dir+HALF_PI/turn_strength;
    }
    
    if(x > width || x<0 || y> height || y<0){
      return dir+map(random(0, 100), 0, 100, 0, PI);
    }
    return new_dir;
  }
  
  void calcNewPos(){
    x += sin(dir)*speed;
    y += cos(dir)*speed;
    
  }
  
  void render(){
        agent.translate(x-oldX, y-oldY);
        oldX = x;
        oldY = y;
  }
}
