//ホモグラフィ変換で二枚の画像を対応点を元につなぎ合わせる
//2019.11.25
//ライブラリ、ApacheCommonsMathが必要

import org.apache.commons.math3.ml.neuralnet.*;
import org.apache.commons.math3.ml.neuralnet.twod.*;
import org.apache.commons.math3.ml.neuralnet.twod.util.*;
import org.apache.commons.math3.ml.neuralnet.oned.*;
import org.apache.commons.math3.ml.neuralnet.sofm.*;
import org.apache.commons.math3.ml.neuralnet.sofm.util.*;
import org.apache.commons.math3.ml.clustering.*;
import org.apache.commons.math3.ml.clustering.evaluation.*;
import org.apache.commons.math3.ml.distance.*;
import org.apache.commons.math3.analysis.*;
import org.apache.commons.math3.analysis.differentiation.*;
import org.apache.commons.math3.analysis.integration.*;
import org.apache.commons.math3.analysis.integration.gauss.*;
import org.apache.commons.math3.analysis.function.*;
import org.apache.commons.math3.analysis.polynomials.*;
import org.apache.commons.math3.analysis.solvers.*;
import org.apache.commons.math3.analysis.interpolation.*;
import org.apache.commons.math3.stat.interval.*;
import org.apache.commons.math3.stat.ranking.*;
import org.apache.commons.math3.stat.clustering.*;
import org.apache.commons.math3.stat.*;
import org.apache.commons.math3.stat.inference.*;
import org.apache.commons.math3.stat.correlation.*;
import org.apache.commons.math3.stat.descriptive.*;
import org.apache.commons.math3.stat.descriptive.rank.*;
import org.apache.commons.math3.stat.descriptive.summary.*;
import org.apache.commons.math3.stat.descriptive.moment.*;
import org.apache.commons.math3.stat.regression.*;
import org.apache.commons.math3.linear.*;
import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;
import org.apache.commons.math3.distribution.fitting.*;
import org.apache.commons.math3.complex.*;
import org.apache.commons.math3.ode.*;
import org.apache.commons.math3.ode.nonstiff.*;
import org.apache.commons.math3.ode.events.*;
import org.apache.commons.math3.ode.sampling.*;
import org.apache.commons.math3.random.*;
import org.apache.commons.math3.primes.*;
import org.apache.commons.math3.optim.*;
import org.apache.commons.math3.optim.linear.*;
import org.apache.commons.math3.optim.nonlinear.vector.*;
import org.apache.commons.math3.optim.nonlinear.vector.jacobian.*;
import org.apache.commons.math3.optim.nonlinear.scalar.*;
import org.apache.commons.math3.optim.nonlinear.scalar.gradient.*;
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.*;
import org.apache.commons.math3.optim.univariate.*;
import org.apache.commons.math3.exception.*;
import org.apache.commons.math3.exception.util.*;
import org.apache.commons.math3.fitting.leastsquares.*;
import org.apache.commons.math3.fitting.*;
import org.apache.commons.math3.dfp.*;
import org.apache.commons.math3.fraction.*;
import org.apache.commons.math3.special.*;
import org.apache.commons.math3.geometry.*;
import org.apache.commons.math3.geometry.hull.*;
import org.apache.commons.math3.geometry.enclosing.*;
import org.apache.commons.math3.geometry.spherical.twod.*;
import org.apache.commons.math3.geometry.spherical.oned.*;
import org.apache.commons.math3.geometry.euclidean.threed.*;
import org.apache.commons.math3.geometry.euclidean.twod.*;
import org.apache.commons.math3.geometry.euclidean.twod.hull.*;
import org.apache.commons.math3.geometry.euclidean.oned.*;
import org.apache.commons.math3.geometry.partitioning.*;
import org.apache.commons.math3.geometry.partitioning.utilities.*;
import org.apache.commons.math3.optimization.*;
import org.apache.commons.math3.optimization.linear.*;
import org.apache.commons.math3.optimization.direct.*;
import org.apache.commons.math3.optimization.fitting.*;
import org.apache.commons.math3.optimization.univariate.*;
import org.apache.commons.math3.optimization.general.*;
import org.apache.commons.math3.util.*;
import org.apache.commons.math3.genetics.*;
import org.apache.commons.math3.transform.*;
import org.apache.commons.math3.filter.*;


double x[];
double y[];
double u[];
double v[];
double MAT[][];
double VEC[];
color UV[][];
int size;

void setup() {
  size(1188, 890);
  PImage img = loadImage("2.jpg");
  PImage img2 = createImage(img.width*2, img.height*2, RGB);//imgと同じサイズの空画像

  x = new double [5];
  y = new double [5];
  u = new double [5];
  v = new double [5];
  UV = new color [width+1][height+1];

//対応点入力
  AddArray(109, 24, 115, 244, 0);
  AddArray(574, 43, 547, 266, 1);
  AddArray(111, 211, 90, 428, 2);
  AddArray(433, 190, 428, 411, 3);

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

      UV[i][j] = c;
      img2.set(i, j, c);
    }
    //描画
    image(img2, 0, 0);
    PImage img3 = loadImage("1.jpg");
    image (img3, 0, 0);
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