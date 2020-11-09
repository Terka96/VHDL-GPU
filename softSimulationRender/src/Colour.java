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

public class Colour {
    private float r,g,b;
    public Colour(float r, float g, float b) {
        if(r >1.0f) this.r=1.0f;
        else if(r < 0.0f) this.r=0.0f;
        else this.r=r;
        if(g >1.0f) this.g=1.0f;
        else if(g < 0.0f) this.g=0.0f;
        else this.g=g;
        if(b >1.0f) this.b=1.0f;
        else if(b < 0.0f) this.b=0.0f;
        else this.b=b;
    }

    public Colour(Colour c) {
        this.r=c.getR()/255.0f;
        this.g=c.getG()/255.0f;
        this.b=c.getB()/255.0f;
    }

    public int getR() {
        return Math.round(r*255);
    }

    public int getG() {
        return Math.round(g*255);
    }

    public int getB() {
        return Math.round(b*255);
    }

    public String getHex() {return String.format("%02x%02x%02x", getR(),getG(),getB());}
}
