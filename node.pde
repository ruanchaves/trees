import java.util.ArrayList;
import java.util.List;

class Node<Integer> {

    int data;
    int nodecolor;
    int level;

    List<Node<Integer>> children;
    ArrayList<Integer> branches;

    Node<Integer> parent = null;

    public Node(int data){
        this.data = data;
        this.nodecolor = 0;
        this.level = 0;
        this.children = new ArrayList<Node<Integer>>();
        this.branches = new ArrayList<Integer>();
    }

    public Node<Integer> add(Node<Integer> child){
        child.setParent(this);
        this.children.add(child);
        return child;
    }

    public int getData(){
        return data;
    }

    public int getColor(){
        return nodecolor;
    }

    public int getLevel(){
        return level;
    }

    public Node<Integer> getParent(){
        return parent;
    }

    public void setLevel(int level){
        this.level = level;
    }

    public void setData(int data){
        this.data = data;
    }

    public void setColor(int nodecolor){
        this.nodecolor = nodecolor;
    }

    public void setParent(Node<Integer> parent){
        this.parent = parent;
    }
}
