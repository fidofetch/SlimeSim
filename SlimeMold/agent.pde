public class Agent extends Thread{
  float oldX, oldY, x, y;
  color c;
  color oc = 0;
  float dir;
  float speed;
  float turn_strength;
  float sensor_dist;
  float size;
  int life;
  int max_life;
  boolean can_die;
  int senseRate = 0;
  int count = 0;
  
  //PShape agent;
  
  Agent(int x, int y, color c, float speed, float turn_strength, float sensor_dist, float size, float dir, int life_amount, boolean can_die){
    this.x = x;
    this.oldX = x;
    this.oldY = y;
    this.y = y;
    this.c = c;
    this.oc = c;
    this.dir = dir;
    this.speed = speed;
    this.turn_strength = turn_strength;
    this.sensor_dist = sensor_dist;
    this.size = size;
    this.life = life_amount;
    this.max_life = life_amount;
    this.can_die = can_die;
    
    //agent = createShape(RECT, 0, 0, size, size);
    //agent.setStroke(0);
    //agent.setStrokeWeight(0);
    //agent.setFill(c);
    //agent.translate(x,y);
  }
  
  void update(){        
        
    calcNewPos();
    if(count >= senseRate){
      dir = sense(dir);
      count = 0;
    }
    count++;
  }
  
  void eat(){
    color m = 0;
    //Check for food directly in front of the agent
    //color m = get(round(sin(dir)+x+size+1), round(cos(dir)+y+size+1));
    int face = round((cos(dir)+y+size+1))*width + round(-(sin(dir)+x+size+1));
    if(face > 0 && face < width*height) m = pgRead.pixels[face];
    else return;
    float food = ((m >> 16) & 0xFF) + ((m >> 8) & 0xFF) + (m & 0xFF);
    if(food<.5){//Threshold 
      if(life>0)life--;
    }else if(life<max_life) life++;
    if(life<=0)
    {
      c = 0;
      return;//skip rest of update if dead
    }
    c = oc;
  }
  
  float sense(float new_dir){
    //Sensors
    color frontc =0, leftc=0, rightc =0;
    int front = round((cos(dir)*sensor_dist+y))*width + round((sin(dir)*sensor_dist+x)*-x_symmetry_mode);
    if(front > 0 && front < width*height) frontc = pgRead.pixels[front];
    front = ((frontc >> 16) & 0xFF) + ((frontc >> 8) & 0xFF) + (frontc & 0xFF);
    int left = round((cos(dir+HALF_PI/sensor_width)*sensor_dist+y))*width+round((sin(dir+HALF_PI/sensor_width)*sensor_dist+x)*-x_symmetry_mode);
    if(left > 0 && left < width*height) leftc = pgRead.pixels[left];
    left = ((leftc >> 16) & 0xFF) + ((leftc >> 8) & 0xFF) + (leftc & 0xFF);
    int right = round((cos(dir-HALF_PI/sensor_width)*sensor_dist+y))*width+round((sin(dir-HALF_PI/sensor_width)*sensor_dist+x)*-x_symmetry_mode);
    if(right > 0 && right < width*height)rightc = pgRead.pixels[right];    
    right = ((rightc >> 16) & 0xFF) + ((rightc >> 8) & 0xFF) + (rightc & 0xFF);
    //If there is a stronger signal to the left and right randomly choose a direction
    if(right > front && left > front){
      return dir+random(-HALF_PI/turn_strength, HALF_PI/turn_strength);
    }
    else if(right>left){
      return dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, 0);
      //return dir-HALF_PI/turn_strength;
    }
      
    else if(left>right){
      return dir+map(random(0, 5), 0, 5, 0, HALF_PI/turn_strength);
      //return dir+HALF_PI/turn_strength;
    }
    if(x > width || x<0 || y> height || y<0){
      return dir+random(0, PI);
    }
    return new_dir;
  }
  
  void calcNewPos(){
    x += sin(dir)*speed;
    y += cos(dir)*speed;
    
  }
  
  void render(){
        int pix = (int)(y)*width+(int)(x);
        if(pix>0 && pix <width*height && c!=0)
          pgDraw.pixels[pix] = c;
  }
}
