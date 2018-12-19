import java.util.Random;
import java.util.Map;
import java.util.TreeMap;

String tree_path = "./models/tree3d/tree";
String ext = ".txt";
int limit = 100;

void setup(){
    for(int i = 0; i < limit; i++){

        int choice = i;

        TreeMaker t = new TreeMaker(choice);
        t.set3();
        t.run();

        Replacer r = new Replacer(t);
        Analyzer a = new Analyzer(r);

        Painter p = new Painter(r);
        p.set3();
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
