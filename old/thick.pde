class Thick {

    Map <Integer,String> mapping = new TreeMap<Integer,String>();

    ArrayList<Float> points = new ArrayList<Float>();
    Map<Integer,String> facepoints;
    ArrayList<String> faces;

    float max_thickness = 10.0;

    Thick(Map <Integer, String> mapping, ArrayList<Float> points){
        this.mapping = mapping;
        this.points = points;
    }

    public float get_length(float x, float y, float z){
        return (float) Math.sqrt ( Math.pow(x,2) + Math.pow(y,2) + Math.pow(z,2) );
    }

    public float get_angle(xax,yax,zax,x,y,z){
        float dot = ( xax * x + yax * y + zax * z )
        float mag = get_length(xax,yax,zax) * get_length(x,y,z);
        float cos_angle = dot / mag;
        return (float) Math.acos(cos_angle);
    }

    public float get_distance(float xa, float ya, float za, float xb, float yb, float zb){
        float dx = (float) Math.pow(xa - xb);
        float dy = (float) Math.pow(ya - yb);
        float dz = (float) Math.pow(za - zb);
        return (float) Math.sqrt(dx + dy + dz);
    }

    public ArrayList<Float> get_points(float r, float h){
        ArrayList<Float> points = new ArrayList<Float>();
        float px = r;
        float py = 0;
        float pz = h;

        float fx = px;
        float fy = py;
        float fz = pz;
        points.add(fx);
        points.add(fy);
        points.add(fz);
        for(float i = 0; i < 6; i += 0.1){
            fx = px * (float) Math.cos(i) + py * (float) Math.sin(i) ;
            fy = px * (float) Math.sin(i) + py * (float) Math.cos(i) ;
            points.add(fx);
            points.add(fy);
            points.add(fz);
        }
        return points;
    }

    public ArrayList<Float> translate(ArrayList<Float> arr, float x, float y, float z){
        for(int i = 0; i < arr.size(); i += 3){
            float posx = x;
            float posy = y;
            float posz = z;
            posx += arr.get(i);
            posy += arr.get(i+1);
            posz += arr.get(i+2);
            arr.set(i, posx);
            arr.set(i+1, posy);
            arr.set(i+2, posz);
        }
        return arr;
    }

    public ArrayList<Float> rotate(ArrayList<Float> arr, float angle, String choice){
        float angle_cos = (float) Math.cos(angle);
        float angle_sin = (float) Math.sin(angle);
        for(int i = 0; i < arr.size(); i +=3 ){
            switch(choice){
                case 'x':
                    break;
                case 'y':
                    break;
                case 'z':
                    break;
            }
        }
    }

    public void generate(){

        // Para cada linha de A a B:
        for(int i = 0; i < points.size(); i += 6){
        // Calcular o vetor direcional d , dado por B - A
            float xa = points.get(i);
            float ya = points.get(i+1);
            float za = points.get(i+2);
            float xb = points.get(i+3);
            float yb = points.get(i+4);
            float zb = points.get(i+5);

            float xd = xb - xa;
            float yd = yb - ya;
            float zd = zb - za;

        // Normalizar o vetor direcional d
            float dlength = get_length(xd,yd,zd);
            float xd /= dlength;
            float yd /= dlength;
            float zd /= dlength;

        // Calcular o angulo do vetor direcional d com os eixos x, y e z

        //eixo x
            float xangle = get_angle(1,0,0,xd,yd,zd);
        //eixo y
            float yangle = get_angle(0,1,0,xd,yd,zd);
        //eixo z
            float zangle = get_angle(0,0,1,xd,yd,zd);
        // Criar um cilindro de altura B - A na origem
        // com a grossura pré-determinada

            float cyl_radius = max_thickness * Float.parseFloat(mapping.get(i).split(" ")[1]) ;

            float cyl_height = get_distance(xa,ya,za,xb,yb,zb);

        // // Formar pontos da circunferencia inferior
            ArrayList<Float> lower_circ = get_points(cyl_radius, 0);

        // // Formar pontos da circunferencia superior
            ArrayList<Float> upper_circ = get_points(cyl_radius, cyl_height);

        // // Transladar a base do cilindro para o ponto A
            lower_circ = translate(lower_circ, xa, ya, za);
            upper_circ = translate(upper_circ, xa, ya, za);

        // // Rotacionar o cilindro criado de acordo com os angulos do vetor direcional

            lower_circ = rotate(lower_circ, xangle, 'x');
            lower_circ = rotate(lower_circ, yangle, 'y');
            lower_circ = rotate(lower_circ, zangle, 'z');
            upper_circ = rotate(upper_circ, xangle, 'x');
            upper_circ = rotate(upper_circ, yangle, 'y');
            upper_circ = rotate(upper_circ, zangle, 'z');

        // // Apontar os pontos de cada face
            facepoints = build_map(lower_circ, upper_circ);
            faces = build_index(lower_circ);
        }
    }

}
