import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Diarias',
      theme: ThemeData(        
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Notificaciones Diarias'),
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
  final strIconList = ["@drawable/ic_library","@drawable/ic_sleep","@drawable/ic_uniform"];
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
      title: Text("Recuerda! "),
      content: Text('$payload'),
    ));
  }

    _getData() async {
    final SharedPreferences prefs = await _sprefs;
    //print('-getData()-----state$key');
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
      color: Colors.greenAccent);
    var  ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      idNotification,
      'Recordatorio',
      notificationBody,
      _time,
      platform,
      payload: payload);

    print("_time.toString()==>${_time.toString()}");
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

  @override
  Widget build(BuildContext context) {
    //elementos que se muestran en el widget de la pagina principal
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            Text(
              'Listado de recordatorios diarios',
              textScaleFactor: 1.2,
              //padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[0] ? 'Cancelar notification Tarea [${_timesxNotiStr[0]}]' : 'Activar notificacion tarea'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(0,'Recuerda hacer tu tarea','Debes hacer siempre todas tus tareas');
                    },
                    colorBoton: (_actives[0] ? Colors.purpleAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[1] ? 'Cancelar notification Dormir [${_timesxNotiStr[1]}]' : 'Activar notificacion dormir'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(1,'Ya es hora de ir a dormir','Debes dormir el tiempo suficiente cada dia');
                    },
                    colorBoton: (_actives[1] ? Colors.greenAccent : Colors.redAccent),
            ),
            PaddedRaisedButton(
                    buttonText: (
                      _actives[2] ? 'Desactivar Alistar Uniforme [${_timesxNotiStr[2]}]' : 'Activar Alistar uniforme'),                    
                    onPressed: () async {
                      await _cancelActivateNotification(2,'Alista el uniforme','Deberias tener el uniforme de mañana limpio');
                    },
                    colorBoton: (_actives[2] ? Colors.lightBlueAccent : Colors.redAccent),
            ),
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
      ),
      body: Center(        
        child: SingleChildScrollView(child: column),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: ()=> _showNotification(0),        
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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