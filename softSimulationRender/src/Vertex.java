public class Vertex {
    public Point3f geo;
    public Point3f norm;
    public Point3f uvmap;
    public Point4f projected;
    public float lightLevel;
    public Colour color;

    Vertex(Point3f g, Point3f n,Point3f uvmap){
        this.geo=g;
        this.norm=n;
        this.uvmap=uvmap;
    }
}