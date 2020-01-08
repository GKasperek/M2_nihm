

/*
	"Dictionnaire" qui va contenir tout le "scénario", une ligne par trial.
	La structure est {nom_de_colonne_1: [une valeur par trial], nom_de_colonne_2: [une valeur par trial], etc.}
*/
var Trials = [];

/* Liste des noms de colonnes dans le bon ordre, au cas où le "dictionnaire" ne respecte pas l'ordre. */
var ParamNamesInOrder = [];

/* Trial courrant */
var CurrentParticipant = "";
var CurrentTrial = [];
var IndexTrial = 1;

/* Fonction utilitaire permettant d'obtenir toutes les valeurs uniques dans une liste. */
function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}

/*
	Lecture d'un fichier de scénario.
	Le fichier de scénario doit être au format .tsv (tab-separated values) et commencer par une ligne
	décrivant les noms de colonnes.
	Le fichier est chargé en cliquant sur un bouton en haut de la page.
*/
function lireScenario(event) {

	let input = event.target;
	let reader = new FileReader();

	reader.onload = function(){
		let text = reader.result.split('\n');

		// First line: Parameter names

		ParamNamesInOrder = text[0].split('\t');
		for (let i = 0 ; i < ParamNamesInOrder.length ; i++) {
			Trials[ ParamNamesInOrder[i] ] = [];
		}


		// Next lines: Trials

		for (let i = 1 ; i < text.length ; i++) {
			let paramValues = text[i].split('\t');
			for (let j = 0 ; j < paramValues.length ; j++) {
				Trials[ ParamNamesInOrder[j] ][i] = paramValues[j];
			}
		}

		let uniqueParticipants = Trials['Participant'].filter( onlyUnique );

		let select = document.getElementById('Plist');
		for (let i = 0 ; i < uniqueParticipants.length ; i++) {
			var opt = document.createElement('option');
			opt.value = uniqueParticipants[i];
			opt.innerHTML = uniqueParticipants[i];
			select.appendChild(opt);
		}

		// Voir logging.js
		initLogs();

	};

	reader.readAsText(input.files[0]);

};


function chargerParticipant() {
	/* TODO
		- charger le premier trial du participant correspondant
	*/
  let select = document.getElementById('Plist');
  let participant = select.value;
  console.log("Selectionné : "+ participant);
  IndexTrial = 1;
  for(let i = 1; i < Trials[ParamNamesInOrder[0]].length; i++){
    // On parcourt tous les participants
    console.log("Liste : "+ Trials[ParamNamesInOrder[0]][i]);
    IndexTrial = i;
    if(participant === Trials[ParamNamesInOrder[0]][i]){
      // Quand on trouve la premiere occurence du participant
      for(let j = 0; j < ParamNamesInOrder.length; j++){
        //console.log(Trials[ParamNamesInOrder[j]]);
        CurrentTrial[j] = Trials[ParamNamesInOrder[j]][IndexTrial];
      }

      CurrentParticipant = participant;
      break;
    }
  }
  console.log("Participant = " + participant + ", Trials n° " + IndexTrial);
  console.log(CurrentTrial);
  IndexTrial = 0;
  trialSuivant();
  console.log(IndexTrial);
}

function trialSuivant() {

	/* TODO fonction à appeler pour passer au trial suivant.
		- Logguer les résultats
		- Vérifier qu'il ne s'agit pas du dernier trial pour ce participant
		- Nettoyer le canvas
		- Générer un nouveau canvas à partir des paramètres du trial
	*/
  startingDate = new Date();
  console.log(CurrentTrial[0] +" "+Trials[ParamNamesInOrder[0]][IndexTrial+1])
  if(CurrentTrial[0] != Trials[ParamNamesInOrder[0]][IndexTrial+1]){
    alert("Le participant a fini");
  }else{
    clearCanvas();
    IndexTrial++;
    CurrentTrial = [];
    for(let j = 0; j < ParamNamesInOrder.length; j++){
      //console.log(Trials[ParamNamesInOrder[j]]);
      CurrentTrial[j] = Trials[ParamNamesInOrder[j]][IndexTrial];
    }

    if(CurrentTrial[1] === 'Baseline'){
      Bubble = false;
    }

    if(CurrentTrial[1] === 'Bubble'){
      Bubble = true;
    }
    console.log(Bubble ? "Bubble" : "Baseline ");

    let decalage = (CurrentTrial[5] === 'Gauche')? -1 : 1;

    let coordX = (canvas.node.clientWidth /2) +(decalage*CurrentTrial[6]);
    let coordY = 150;
    createTargets(coordX,coordY, parseInt(CurrentTrial[4]), parseInt(CurrentTrial[3]));

  }

  function createTargets(x , y, density, taille){
    let taillePix = Math.trunc(fromCmToPixel(taille));
  //  let densityPix = Math.trunc(fromCmToPixel(density));
    let densityPix = 30;

    let nbDistracteur = Math.trunc((10 + taille)/ (density + taille));
    if(nbDistracteur % 2 == 0){
      nbDistracteur++;
    }
    console.log(nbDistracteur);
    for(let i = 0; i < nbDistracteur; i++){
      for(let j = 0; j < nbDistracteur; j++){
        if(parseInt(nbDistracteur/2,10) == i && parseInt(nbDistracteur/2,10) == j ){
          new Target( i*(taillePix+densityPix)+ x, j*(taillePix+densityPix)+y, taillePix, false);
        }
        else{
          new Target( i*(taillePix+densityPix)+ x, j*(taillePix+densityPix)+y, taillePix, true);
        }
      }
    }


  }

  function fromCmToPixel(cm){
    return parseInt(cm*38,10);
  }

  function fromPixelToCm(pixel){
    return parseInt((pixel*10)/2.5,10);
  }

}
