import 'package:emergency/models/contact.dart';
import 'package:emergency/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';




class AuthAddScreen extends StatefulWidget {
  static const routeName = '/add-auth';
  @override
  _AuthAddScreenState createState() => _AuthAddScreenState();
}

User _user;
List<Contact> _contacts;

class _AuthAddScreenState extends State<AuthAddScreen> {
 
  @override
  void initState() {
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
   
    final map=ModalRoute.of(context).settings.arguments as List<Map<String, Object>>;
    
    _user=map[0].values.first as User;
    _contacts=map[2].values.first as List<Contact>;
 
    super.didChangeDependencies();
  }

  @override
  void dispose() {
   _passwordController.dispose();
  
    super.dispose();
  }
final GlobalKey<FormState> _formKey = GlobalKey();
 
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(message),
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

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
     
        
        
        await   Provider.of<AuthService>(context, listen: false).signUpWithEmail(email:
          _authData['email'],
          password:_authData['password'],user: _user,contact: _contacts);
     
    }  catch (error) {
      final errorMessage =
         error.toString();
      _showErrorDialog(errorMessage);
    }
Navigator.of(context).popUntil((route) => route.isFirst);

    setState(() {
      _isLoading = false;
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('authentication'),
       
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                      Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
       
       
        child: Text("Set email and password", style: TextStyle(fontSize: 30)),
      ),
       TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                     return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                
                  TextFormField(
                 
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator:  (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                             return null;
                          }
                      
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text('SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
               
                    
                  
                  ],
                ),
              ),
            ),
    );
  }
}
