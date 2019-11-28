//対応点からホモグラフィ行列で変換
//2019.11.25

import org.apache.commons.math3.ml.neuralnet.*;
import org.apache.commons.math3.ml.neuralnet.twod.*;
import org.apache.commons.math3.ml.neuralnet.twod.util.*;
import org.apache.commons.math3.ml.neuralnet.oned.*;
import org.apache.commons.math3.ml.neuralnet.sofm.*;
import org.apache.commons.math3.ml.neuralnet.sofm.util.*;
import org.apache.commons.math3.ml.clustering.*;
import org.apache.commons.math3.ml.clustering.evaluation.*;
import org.apache.commons.math3.linear.*;

//画像の変換：Hの逆行列をu,v,1にかければx,y,1

double x[];
double y[];
double u[];
double v[];
double MAT[][];
double VEC[];
color UV[][];
int size;

void setup() {
  size(500, 400);
  PImage img = loadImage("test.jpg");
  PImage img2 = createImage(img.width, img.height, RGB);//imgと同じサイズの空画像

  x = new double [5];
  y = new double [5];
  u = new double [5];
  v = new double [5];
  UV = new color [width+1][height+1];

  AddArray(141, 109, 0, 0, 0);
  AddArray(407, 32, 500, 0, 1);
  AddArray(53, 304, 0, 400, 2);
  AddArray(452, 352, 500, 400, 3);

  // double型の2次元配列から行列を作成
  MAT = CreateA();
  // 行列を作成
  RealMatrix A = MatrixUtils.createRealMatrix(MAT);
  //行列デバッグ
  showMatrix(A);

  //ベクトル作成
  VEC = Createb();
  RealVector b = MatrixUtils.createRealVector(VEC); 
  //ベクトルデバッグ
  showVector(b);

  //計算

  RealMatrix A1 = A.transpose(); // 行列Mの転置行列
  RealMatrix A2 = A1.multiply(A); // 行列M1と行列M2の乗算
  RealMatrix A3 = MatrixUtils.inverse(A2); // 行列Mの逆行列
  RealMatrix A4 = A.transpose();//Aの転値
  RealMatrix A5 = A3.multiply(A4);
  RealVector x1 = A5.operate(b); // 行列Mとベクトルvの乗算

  //xデバッグ
  showVector(x1);

  //ホモグラフィ行列
  RealMatrix H = MatrixUtils.createRealMatrix(3, 3); 
  int temp = 0;
  for (int i = 0; i<3; i++) {
    for (int j = 0; j<3; j++) {
      if (temp == 8)  H.setEntry( i, j, 1.0);
      else H.setEntry( i, j, x1.getEntry( temp ));
      temp++;
    }
  }
  //Hデバッグ
  showMatrix(H);

  for (int j=0; j<height; j++) {
    for (int i =0; i<width; i++) {
      double[] vecT = {i, j, 1};
      RealVector vT = MatrixUtils.createRealVector(vecT);
      RealMatrix H2 = MatrixUtils.inverse(H);//逆行列
      //RealVector vT2 = H.operate(vT);
      RealVector vT3 = H2.operate(vT);
      
      int vT3x = (int)(vT3.getEntry(0)/vT3.getEntry(2));
      int vT3y = (int)(vT3.getEntry(1)/vT3.getEntry(2)); 
      
      color c = img.get(vT3x, vT3y);

      if (0<=vT3x && vT3x<width &&  0<vT3y && vT3y<height) {
        UV[i][j] = c;
        img2.set(i, j, c);
      }
    }
    image(img2, 0, 0);
  }
}

//配列作成
void AddArray(double xi, double yi, double ui, double vi, int i) {
  x[i] = xi;
  y[i] = yi;
  u[i] = ui;
  v[i] = vi;
  size=i+1;
}

double[][] CreateA() {
  double [][] M = {{x[0], y[0], 1, 0, 0, 0, -1*x[0]*u[0], -y[0]*u[0]}, 
    {0, 0, 0, x[0], y[0], 1, -1*x[0]*v[0], -1*y[0]*v[0]}, 
    {x[1], y[1], 1, 0, 0, 0, -1*x[1]*u[1], -y[1]*u[1]}, 
    {0, 0, 0, x[1], y[1], 1, -1*x[1]*v[1], -1*y[1]*v[1]}, 
    {x[2], y[2], 1, 0, 0, 0, -1*x[2]*u[2], -y[2]*u[2]}, 
    {0, 0, 0, x[2], y[2], 1, -1*x[2]*v[2], -1*y[2]*v[2]}, 
    {x[3], y[3], 1, 0, 0, 0, -1*x[3]*u[3], -y[3]*u[3]}, 
    {0, 0, 0, x[3], y[3], 1, -1*x[3]*v[3], -1*y[3]*v[3]}
  };
  return M;
}

double [] Createb() {
  double [] vec = new double[size*2];
  for (int i = 0; i<size; i++) {
    vec[i*2]= u[i];
    vec[i*2+1] = v[i];
  }
  return vec;
}

//行列のデバッグ
void showMatrix(RealMatrix M) {
  println("---");
  for (int i=0; i<M.getRowDimension(); i++) {
    for (int j=0; j<M.getColumnDimension(); j++) {
      print( M.getEntry(i, j) + ", " );
    }
    println();
  }
  println("---");
}

// ベクトルのデバッグ
void showVector(RealVector v) {
  println("---");
  for (int i=0; i<v.getDimension(); i++) {
    println( v.getEntry(i) );
  }
  println("---");
}