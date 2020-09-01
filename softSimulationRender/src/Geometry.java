import java.io.*;
import java.util.ArrayList;

public class Geometry {
    public ArrayList<Triangle> getTriangles() {
        return triangles;
    }

    ArrayList<Triangle> triangles = new ArrayList<>();

    public Geometry (String fileName){
        //read file or load static points
        if(fileName.compareTo("cube")==0){
            Point3f p1 = new Point3f(-1,1,-1);
            Point3f p2 = new Point3f(1,1,-1);
            Point3f p3 = new Point3f(-1,-1,-1);
            Point3f p4 = new Point3f(1,-1,-1);
            Point3f p5 = new Point3f(-1,1,1);
            Point3f p6 = new Point3f(1,1,1);
            Point3f p7 = new Point3f(-1,-1,1);
            Point3f p8 = new Point3f(1,-1,1);

            Point3f nX1 = new Point3f(1,0,0);
            Point3f nX2 = new Point3f(-1,0,0);
            Point3f nY1 = new Point3f(0,1,0);
            Point3f nY2 = new Point3f(0,-1,0);
            Point3f nZ1 = new Point3f(0,0,1);
            Point3f nZ2 = new Point3f(0,0,-1);

            Point3f UV1 = new Point3f(0,0,0);
            Point3f UV2 = new Point3f(0,1,0);
            Point3f UV3 = new Point3f(1,0,0);
            Point3f UV4 = new Point3f(1,1,0);

            //by z
            triangles.add(new Triangle(new Vertex(p3,nZ2,UV3),new Vertex(p2,nZ2,UV2),new Vertex(p1,nZ2,UV1)));
            //triangles.add(new Triangle(new Vertex(p4,nZ2,UV4),new Vertex(p2,nZ2,UV2),new Vertex(p3,nZ2,UV3)));
            //triangles.add(new Triangle(new Vertex(p5,nZ1,UV1),new Vertex(p6,nZ1,UV2),new Vertex(p7,nZ1,UV3)));
            //triangles.add(new Triangle(new Vertex(p7,nZ1,UV3),new Vertex(p6,nZ1,UV2),new Vertex(p8,nZ1,UV4)));
            //by x
            //triangles.add(new Triangle(new Vertex(p5,nX2,UV3),new Vertex(p3,nX2,UV2),new Vertex(p1,nX2,UV1)));
            //triangles.add(new Triangle(new Vertex(p7,nX2,UV4),new Vertex(p3,nX2,UV2),new Vertex(p5,nX2,UV3)));
            //triangles.add(new Triangle(new Vertex(p2,nX1,UV1),new Vertex(p4,nX1,UV2),new Vertex(p6,nX1,UV3)));
            //triangles.add(new Triangle(new Vertex(p6,nX1,UV3),new Vertex(p4,nX1,UV2),new Vertex(p8,nX1,UV4)));
            //by y
            //triangles.add(new Triangle(new Vertex(p7,nY2,UV3),new Vertex(p4,nY2,UV2),new Vertex(p3,nY2,UV1)));
            //triangles.add(new Triangle(new Vertex(p8,nY2,UV4),new Vertex(p4,nY2,UV2),new Vertex(p7,nY2,UV3)));
            //triangles.add(new Triangle(new Vertex(p1,nY1,UV1),new Vertex(p2,nY1,UV2),new Vertex(p5,nY1,UV3)));
            //triangles.add(new Triangle(new Vertex(p5,nY1,UV3),new Vertex(p2,nY1,UV2),new Vertex(p6,nY1,UV4)));
        } else {
            File file = new File(fileName);
            try {
                BufferedReader br = new BufferedReader(new FileReader(file));

                ArrayList <Point3f> vertices = new ArrayList<>();
                ArrayList <Point3f> normals = new ArrayList<>();
                ArrayList <Point3f> uvcoords = new ArrayList<>();

                String line;
                while((line = br.readLine()) != null){
                    String[] fields = line.split(" ");
                    if (fields[0].compareTo("v") == 0){
                        vertices.add(new Point3f(Float.parseFloat(fields[1]),Float.parseFloat(fields[2]),Float.parseFloat(fields[3])));
                    } else if (fields[0].compareTo("vn") == 0){
                        normals.add(new Point3f(Float.parseFloat(fields[1]),Float.parseFloat(fields[2]),Float.parseFloat(fields[3])));
                    } else if (fields[0].compareTo("vt") == 0){
                        uvcoords.add(new Point3f(Float.parseFloat(fields[1]),Float.parseFloat(fields[2]),0.0f));
                    } else if (fields[0].compareTo("f") == 0){
                        String[] _1 = fields[1].split("/");
                        String[] _2 = fields[2].split("/");
                        String[] _3 = fields[3].split("/");
                        triangles.add(new Triangle(new Vertex(vertices.get(Integer.parseInt(_1[0])-1),normals.get(Integer.parseInt(_1[2])-1),uvcoords.get(Integer.parseInt(_1[1])-1)),
                                new Vertex(vertices.get(Integer.parseInt(_2[0])-1),normals.get(Integer.parseInt(_2[2])-1),uvcoords.get(Integer.parseInt(_2[1])-1)),
                                new Vertex(vertices.get(Integer.parseInt(_3[0])-1),normals.get(Integer.parseInt(_3[2])-1),uvcoords.get(Integer.parseInt(_3[1])-1))));
                    }
                }

            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void draw(Perspective perspective,Canvas canvas){
        for(Triangle triangle : triangles){
            Vertex[] vertices3d = triangle.getVertices();
            vertices3d[0].projected = perspective.projectPoint(vertices3d[0].geo);
            vertices3d[1].projected = perspective.projectPoint(vertices3d[1].geo);
            vertices3d[2].projected = perspective.projectPoint(vertices3d[2].geo);

            //if(vertices3d[0].projected.z<0 || vertices3d[1].projected.z <0 || vertices3d[2].projected.z <0)
            //    continue;

            //wireframe mode
//            canvas.drawLine(vertices2d[0],vertices2d[1]);
//            canvas.drawLine(vertices2d[1],vertices2d[2]);
//            canvas.drawLine(vertices2d[2],vertices2d[0]);

            //calculate normal vector/calculate lighting
            //Point3f lightPos = new Point3f(3,3,3); //POINT LIGHT
            //Point3f lightDir = new Point3f(center.getX()-lightPos.getX(),center.getY()-lightPos.getY(),center.getZ()-lightPos.getZ()); //POINT LIGHT
            //Point3f lightDir = perspective.transformPointToCam(new Point3f(-1,1,1)); //SUN LIGHT
            Point3f lightDir = new Point3f(1.7f,1.5f,-4.5f);
            float lightDist = (float)Math.sqrt(lightDir.x*lightDir.x+lightDir.y*lightDir.y+lightDir.z*lightDir.z);
            vertices3d[0].lightLevel = Math.max(0.0f,(lightDir.x*vertices3d[0].norm.x+lightDir.y*vertices3d[0].norm.y+lightDir.z*vertices3d[0].norm.z) / lightDist);
            vertices3d[1].lightLevel = Math.max(0.0f,(lightDir.x*vertices3d[1].norm.x+lightDir.y*vertices3d[1].norm.y+lightDir.z*vertices3d[1].norm.z) / lightDist);
            vertices3d[2].lightLevel = Math.max(0.0f,(lightDir.x*vertices3d[2].norm.x+lightDir.y*vertices3d[2].norm.y+lightDir.z*vertices3d[2].norm.z) / lightDist);
/*
            //color fill
            //posortuj wierzchołki wzrostem
            Vertex swapper;
            if(vertices3d[2].projected.y > vertices3d[1].projected.y) {
                swapper = vertices3d[2];
                vertices3d[2] = vertices3d[1];
                vertices3d[1] = swapper;
            }
            if(vertices3d[1].projected.y > vertices3d[0].projected.y) {
                swapper = vertices3d[1];
                vertices3d[1] = vertices3d[0];
                vertices3d[0] = swapper;
                if (vertices3d[2].projected.y > vertices3d[1].projected.y) {
                    swapper = vertices3d[2];
                    vertices3d[2] = vertices3d[1];
                    vertices3d[1] = swapper;
                }
            }
            //filling

            int v1x = (int)vertices3d[0].projected.x;
            int v1y = (int)vertices3d[0].projected.y;
            int v2x = (int)vertices3d[1].projected.x;
            int v2y = (int)vertices3d[1].projected.y;
            int v3x = (int)vertices3d[2].projected.x;
            int v3y = (int)vertices3d[2].projected.y;
            float v1z = vertices3d[0].projected.z;
            float v2z = vertices3d[1].projected.z;
            float v3z = vertices3d[2].projected.z;
            float v1l = vertices3d[0].lightLevel;
            float v2l = vertices3d[1].lightLevel;
            float v3l = vertices3d[2].lightLevel;
            float v1tu = vertices3d[0].uvmap.x;
            float v1tv = vertices3d[0].uvmap.y;
            float v2tu = vertices3d[1].uvmap.x;
            float v2tv = vertices3d[1].uvmap.y;
            float v3tu = vertices3d[2].uvmap.x;
            float v3tv = vertices3d[2].uvmap.y;


            float delta12x = 0;
            float delta13x = 0;
            float delta23x = 0;
            float delta12z = 0;
            float delta13z = 0;
            float delta23z = 0;
            float delta12l = 0;
            float delta13l = 0;
            float delta23l = 0;
            float delta12tu = 0;
            float delta12tv = 0;
            float delta13tu = 0;
            float delta13tv = 0;
            float delta23tu = 0;
            float delta23tv = 0;

            if(v1y != v3y) {
                delta13x = (v1x - v3x) / (float)(v1y - v3y);
                delta13z = (v1z - v3z) / (float)(v1y - v3y);
                delta13l = (v1l - v3l) / (float)(v1y - v3y);
                delta13tu = (v1tu - v3tu) / (float)(v1y - v3y);
                delta13tv = (v1tv - v3tv) / (float)(v1y - v3y);
                if (v1y != v2y) {
                    delta12x = (v1x - v2x) / (float)(v1y - v2y);
                    delta12z = (v1z - v2z) / (float)(v1y - v2y);
                    delta12l = (v1l - v2l) / (float)(v1y - v2y);
                    delta12tu = (v1tu - v2tu) / (float)(v1y - v2y);
                    delta12tv = (v1tv - v2tv) / (float)(v1y - v2y);
                    for (int i = 0; i < v1y - v2y; i++) {
                        int line = v1y - i;
                        canvas.drawLine(new Point3f(v1x - (int)(i * delta12x), line,v1z - (i * delta12z)),
                                new Point3f (v1x - (int)(i * delta13x), line,v1z - (i * delta13z)),
                                v1tu - delta12tu*i, v1tv - delta12tv*i,v1tu - delta13tu*i,v1tv - delta13tv*i,
                                v1l-delta12l*i,v1l-delta13l*i);
                    }
                }   //END IF2 FOR1
                if (v2y != v3y) {
                    delta23x = (v2x - v3x) / (float)(v2y - v3y);
                    delta23z = (v2z - v3z) / (float)(v2y - v3y);
                    delta23l = (v2l - v3l) / (float)(v2y - v3y);
                    delta23tu = (v2tu - v3tu) / (float)(v2y - v3y);
                    delta23tv = (v2tv - v3tv) / (float)(v2y - v3y);
                    int Y = v1y-v2y;
                    for (int i = 0; i < v2y - v3y; i++) {
                        int line = v2y - i;
                        canvas.drawLine(new Point3f(v2x - (int)(i * delta23x), line,v2z - (i * delta23z)),
                                new Point3f ( v1x - (int)((i+Y) * delta13x), line,v1z - ((i+Y) * delta13z)),
                                v2tu - delta23tu*i, v2tv - delta23tv*i,v1tu - delta13tu*(i+Y),v1tv - delta13tv*(i+Y),
                                v2l-(delta23l*i),v1l-(delta13l*(i+Y)));
                    }
                }   //END IF3 FOR2
            }   //END IF1
*/

            float v1x = vertices3d[0].projected.x;
            float v1y = vertices3d[0].projected.y;
            float v2x = vertices3d[1].projected.x;
            float v2y = vertices3d[1].projected.y;
            float v3x = vertices3d[2].projected.x;
            float v3y = vertices3d[2].projected.y;
            float v1w = vertices3d[0].projected.w;
            float v2w = vertices3d[1].projected.w;
            float v3w = vertices3d[2].projected.w;
            float v1z = vertices3d[0].projected.z/v1w;
            float v2z = vertices3d[1].projected.z/v2w;
            float v3z = vertices3d[2].projected.z/v3w;
            float v1l = vertices3d[0].lightLevel/v1w;
            float v2l = vertices3d[1].lightLevel/v2w;
            float v3l = vertices3d[2].lightLevel/v3w;
            float v1tu = vertices3d[0].uvmap.x/v1w;
            float v1tv = vertices3d[0].uvmap.y/v1w;
            float v2tu = vertices3d[1].uvmap.x/v2w;
            float v2tv = vertices3d[1].uvmap.y/v2w;
            float v3tu = vertices3d[2].uvmap.x/v3w;
            float v3tv = vertices3d[2].uvmap.y/v3w;

            int maxX = (int)Math.max(v1x,Math.max(v2x,v3x));
            int maxY = (int)Math.max(v1y,Math.max(v2y,v3y));
            int minX = (int)Math.min(v1x,Math.min(v2x,v3x));
            int minY = (int)Math.min(v1y,Math.min(v2y,v3y));

            v1w = 1.0f / v1w;
            v2w = 1.0f / v2w;
            v3w = 1.0f / v3w;


            float area = (v3x - v1x) * (v2y - v1y) - (v3y - v1y) * (v2x - v1x);

            for(int y = minY;y <= maxY;y++)
                for(int x =minX;x <= maxX;x++) {
                    float w0 =(x - v2x) * (v3y - v2y) - (y - v2y) * (v3x - v2x);
                    float w1 =(x - v3x) * (v1y - v3y) - (y - v3y) * (v1x - v3x);
                    float w2 =(x - v1x) * (v2y - v1y) - (y - v1y) * (v2x - v1x);
                    if (w0 >= 0 && w1 >= 0 && w2 >= 0)
                    {
                        w0 /= area;
                        w1 /= area;
                        w2 /= area;

                        float w = 1.0f / (w0 * v1w + w1 * v2w + w2 * v3w);
                        float tu = (w0 * v1tu + w1 * v2tu + w2 * v3tu)*w;
                        float tv = (w0 * v1tv + w1 * v2tv + w2 * v3tv)*w;
                        float l =  (w0 * v1l + w1 * v2l + w2 * v3l)*w;
                        float z =  (w0 * v1z + w1 * v2z + w2 * v3z)*w;
                        canvas.drawTexel(x,y,z,l,tu,tv);
                    }
                }













        }
    }
}
