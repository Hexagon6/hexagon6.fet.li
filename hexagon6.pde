void setup()
{
    temp = 0;
    up = true;
    m = 0.5 * 3.141;
    movement = 0.12;
    temp_diff = 0.8;
    N = 0;
    factor = 1;
    GRID_X = 3 * factor;
    GRID_Y = 3 * factor;
    HEX_SCALE = 6;
    //size((2.6 + GRID_X) * HEX_SCALE * 8, (2.6 + GRID_Y) * HEX_SCALE * 8.8);
    //size(720, 480);
    size(screenWidth, screenHeight);
    //fill(127, 0, 0);
    background(0);
    colors = [ #ffffff, #888888, #222222, #3c444e, 
        #a403da, #a60b69, #ffaa00, #aaff00, #aaaaff ];
    l = colors.length();
    color_indices = [];
    for(int k = 0; k < GRID_X*GRID_Y*2; k = k+1){
        color_indices[k] = floor(random() * l);
        //color_indices[k] = k % l;
    }
    PFont fontA = loadFont("courier");
    textFont(fontA, 14);
    frameRate(30);
    //noLoop();
}

class Hexagon {
    Hexagon (int[] pos, scale, color, pos_offset) {
        pos_x = pos[0];
        pos_y = pos[1];
	pos_off_x = pos_offset[0];
	pos_off_y = pos_offset[1];
        //smaller multiplier => smaller elements
        multiplier = max(min(15,screenWidth/60),5);
        x = scale.x * multiplier;
        y = scale.y * multiplier;
        pos_x = pos_x * scale.x * multiplier + pos_off_x;
        pos_y = pos_y * scale.y * multiplier + pos_off_y;
        noStroke();
        int[] hx6 = { 
            1, 0, //first triangle
            0, 0.6, //
            2, 0.6, //                    //rectangle part1
            0, 2.0, //second triangle     //rectangle part2
            2, 2.0, //
            1, 2.6 //
        };
        fill(color);
        triangle(
          hx6[0] * x + pos_x, hx6[1] * x + pos_y, 
          hx6[2] * x + pos_x, ceil(hx6[3] * x + pos_y), 
          hx6[4] * x + pos_x, ceil(hx6[5] * x + pos_y) 
        );
        rect(
          floor(hx6[2] * x + pos_x), 
          ceil(hx6[3] * x + pos_y), 
          ceil((hx6[4] - hx6[2]) * x), 
          ceil((hx6[9] - hx6[3]) * x)
        );
        triangle(
          hx6[6] * x + pos_x, ceil(hx6[7] * x + pos_y), 
          hx6[8] * x + pos_x, ceil(hx6[9] * x + pos_y), 
          hx6[10] * x + pos_x, hx6[11] * x + pos_y
        );
    }
    Hexagon (int[] pos, scale, color) {
        Hexagon(pos, scale, color, {0, 0});
    }
    Hexagon (int[] pos, scale) {
	Hexagon(pos, scale, #ff0000);
    }
    Hexagon (int[] pos) {
	Hexagon(pos, 1);
    }
    Hexagon () {
	Hexagon({0, 0});
    }
    
    void outline() {
        
    }
}

void draw(){
    if(temp < 150 && up == true){
        temp = (temp + sin(temp_diff * random()));
    } else {
        up = false;
    }
    if(temp > 0 && up == false){
        temp = (temp - sin(temp_diff * random()));
    } else {
        up = true;
    }
    background(0);
    fill(255);
    stroke(255);
    scale = {
        x: HEX_SCALE,
        y: HEX_SCALE
    }; //size factor
    m = movement + m;
    grid = {
        x: GRID_X,
        y: GRID_Y,
        t: GRID_X * GRID_Y
    };
    /*
    new Hexagon();
    */
    for(int k = 0; k < grid.y*2; k = k+4){
        for(int i = 0; i < grid.x*2; i = i+2){
	    if(!(i == 0 && k == 0) && !(i == 0 && k == 4)){
            Hexagon h0 = new Hexagon(
                { i, k}, scale, 
                colors[color_indices[i/2+k/2*grid.x]], 
                {3 * sin(3.14*m + 10) + temp * random() + tan(m)/m, 
                    abs(tan(60 * m + 0.01 * i)) + temp * random()
                }
            );
	    }
        }
	if(k < grid.y*2 - 3){
        for(int i = 0; i < grid.x*2; i = i+2){
	    if(!(i == 2 && k == 0)){
            Hexagon h0 = new Hexagon(
                { i + 1, k + 2 }, scale, 
                colors[color_indices[i/2+(k+2)/2*(grid.x)]],
                {-2.5 * sin(m) + temp * random() + tan(m)/m/2, 
                    abs(tan(59.99 * m - 0.01 * i)) + temp * random()
                }
            );
	    }
	    }
        }
    }
}


