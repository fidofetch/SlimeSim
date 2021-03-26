public class Agent{
  float x, y;
  color c;
  float dir;
  float speed;
  float turn_strength;
  float sensor_dist;
  float size;
  Agent(int x, int y, color c, float speed, float turn_strength, float sensor_dist, float size, float dir){
    this.x = x;
    this.y = y;
    this.c = c;
    this.dir = dir;
    this.speed = speed;
    this.turn_strength = turn_strength;
    this.sensor_dist = sensor_dist;
    this.size = size;
  }

  void update(){
    
        
    x += sin(dir)*speed;
    y += cos(dir)*speed;
    
    
    float new_dir=dir;
    
    color front = get(round(sin(dir)*sensor_dist+x), round(cos(dir)*sensor_dist+y));
    color left = get(round(sin(dir+HALF_PI/6)*sensor_dist+x), round(cos(dir+HALF_PI/6)*sensor_dist+y));
    color right = get(round(sin(dir-HALF_PI/6)*sensor_dist+x), round(cos(dir-HALF_PI/6)*sensor_dist+y));
    
    
    if(right > front && left > front){
      new_dir = dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, HALF_PI/turn_strength);
    }
    else if(right>left){
      new_dir = dir+map(random(0, 5), 0, 5, -HALF_PI/turn_strength, 0);
    }
      
    if(left>right){
      new_dir = dir+map(random(0, 5), 0, 5, 0, HALF_PI/turn_strength);
    }
    
    if(x > width || x<0 || y> height || y<0){
      new_dir =dir+map(random(0, 100), 0, 100, 0, TWO_PI);
    }
    
    
    dir = new_dir;

    
  }
  
  
  void render(){
    fill(c);
    noStroke();
    circle(x, y, size);
  }
}
