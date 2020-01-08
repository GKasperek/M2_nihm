

/* Une ligne par trial + noms de colonnes */
var Resultats = [];

/* Une ligne par mouse event + noms de colonnes */
var Cinematiques = [];


/*
	Initialisation des logs, notamment les noms de colonne (y compris les mesures).
*/
function initLogs() {

	Resultats.push( ParamNamesInOrder.join('\t') );
	Cinematiques.push( ParamNamesInOrder.join('\t') );

	Resultats.push[0] +=  '\t' + 'Erreurs' ;
	Resultats.push[0] +=  '\t' + 'Start at' ;
	Resultats.push[0] +=  '\t' + 'End at' ;
	Resultats.push[0] +=  '\t' + 'End at' ;
	/* TODO colonnes supplémentaires (mesures, etc.) */

}

function logEvent(values) {

	/* TODO Ajouter un événement aux logs cinématiques. Tous les champs doivent être remplis. */

}

function logTrial(values) {
	const logsT = [
		Trials[ ParamNamesInOrder[0]],
		Trials[ ParamNamesInOrder[1]],
		Trials[ ParamNamesInOrder[2]],
		Trials[ ParamNamesInOrder[3]],
		Trials[ ParamNamesInOrder[4]],
		Trials[ ParamNamesInOrder[5]],
		Trials[ ParamNamesInOrder[6]],
		Trials[ ParamNamesInOrder[7]],
		values['Errors'],
		values['StartAt'],
		values['ClickAt'],
		values['Time']
	];

	Resultats.push(logsT.join('\t'));
	Resultats[Resultats.length -1]+= '\n';


}
