import java.util.ArrayList;

public class Perspective {
    private float[][] projectionMatrix = new float[4][4]; //kolejność współrzędnych macierzowa (y,x)
    private float[][] world2CamMatrix = new float[4][4];
    private float[][] perspectiveMatrix = new float[4][4];

    public void calculateProjectionMatrix(Point3f camPos, Point3f camAngle, float fov){
        //TRANSLACJA I OBRÓT W OSI Y
        world2CamMatrix[0][0] = (float)Math.cos(camAngle.y);
        world2CamMatrix[0][1] = 0.0f;
        world2CamMatrix[0][2] = -(float)Math.sin(camAngle.y);
        world2CamMatrix[0][3] = -camPos.x; //-camPos.x*(float)Math.cos(camAngle.y) - (float)Math.sin(camAngle.y)*camPos.z;

        world2CamMatrix[1][0] = 0.0f;
        world2CamMatrix[1][1] = 1.0f;
        world2CamMatrix[1][2] = 0.0f;
        world2CamMatrix[1][3] = -camPos.y;

        world2CamMatrix[2][0] = (float)Math.sin(camAngle.y);
        world2CamMatrix[2][1] = 0.0f;
        world2CamMatrix[2][2] = (float)Math.cos(camAngle.y);
        world2CamMatrix[2][3] = -camPos.z; //camPos.z*(float)Math.sin(camAngle.y) - (float)Math.cos(camAngle.y)*camPos.z;

        world2CamMatrix[3][0] = 0.0f;
        world2CamMatrix[3][1] = 0.0f;
        world2CamMatrix[3][2] = 0.0f;
        world2CamMatrix[3][3] = 1.0f;

        float tgfov = (float)Math.tan(fov * 0.5f * Math.PI / 180.0f);
        float aspectRatio = 320.0f/240.0f;
        float n = 2.0f;
        float f = 50.0f;
        float l =-aspectRatio * n * tgfov;
        float r =aspectRatio * n * tgfov;
        float b =-n * tgfov;
        float t =n * tgfov;

        perspectiveMatrix[0][0] = 2 * n / r - l;
        perspectiveMatrix[0][1] = 0.0f;
        perspectiveMatrix[0][2] = 0.0f;
        perspectiveMatrix[0][3] = 0.0f;

        perspectiveMatrix[1][0] = 0.0f;
        perspectiveMatrix[1][1] = 2 * n / t - b;
        perspectiveMatrix[1][2] = 0.0f;
        perspectiveMatrix[1][3] = 0.0f;

        perspectiveMatrix[2][0] = (r + l) / (r - l);
        perspectiveMatrix[2][1] = (t + b) / (t - b);
        perspectiveMatrix[2][2] = (f + n) / (f - n);
        perspectiveMatrix[2][3] = -1.0f;

        perspectiveMatrix[3][0] = 0.0f;
        perspectiveMatrix[3][1] = 0.0f;
        perspectiveMatrix[3][2] = 2*n*f / (f - n);
        perspectiveMatrix[3][3] = 0.0f;

        //PROJECTION MATRIX

        projectionMatrix[0][0] = perspectiveMatrix[0][0]*world2CamMatrix[0][0]+perspectiveMatrix[0][1]*world2CamMatrix[1][0]+perspectiveMatrix[0][2]*world2CamMatrix[2][0]+ perspectiveMatrix[0][3]*world2CamMatrix[3][0];
        projectionMatrix[0][1] = perspectiveMatrix[0][0]*world2CamMatrix[0][1]+perspectiveMatrix[0][1]*world2CamMatrix[1][1]+perspectiveMatrix[0][2]*world2CamMatrix[2][1]+ perspectiveMatrix[0][3]*world2CamMatrix[3][1];
        projectionMatrix[0][2] = perspectiveMatrix[0][0]*world2CamMatrix[0][2]+perspectiveMatrix[0][1]*world2CamMatrix[1][2]+perspectiveMatrix[0][2]*world2CamMatrix[2][2]+ perspectiveMatrix[0][3]*world2CamMatrix[3][2];
        projectionMatrix[0][3] = perspectiveMatrix[0][0]*world2CamMatrix[0][3]+perspectiveMatrix[0][1]*world2CamMatrix[1][3]+perspectiveMatrix[0][2]*world2CamMatrix[2][3]+ perspectiveMatrix[0][3]*world2CamMatrix[3][3];

        projectionMatrix[1][0] = perspectiveMatrix[1][0]*world2CamMatrix[0][0]+perspectiveMatrix[1][1]*world2CamMatrix[1][0]+perspectiveMatrix[1][2]*world2CamMatrix[2][0]+ perspectiveMatrix[1][3]*world2CamMatrix[3][0];
        projectionMatrix[1][1] = perspectiveMatrix[1][0]*world2CamMatrix[0][1]+perspectiveMatrix[1][1]*world2CamMatrix[1][1]+perspectiveMatrix[1][2]*world2CamMatrix[2][1]+ perspectiveMatrix[1][3]*world2CamMatrix[3][1];
        projectionMatrix[1][2] = perspectiveMatrix[1][0]*world2CamMatrix[0][2]+perspectiveMatrix[1][1]*world2CamMatrix[1][2]+perspectiveMatrix[1][2]*world2CamMatrix[2][2]+ perspectiveMatrix[1][3]*world2CamMatrix[3][2];
        projectionMatrix[1][3] = perspectiveMatrix[1][0]*world2CamMatrix[0][3]+perspectiveMatrix[1][1]*world2CamMatrix[1][3]+perspectiveMatrix[1][2]*world2CamMatrix[2][3]+ perspectiveMatrix[1][3]*world2CamMatrix[3][3];

        projectionMatrix[2][0] = perspectiveMatrix[2][0]*world2CamMatrix[0][0]+perspectiveMatrix[2][1]*world2CamMatrix[1][0]+perspectiveMatrix[2][2]*world2CamMatrix[2][0]+ perspectiveMatrix[2][3]*world2CamMatrix[3][0];
        projectionMatrix[2][1] = perspectiveMatrix[2][0]*world2CamMatrix[0][1]+perspectiveMatrix[2][1]*world2CamMatrix[1][1]+perspectiveMatrix[2][2]*world2CamMatrix[2][1]+ perspectiveMatrix[2][3]*world2CamMatrix[3][1];
        projectionMatrix[2][2] = perspectiveMatrix[2][0]*world2CamMatrix[0][2]+perspectiveMatrix[2][1]*world2CamMatrix[1][2]+perspectiveMatrix[2][2]*world2CamMatrix[2][2]+ perspectiveMatrix[2][3]*world2CamMatrix[3][2];
        projectionMatrix[2][3] = perspectiveMatrix[2][0]*world2CamMatrix[0][3]+perspectiveMatrix[2][1]*world2CamMatrix[1][3]+perspectiveMatrix[2][2]*world2CamMatrix[2][3]+ perspectiveMatrix[2][3]*world2CamMatrix[3][3];

        projectionMatrix[3][0] = perspectiveMatrix[3][0]*world2CamMatrix[0][0]+perspectiveMatrix[3][1]*world2CamMatrix[1][0]+perspectiveMatrix[3][2]*world2CamMatrix[2][0]+ perspectiveMatrix[3][3]*world2CamMatrix[3][0];
        projectionMatrix[3][1] = perspectiveMatrix[3][0]*world2CamMatrix[0][1]+perspectiveMatrix[3][1]*world2CamMatrix[1][1]+perspectiveMatrix[3][2]*world2CamMatrix[2][1]+ perspectiveMatrix[3][3]*world2CamMatrix[3][1];
        projectionMatrix[3][2] = perspectiveMatrix[3][0]*world2CamMatrix[0][2]+perspectiveMatrix[3][1]*world2CamMatrix[1][2]+perspectiveMatrix[3][2]*world2CamMatrix[2][2]+ perspectiveMatrix[3][3]*world2CamMatrix[3][2];
        projectionMatrix[3][3] = perspectiveMatrix[3][0]*world2CamMatrix[0][3]+perspectiveMatrix[3][1]*world2CamMatrix[1][3]+perspectiveMatrix[3][2]*world2CamMatrix[2][3]+ perspectiveMatrix[3][3]*world2CamMatrix[3][3];
    }

