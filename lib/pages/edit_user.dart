
import 'package:emergency/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';


class EditUserScreen extends StatefulWidget {
  static const routeName = '/edit-user';
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
   final _namesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
 
  
  final _form = GlobalKey<FormState>();
  var _editedProduct = User(
    id: null,
    names: '',
    phoneNumber: '',
  );
  var _initValues = {
    'names': '',
    
    'phoneNumber': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
       _editedProduct = ModalRoute.of(context).settings.arguments as User;
    
      if (_editedProduct != null) {
       
      _initValues = {
          'names': _editedProduct.names,
          'phoneNumber': _editedProduct.phoneNumber,
      };
         
          
       
         
      
        
      }
    }
    
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
  
    
    if (_editedProduct.id != null) {
      
      await Provider.of<UserProvider>(context, listen: false)
          .updateProduct( _editedProduct,_editedProduct.id,);
    } else {
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .addUser(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['names'],
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
                      initialValue: _initValues['phoneNumber'],
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


 