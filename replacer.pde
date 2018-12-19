import java.util.Random;
import java.util.HashMap;
import java.util.ArrayList;

class Replacer {

    String axiom;
    HashMap<String, ArrayList<String>> expr;
    String result;
    float angle;
    float walk;
    int gen;

    Replacer(TreeMaker t){
        this.axiom = t.axiom;
        this.expr = t.expr;
        this.angle = t.angle;
        this.walk = t.walk;
        this.gen = t.gen;
        generate();
    }

    public String get_random(String key){
        ArrayList<String> value = expr.get(key);
        if(value == null){
            return null;
        }
        else{
            Random rd = new Random();
            int chosen = rd.nextInt(value.size());
            return value.get(chosen);
        }
    }

    public void generate(){
        String result = axiom;
        for (int k = 0; k <= this.gen; k++){
            for(String key: expr.keySet()){
                String value = get_random(key);
                if(value != null) result = result.replaceAll(key, value);
            }
        }
        this.result = result;
    }
}

