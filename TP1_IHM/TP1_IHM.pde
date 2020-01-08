// Globally ----------------

//declare the min and max variables that you need in parseInfo
  float minX, maxX;
  float minY, maxY;
  int totalCount; // total number of places
  int minPopulation, maxPopulation;
  int minSurface, maxSurface;
  int minAltitude, maxAltitude;
  float densityMax, densityMin;
  int seuilDensity;
  int minPopulationToDisplay = 10000;
  int colorText = 255;
  City lastCity = new City(99999,"zz",0,0,0,0,0,0,0);

//declare the variables corresponding to the column ids for x and y
  int x = 1;
  int y = 2;
  
// and the tables in which the city coordinates will be stored
  float xList[];
  float yList[];
  
// List of the cities
  City cities[];
  City chosen;
  int postalChosen = 76100;


//Parametre fenetre
  int background = 30;
// End Globally --------------

/*
 * Setup the application
 */
void setup() {
  size(1100,700);
  readData();
  seuilDensity  = 50;
  //frameRate(30);
  
}

/*
 * Draw the application
 */
void draw(){

  background(background);
  //in your draw method
  drawLegendDensity(800,50);
  //println(cities.length);
  fill(colorText);
  textSize(12);
  text("Seuil de densité : " + seuilDensity, 800,100);
  text("Afficher les populations supérieurs à " + minPopulationToDisplay, 800,150);

  for (int i = 0 ; i < cities.length -2 ; i++){
    if(cities[i].getPopulation() > minPopulationToDisplay){
          cities[i].draw();

    }
    //line(cities[i].x, cities[i].y, cities[i+1].x, cities[i+1].y);
  }
}

void drawLegendDensity(int x, int y){
   color c = color(0);
   fill(colorText);
   text("0", x,y + 25);
    for(int i = 0; i < 100; i++){
      c = color(map(i, 0,100, 0,255), 255,0);
      for(int j = 0; j < 10; j++){
          stroke(c);
          point(i + x, j + y);   
      }
    }
    c = color(0);
    fill(colorText);
    text(densityMax, x + 200,y + 25);
    for(int i = 0; i < 100; i++){
      c = color(255,map(i, 0,100, 255,0),0);
      for(int j = 0; j < 10; j++){
          stroke(c);
          point(i + x + 100, j + y);   
      }
    }

}

void keyPressed(){
   if(keyCode == TAB){
      background = (background == 0) ? 30 : 0;
      //colorText = (colorText == 255) ? 0 : 255;
    }
    if(key == 'a'){
      if(minPopulationToDisplay < 100){
        minPopulationToDisplay = 100;
      }
      minPopulationToDisplay = minPopulationToDisplay - (minPopulationToDisplay / 5);
    }
    if(key == 'z'){
      minPopulationToDisplay = minPopulationToDisplay + (minPopulationToDisplay / 5);
    }
    if(key == 'q'){
      seuilDensity = seuilDensity - (seuilDensity / 10);
      if(seuilDensity < 10){
        seuilDensity = 10;
      }
    }
    if(key == 's'){
      seuilDensity = seuilDensity + (seuilDensity / 5);
    }
      
    redraw();
}


/*
*  Read the CSV
*/
void readData() {
  String[] lines = loadStrings("./villes.tsv");
  parseInfo(lines[0]); // read the header line
  xList = new float[totalCount];
  yList = new float[totalCount];
  cities = new City[totalCount];
  densityMax = 0;
  densityMin = 100000;
  float density;
  for (int i = 2 ; i < totalCount ; ++i) {
    String[] columns = split(lines[i], TAB);
    xList[i-2] = float (columns[1]);
    if(float (columns[5]) != 0 && float(columns[6]) != 0){
      density = (float (columns[5])/float(columns[6]));
      //Density max
      if(density > densityMax){
        densityMax = density;
      }
      if(density < densityMin){
        densityMin = density;
      }
    }
    cities[i - 2] = new City(int (columns[0]),columns[4], mapX(float (columns[1])), mapY(float (columns[2])), float (columns[5]),float (columns[5])/float(columns[6]), float (columns[7]),float (columns[1]),float (columns[2])); 
   
    // Choosen city
    if(int(columns[0]) == postalChosen){
      chosen = new City(int (columns[0]),columns[4], mapX(float (columns[1])), mapY(float (columns[2])), float (columns[5]), (float (columns[5])/float(columns[6])), float (columns[7]),float (columns[1]),float (columns[2])); 
    }

    
    
  }
  println(densityMax);
  println(densityMax/2);  
}


/*
 *  Parse the string line given
 */
void parseInfo(String line) {
  String infoString = line.substring(2); // remove the #
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
  minPopulation = int(infoPieces[5]);
  maxPopulation = int(infoPieces[6]);
  minSurface = int(infoPieces[7]);
  maxSurface = int(infoPieces[8]);
  minAltitude = int(infoPieces[9]);
  maxAltitude = int(infoPieces[10]);
}

/*
 *  Convert x coord in the window coord
 */
float mapX(float x) {
 return map(x, minX, maxX, 0,700);
}

/*
 *  Convert y coord in the window coord
 */
float mapY(float y) {
 return map(y, minY, maxY, 700, 0);
}

City pick(int px, int py){
  City picked = null;
  for (int i = cities.length -3 ; i  > 0  ; i--){ 
    if(cities[i].contains(px,py)){  
      picked = cities[i];
      return picked;
    }
  }
  
  return picked;
}

void mouseMoved(){
  //println("mouse : (" + mouseX + "," + mouseY + ")" + " _ mouseOnScreen : (" + mapX(mouseX) + "," + mapY(mouseY) + ")");
  City picked = pick(mouseX,mouseY);
  if(picked != null&& lastCity != picked && picked.population > minPopulationToDisplay){
    println(picked.name);
    lastCity.isSelected = false;
    lastCity = picked;
    picked.isSelected = true;
  }
}
