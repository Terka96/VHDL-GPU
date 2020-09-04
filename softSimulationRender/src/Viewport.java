import javax.swing.JFrame;

public class Viewport {
    public static void main(String[] args) {
        Perspective perspective = new Perspective();
        Geometry model = new Geometry("cube.obj");
        Canvas canvas = new Canvas(640,480);
        drawFrame(perspective, canvas, model,0);

        JFrame frame = new JFrame();
        frame.setSize(640, 480); // Change width and height as needed
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        CanvasComponent component = new CanvasComponent();
        component.setCanvas(canvas);
        frame.add(component);
        frame.setVisible(true);

        float rot =0;
        while(true){
            drawFrame(perspective, canvas, model,rot);
            frame.repaint(0,0,0,640,480);
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
        perspective.calculateProjectionMatrix(new Point3f(0.0f,1.0f,-9.0f),new Point3f(0.0f,rotation + 1.57f,0.0f),40.0f);  //cube
        //perspective.calculateProjectionMatrix(new Point3f(0.0f,1.1f,-2.5f),new Point3f(0.0f,3.80f,0.0f),50.0f); //furniture
        model.draw(perspective,canvas);
        showFrame(canvas);
    }
    private static void showFrame(Canvas canvas){

    }
}
