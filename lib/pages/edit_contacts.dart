import 'package:emergency/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart' as c;
import 'package:provider/provider.dart';
import '../providers/contactProvider.dart';



class EditContactScreen extends StatefulWidget {
  static const routeName = '/edit-contact';

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
    c.PhoneContact _phoneContact;
    final _phoneController= TextEditingController();
     final _name= TextEditingController();
    
  final _namesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
 
  final _relationshipNode = FocusNode();
  final _form = GlobalKey<FormState>();
  
     final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
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
        _phoneController.text=_editedProduct.phoneNumber;
        _name.text=_editedProduct.names;
        
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
  
  
    if (_editedProduct.id != null) {
      try{
      await Provider.of<ContactProvider>(context, listen: false)
          .updateContact( _editedProduct,_editedProduct.id,);
                
     }on Exception {
       _showScaffold("contact exists");
       setState(() {
      _isLoading = false;
    });
    return;
       
     }catch (error) {
_showScaffold("contact exists");
setState(() {
      _isLoading = false;
    });
    return;
}
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
          key: _scaffoldKey,
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
                     
                      decoration: InputDecoration(labelText: 'names'),
                      controller: _name,
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
                    Row(children: <Widget>[
                      Expanded(child:TextFormField(
                  
                      decoration: InputDecoration(labelText: 'phone'),
                      textInputAction: TextInputAction.next,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      focusNode: _phoneFocusNode,

                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_relationshipNode);
                      },
                      validator: (value) {
                        
                        if (value.trim().length==0) {
                          return 'Please enter a phone Number.';
                        }
                        if (value.trim().length<10) {
                          return 'Please enter a valid number.';
                        }
                        
                        return null;
                      },
                      onSaved: (value) {
                       
                         _editedProduct = Contact(
                            names: _editedProduct.names,
                            phoneNumber: value.trim(),
                            relationship: _editedProduct.relationship,
                              id: _editedProduct.id,
                            );
                         
                      }
                    ),
                     ),
                       IconButton(
          icon: Icon(Icons.photo_filter),
        
          onPressed: () async {
           final c.PhoneContact contact =
            await c.FlutterContactPicker.pickPhoneContact();
            
            setState(() {
              _phoneContact = contact;
              _name.text=_phoneContact.fullName;
              _phoneController.text=_phoneContact.phoneNumber.number;

            });
          },
        ),
                    ],),
                    
                    TextFormField(
                      initialValue: _initValues['relationship'],
                      decoration: InputDecoration(labelText: 'relationship'),
                    
                      keyboardType: TextInputType.multiline,
                      focusNode: _relationshipNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a realationship.';
                        }
                        if (value.trim().length < 2) {
                          return 'Should be at least 2 characters long.';
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
