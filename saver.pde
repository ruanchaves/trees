import java.util.ArrayList;
import java.util.Map;
import java.util.TreeMap;

class Saver {

    String filename;
    PrintWriter output;
    Map<Integer,String> mapping;
    ArrayList<Float> points;

    Saver(Analyzer a, Painter p){
        this.mapping = a.mapping;
        this.points = p.points;
    }

    Saver(Painter p){
        this.mapping = null;
        this.points = p.points;
    }

    public void set_path(String filename){
        this.filename = filename;
    }

    public void dump(String filename, ArrayList<String> lines){
        String[] lines_array = lines.toArray(new String[lines.size()]);
        saveStrings(filename, lines_array);
    }

    public ArrayList<String> load_meta(Map<Integer,String> mapping){
        ArrayList<String> lines = new ArrayList<String>();
        for( Map.Entry<Integer,String> entry : mapping.entrySet()){
            int int_key = entry.getKey();
            if(int_key < 0) continue;
            String key = Integer.toString(int_key);
            String value = entry.getValue();
            String line = key + " " + value;
            lines.add(line);
            lines.add(line);
        }
        return lines;
    }

    public void save(){
        float x;
        float y;
        float z;
        ArrayList<String> meta = load_meta(mapping);
        ArrayList<String> lines = new ArrayList<String>();
        int j = 0;
        for(int i = 0; i < points.size(); i += 3){
            x = points.get(i);
            y = points.get(i+1);
            z = points.get(i+2);
            String line = x + " " + y + " " + z + meta.get(j);
            lines.add(line);
            j += 1;
        }
        dump(filename, lines);
    }

}
