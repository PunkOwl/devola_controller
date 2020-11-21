import 'package:devola_controller/components/devola_button.dart';
import 'package:devola_controller/data/settings_bloc.dart';
import 'package:devola_controller/language.dart';
import 'package:devola_controller/model/entity/devola_settings_entity.dart';
import 'package:devola_controller/util/devola_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsBloc settingsBloc;

  const SettingsScreen({Key key, this.settingsBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState(settingsBloc);
  }
}

class _SettingsScreenState extends State<SettingsScreen> {

  final SettingsBloc _settingsBloc;
  DevolaSettingsEntity _settingsEntity;
  TextEditingController _ipAddrController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  String _errorText;
  bool _isLoading = false;

  _SettingsScreenState(this._settingsBloc);

  @override
  void initState() {
    _settingsBloc.add(GetSettings());
    super.initState();
  }

  @override
  void dispose() {
    _ipAddrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.TITLE_SETTINGS.toUpperCase()),
      ),
      body: Column(
        children: [
          Row(
            children: [
              BlocListener(
                cubit: _settingsBloc,
                listener: (context, state) {
                  if(state is GetSettingsLoaded) {
                    setState(() {
                      _isLoading = false;
                      _settingsEntity = state.settings;
                      _ipAddrController.text = state.settings.devolaAddr;
                      _portController.text = state.settings.devolaAddrPort.toString();
                    });
                  } else if(state is GetSettingsLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  } else if(state is GetSettingsError) {
                    setState(() {
                      _isLoading = false;
                      _errorText = state.error;
                    });
                  } else if(state is UpdateSettingsLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  } else if(state is UpdateSettingsLoaded) {
                    setState(() {
                      _isLoading = false;
                    });
                    DevolaUtils.showDialog(Language.DESC_SETTINGS_SAVED);
                  } else if(state is UpdateSettingsError) {
                    setState(() {
                      _isLoading = false;
                      _errorText = state.error;
                    });
                  }
                },
                child: SizedBox(height: 10,),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 28,
              obscureText: false,
              style: TextStyle(fontSize: 18),
              enabled: true,
              controller: _ipAddrController,
              decoration: InputDecoration(
                errorText: _errorText,
                counterText: '',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.loop, color: Colors.deepOrangeAccent),
                labelText: Language.LABEL_IP_ADDR,
                labelStyle: TextStyle(fontSize: 16),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.redAccent, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.redAccent, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 28,
              obscureText: false,
              style: TextStyle(fontSize: 18),
              enabled: true,
              controller: _portController,
              decoration: InputDecoration(
                errorText: _errorText,
                counterText: '',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.call_merge, color: Colors.deepOrangeAccent),
                labelText: Language.LABEL_PORT,
                labelStyle: TextStyle(fontSize: 16),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.redAccent, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.redAccent, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  child: DevolaButton(
                    color: Colors.blueGrey,
                    text: Language.BTN_TEST.toUpperCase(),
                    fontSize: 16,
                    isLoading: _isLoading,
                    onClick: () {

                    },
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  height: 50,
                  child: DevolaButton(
                    color: Colors.deepOrangeAccent,
                    text: Language.BTN_SAVE.toUpperCase(),
                    fontSize: 16,
                    isLoading: _isLoading,
                    onClick: () {
                      if(_ipAddrController.text.length > 1 && DevolaUtils.isNumeric(_portController.text)) {
                        _settingsEntity.devolaAddr = _ipAddrController.text;
                        _settingsEntity.devolaAddrPort = int.parse(_portController.text);
                        _settingsBloc.add(UpdateSettings(
                          _settingsEntity
                        ));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

}