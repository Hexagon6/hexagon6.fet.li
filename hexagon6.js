const screenWidth = 400;

function setup() {
  createCanvas(screenWidth, 400);
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
  background(120);
  colors = [
    "#ffffff",
    "#888888",
    "#222222",
    "#3c444e",
    "#a403da",
    "#a60b69",
    "#ffaa00",
    "#aaff00",
    "#aaaaff"
  ];
  l = colors.length;
  color_indices = [];
  for (k = 0; k < GRID_X * GRID_Y * 2; k = k + 1) {
    color_indices[k] = floor(random() * l);
  }
  frameRate(30);
}

class Hexagon {
  constructor(pos, scale, color, pos_offset) {
    let pos_x = pos[0];
    let pos_y = pos[1];
    let pos_off_x = pos_offset[0];
    let pos_off_y = pos_offset[1];
    //smaller multiplier => smaller elements
    let multiplier = max(min(15, screenWidth / 60), 5);
    let x = scale.x * multiplier;
    let y = scale.y * multiplier;
    pos_x = pos_x * scale.x * multiplier + pos_off_x;
    pos_y = pos_y * scale.y * multiplier + pos_off_y;
    noStroke();

    let r = 50;
    let points = 6;

    fill(color);
    beginShape(TRIANGLE_FAN);
    Array.from({ length: points }).map((_, n) =>
      vertex(
        pos_x + cos((n * TWO_PI + PI) / points) * r,
        pos_y + sin((n * TWO_PI + PI) / points) * r
      )
    );
    endShape();
  }
}

function draw() {
  if (temp < 150 && up == true) {
    temp = temp + sin(temp_diff * random());
  } else {
    up = false;
  }
  if (temp > 0 && up == false) {
    temp = temp - sin(temp_diff * random());
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
  for (y = 0; y < grid.y * 2; y = y + 4) {
    for (x = 0; x < grid.x * 2; x = x + 2) {
      if (!(x == 0 && y == 0) && !(x == 0 && y == 4)) {
        h0 = new Hexagon(
          [x, y],
          scale,
          colors[color_indices[x / 2 + (x / 2) * grid.x]],
          [
            3 * sin(3.14 * m + 10) + temp * random() + tan(m) / m,
            abs(tan(60 * m + 0.01 * x)) + temp * random()
          ]
        );
      }
    }
    if (y < grid.y * 2 - 3) {
      for (x = 0; x < grid.x * 2; x = x + 2) {
        if (!(x == 2 && y == 0)) {
          h0 = new Hexagon(
            [x + 1, y + 2],
            scale,
            colors[color_indices[x / 2 + ((y + 2) / 2) * grid.x]],
            [
              -2.5 * sin(m) + temp * random() + tan(m) / m / 2,
              abs(tan(59.99 * m - 0.01 * x)) + temp * random()
            ]
          );
        }
      }
    }
  }
}
