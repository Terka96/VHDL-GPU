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

import javax.swing.JFrame;

public class Viewport {
    public static void main(String[] args) {
        Perspective perspective = new Perspective();
        Geometry model = new Geometry("cube.obj");
        Canvas canvas = new Canvas(320,240);
        drawFrame(perspective, canvas, model,0);

        JFrame frame = new JFrame();
        frame.setSize(320, 240); // Change width and height as needed
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        CanvasComponent component = new CanvasComponent();
        component.setCanvas(canvas);
        frame.add(component);
        frame.setVisible(true);

        float rot =0;
        while(true){
            drawFrame(perspective, canvas, model,rot);
            frame.repaint(0,0,0,320,240);
            rot += 0.1f;
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    private static void drawFrame(Perspective perspective, Canvas canvas, Geometry model, float rotation){
        canvas.clearToColor(new Colour(0,0.5f,0));
        perspective.calculateProjectionMatrix(new Point3f(0.0f,1.0f,-9.0f),new Point3f(0.0f,1.57f,0.0f),40.0f);  //cube
        //perspective.calculateProjectionMatrix(new Point3f(0.0f,1.1f,-2.5f),new Point3f(0.0f,3.80f,0.0f),50.0f); //furniture
        model.draw(perspective,canvas);
        showFrame(canvas);
    }
    private static void showFrame(Canvas canvas){

    }
}
