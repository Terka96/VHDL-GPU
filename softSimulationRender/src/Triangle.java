public class Triangle {
    private Vertex[] vertices = new Vertex[3];

    public Triangle(Vertex a,Vertex b, Vertex c){
        vertices[0]=a;
        vertices[1]=b;
        vertices[2]=c;
    }

    public Vertex[] getVertices() {
        return vertices;
    }
    public void setVertices(Vertex[] vertices) {
        this.vertices = vertices;
    }
}
