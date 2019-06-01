import 'package:flutter/material.dart';
import 'package:system_setting/system_setting.dart';

class HelpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget textSection1 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Como primer paso das click en el reloj para que aparezcan las horas. ',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),      
    );

    Widget textSection2 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Seleccionar la hora hora deseada y darle al boton de terminar. ',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),      
    );

    Widget textSection3 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Despues de haber seleccionado una hora, oprimir en cualquier notificación para activarla en la hora indicada. Obervarás que cambia de color cuando esta activa la notificacion y roja cuando no.',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),      
    );

    Widget textSection4 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Para que las notificaciones aparezcan correctamente, oprimir en el boton *[Ir a Configuraciones]* y realizar los pasos que se indican debajo.',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    );

    Widget textSection5 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Oprimir en la opcion señalada como Notificaciones',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    );

    Widget textSection6 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Oprimir en Notificaciones flotantes y en sonido, esto permitirá a la aplicación actuar de una manera mas acertada.',
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Tutorial"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textSection1,
            Image.asset(            
              'assets/images/img_tut1.jpg',
              scale: 1.0,           
              fit: BoxFit.cover,            
            ),
            textSection2,
            Image.asset(            
              'assets/images/img_tut2.jpg',
              scale: 2.0,           
              fit: BoxFit.cover,            
            ),
            textSection3,
            Image.asset(            
              'assets/images/img_tut3.jpg',
              scale: 1.0,           
              fit: BoxFit.cover,            
            ),
            textSection4,
            RaisedButton(
              onPressed: () {
                _jumpToSetting();
              },
              child: Text('Ir a Configuraciones'),
              color: Colors.tealAccent,
            ),
            textSection5,
            Image.asset(            
              'assets/images/img_tut4.jpg',
              scale: 1.0,           
              fit: BoxFit.cover,            
            ),
            textSection6,
            Image.asset(            
              'assets/images/img_tut5.jpg',
              scale: 1.0,           
              fit: BoxFit.cover,            
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack
                Navigator.pop(context);
              },
              child: Text('Volver al menú principal'),
            ),
          ],        
        ),
      ),      
    );
  }


  void _jumpToSetting() async{
  SystemSetting.goto(SettingTarget.NOTIFICATION);
  }

}