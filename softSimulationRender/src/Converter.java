/*
 * Copyright 2020 Piotr Terczyński
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated           
 * documentation files (the "Software"), to deal in the       
 * Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish,           
 * distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to
 * do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice 
 * shall be included in all copies or substantial portions of
 * the Software.
 *
 * 		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF 
 * ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
 * THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import java.util.ArrayList;

public class Converter {
    public static void main(String[] args) {
        //String x = "x\""+Integer.toHexString(f32tof16(320.0f) & 0xffff)+"\"";
        //String y = "x\""+Integer.toHexString(f32tof16(-240.0f) & 0xffff)+"\"";
        //System.out.println("X: "+x+" Y: "+y);
        //exportMatrix();
        //System.out.println(light_dir_to_norm(new Point3f(2.0f,0.5f,0.5f)));
        //exportbmp("tex_tb2.png",512);
        exportObj("furniture.obj");

    }

    private static void exportbmp(String file,int texSize){
        Texture tex = new Texture(file);
        for (int i = 0; i < texSize; i++) {
            System.out.print("(");
            for (int j = 0; j < texSize; j++) {
                Colour colour = tex.getColor(i*1.0f/texSize,j*1.0f/texSize);
                System.out.print("x\""+colour.getHex()+"\",");
            }
            System.out.println("),");
        }
    }

    private static void exportMatrix(){
        Perspective p = new Perspective();
        //p.calculateProjectionMatrix(new Point3f(2.0f,0.3f,3.0f),new Point3f(0.0f,-0.6f,0.0f),10.0f); //cuptex
        p.calculateProjectionMatrix(new Point3f(0.0f,1.0f,-9.0f),new Point3f(0.0f,1.57f,0.0f),40.0f);  //cube
        //p.calculateProjectionMatrix(new Point3f(0.0f,1.1f,-2.5f),new Point3f(0.0f,3.80f,0.0f),50.0f);
        //float[][] w2c = p.getWorld2CamMatrix();
        float[][] pp = p.getProjectionMatrix();

        //for (int i = 0; i < 4; i++)
        //    for (int j = 0; j < 4; j++)
        //        System.out.println("x\""+Integer.toHexString(f32tof16(w2c[i][j]) & 0xffff)+"\"");
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                System.out.print(floatToStr(pp[i][j])+",");
    }

    private static void exportObj(String filename){
        System.out.println(filename+" model below:");
        Geometry geom = new Geometry(filename);
        ArrayList<Triangle> triangles = geom.getTriangles();
        for (Triangle t : triangles){
            String v1gx = floatToStr(t.getVertices()[0].geo.x);
            String v1gy = floatToStr(t.getVertices()[0].geo.y);
            String v1gz = floatToStr(t.getVertices()[0].geo.z);
            String v1nx = floatToStr(t.getVertices()[0].norm.x);
            String v1ny = floatToStr(t.getVertices()[0].norm.y);
            String v1nz = floatToStr(t.getVertices()[0].norm.z);
            String v1tu = floatToStr(t.getVertices()[0].uvmap.x);
            String v1tv = floatToStr(t.getVertices()[0].uvmap.y);

            String v2gx = floatToStr(t.getVertices()[1].geo.x);
            String v2gy = floatToStr(t.getVertices()[1].geo.y);
            String v2gz = floatToStr(t.getVertices()[1].geo.z);
            String v2nx = floatToStr(t.getVertices()[1].norm.x);
            String v2ny = floatToStr(t.getVertices()[1].norm.y);
            String v2nz = floatToStr(t.getVertices()[1].norm.z);
            String v2tu = floatToStr(t.getVertices()[1].uvmap.x);
            String v2tv = floatToStr(t.getVertices()[1].uvmap.y);

            String v3gx = floatToStr(t.getVertices()[2].geo.x);
            String v3gy = floatToStr(t.getVertices()[2].geo.y);
            String v3gz = floatToStr(t.getVertices()[2].geo.z);
            String v3nx = floatToStr(t.getVertices()[2].norm.x);
            String v3ny = floatToStr(t.getVertices()[2].norm.y);
            String v3nz = floatToStr(t.getVertices()[2].norm.z);
            String v3tu = floatToStr(t.getVertices()[2].uvmap.x);
            String v3tv = floatToStr(t.getVertices()[2].uvmap.y);

            String line = String.format("(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s),",
                                        v1gx,v1gy,v1gz,v1nx,v1ny,v1nz,v1tu,v1tv,
                                        v2gx,v2gy,v2gz,v2nx,v2ny,v2nz,v2tu,v2tv,
                                        v3gx,v3gy,v3gz,v3nx,v3ny,v3nz,v3tu,v3tv);

            //String line = String.format("((%s,%s,%s,%s,%s,%s,%s,%s)," +
            //                            " (%s,%s,%s,%s,%s,%s,%s,%s)," +
            //                            " (%s,%s,%s,%s,%s,%s,%s,%s)),",
            //                            v1gx,v1gy,v1gz,v1nx,v1ny,v1nz,v1tu,v1tv,
            //                            v2gx,v2gy,v2gz,v2nx,v2ny,v2nz,v2tu,v2tv,
            //                            v3gx,v3gy,v3gz,v3nx,v3ny,v3nz,v3tu,v3tv);

            System.out.println(line);
        }
    }
    private static String floatToStr(float a){
        return String.format("x\"%1$" + 4 + "s\"", Integer.toHexString(f32tof16(a) & 0xffff)).replace(' ', '0');
    }

    private static short f32tof16(float a){
        int i = Float.floatToIntBits(a);
        int s = (i & 0x80000000) >> 16; //sign
        int e1 = (i & 0x07800000) >> 13; //exponent1
        int e2 = (i & 0x40000000) >> 16; //exponent2
        int m = (i & 0x007FE000) >> 13; //mantis

        return (short)((s|e1|e2|m) & 0xFFFF);
    }

    private static String light_dir_to_norm(Point3f lightDir){
        float lightDist = (float)Math.sqrt(lightDir.x*lightDir.x+lightDir.y*lightDir.y+lightDir.z*lightDir.z);
        String lx = floatToStr(lightDir.x/lightDist);
        String ly = floatToStr(lightDir.y/lightDist);
        String lz = floatToStr(lightDir.z/lightDist);
        return lx + " "+ly+ " "+lz;
    }
}