    public Point3f transformPointToCam(Point3f point3d){
        float W = point3d.x*world2CamMatrix[3][0]+point3d.y*world2CamMatrix[3][1]+point3d.z*world2CamMatrix[3][2]+world2CamMatrix[3][3];

        return new Point3f((point3d.x*world2CamMatrix[0][0]+point3d.y*world2CamMatrix[0][1]+point3d.z*world2CamMatrix[0][2]+world2CamMatrix[0][3])/W,
                (point3d.x*world2CamMatrix[1][0]+point3d.y*world2CamMatrix[1][1]+point3d.z*world2CamMatrix[1][2]+world2CamMatrix[1][3])/W,
                (point3d.x*world2CamMatrix[2][0]+point3d.y*world2CamMatrix[2][1]+point3d.z*world2CamMatrix[2][2]+world2CamMatrix[2][3])/W);
    }
    public Point3f projectPoint(Point3f point3d){
        float W = point3d.x*projectionMatrix[3][0]+point3d.y*projectionMatrix[3][1]+point3d.z*projectionMatrix[3][2]+projectionMatrix[3][3];

        Point3f rzutnia = new Point3f((point3d.x*projectionMatrix[0][0]+point3d.y*projectionMatrix[0][1]+point3d.z*projectionMatrix[0][2]+projectionMatrix[0][3])/W,
                (point3d.x*projectionMatrix[1][0]+point3d.y*projectionMatrix[1][1]+point3d.z*projectionMatrix[1][2]+projectionMatrix[1][3])/W,
                (point3d.x*projectionMatrix[2][0]+point3d.y*projectionMatrix[2][1]+point3d.z*projectionMatrix[2][2]+projectionMatrix[2][3])/W);
        return new Point3f(rzutnia.x*320+320,-rzutnia.y*240+240,rzutnia.z);
    }

    public float[][] getProjectionMatrix() {
        return projectionMatrix;
    }

    public float[][] getWorld2CamMatrix() {
        return world2CamMatrix;
    }
}
