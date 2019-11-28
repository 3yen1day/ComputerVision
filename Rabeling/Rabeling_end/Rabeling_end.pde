//近傍処理によるラベリング
//2019/10/21

PImage img;

//今のpixcelのcolor判定
color [][] pixcel;
//今のpixcelのLUT
int [][] col;
//iのLUT
int [] LUT;
int i =0;
ArrayList<Integer> array = new ArrayList();

void setup() {
  //初期化
  array.add(0);
  pixcel = new color[800][600];
  col = new int[800][600];
  for (int i=0; i<600; i++) {
    for (int j=0; j<800; j++) {
      pixcel[j][i]=0;
      col[j][i]=0;
    }
  }
  LUT = new int [1000];
  for (int k=0; k<1000; k++) {
    LUT[k]=0;
  }
  size(800, 600);
  img = loadImage("target.png");
  image(img, 0, 0);


  for (int y=0; y<600; y++) {
    for (int x=0; x<800; x++) {
      //println(111111111);
      pixcel[x][y]=img.get(x, y);
      float r = red(pixcel[x][y]);
      if (r!=0) {
        labeling(x, y);
      } else {
        col[x][y]=0;
      }
    }
  }

  //色のセット
  for (int y=0; y<600; y++) {
    for (int x=0; x<800; x++) {
      //color c = color(LUT[col[x][y]]/10, LUT[col[x][y]]*10, LUT[col[x][y]]+10);
      //set(x, y, c);
      if (LUT[col[x][y]]!=0) {
        //println("("+x+","+y+")"+" ; "+LUT[col[x][y]]);
        AddList(LUT[col[x][y]]);
      }
    }
  }


  //色塗り
  for (int y=0; y<600; y++) {
    for (int x=0; x<800; x++) {
      set(x, y, ColorList(LUT[col[x][y]]));
    }
  }
}

void AddList(int lut) {
  //リストに値が存在しなければ     
  if (array.indexOf(lut)==-1) {
    array.add(lut);
    println(lut);
  }
}

color ColorList(int lut) {
  int num = int(array.lastIndexOf(lut));
  if (num!=0) {
    return color(noise(num)*255, noise(num+1)*255, noise(num+2)*255);
  } else {
    return color(0, 0, 0);
  }
}

void labeling(int x, int y) {
  float rNow=red(pixcel[x][y]);

  //画面端の処理
  if (x-1<0 && y-1<0) {
    if (rNow!=0) {
      col[x][y]=i;
    }
  } else if (y-1<0) {
    if (col[x-1][y]==0) {
      col[x][y]=0;
    } else {
      col[x][y]=col[x-1][y];
    }
  } else if (x-1<0) {
    if (col[x][y-1]==0) {
      col[x][y]=0;
    } else {
      col[x][y]=col[x][y-1];
    }
  }

  //4近傍
  if (x==0 || y==0) {
    col[x][y]=0;
  } else if (red(pixcel[x][y-1])==0 && red(pixcel[x-1][y])==0) {
    i++;
    col[x][y]=i;
    LUT[i]=col[x][y];
  } else if (red(pixcel[x][y-1])==0 && red(pixcel[x-1][y])!=0) {
    col[x][y]=col[x-1][y];
  } else if (red(pixcel[x][y-1])!=0 && red(pixcel[x-1][y])==0) {
    col[x][y]=col[x][y-1];
  } else if (red(pixcel[x][y-1])!=0 && red(pixcel[x-1][y])!=0) {
    col[x][y]=min(col[x][y-1], col[x-1][y]);
    //LUTの更新
    if (LUT[col[x][y-1]]<LUT[col[x-1][y]]) {
      LUT[col[x-1][y]]=LUT[col[x][y-1]];
    } else {
      LUT[col[x][y-1]]=LUT[col[x-1][y]];
    }
  }
}