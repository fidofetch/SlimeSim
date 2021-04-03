//Presets
//0: nothing
//1: fireworks
//2: Sparks
//3: Electricity
//4: Mold
//5: Currents
//6: City Map

void preset(int i){
  switch(i){
    case 0:
    break;
    //Fireworks
    case 1:
    num_agents = 10000; //Number of agents
    faderate = 2;  //How fast the old trails fade out
    speed=1; //Speed the agents move 
    turn_strength = 3; //How fast the agents can turn (Higher is slower)
    sensor_dist =45; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = false; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 30;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 4;

    face_towards_center = true; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = false; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 1; //how fast they can die
    break;
    //Sparks
    case 2:
    num_agents = 50000; //Number of agents
    faderate = 12;  //How fast the old trails fade out
    speed=3; //Speed the agents move 
    turn_strength = 8; //How fast the agents can turn (Higher is slower)
    sensor_dist =45; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 2;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower

    chaotic = true; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 40;

    face_towards_center = false; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 10; //how fast they can die
    break;
    
    //Electricity
    case 3:
    num_agents = 5000; //Number of agents
    faderate = 4;  //How fast the old trails fade out
    speed=8; //Speed the agents move 
    turn_strength = 3; //How fast the agents can turn (Higher is slower)
    sensor_dist =12; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = false; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 40;

    face_towards_center = true; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = false; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 1; //how fast they can die
    break;
    
    //Mold
    case 4:
    num_agents = 30000; //Number of agents
    faderate = 2;  //How fast the old trails fade out
    speed=1; //Speed the agents move 
    turn_strength = 2; //How fast the agents can turn (Higher is slower)
    sensor_dist =12; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = true; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 40;

    face_towards_center = true; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 1; //how fast they can die
    break;
    
    //Mold2
    case 7:
    num_agents = 40000; //Number of agents
    faderate = 1;  //How fast the old trails fade out
    speed=.8; //Speed the agents move 
    turn_strength = 2; //How fast the agents can turn (Higher is slower)
    sensor_dist =12; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = true; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 40;

    face_towards_center = true; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = true; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 10; //how fast they can die
    
    blur_strength = 2;
    blur_sigma = 2.0;
    break;
    
    //Currents
    case 5:
    num_agents = 60000; //Number of agents
    faderate = 2;  //How fast the old trails fade out
    speed=3; //Speed the agents move 
    turn_strength = 7; //How fast the agents can turn (Higher is slower)
    sensor_dist =100; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = false;

    min_circle = 50;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 2;

    face_towards_center = false; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = false; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 1; //how fast they can die
    break;
    
    //City Map
    case 6:
    num_agents = 200; //Number of agents
    faderate = 0;  //How fast the old trails fade out
    speed=2; //Speed the agents move 
    turn_strength = 15; //How fast the agents can turn (Higher is slower)
    sensor_dist =10; //Distance the agents look ahead, should almost always be larger than speed and size
    size = 1;//Figure out how to reimplement size using pixel calls
    sensor_width = 6; //How far to the sides the agents can see higher is narrower
    
    chaotic = false; //Change how agents act when in the void, false agents will go straight, true agents will steer randomly

    min_circle = 20;//size of starting circle as ratio of width and height default: 30, 4
    max_circle = 1;

    face_towards_center = false; //Starting facing direction

    x_symmetry_mode = -1; //1 on, -1 off
    //Life Settings// 
    can_die = false; // causes agents that move too far from others to die out, come back to life if mass surrounds it
    revive = true; // agents that are dead will come back to life if they are surrounded again
    life_amount = 1; //how fast they can die
    
    blur_strength = 2;
    blur_sigma = 2.0;
    
    break;
  }
}
