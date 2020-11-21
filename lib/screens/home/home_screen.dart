import 'dart:io';

import 'package:devola_controller/app_types.dart';
import 'package:devola_controller/data/settings_bloc.dart';
import 'package:devola_controller/model/dto/packet_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udp/udp.dart';

import '../../language.dart';

class HomeScreen extends StatefulWidget {
  final SettingsBloc settingsBloc;

  const HomeScreen({Key key, this.settingsBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(settingsBloc);
  }
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isShowingCamera = true;
  double _scaleFactorValue = 1;
  final SettingsBloc _settingsBloc;

  bool _isReady = false;
  String _ipAddr = '';
  int _idAddrPort = 0;
  Endpoint _endpoint;

  UDP _receiver;
  UDP _sender;

  _HomeScreenState(this._settingsBloc);

  @override
  void initState() {
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
    try {
      _endpoint = Endpoint.multicast(InternetAddress(_ipAddr), port: Port(_idAddrPort));
      _sender = await UDP.bind(Endpoint.any());
      setState(() {
        _isReady = true;
      });
    } catch(ex, stacktrace) {
      _showError(ex, stacktrace);
    }

  }
  
  _sendScaleFactor() async {
    print('Sending');
    _sender.send(PacketDto(
      scaleFactor: _scaleFactorValue,
      isCameraOn: _isShowingCamera,
      extra: null
    ).toRawJson().codeUnits, _endpoint);
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
              } else if(state is UpdateSettingsLoaded) {
                _settingsBloc.add(GetSettings());
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
                    if(_isReady) {
                      setState(() {
                        _isShowingCamera = value;
                      });
                      _sendScaleFactor();
                    }
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
                _sendScaleFactor();
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

  _showError(Exception ex, StackTrace stackTrace) async {
    await showDialog(
      barrierColor: Colors.redAccent,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(ex.toString(), style: TextStyle(fontWeight: FontWeight.w700),),
              ),
              Divider(),
              Container(
                child: Text(stackTrace.toString()),
              )
            ],
          ),
        );
      }
    );
  }
}