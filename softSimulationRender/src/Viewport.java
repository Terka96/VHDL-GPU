import javax.swing.JFrame;

public class Viewport {
    public static void main(String[] args) {
        Perspective perspective = new Perspective();
        Geometry model = new Geometry("cube");
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
        //perspective.calculateProjectionMatrix(new Point3f(2.0f,0.3f,3.0f),new Point3f(0.0f,-0.6f,0.0f),10.0f);  --cup
        perspective.calculateProjectionMatrix(new Point3f(1.7f,1.5f,-4.5f),new Point3f(0.0f,0.5f,0.0f),90.0f);
        model.draw(perspective,canvas);
        showFrame(canvas);
    }
    private static void showFrame(Canvas canvas){

    }
}
