class City { 
      int postalcode; 
      String name; 
      float x; 
      float y; 
      float population; 
      float density; 
      float altitude;
      float realX;
      float realY;
      boolean isSelected;
      int selecteur = 0;

      // put a drawing function in here and call from main drawing loop }
      
      City(int postalcode, String name, float x, float y, float population, float density, float altitude, float rX, float rY){
        this.postalcode = postalcode;
        this.name = name;
        this.x = x;
        this.y = y;
        this.population = population;
        this.density = density;
        this.altitude = altitude;
        this.realX = rX;
        this.realY = rY;
      }
      
      void draw(){
        color c = densityBorneToColor();
        
        fill(c,150);
        stroke(c,500);
        ellipse(x, y, populationToSize(), populationToSize());
        if(isSelected){
          
          if(selecteur > 50){
            selecteur = 0;
          }else{
            if(selecteur < 10){
              selecteur = selecteur +1;
            }
            else if(selecteur < 40){
              selecteur = selecteur + 4;
            }else{
              selecteur = selecteur +2;
            }
          }
          noFill();
          stroke(color(0,255,255),500);
          ellipse(x, y, populationToSize()+selecteur, populationToSize()+selecteur);
          
          fill(color(0,255,255));
          textAlign(LEFT);
          textSize(16);
          text(name, x + populationToSize()/2 + 10, y);

        }
      }
      
      String toString(){
        return name;
      }
      
      color densityToColor(){
        color c = color(map(int(density), 0, 100, 0,255),map(int(density), 0, 1000, 255,0),0);
        return color(c);
      }
      
      color densityBorneToColor(){
        color c = color(0);
        float mid = seuilDensity;
        float min = minPopulationToDisplay; 
 
        if(this.density < mid){
          c = color( map(int(density), 0,mid, 0,255), 255,0);
        }else{
          c = color( 255,map(int(density), 0,mid, 255,0),0);
        }
        
        return c;
      }
      
      color altitudeToColor(){
        color c = color(map(int (altitude), minAltitude, 1000, 0,255),0,map(int (altitude), minAltitude, 2000, 255,0));
        return color(c);
      }
      
      float mapDensity(){
        return map(int(density), 0, 100, 0,255);
      }
      
      int populationToSize(){
        return int (map(int (population),minPopulation,maxPopulation, 1,100));
      }
      
      float distanceTo(City city){
         return sqrt(pow((city.x - this.x),2) + pow((city.y - this.y),2));   
      }
      
      float distanceReal(City city){
        return sqrt(pow((city.realX - this.realX),2) + pow((city.realY - this.realY),2)); 
      }
      
      color distanceToChosenToColor(){
        return color(map(int (distanceTo(chosen)), 0, 750, 255,0),map(int (distanceTo(chosen)), 0, 750, 0,255),0);
      }
      
      color nukeByTsarBomb(){
        float dist = distanceTo(chosen);
        color c = color(0);
        if(dist < mapDistReel(92)){
          c = color(150,150,150);
        }
        if(dist < mapDistReel(74)){
          c = color(71,255,15);
        }
         if(dist < mapDistReel(37)){
          c = color(255,35,15);
        }   
        if(dist < mapDistReel(6)){
          c = color(255,203,15);
        }

        return c;
      }
      
      float mapDistReel(float f){
        return (473 * f)/661;
      }
      // Paris marseille reel = 661 km
      // Paris marseille = 473
      
      public float getPopulation(){
        return population;
      }
      
      boolean contains(int px, int py){
        return dist(px, py, x,y) <= populationToSize()/2 +1;
      }
}
    
