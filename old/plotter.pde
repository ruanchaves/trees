class Plotter {

    ArrayList<String> lines;
    ArrayList<ArrayList<Float>> points;

    Plotter(String[] lines){
        this.lines = new ArrayList<String>();
        this.points = new ArrayList<ArrayList<Float>>();
        for(int i = 0; i < lines.length; i++ ){
            this.lines.add(lines[i]);
        }
    }

    public ArrayList<Float> draw_call(String[] a, String[] b){
        ArrayList<Float> point_buffer = new ArrayList<Float>();

        if(a.length < 3) return point_buffer;
        if(b.length < 3) return point_buffer;

        try {
	        float x1 = Float.parseFloat(a[0]);
	        float y1 = Float.parseFloat(a[1]);
	        float z1 = Float.parseFloat(a[2]);
	        float x2 = Float.parseFloat(b[0]);
	        float y2 = Float.parseFloat(b[1]);
	        float z2 = Float.parseFloat(b[2]);
	        point_buffer.add(x1);
	        point_buffer.add(y1);
	        point_buffer.add(z1);
	        point_buffer.add(x2);
	        point_buffer.add(y2);
	        point_buffer.add(z2);
	        return point_buffer;
        } catch (NumberFormatException nf) {
            return point_buffer;
        }
    }

    public void plot(){
        for(int i = 0; i < this.lines.size(); i += 2){
            String[] point_a = this.lines.get(i).split(" ");
            if(i+1 < this.lines.size() ){
                String[] point_b = this.lines.get(i+1).split(" ");
                ArrayList<Float> point_buffer = draw_call(point_a, point_b);
                if(point_buffer.size() < 6) continue;
                points.add(point_buffer);
            }
            else{
                continue;
            }
        }
    }

    public void show(){
        for(ArrayList<Float> pbuffer : points){
            float x1 = pbuffer.get(0);
            float y1 = pbuffer.get(1);
            float z1 = pbuffer.get(2);
            float x2 = pbuffer.get(3);
            float y2 = pbuffer.get(4);
            float z2 = pbuffer.get(5);
            stroke(255,0,0);
            line(x1,y1,z1,x2,y2,z2);
        }
    }
}
