import 'package:emergency/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contactProvider.dart';



class EditContactScreen extends StatefulWidget {
  static const routeName = '/edit-contact';

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _namesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
 
  final _relationshipNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Contact(
    id: null,
    userID: '',
    relationship: '',
    names: '',
    phoneNumber: '',
  );
  var _initValues = {
    'userID': '',
    'relationship': '',
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
      final contactID = ModalRoute.of(context).settings.arguments as String;
      if (contactID != null) {
        _editedProduct =
            Provider.of<ContactProvider>(context, listen: false).getContactById(contactID) ;
           
        _initValues = {
          'names': _editedProduct.names,
          'phoneNumber': _editedProduct.phoneNumber,
          'relationship': _editedProduct.relationship,
          'userID':_editedProduct.userID,
          
         
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
    _relationshipNode.dispose();
  
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
  
    print(_editedProduct.id);
    if (_editedProduct.id != null) {
      
      await Provider.of<ContactProvider>(context, listen: false)
          .updateContact( _editedProduct,_editedProduct.id,);
    } else {
      try {
        await Provider.of<ContactProvider>(context, listen: false)
            .addContact(_editedProduct);
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
        title: Text('Edit Contact'),
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
                        _editedProduct = Contact(
                            names: value,
                            phoneNumber: _editedProduct.phoneNumber,
                            relationship: _editedProduct.relationship,
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
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_relationshipNode);
                      },
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
                       
                         _editedProduct = Contact(
                            names: _editedProduct.names,
                            phoneNumber: value,
                            relationship: _editedProduct.relationship,
                              id: _editedProduct.id,
                            );
                         
                      }
                    ),
                    TextFormField(
                      initialValue: _initValues['relationship'],
                      decoration: InputDecoration(labelText: 'relationship'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _relationshipNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a realationship.';
                        }
                        if (value.length < 4) {
                          return 'Should be at least 4 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        
                         _editedProduct = Contact(
                            names: _editedProduct.names,
                            phoneNumber: _editedProduct.phoneNumber,
                            relationship:value,
                              id: _editedProduct.id,
                            );
                      },
                    ),
                  
                  ],
                ),
              ),
            ),
    );
  }
}
