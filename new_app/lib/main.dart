import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Title'),
      ),
      body: MyForm(
        account: Account(
          Client()
              .setEndpoint('https://cloud.appwrite.io/v1')
              .setProject('praktikum')
              .setSelfSigned(status: true),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  final Account account;

  MyForm({required this.account});

  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  models.User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> login(String email, String password) async {
    await widget.account.createEmailSession(email: email, password: password);
    final user = await widget.account.get();
    setState(() {
      loggedInUser = user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    await widget.account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    await login(email, password);
  }

  Future<void> logout() async {
    await widget.account.deleteSession(sessionId: 'current');
    setState(() {
      loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          loggedInUser != null
              ? 'Logged in as ${loggedInUser!.name}'
              : 'Not logged in',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.0),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                register(
                  emailController.text,
                  passwordController.text,
                  nameController.text,
                );
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }
}
