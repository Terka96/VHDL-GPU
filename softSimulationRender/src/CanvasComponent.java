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
