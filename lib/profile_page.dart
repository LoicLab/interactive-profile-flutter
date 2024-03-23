import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_profile/profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  Profile profile = Profile();
  late TextEditingController usernameChanged;
  late TextEditingController secretChanged;
  late TextEditingController ageChanged;
  late TextEditingController theme;
  static const titleAge = 'Age';
  static const titleSize = 'Taille';
  static const titleType = 'Genre';
  static const titleHobbies = 'Hobbies';
  static const titlePL = 'Langage de programmation favori';
  List<String> listHobbies=[];
  int choiceLangage = 1;
  static const double textSize = 16;
  bool visibilitySecret=false;
  ImagePicker imagePicker = ImagePicker();
  File? file;
  String displayTextBtnSecret='Montrer secret';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Tout ce que l'on va faire pendant l'initialisation du Widget.
    usernameChanged = TextEditingController();
    secretChanged = TextEditingController();
    ageChanged = TextEditingController();
  }

  @override
  void dispose() {
    usernameChanged.dispose();
    secretChanged.dispose();
    ageChanged.dispose();
    // TODO: implement dispose
    super.dispose();
    //Tout ce que l'on va faire quand le widget sera dispose. Quand le widget sera supprimé
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: Text(
              "Mon profil",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary
              ),
          )
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child : SingleChildScrollView(
            child: Column(
                children: [
                displayInformations(),
                photoButtons(),
                const Divider(thickness: 2,),
                title(name: 'Modifier les informations'),
                modifyInformations(),
                const Divider(thickness: 2,),
                title(name: 'Mes hobbies'),
                displayHobbies(),
                const Divider(thickness: 2,),
                title(name: 'Langage préféré'),
                displayPL()
            ],
          ),
        ),
      ),
    );
  }
  ///Affiche les informations dans une card
  Card displayInformations(){
    List<String> texts = [
      usernameChanged.text,
      '${ProfilePageState.titleAge}: ${ageChanged.text}',
      '${ProfilePageState.titleSize}: ${profile.getSizePerson()}',
      '${ProfilePageState.titleType}: ${profile.getTypeChoise()}'
    ];
    List<Widget> infoCol= [];
    for (var i = 0; i < texts.length; i++) {
      Widget row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              texts[i],
              style: const TextStyle(
                  fontSize: ProfilePageState.textSize
              )
          ),
        ],
      );
      infoCol.add(row);
    }

    Column cInfos = Column(children: infoCol);
    List<Widget> columns=[cInfos];
    if(file != null){
      columns.insert(0, Column(
        children: [
          Image(
            height: 100,
            image: FileImage(file!),
            fit: BoxFit.cover,
          )
        ],
      ));
    }

    Row r = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columns
    );
    Row r2 = Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '${ProfilePageState.titleHobbies}: ${profile.getChoiceHobbies()}',
            style: const TextStyle(
                fontSize: ProfilePageState.textSize
            )
        )
      ],
    );
    Row r3 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '${ProfilePageState.titlePL}: ${profile.getChoiceLangage(choiceLangage: choiceLangage)}',
            style: const TextStyle(
                fontSize: ProfilePageState.textSize
            )
        )
      ],
    );
    //ajout bouton afficher secret
    Column c = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FloatingActionButton.extended(
          onPressed: changeVisibilitySecret,
          label: Text(
              displayTextBtnSecret,
              style: const TextStyle(
                fontSize: textSize
              ),
          ),
        ),
        Visibility(
          visible: visibilitySecret,
          child: Text(
            secretChanged.text,
            style: const TextStyle(
                fontSize: ProfilePageState.textSize
            )
        ),
        )
      ],
    );

    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Container(
          padding: const EdgeInsets.all(10),
          child:Column(
            children: [r,r2,r3,c],
          )
      ),
    );
  }
  changeVisibilitySecret(){
    setState(() {
      visibilitySecret=(visibilitySecret == true)?false:true;
      displayTextBtnSecret=(displayTextBtnSecret == 'Montrer secret')?'Masquer secret':'Montrer secret';
    });
  }

  ///Création d'un titre
  Row title({required String name}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold
          )
        )
      ],
    );
  }
  ///Création des champs pour modifications du profil
  Column modifyInformations(){
    return Column(
      children: [
        newTextField(
            setValue: profile.username,
            hindText: "Entrez votre nom d'utilisateur",
            obscureText: false,
            controller: usernameChanged,
            keyboardType: TextInputType.text
        ),
        newTextField(
            setValue: profile.secret,
            hindText: "Dites nous un secret",
            obscureText: true,
            controller: secretChanged,
            keyboardType: TextInputType.text
        ),
        newTextField(
            setValue: profile.age,
            hindText: "Votre âge",
            obscureText: false,
            controller: ageChanged,
            keyboardType: TextInputType.number,
            maxLength: 3
        ),
        rowModifyPerson(
            text: "Genre ${profile.getTypeChoise()}",
            widget: Switch(
              value: profile.type,
              onChanged: ((choice) {
                setState(() {
                  profile.type = choice;
                });
              }),
            )
        ),
        rowModifyPerson(
            text: "Taille ${profile.getSizePerson()}",
            widget: Slider(
                value: profile.sizeOfPerson,
                min: 0,
                max: 250,
                onChanged: ((newValue) {
                  setState(() {
                    profile.sizeOfPerson = newValue;
                  });
                })
            )
        )
      ],
    );
  }
  /// Création d'une row pour le bloc modifier
  Row rowModifyPerson({required String text, required Widget widget}){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 17
          ),
        ),
        widget
      ],
    );
  }

  /// Création d'un nouveau champ Textfield
  TextField newTextField({
    required setValue,
    required String hindText,
    required bool obscureText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    int? maxLength
  }){
    return TextField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: true,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onSubmitted: (newString) {
        setState(() {
          setValue = newString;
        });
      },
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary
      ),
      decoration: InputDecoration(
        hintText: hindText,
        hintStyle: const TextStyle(
          color: Colors.grey,

        ),
      ),
    );
  }

  ///Affiche les hobbies
  Column displayHobbies() {
    List<Widget> items = [];

    profile.hobbies.forEach((name, choice) {
      Widget row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: ProfilePageState.textSize)),
          Checkbox(value: choice, onChanged: ((newValue) {
              setState(() {
                profile.hobbies[name] = newValue ?? false;
            });
          }),
          )
        ],
      );
      items.add(row);
    });
    return Column(children: items);
  }
  ///Afficher les langages de programmations
  Column displayPL(){
    List<Widget> texts = [];
    List<Widget> radios = [];
    for (var i = 0; i < profile.listPL.length; i++) {
      Text t = Text(
          profile.listPL[i],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: ProfilePageState.textSize
          ),
      );
      Radio r = Radio(
          activeColor: Theme.of(context).colorScheme.onSecondary,
          value: i,
          groupValue: choiceLangage,
          onChanged: ((newValue) {
            setState(() {
              choiceLangage = newValue as int;
            });
          }));
      texts.add(t);
      radios.add(r);
    }

    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: texts,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: radios,
          )
        ]
    );
  }

  Future getImage(ImageSource source) async {
    XFile? chosen = await imagePicker.pickImage(source: source);
    if (chosen != null){
      setState(() {
        file = File(chosen.path);
      });
    }
  }

  Row photoButtons(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
          IconButton(
              onPressed: (() => getImage(ImageSource.gallery)),
              icon: const Icon(
                Icons.image
              ),
          ),
        IconButton(
            onPressed: (() => getImage(ImageSource.camera)),
            icon: const Icon(
                Icons.camera_alt
            ),
          )
      ],
    );
  }
}