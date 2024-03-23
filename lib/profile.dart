/// Profile de l'utilisateur
class Profile {
  String username ='';
  String secret ='';
  int age =0;
  double sizeOfPerson = 0;
  bool type=true;
  Map<String, bool> hobbies = {
    "Guitare" : false,
    "Violon" : false,
    "Piano" : false,
    "Dance" : false,
    "Développement" : false,
    "Course à pied" : false
  };
  List<String> listPL= [
    "Dart", "PHP", "Javascript", "Java", "Swift"
  ];
  ///Retourne le choix de type de personne homme ou femme
  String getTypeChoise(){
    return (type == false ? 'Masculin' : 'Féminin');
  }
  ///Retourne la taille de la personne pour l'afficher
  String getSizePerson(){
    int sizeRound = sizeOfPerson.ceil();
    return '$sizeRound cm';
  }
  ///Retourne le langage choisi
  String getChoiceLangage({required int choiceLangage}){
    return listPL[choiceLangage];
  }
  ///Retourne les hobbies choisi
  String getChoiceHobbies(){
    String choices = '';
    hobbies.forEach((name, value) {
      if(value == true){
        choices+= '$name, ';
      }
    });
    if (choices.isEmpty){
      return '';
    }
    choices = choices.substring(0, choices.length - 2);
    return choices;
  }
}