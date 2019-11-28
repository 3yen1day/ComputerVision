//マウスクリックした点の座標をコンソールに表示するプログラム

int i = 0;
void setup(){
PImage img = loadImage("1.jpg");
PImage img2 = loadImage("2.jpg");
img.resize(594, 445);
img2.resize(594, 445);
size(594, 890);
image (img, 0,0);
image (img2, 0,445);
}

void draw(){
}

void mousePressed(){
  fill(255,0,0);
  ellipse(mouseX,mouseY,20,20);
  println(i+","+mouseX+","+mouseY);
  i++;
}

/*
115,244と109,24
547,266と574,43
90,428と111,211
428,411と433,190
*/