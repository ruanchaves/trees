import java.util.Random;
import java.util.Map;
import java.util.TreeMap;

String tree_path = "./models/id_6/tree";
String ext = ".txt";
int limit = 10;

void setup(){

    /*

    PIPELINE :

    TreeMaker -> Replacer -> Analyzer, Painter -> Saver

    TreeMaker : Seleciona uma árvore de uma lista de árvores.
    Replacer : Executa as regras de substituição em cima do axioma.
    Analyzer : Analisa a árvore e dá informações sobre cada nó a partir da string gerada por Replacer.
    Painter : Gera os pontos 3D da árvore a partir da string gerada por Replacer.
    Saver : Combina os resultados de Analyzer e Painter em um único arquivo.

     */

    for(int i = 0; i < limit; i++){

        int choice = i;

        TreeMaker t = new TreeMaker(choice);
        /* t.set3(); */
        t.run();

        Replacer r = new Replacer(t);
        Analyzer a = new Analyzer(r);

        Painter p = new Painter(r);
        /* p.set3(); */
        p.paint();

        Saver s = new Saver(a,p);

        String padded = String.format("%03d", i);
        s.set_path(tree_path + padded + ext);
        s.save();
    }
    exit();
}

void draw(){
}
