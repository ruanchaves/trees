import java.util.Random;
import java.util.HashMap;
import java.util.ArrayList;

class Replacer {

    // Esta é a hash table herdada da função TreeMaker, junto com o axioma e a quantidade de iterações.
    // A partir destes dados, geraremos aqui as substituições.
    HashMap<String, ArrayList<String>> expr;
    String axiom;
    int gen;

    // As variáveis abaixo foram herdadas da função TreeMaker.
    // Elas não tem utilidade nesta função, elas estão aqui somente para
    // serem passadas para frente, para a função Painter,
    // que recebe esse objeto Replacer como parâmetro.
    String result;
    float angle;
    float walk;

    Replacer(TreeMaker t){
        this.axiom = t.axiom;
        this.expr = t.expr;
        this.angle = t.angle;
        this.walk = t.walk;
        this.gen = t.gen;
        generate();
    }

    public String get_random(String key){
        // Aqui estamos escolhendo aleatoriamente uma substituição entre as opções possíveis.
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
        // Aqui estamos executando as substituições. 
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

