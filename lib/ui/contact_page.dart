import 'dart:io';
import 'package:agenda_contato/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ContactPage extends StatefulWidget {
  var contact;

  ContactPage({this.contact}); //parametro opcional usa {}

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  var _editedContact;
  bool _userEdited = false;

  late File _arquivo;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _namefocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
      _editedContact.name = "Novo Contato";
    } else {
      //pegando todas as informações de contado da tela principal
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
      if(_editedContact.img != null)
        _arquivo = File(_editedContact.img);
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _namefocus.dispose();
    super.dispose();
  }

  Future getFileFromGallery() async {
    final file = await picker.getImage(source: ImageSource.gallery);
    _arquivo = File(file!.path);
    print(_arquivo.path);

    if (_arquivo != null) {
      setState(() {
        _editedContact.img = _arquivo.path;
        _userEdited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(_editedContact.name),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name.isEmpty) {
                //FocusScope.of(context).requestFocus(_namefocus);
                _namefocus.requestFocus();
              } else {
                print(_editedContact.name);
                Navigator.pop(context, _editedContact); //tela em forma pilha
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.redAccent,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: _editedContact.img != null
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: FileImage(_arquivo),
                                fit: BoxFit.cover),
                          )
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("images/person.png"),
                                fit: BoxFit.cover),
                          ),
                  ),
                  onTap: getFileFromGallery
                ),
                TextField(
                  //autofocus: true,
                  controller: _nameController,
                  focusNode: _namefocus,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() async {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context); //remover o Dialog
                    Navigator.pop(context); //remover o contact_page
                  },
                ),
              ],
            );
          });
      return Future.value(false); // não sair automaticamente
    } else {
      return Future.value(true); //sair automaticamente da tela
    }
  }
}
