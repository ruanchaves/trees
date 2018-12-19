import java.util.ArrayList;
import java.util.Stack;
import java.util.Random;
import java.util.Map;
import java.util.TreeMap;

class Painter {

    Stack<Float> point_stack = new Stack<Float>();
    float turtle_x = 0;
    float turtle_y = 0;
    float turtle_z = 0;
    float angle_increment = (float) Math.PI / 6.0;
    float angle;
    float rot_angle = 0;
    float walk_step;
    int gen;
    boolean chosen_state = false;
    ArrayList<Float> points;
    String walk;

    Painter(Replacer r){
	    this.turtle_x = 0;
	    this.turtle_y = 0;
	    this.turtle_z = 0;
	    this.angle = r.angle;
        this.walk_step = r.walk;
        points = new ArrayList<Float>();
        this.walk = r.result;
    }

    public void set3(){
        this.chosen_state = true;
    }

    public void save_state(){
        point_stack.push(turtle_x);
        point_stack.push(turtle_y);
        point_stack.push(turtle_z);
        point_stack.push(angle);

    }

    public void load_state(){
        angle = point_stack.pop();
        turtle_z = point_stack.pop();
        turtle_y = point_stack.pop();
        turtle_x = point_stack.pop();
    }

    public void save_point(){
        points.add(turtle_x);
        points.add(turtle_y);
        points.add(turtle_z);
    }

    public float get_sin(float angle){
        return (float) Math.sin(angle);
    }


    public float get_cos(float angle){
        return (float) Math.cos(angle);
    }

    public void paint(){

        float vector_x = 0;
        float vector_y = 1;
        float vector_z = 0;
        turtle_x = 0;
        turtle_y = 0;
        turtle_z = 0;
        float tmp_x = vector_x;
        float tmp_y = vector_y;
        float tmp_z = vector_z;

        for(int i = 0; i < walk.length(); i++){

            vector_x = 0;
            vector_y = 1;
            vector_z = 0;

            tmp_x = vector_x;
            tmp_y = vector_y;
            tmp_z = vector_z;

            char c = walk.charAt(i);

            if(c == 'X') continue;
            else if(c == 'F') {
                    save_point();
	                    /* //rotacionar no eixo Z com o angulo */
	                    vector_x = tmp_x * get_cos(angle) +
	                            tmp_y * -get_sin(angle) +
	                            tmp_z * 0;
	                    vector_y = tmp_x * get_sin(angle) +
	                            tmp_y * get_cos(angle) +
	                            tmp_z * 0;
	                    vector_z = tmp_x * 0 +
	                            tmp_y * 0 +
	                            tmp_z * 1;
	                    tmp_x = vector_x;
	                    tmp_y = vector_y;
	                    tmp_z = vector_z;
	                    //rotacionar eixo Y com o angulo
	                    vector_x = tmp_x * get_cos(rot_angle) +
	                            tmp_y * 0 +
	                            tmp_z * get_sin(rot_angle);
	                    vector_y = tmp_x * 0 +
	                            tmp_y * 1 +
	                            tmp_z * 0;
	                    vector_z = tmp_x * -get_sin(rot_angle) +
	                            tmp_y * 0 +
	                            tmp_z * get_cos(rot_angle);
	                    tmp_x = vector_x;
	                    tmp_y = vector_y;
	                    tmp_z = vector_z;
                    vector_x *= walk_step;
                    vector_y *= walk_step;
                    vector_z *= walk_step;
                    turtle_x += vector_x;
                    turtle_y += vector_y;
                    turtle_z += vector_z;
                    save_point();
            }
            else if(c == '[') {
                if(chosen_state){
                    float bottom = (float) Math.PI / 12.0;
                    float upper = (float) Math.PI / 6.0;
                    Random rd = new Random();
                    rot_angle = bottom + rd.nextFloat() * (upper - bottom );
                }
                save_state();
            }
            else if(c == ']') {
                rot_angle = 0;
                load_state();
            }
            else if(c == '+') {
                this.angle += angle_increment;
            }
            else if(c == '-') {
                this.angle -= angle_increment;
            }
        }
    }

}
