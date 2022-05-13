import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),

      debugShowCheckedModeBanner: false,
      title: 'Transposition Cipher',
      home: CaesarCipher(),
    );
  }
}

class CaesarCipher extends StatefulWidget {
  @override
  _CaesarCipherState createState() => _CaesarCipherState();
}

class _CaesarCipherState extends State<CaesarCipher> {
  TextEditingController _wordEncryptController = TextEditingController();
  TextEditingController _keyEncryptController = TextEditingController();
  TextEditingController _wordDecryptController = TextEditingController();
  TextEditingController _keyDecryptController = TextEditingController();

  String _resultEnc = "";

  String _resultDec = "";

  @override
  void dispose() {
    _wordEncryptController.dispose();
    _keyEncryptController.dispose();
    _wordDecryptController.dispose();
    _keyDecryptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transposition Cipher'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
              padding: EdgeInsets.all(26.0),
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "ENCRYPTION",
                    style: TextStyle(color: Colors.black54, fontSize: 26),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Input your text here',
                    ),
                    controller: _wordEncryptController,
                    keyboardType: TextInputType.text,
                  ),
                  Container(
                    height: 32.0,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Input your key'),
                    controller: _keyEncryptController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Encrypt"),
                        onPressed: () {
                          this.encrypt();
                        },
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Output :',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                      SelectableText(
                        _resultEnc,
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Container(
                    height: 32.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
              padding: EdgeInsets.all(26.0),
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "DECRYPTION",
                    style: TextStyle(color: Colors.black54, fontSize: 26),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Input your text here',
                    ),
                    controller: _wordDecryptController,
                    keyboardType: TextInputType.text,
                  ),
                  Container(
                    height: 32.0,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Input your key'),
                    controller: _keyDecryptController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Decrypt"),
                        onPressed: () {
                          this.decrypt();
                        },
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Container(
                    height: 64.0,
                  ),
                  Row(
                    children: [
                      SelectableText(
                        'Output :$_resultDec',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void encrypt() {
    HashMap keyText = HashMap();
try{
    String keyString = _keyEncryptController.text;
    String plain_text = _wordEncryptController.text;
    var k_leng = keyString.length;
    var p_leng = plain_text.length;
    var rem = p_leng % k_leng;

    if (rem != 0) {
      var space = "_" * (k_leng - rem).abs();
      plain_text = plain_text + space;
    }

    var plain_text_ = plain_text.replaceAll(" ", "_");
    var keys = [];

    for (int i = 0; i < k_leng; i++) {
      keys.add(keyString[i]);
      keyText[keyString[i]] = [];
    }

    keys.sort();
    for (int i = 0; i < plain_text_.length; i++) {
      var temp = i % k_leng;
      keyText[keyString[temp]].add(plain_text_[i]);
    }

    var encrypted = "";
    keys.forEach((char) {
      for (int i = 0; i < keyText[char].length; i++) {
        encrypted = encrypted + keyText[char][i];
      }
    });

    setState(() {
      _resultEnc = encrypted;
    });
    } catch (e) {
      print("error>>>> $e");
      _showAlert("Invalid Key");
    }
  }

  void decrypt() {
    // try {
    String cipher = _wordDecryptController.text;
    String keyString = _keyDecryptController.text;
    var k_leng = keyString.length;
    var c_leng = cipher.length;

    var rem = c_leng % k_leng;
    

try{
    if (rem != 0) {
      var space = " " * (k_leng - rem).abs();
      cipher = cipher + space;
    }

    var cipher_ = cipher.replaceAll(" ", "_");
    c_leng = cipher.length;
    HashMap keyCipher = HashMap();
    var keys = [];
    var keysCopy = [];

    for (int i = 0; i < k_leng; i++) {
      keys.add(keyString[i]);
      keysCopy.add(keyString[i]);
      keyCipher[keyString[i]] = [];
    }

    keys.sort();
    var leng = cipher_.length / k_leng;
    var li = [];
    int j = 0;

    for (int i = 0; i < cipher_.length; i++) {
      li.add(cipher_[i]);
      if (li.length == leng) {
        keyCipher[keys[j]] = li;
        li = [];
        j++;
      }
    }

    String decrypted = "";
    for (int i = 0; i < leng; i++) {
      keysCopy.forEach((key) {
        decrypted = decrypted + keyCipher[key][i];
      });
    }

    decrypted = decrypted.replaceAll("_", " ");

    setState(() {
      _resultDec = decrypted;
    });
     } catch (e) {
      print("error>>>> $e");
      _showAlert("Invalid Key");
    }
  }

  Future<void> _showAlert(String _alert) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something is Wrong'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_alert),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
