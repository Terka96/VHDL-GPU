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

public class Canvas {
    private Colour[][] canvas;
    private float[][] zBuf;
    private int sizeX;
    private int sizeY;
    Texture tx;
    private Colour currentColour = new Colour(1.0f, 1.0f, 1.0f);
    Canvas(int sizeX,int sizeY){
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        canvas = new Colour[sizeX][sizeY];
        zBuf = new float[sizeX][sizeY];
        tx = new Texture("tex_tb1.bmp");
    }
    public void drawLine(Point3f p1, Point3f p2,float tx1u,float tx1v,float tx2u,float tx2v, float ll1, float ll2){
            Point3f delta = new Point3f(p2.x-p1.x,0,p2.z-p1.z);
            float lightDelta = ll2 - ll1;
            float txuDelta = tx2u - tx1u;
            float txvDelta = tx2v - tx1v;
            //TODO: optimize make variable itercount

            float dx = delta.x/Math.abs(delta.x);
            float dz = delta.z/Math.abs(delta.x);
            float dl = lightDelta/Math.abs(delta.x);
            float du = txuDelta/Math.abs(delta.x);
            float dv = txvDelta/Math.abs(delta.x);
            for (int i = 0; i <= Math.abs(delta.x) ; i++) {
                Colour diffuse = tx.getColor(tx1u + i*du,tx1v+ i*dv);
                setCurrentColour(new Colour(diffuse.getR()*(ll1+i*dl)/255.0f,diffuse.getG()*(ll1+i*dl)/255.0f,diffuse.getB()*(ll1+i*dl)/255.0f));
                drawPixel((int) (p1.x + dx * i), (int) p1.y, p1.z + dz * i);
            }
    }

    public void drawTexel(float x, float y, float z, float l, float tu,float tv){
        Colour diffuse = tx.getColor(tu,tv);
        setCurrentColour(new Colour(diffuse.getR()*(l)/255.0f,diffuse.getG()*(l)/255.0f,diffuse.getB()*(l)/255.0f));
        //setCurrentColour(new Colour(z,z,z));
        drawPixel((int) x, (int) y, z);
    }

    ///x,y and depth z
    public void drawPixel(int x, int y, float z){
        if(x > 0 && x < sizeX && y > 0 && y < sizeY && z < zBuf[x][y]) {
            canvas[x][y] = new Colour(currentColour);
            zBuf[x][y] = z;
        }
    }
    public void clearToColor(Colour colour){
        for(int x=0;x<sizeX;x++)
            for(int y=0;y<sizeY;y++){
                canvas[x][y]= colour;
                zBuf[x][y]=1000.0f; //todo set infinity
            }
    }
    public Colour getPixel(int x, int y){
        return canvas[x][y];
    }

    public void setCurrentColour(Colour c) {this.currentColour = c;}

    public int getSizeX(){return sizeX;}

    public int getSizeY(){return sizeY;}

}
