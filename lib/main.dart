import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:system_setting/system_setting.dart';
import 'package:flutter/services.dart';

import './infoscreen.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_){
    runApp(MyApp());
  });  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Diarias',
      theme: ThemeData(        
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Notificaciones Diarias'),
      routes: {
        '/second': (context) => InfoScreen(),
      },      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);  

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final strIconList = [
    "@drawable/ic_alarm","@drawable/ic_uniform","@drawable/ic_food",
    "@drawable/ic_library","@drawable/ic_sport","@drawable/ic_sleeping_bag",
    "@drawable/ic_toothbrush","@drawable/ic_sleep"
  ];
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  var _actives = [false,false,false,false,false,false,false,false];
  Time _time;
  static var timeIni = Time(DateTime.now().hour,DateTime.now().minute,DateTime.now().second);
  //var _timesxNoti = List.filled(8, timeIni);
  var _timesxNotiStr = List.filled(8, "00:00:00");
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  

  @override
  void initState() {           
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@drawable/ic_iconpush');
    var ios = new IOSInitializationSettings();
    var initsettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initsettings, onSelectNotification: onSelectNotification);
    _getData();
  }

  Future<void> onSelectNotification(String payload) async {
    debugPrint("payload: $payload");
    showDialog(context: context, builder: (_)=> AlertDialog(
      title: Text("Recuerda!"),
      content: Text('$payload'),
    ));
  }

    _getData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
     _timesxNotiStr = prefs.getStringList('timeslist') ?? _timesxNotiStr ; 
    });    
    for(var i =0; i<_actives.length;i++){
      bool state = (prefs.getBool('state$i') ?? false);
      setState(() {
      _actives[i] = state;
    });
    }    
  }

 

  void _showNotification(int idNotification,String notificationBody, String payload) async{
    final SharedPreferences prefs = await _sprefs;   
    debugPrint("Id Notification: $idNotification");
    if(_time == null){
      var dNow = DateTime.now().add(new Duration(seconds: 5));
      setState(() {
        _time = new Time(dNow.hour,dNow.minute,dNow.second);
      });
    }     
    var android = new AndroidNotificationDetails('channel Id', 'channel Name', 'channel Description',
      largeIconBitmapSource: BitmapSource.Drawable, 
      largeIcon: strIconList[idNotification],
      importance: Importance.Max,
      priority: Priority.High,
      color: Colors.greenAccent,
      channelAction: AndroidNotificationChannelAction.CreateIfNotExists);
      
    var  ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      idNotification,
      'Recordatorio',
      notificationBody,
      _time,
      platform,
      payload: payload);

    //print("_time.toString()==>${_time.toString()}");
    setState(() {
     _actives[idNotification] = true;
     //_timesxNoti[idNotification] = _time;
     _timesxNotiStr[idNotification] = "${_time.hour}:${_time.minute}:${_time.second}";
    });
    prefs.setStringList('timeslist', _timesxNotiStr);
  }

  Future<void> _cancelActivateNotification(int idNotification,String notificationBody, String payload) async {
    final SharedPreferences prefs = await _sprefs;
    if(_actives[idNotification]){
      await flutterLocalNotificationsPlugin.cancel(idNotification);
    }else{
      _showNotification(idNotification,notificationBody, payload);
    }   
    String idnoti = idNotification.toString();    
    //bool state = (prefs.getBool('state$idnoti') ?? false);    
    setState(() {      
      _actives[idNotification] = !_actives[idNotification];
      prefs.setBool('state$idnoti', _actives[idNotification]);
    });
  }

