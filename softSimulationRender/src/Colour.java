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
