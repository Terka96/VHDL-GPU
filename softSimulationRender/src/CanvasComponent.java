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

import javax.swing.JComponent;
import java.awt.Graphics;

public class CanvasComponent extends JComponent{
    Canvas canvas;
    public void setCanvas(Canvas canvas){
        this.canvas = canvas;
    }

    public void paintComponent(Graphics g)
    {
        for(int x=0;x<canvas.getSizeX();x++)
            for(int y=0;y<canvas.getSizeY();y++) {
                Colour colour = canvas.getPixel(x,y);
                g.setColor(new java.awt.Color(colour.getR(), colour.getG(), colour.getB()));
                g.drawLine(x, y, x, y);
            }
    }
}