/*
  void _jumpToSetting() async{
  SystemSetting.goto(SettingTarget.NOTIFICATION);
  }  
*/
  @override
  Widget build(BuildContext context) {
    //elementos que se muestran en el widget de la pagina principal
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            /*Text(
              'Listado de recordatorios diarios',
              textScaleFactor: 1.4,             
            ),*/
            PaddedRaisedButton(
                    buttonText: (
                      _actives[0] ? 'Cancelar Hora de Levantarse [${_timesxNotiStr[0]}]' : 'Hora de Levantarse'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(0,'Es hora de levantarse ','Da inicio a tu jornada escolar con la mejor actitud.');
                    },
                    colorBoton: (_actives[0] ? Colors.purpleAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[1] ? 'Cancelar Organizar uniforme [${_timesxNotiStr[1]}]' : 'Quitarse y organizar el uniforme '),                    
                    onPressed: () async {
                      await _cancelActivateNotification(1,'Organiza tu uniforme','Ten listo tu uniforme , al día siguiente  veraz que te  rendirá  el tiempo  !!!');
                    },
                    colorBoton: (_actives[1] ? Colors.greenAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[2] ? 'Cancelar Alimentarse [${_timesxNotiStr[2]}]' : 'Alimentarse'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(2,'Recuerda Alimentarte Bien ','Come sano, cuida tu salud, te ayudara a sentirte bien y rendir en tus actividades diarias.!!!');
                    },
                    colorBoton: (_actives[2] ? Colors.lightBlueAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[3] ? 'Cancelar Hacer Tareas [${_timesxNotiStr[3]}]' : 'Hacer tareas'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(3,'Recuerda Hacer Tus Tareas ','Cumplir con las responsabilidades diarias te hace una persona exitosa. Sigue así Tu Puedes. !!!!');
                    },
                    colorBoton: (_actives[3] ? Colors.yellowAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[4] ? 'Cancelar Practicar un deporte [${_timesxNotiStr[4]}]' : 'Practicar un deporte'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(4,'Recuerda Practicar un deporte','Juega, diviértete, haz deporte es la mejor manera de Sonríe y ser Feliz !!!');
                    },
                    colorBoton: (_actives[4] ? Colors.indigoAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[5] ? 'Cancelar Ponerse pijama [${_timesxNotiStr[5]}]' : 'ponerse Pijama'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(5,'Recuerda ponerte tu Pijama ','Prepararnos para dormir es la mejor manera de recargar energías para un día de arduo trabajo escolar !!!');
                    },
                    colorBoton: (_actives[5] ? Colors.limeAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[6] ? 'Cancelar Cepillarse [${_timesxNotiStr[6]}]' : 'Cepillarse'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(6,'Recuerda Cepillarte','Mantener un autocuidado diariamente  no solo te hará sentir bien , sino también  hablara por ti !!!');
                    },
                    colorBoton: (_actives[6] ? Colors.tealAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[7] ? 'Cancelar Dormir [${_timesxNotiStr[7]}]' : 'Dormir'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(7,'Vamos, a Dormir','Descansa, sueña .Mañana será un día excelente para cumplir con tus responsabilidades escolares !!!');
                    },
                    colorBoton: (_actives[7] ? Colors.orangeAccent : Colors.redAccent),
            ),
            /*PaddedRaisedButton(
                    buttonText: ('android 8+ configuracion'),                    
                    onPressed: () async {
                      _jumpToSetting();
                      },
                    colorBoton: Colors.brown,
            ),*/
          ],
    );
    /*column.children.add(PaddedRaisedButton(
                    buttonText: (
                      _actives[1] ? 'Cancelar notification dormir [${_timesxNoti[1].hour}:${_timesxNoti[1].minute}:${_timesxNoti[1].second}]' : 'Activar notificacion dormir #%&'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(1,'Ya es hora de ir a dormir @#%?','Debes dormir el tiempo suficiente cada dia');
                    },
                    colorBoton: (_actives[1] ? Colors.greenAccent : Colors.redAccent),
            ),);*/
    return Scaffold(
      appBar: AppBar(        
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ),
        ],
      ),
      body: Container(        
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo_proyecto.jpeg"),
            fit: BoxFit.contain,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(child: column),
        ),
        
      ),     
      floatingActionButton: FloatingActionButton(     
        onPressed: () {
                  DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      setState(() {
                                        _time = new Time(date.hour,date.minute,date.second);
                                      });
                                      print('confirm ${date.hour} : ${date.minute} : ${date.second}');
                                    }, currentTime: DateTime.now());
              },
        tooltip: 'Notification',
        child: Icon(Icons.watch_later),
      ),
    );
  }
}

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color colorBoton;
  const PaddedRaisedButton(
      {@required this.buttonText, @required this.onPressed, @required this.colorBoton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed, color: colorBoton),
    );
  }
}

/*
String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
*/