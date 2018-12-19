import java.util.Random;
import java.util.HashMap;
import java.util.ArrayList;

class TreeMaker {

    String axiom;
    HashMap<String, ArrayList<String>> expr;
    boolean chosen_state = false;
    float angle;
    float walk;
    int gen;
    int choice;

    public void build(String key, String value){
        ArrayList<String> arr = new ArrayList<String>();
        if( expr.containsKey(key) ) arr = expr.get(key);
        arr.add(value);
        expr.put(key, arr);
    }

    TreeMaker(int choice){
        this.choice = choice;
    }

    public void set3(){
        this.chosen_state = true;
    }

    public void run(){
        this.expr = new HashMap<String, ArrayList<String>>();
        if(chosen_state == false){
            choice %= 7;
	        switch(choice){
	            case 0:
	                tree0();
	                break;
	            case 1:
	                tree1();
	                break;
	            case 2:
	                tree2();
	                break;
	            case 3:
	                tree3();
	                break;
	            case 4:
	                tree4();
	                break;
	            case 5:
	                tree5();
	                break;
	            case 6:
	                tree6();
	                break;
	            default:
	                tree0();
	                break;
	        }
        }
        else{
            choice %= 4;
	        switch(choice){
	            case 0:
	                tree2();
	                break;
	            case 1:
	                tree3();
	                break;
	            case 2:
	                tree4();
	                break;
	            case 3:
	                tree6();
	                break;
	            default:
	                tree2();
	                break;
            }
        }
    }

    public float float_range(float minvalue, float maxvalue){
        Random rd = new Random();
        return minvalue + rd.nextFloat() * ( maxvalue - minvalue);
    }

    public int int_range(int minvalue, int maxvalue){
        Random rd = new Random();
        return minvalue + (int) rd.nextFloat() * ( maxvalue - minvalue );
    }

    public void tree0(){
        this.axiom = "F";
        build("F","F[+F]F[-F]F");
        build("F","F[-F]F[-F]F");
        build("F","F[+F]F[-F]F");
        build("F","F[-F]F[+F]F");
        this.walk = float_range(3.0,5.0);
        this.angle = float_range(0.30, 0.54);
        this.gen = int_range(3,5);

    }

    public void tree1(){
        this.axiom = "F";
        build("F","F[+F]F[-F][F]");
        build("F","F[-F]F[-F][F]");
        build("F","F[+F]F[-F][F]");
        build("F","F[-F]F[+F][F]");
        this.walk = float_range(3.0, 5.0);
        this.angle = float_range(0.30, 0.80);
        this.gen = int_range(3,5);
    }

    public void tree2(){
        this.axiom = "F";
        build("F","FF-[-F+F+F]+[+F-F-F]");
        build("F","FF+[-F+F+F]+[+F-F-F]");
        this.walk = float_range(1.0, 2.0);
        this.angle = float_range(0.50,0.80);
        this.gen = int_range(1,3);
        if(chosen_state) this.walk = float_range(3.0,5.0);
    }

    public void tree3(){
        this.axiom = "X";
        build("X", "F[+X]F[-X]+X");
        build("X", "F[-X]F[-X]+X");
        build("F", "FF");
        this.walk = float_range(0.25, 4.0);
        this.angle = float_range(0.17, 0.9);
        this.gen = int_range(4,6);
        if(chosen_state) this.walk = float_range(0.25,2.0);

    }

    public void tree4(){
        this.axiom = "X";
        build("X", "F[+X][-X]FX");
        build("F","FF");
        this.walk = float_range(0.25, 3.0);
        this.angle = float_range(0.17, 0.54);
        this.gen = int_range(3,8);
    }

    public void tree5(){
        this.axiom = "X";
        build("X","F-[[X]+X]+F[+FX]-X");
        build("X","F-[[X]-X]+F[-FX]-X");
        build("F","FF");
        this.walk = float_range(0.25,4.0);
        this.angle = float_range(0.44, 0.54);
        this.gen = int_range(3,5);
    }

    public void tree6(){
        this.axiom = "F";
        build("F", "F[+F]F");
        build("F", "F[-F]F");
        this.walk = float_range(1.0,5.0);
        this.angle = float_range(0.10,0.84);
        this.gen = int_range(3,7);
        if(chosen_state) this.walk = float_range(4.0,5.0);
    }

}
