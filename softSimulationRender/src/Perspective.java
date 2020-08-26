import java.util.ArrayList;

public class Perspective {
    private float[][] projectionMatrix = new float[4][4]; //kolejność współrzędnych macierzowa (y,x)
    private float[][] world2CamMatrix = new float[4][4];
    private float[][] perspectiveMatrix = new float[4][4];

    public void calculateProjectionMatrix(Point3f camPos, Point3f camAngle, float fov){
        //TRANSLACJA I OBRÓT W OSI Y
        world2CamMatrix[0][0] = (float)Math.cos(camAngle.y);
        world2CamMatrix[0][1] = 0.0f;
        world2CamMatrix[0][2] = (float)Math.sin(camAngle.y);
        world2CamMatrix[0][3] = -camPos.x; //CAM ROT: -camPos.getX()*(float)Math.cos(camAngle.getY()) - (float)Math.sin(camAngle.getY())*camPos.getZ();

        world2CamMatrix[1][0] = 0.0f;
        world2CamMatrix[1][1] = 1.0f;
        world2CamMatrix[1][2] = 0.0f;
        world2CamMatrix[1][3] = -camPos.y;

        world2CamMatrix[2][0] = -(float)Math.sin(camAngle.y);
        world2CamMatrix[2][1] = 0.0f;
        world2CamMatrix[2][2] = (float)Math.cos(camAngle.y);
        world2CamMatrix[2][3] = -camPos.z; //CAM ROT: camPos.getZ()*(float)Math.sin(camAngle.getY()) - (float)Math.cos(camAngle.getY())*camPos.getZ();

        world2CamMatrix[3][0] = 0.0f;
        world2CamMatrix[3][1] = 0.0f;
        world2CamMatrix[3][2] = 0.0f;
        world2CamMatrix[3][3] = 1.0f;

        float scale = 1.0f / (float)Math.tan(fov * 0.5f * Math.PI / 180.0f);
        float near = 0.1f;
        float far = 100.0f;

        perspectiveMatrix[0][0] = scale;
        perspectiveMatrix[0][1] = 0.0f;
        perspectiveMatrix[0][2] = 0.0f;
        perspectiveMatrix[0][3] = 0.0f;

        perspectiveMatrix[1][0] = 0.0f;
        perspectiveMatrix[1][1] = scale;
        perspectiveMatrix[1][2] = 0.0f;
        perspectiveMatrix[1][3] = 0.0f;

        perspectiveMatrix[2][0] = 0.0f;
        perspectiveMatrix[2][1] = 0.0f;
        perspectiveMatrix[2][2] = -(far + near) / (far - near);
        perspectiveMatrix[2][3] = -2 * far * near / (far - near);

        perspectiveMatrix[3][0] = 0.0f;
        perspectiveMatrix[3][1] = 0.0f;
        perspectiveMatrix[3][2] = -1.0f;
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
        return new Point3f(rzutnia.x*160+160,-rzutnia.y*120+120,rzutnia.z);
    }

    public float[][] getProjectionMatrix() {
        return projectionMatrix;
    }

    public float[][] getWorld2CamMatrix() {
        return world2CamMatrix;
    }
}
