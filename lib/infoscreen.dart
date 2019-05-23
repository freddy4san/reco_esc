import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Teniendo en cuenta la problemática que actualmente han acarreado '
        'las redes sociales en los colegios Seminario Menor Santo Tomas de Aquino '
        'y Bethlemitas Brigthon Sede Afanador y como se ha visto afectada la '
        'estructuración y organización de hábitos y rutinas se pretende a través '
        'de la aplicación dar cumplimiento las responsabilidades y tareas a realizar diariamente '
        'facilitando un óptimo desempeño ocupacional y escolar.',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),      
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Acerca del Proyecto"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(            
            'assets/images/logo_terapia.jpeg',            
            width: 180,            
            height: 200,            
            fit: BoxFit.cover,            
          ),
          textSection,
          RaisedButton(
            onPressed: () {
              // Navigate back to the first screen by popping the current route
              // off the stack
              Navigator.pop(context);
            },
            child: Text('volver'),
          ),
        ],        
      ),
    );
  }
}