/*
Then convex hull of points on a sphere is a Dealaunay triangulation.
The dual of this triangulation is the Voronoi diagram of the points on the sphere.
The cells are technically parts of the sphere and not planar so the approach below
introduces some errors. But it's close.
*/

import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh,mesh2;
WB_Render3D render;
WB_DebugRender3D drender;
WB_Point[] points;
int num;
void setup() {
  size(1920, 1080, P3D);
  smooth(8);
  WB_RandomOnSphere rs=new WB_RandomOnSphere();
  HEC_ConvexHull creator=new HEC_ConvexHull();
  num=500;
  points =new WB_Point[num];
  for (int i=0;i<num;i++) {
   
    points[i]=rs.nextPoint().mulSelf(400.0); 
  }
  creator.setPoints(points);
  creator.setN(num);  
  mesh=new HE_Mesh(creator); 
  mesh=new HE_Mesh(new HEC_Dual(mesh).setFixNonPlanarFaces(false));
  mesh2=mesh.get();
  mesh2.scale(0.9);
  mesh.modify(new HEM_PunchHoles().setWidth(10));
  mesh.modify(new HEM_Shell().setThickness(10));

 
  HET_Diagnosis.validate(mesh);

 
  render=new WB_Render3D(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  render.drawEdges(mesh2);
 for (int i=0;i<num;i++) {
    render.drawPoint(points[i]);
  }
  noStroke();
  render.drawFaces(mesh);
  render.drawFaces(mesh2);
}

