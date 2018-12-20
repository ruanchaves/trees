import java.util.ArrayList;
import java.util.Stack;
import java.util.Random;
import java.util.Map;
import java.util.TreeMap;

class Painter {

    // Esta é a pilha de estados, manipulada pelos comandos "[" e "]".
    Stack<Float> point_stack = new Stack<Float>();

    // Estas são as coordenadas iniciais da tartaruga.
    float turtle_x = 0;
    float turtle_y = 0;
    float turtle_z = 0;

    // Este é o incremento angular que ocorre quando fazemos "+" ou "-". Ele é herdado da função Replacer.
    float angle_increment;

        // Este é o ângulo de rotação em torno do eixo Z.
    float angle;

    // Este é o ângulo de rotação em torno do eixo Y.
    // Este ângulo só é ativado no modo 3D, e somente quando estamos fora do tronco.
    float rot_angle = 0;

    // Estes parâmetros são herdados do Replacer.
    float walk_step;
    boolean chosen_state = false;
    String walk_string;

    // Este array armazena o resultado desejado do Painter, um array de pontos a serem ligados entre si.
    ArrayList<Float> points;


    Painter(Replacer r){

        // Inicialização da tartaruga
	    this.turtle_x = 0;
	    this.turtle_y = 0;
	    this.turtle_z = 0;

        // Inicialização do array que conterá o resultado
        points = new ArrayList<Float>();

        // Herança de variáveis do Replacer
            // Herdamos o ângulo
	    this.angle = 0;
        this.angle_increment = r.angle;
            // Herdamos o tamanho do passo em F
        this.walk_step = r.walk;
            // Herdamos a string que foi gerada pelas substituições do Replacer
        this.walk_string = r.result;
    }

    public void set3(){
        this.chosen_state = true;
    }

    public void save_state(){
        // Salvamos a posição atual e o ângulo atual na pilha
        point_stack.push(turtle_x);
        point_stack.push(turtle_y);
        point_stack.push(turtle_z);
        point_stack.push(angle);
    }

    public void load_state(){
        // Carregamos da pilha a última posição e o último ângulo salvos
        angle = point_stack.pop();
        turtle_z = point_stack.pop();
        turtle_y = point_stack.pop();
        turtle_x = point_stack.pop();
    }

    public void save_point(){
        // Adicionamos um ponto ao array de resultados finais
        points.add(turtle_x);
        points.add(turtle_y);
        points.add(turtle_z);
    }

    public float get_sin(float angle){
        // Função para obter o seno de um ângulo
        // ( Simples conversão de tipos )
        return (float) Math.sin(angle);
    }


    public float get_cos(float angle){
        // Função para obter o cosseno de um ângulo
        // ( Simples conversão de tipos )
        return (float) Math.cos(angle);
    }

    public void paint(){

        // Inicializamos um vetor unitário que indica a nossa direção.
        float vector_x = 0;
        float vector_y = 1;
        float vector_z = 0;

        // Inicializamos as coordenadas da tartaruga que indicam nossa posição.
        turtle_x = 0;
        turtle_y = 0;
        turtle_z = 0;

        // Um vetor auxiliar tmp recebe as coordenadas do vetor unitário.
        float tmp_x = vector_x;
        float tmp_y = vector_y;
        float tmp_z = vector_z;

        for(int i = 0; i < walk_string.length(); i++){


            // A cada iteração, inicializamos novamente o vetor unitário.
            vector_x = 0;
            vector_y = 1;
            vector_z = 0;
            tmp_x = vector_x;
            tmp_y = vector_y;
            tmp_z = vector_z;

            char c = walk_string.charAt(i);

            // Caracteres X são ignorados.
            if(c == 'X') continue;
            // Caracteres F resultam em um passo adiante.
            else if(c == 'F') {

                    // Salvamos a posição atual no resultado final.
                    save_point();

                    // Executamos uma rotação no eixo Z conforme o ângulo.
                    // Esse ângulo depende do valor inicial informado, e das
                    // alterações feitas pelos operadores + e -.
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

                    // Executamos uma rotação no eixo Y conforme um ângulo de rotação.
                    // Este ângulo de rotação é um valor fixo.
                    // Esta operação é realizada somente se o modo 3D foi ativado
                    // através da variável chosen_state.

                    if(chosen_state){
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
                    }

                    // Aqui estamos escalando o vetor unitário, aumentando o seu tamanho.
                    vector_x *= walk_step;
                    vector_y *= walk_step;
                    vector_z *= walk_step;

                    // Aqui estamos adicionando o vetor escalonado à nossa posição atual,
                    // obtendo a nova posição para a qual iremos nos deslocar.
                    turtle_x += vector_x;
                    turtle_y += vector_y;
                    turtle_z += vector_z;

                    // Salvamos a nova posição no resultado final.
                    save_point();
            }
            // Caracteres [ armazenam o estado atual na pilha.
            else if(c == '[') {

                // Caso o modo 3D esteja ativado, caracteres [ ativam o ângulo de rotação.
                // Esta rotação só é realizada quando estamos no começo de uma ramificação.
                // O ângulo de rotação é um valor aleatório dentro de um intervalo entre 15 e 30 graus.
                if(chosen_state){
                    float bottom = (float) Math.PI / 12.0;
                    float upper = (float) Math.PI / 6.0;
                    Random rd = new Random();
                    rot_angle = bottom + rd.nextFloat() * (upper - bottom );
                }
                save_state();
            }
            // Caracteres ] restauram o último estado armazenado na pilha.
            else if(c == ']') {
                // O ângulo de rotação é desativado quando retornamos de uma ramificação.
                // No modo 3D, a rotação no eixo Y não terá efeito,
                // pois estaremos rotacionando por um ângulo 0.
                if(chosen_state) rot_angle = 0;
                load_state();
            }
            // Caracteres + rodam em sentido horário.
            else if(c == '+') {
                this.angle += angle_increment;
            }
            // Caracteres - rodam em sentido anti-horário.
            else if(c == '-') {
                this.angle -= angle_increment;
            }
        }
    }

}
