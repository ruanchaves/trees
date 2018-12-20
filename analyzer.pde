import java.util.LinkedList;
import java.util.Queue;
import java.util.Map;
import java.util.TreeMap;
import java.util.Collections;
import java.util.Random;

class Analyzer {

    // Estes parâmetros são herdados do Replacer.
    String tree_string;
    float angle;
    float walk;
    int gen;

    // Este objeto é uma árvore red-black.
    // Cada chave da árvore corresponde a um passo F distinto.
    // A árvore irá associar a cada chave a uma string contendo os dados resultantes da análise do passo F.
    Map<Integer, String> mapping;


    // Estes objetos serão utilizados na função build_tree().
    int counter;
    Stack<Node<Integer>> tree_stack;
    Node<Integer> root;
    Node<Integer> current;

    Analyzer(Replacer r){
        this.tree_string = r.result;
        this.angle = r.angle;
        this.walk = r.walk;
        this.gen = r.gen;
        build_tree();
    }

    public float get_leaf_value(int key){
        // Esta função obtém um "valor folha" para o passo F.
        // Este valor mede o quão próximo estamos de uma folha,
        // e se somos uma folha ou não.

        // Esta variável será usada no programa de projeção
        // para determinar a cor de cada passo.

        // Ela é a quarta coluna do arquivo .txt final gerado por este programa.
        String value = mapping.get(key).split(" ")[0];
        return Float.parseFloat(value);
    }

    public float get_branch_value(int key){
        // Esta função obtém um "valor ramo" para o passo F.
        // Este valor informa em qual nível de ramificação estamos:
        // tronco, galho, galho do galho, galho do galho do galho, etc..

        // Esta variável será usada no programa de projeção
        // para determinar a grossura de cada passo.

        // Ela é a quinta coluna do arquivo .txt final gerado por este programa.
        String value = mapping.get(key).split(" ")[1];
        return Float.parseFloat(value);
    }

    // Em implementações mais complexas, as duas funções abaixo ( get_thickness e get_leaves )
    // podem variar de acordo com cada árvore escolhida.

    public float get_thickness(int value){
        // Esta função expressa a grossura que o passo atual deve ter.
        // Escolhemos uma função que simplesmente retorna o nosso nível atual na árvore.
        return (float) value;
    }

    public float get_leaves(ArrayList<Integer> branches){
        // Esta função expressa o quão distantes estamos de uma folha.
        // Escolhemos uma função que simplesmente escolhe o tamanho da maior ramificação
        // que parte do ramo atual.
        if(branches.size() == 0) return 0.0;
        float max_branch = (float) Collections.max(branches);
        return max_branch;
    }


    public void build_tree(){

        // Inicializamos o TreeMap.
        mapping = new TreeMap<Integer, String>();

        // Aqui transformamos a string gerada por Replacer
        // em uma árvore expressa como uma estrutura de dados com nós interligados, para que ela seja analisada.

        // Definimos uma pilha auxiliar para nos ajudar com a construção da árvore.
        tree_stack = new Stack<Node<Integer>>();

        // Definimos uma raíz com valor a ser ignorado.
        // A esta raíz adicionaremos o primeiro passo F da árvore.
        root = new Node<Integer>(-1);

        // Definimos um nó auxiliar para nos ajudar com a construção da árvore.
        current = root;

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

        // Aqui estamos executando um BFS sobre a árvore gerada na etapa anterior.
        // A finalidade desse BFS é informar qual é o nível de cada passo F ( se é tronco, galho, galho de galho, etc. )
        // e adicionar todas as folhas da árvore em uma pilha chamada leaf_stack.
        current = root;
        current.setColor(1);
        current.setLevel(0);
        // Esta pilha armazena todas as folhas da árvore.
        Stack<Node<Integer>> leaf_stack = new Stack<Node<Integer>>();
        // Esta fila é uma estrutura de dados auxiliar ao BFS.
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

        // Aqui estamos saindo de cada folha e retornando para a raíz da árvore.
        // Conforme percorremos esse caminho, informamos a cada nó quantos nós já
        // foram visitados durante a nossa caminhada.
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

	    // Aqui executamos um BFS com a única finalidade de apenas percorrer todos os nós da árvore,
        // resetando as cores e colhendo as informações geradas nas etapas anteriores.

        // Enquanto no primeiro BFS saímos da cor branca para a cor cinza/preta,
        // aqui estamos voltando da cor cinza/preta para a cor branca.

        // Conforme percorremos os nós da árvore, vamos armazenando as informações em cada nó
        // no nosso TreeMap chamado mapping.

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
            mapping.put(map_key, map_value);
        }
    }
}
