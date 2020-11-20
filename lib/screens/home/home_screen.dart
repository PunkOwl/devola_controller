import 'dart:io';

import 'package:devola_controller/app_const.dart';
import 'package:devola_controller/app_types.dart';
import 'package:devola_controller/data/settings_bloc.dart';
import 'package:devola_controller/data/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udp/udp.dart';

import '../../language.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isShowingCamera = true;
  double _scaleFactorValue = 1;
  final SettingsRepository _settingsRepository = SettingsRepository();
  SettingsBloc _settingsBloc;

  bool _isReady = false;
  String _ipAddr = '';
  int _idAddrPort = 0;
  Endpoint _endpoint;

  UDP _receiver;
  UDP _sender;

  @override
  void initState() {
    _settingsBloc = SettingsBloc(settingsRepository: _settingsRepository);
    _settingsBloc.add(GetSettings());
    super.initState();
  }

  @override
  void dispose() {
    _receiver?.close();
    _sender?.close();
    super.dispose();
  }

  _setupConnection() async {
    print(_ipAddr);
    print(_idAddrPort.toString());
    _endpoint = Endpoint.multicast(InternetAddress(_ipAddr), port: Port(_idAddrPort));
    // _receiver = await UDP.bind(_endpoint);
    _sender = await UDP.bind(Endpoint.any(port: Port(_idAddrPort)));
    setState(() {
      _isReady = true;
    });
  }
  
  _sendScaleFactor(double data) async {
    print('Sending');
    _sender.send(data.toString().codeUnits, _endpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(Language.APP_NAME),
            _isReady ? Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ) : SizedBox(width: 15,)
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppTypes.SCREEN_SETTINGS);
            },
          )
        ],
      ),
      body: Column(
        children: [
          BlocListener(
            cubit: _settingsBloc,
            listener: (context, state) {
              if(state is GetSettingsLoaded) {
                _ipAddr = state.settings.devolaAddr;
                _idAddrPort = state.settings.devolaAddrPort;
                _setupConnection();
              }
            },
            child: SizedBox(height: 10,),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(Language.LABEL_SHOW_CAMERA, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                Checkbox(
                  checkColor: Colors.white,
                  focusColor: Colors.deepOrange,
                  activeColor: Colors.deepOrange,
                  value: _isShowingCamera,
                  onChanged: (value) {
                    setState(() {
                      _isShowingCamera = value;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(Language.LABEL_SCALE_FACTOR, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),)
              ],
            ),
          ),
          Slider(
            value: _scaleFactorValue,
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.orange,
            min: 0.5,
            max: 1,
            onChanged: (value) {
              if(_isReady) {
                _sendScaleFactor(value);
              }
              setState(() {
                _scaleFactorValue = value;
              });
            },
          ),
          Divider(color: Colors.black54,),
        ],
      ),
    );
  }
}