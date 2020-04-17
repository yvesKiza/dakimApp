
import 'package:emergency/models/contact.dart';
import 'package:emergency/models/user.dart';
import 'package:emergency/pages/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';


class AddUserScreen extends StatefulWidget {
  static const routeName = '/add-user';
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
   final _namesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
 
  
  final _form = GlobalKey<FormState>();
  var _editedProduct = User(
    id: null,
    names: '',
    phoneNumber: '',
  );
  
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
   
    
    
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    
    _namesFocusNode.dispose();
    _phoneFocusNode.dispose();
    
    super.dispose();
  }

  

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    List<Contact> _contacts=[];
    Navigator.of(context)
                    .pushNamed(AddContactScreen.routeName, arguments: [{'user': _editedProduct} ,{'condition': 'First Contact'},{'contacts':_contacts}]);
     setState(() {
      _isLoading = false;
    });     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
       
       
        child: Text("Sign up", style: TextStyle(fontSize: 30)),
      ),
                    TextFormField(
                     
                      decoration: InputDecoration(labelText: 'names'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = User(
                            names: value,
                            phoneNumber: _editedProduct.phoneNumber,
                          
                              id: _editedProduct.id,
                            );
                      },
                    ),
                    TextFormField(
                     
                      decoration: InputDecoration(labelText: 'phone'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _phoneFocusNode,
                     
                      validator: (value) {
                        String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(patttern); 
                        if (value.length==0) {
                          return 'Please enter a phone Number.';
                        }
                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a valid number.';
                        }
                        
                        return null;
                      },
                      onSaved: (value) {
                       
                         _editedProduct = User(
                            names: _editedProduct.names,
                            phoneNumber: value,
                          
                              id: _editedProduct.id,
                            );
                         
                      }
                    ),
               
                  
                  ],
                ),
              ),
            ),
    );
  }
}


 