import java.util.LinkedList;
import java.util.Queue;
import java.util.Map;
import java.util.TreeMap;
import java.util.Collections;
import java.util.Random;

class Analyzer {

    String tree_string;
    float angle;
    float walk;
    int gen;
    Map<Integer, String> mapping;

    Analyzer(Replacer r){
        this.tree_string = r.result;
        this.angle = r.angle;
        this.walk = r.walk;
        this.gen = r.gen;
        build_tree();
    }

    public float get_thickness(int value){
        return (float) value;
    }

    public float get_leaves(ArrayList<Integer> branches){
        if(branches.size() == 0) return 0.0;
        float max_branch = (float) Collections.max(branches);
        return max_branch;
    }

    public void build_tree(){

        Map<Integer, String> value_map = new TreeMap<Integer, String>();
        Stack<Node<Integer>> tree_stack = new Stack<Node<Integer>>();

        Node<Integer> root = new Node<Integer>(-1);
        Node<Integer> current = root;

        int counter = 0;

	    for(int i = 0; i < tree_string.length(); i++){
		    char c = tree_string.charAt(i);
		    if(c == '['){
                tree_stack.push(current);
		    }
		    if(c == 'F'){
                current = current.add(new Node<Integer>(counter) );
                counter += 1;
            }
		    if(c == ']'){
                if(tree_stack.empty()) current = root;
                else current = tree_stack.pop();
		    }
            else{
                continue;
            }
	    }
    // BFS
        current = root;
        current.setColor(1);
        current.setLevel(0);
        Stack<Node<Integer>> leaf_stack = new Stack<Node<Integer>>();
        Queue<Node<Integer>> q = new LinkedList<Node<Integer>>();
        q.add(current);
        while(true){
            current = q.poll();
            if(current == null) break;
            else{
	            for(Node<Integer> child : current.children){
	                if(child.getColor() == 0){
	                    child.setColor(1);
	                    child.setLevel(current.getLevel() + 1);
	                    q.add(child);
                        if( child.children.size() == 0 ){
                            leaf_stack.push(child);
                        }
	                }
	            }
            }
            current.setColor(1);
        }

	    while(true){
            if(leaf_stack.empty()) break;
	        current = leaf_stack.pop();
	        counter = 0;
	        while(true){
	            current = current.getParent();
	            if(current == null) break;
	            current.branches.add(counter);
	            counter += 1;
	        }
	    }

	    //BFS
	    current = root;
	    current.setColor(0);
	    current.setLevel(1);
	    q = new LinkedList<Node<Integer>>();
	    q.add(current);
	    while(true){
            current = q.poll();
            if(current == null) break;
            else{
                for(Node<Integer> child : current.children){
                    if(child.getColor() == 1){
                        child.setColor(0);
                        q.add(child);
                    }
                }
            }
            current.setColor(0);
            float leaf_value = get_leaves(current.branches);
            float branch_value = get_thickness(current.level);

            int map_key = current.getData();
            String map_value = Float.toString(leaf_value) + " " + Float.toString(branch_value);
            value_map.put(map_key, map_value);
        }
        this.mapping = value_map;
    }
}
