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
        float nU = u - (float)(int)u;
        float nV = v - (float)(int)v;
        if(nU < 0 ) nU += 1.0f;
        if(nV < 0 ) nV += 1.0f;
        int x = (int)(nU*sizeX);
        int y = (int)(nV*sizeY);
        if(x>=sizeX) x=0;
        if(y>=sizeY) y=0;
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
