import 'package:flutter/material.dart';
import 'package:michaels_library/providers/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            SizedBox(height: 120,),
            Container(
              child: Center(
                child: Icon(Icons.book, size: 100, color: Colors.black38,),
              ),
            ),
            SizedBox(height: 8,),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Library', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.black54), textAlign: TextAlign.center,),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (email) {
                auth.setEmail(email);
              },
            ),
            SizedBox(height: 16,),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              obscureText: true,
              onChanged: (password) {
                auth.setPassword(password);
              },
            ),
            SizedBox(height: 32,),
            auth.loading ? Center(
              child: CircularProgressIndicator(),
            ) :
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Login'),
              ),
              onPressed: (){
                FocusScope.of(context).requestFocus(FocusNode());
                auth.loginUser();
              },
            ),
            SizedBox(height: 16,),
            FlatButton(
              child: Text('Fogot Password?'),
              onPressed: (){},
            ),
            SizedBox(height: 120,),
          ],
        ),
      ),
    );
  }
}
