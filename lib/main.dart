import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}



Map Coordinnate = {
  'id':1,
  'coordinateX':111,
  'coordinateY':222
};



//启动定位插件
startUp() async{
  await AMapLocationClient.startup(new AMapLocationOption( desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters ));

}

postData()async{
  Response response = await Dio().post("url", data: Coordinnate);
  return response;
}

processData(id,x,y){
  Coordinnate['id'] = id;
  Coordinnate['coordinateX']=x;
  Coordinnate['coordinateY']=y;
}
var lat;
var lon;
void getLocation() async {
  print('获取定位');
  // 申请权限 定位权限
  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
  // 申请结果
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
  print('PermissionStatus.granted${PermissionStatus.granted}');
  if (permission == PermissionStatus.granted) {
    Fluttertoast.showToast(msg: "权限申请通过");

    await AMapLocationClient.getLocation(true).then((_) {
      lat =_.latitude;
      lon = _.longitude;
      print('获取的latitude${_.latitude}');
      print('获取的longitude${_.longitude}');
     
    });
  } else {
    Fluttertoast.showToast(msg: "权限申请被拒绝");
  }
}


getX(){

}

getY(){

}
  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('设备号 ${androidInfo.androidId}'); // e.g. "Moto G (4)"
    return androidInfo.androidId;
  }

class _MyAppState extends State<MyApp> {
  @override

  void initState() { 
  super.initState();
  startUp();
  getDeviceId();
}
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('被监护端')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('注册并开始上传位置'),
                  onPressed: () {
                    processData(getDeviceId(),lat,lon);
                    print(Coordinnate);
                    //postData();

                  },
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
