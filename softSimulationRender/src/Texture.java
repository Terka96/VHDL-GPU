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

import java.io.File;
import java.awt.image.BufferedImage;
import java.io.IOException;
import javax.imageio.ImageIO;

public class Texture {
    private Colour[][] texture;
    private int sizeX;
    private int sizeY;
    Texture(String fileName) {
        File file = new File(fileName);
        BufferedImage img = null;
        try {
            img = ImageIO.read(file);
        } catch (IOException e) {

        }
        sizeY = img.getHeight();
        sizeX = img.getWidth();

        texture = new Colour[sizeX][sizeY];

        for(int y=0;y<sizeY;y++)
            for(int x=0;x<sizeX;x++) {
                int rgb = img.getRGB(x, y);
                int r = (rgb >> 16) & 0x000000FF;
                int g = (rgb >> 8) & 0x000000FF;
                int b = (rgb) & 0x000000FF;
                texture[x][y] = new Colour(r/255.0f,g/255.0f,b/255.0f);
            }

    }
    Colour getColor(float u,float v){
        int x = (int)(u*(float)sizeX)%sizeX; if(x < 0 ) x+=sizeX;
        int y = (int)(v*(float)sizeY)%sizeY; if(y < 0 ) y+=sizeY;

        return texture[x][y];
    }
    void drawOnCanvas(Canvas canvas){
        for (int y = 0; y < sizeY; y++)
            for (int x = 0; x < sizeX; x++) {
                canvas.setCurrentColour(texture[x][y]);
                canvas.drawPixel(x,y,1.0f);
            }
    }
}
