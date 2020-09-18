import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_enam/application/auth/cubit/auth_cubit.dart';
import 'package:hello_enam/domain/auth/model/login_request.dart';
import 'package:hello_enam/presentation/home/home_page.dart';

class SiginPage extends StatefulWidget {
  @override
  _SiginPageState createState() => _SiginPageState();
}

class _SiginPageState extends State<SiginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. kasih tau, kalo page ini bisa akses ke cubit. dengan menambahkan blocprovider & mengganti Subject dengan AuthCubit()
      body: BlocProvider(
        create: (context) => AuthCubit(),
        // 2. harus ada builder, dengan menambahkan blocconsumer
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // 3. baca data dari listener (listener itu untuk mengolah data)
            if (state is AuthError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('ERROR'),
                  content: Text(state.errorMessage),
                ),
              );
            } else if (state is AuthLoading) {
              print('loading');
            } else if (state is AuthSuccess) {
              print(state.dataLogin);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    loginResponse: state.dataLogin,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey.shade800,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        title: TextField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Email address:",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.email,
                                color: Colors.white30,
                              )),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade600,
                      ),
                      ListTile(
                        title: TextField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Password:",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white30,
                              )),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: (state is AuthLoading)
                                ? _loadingButton()
                                : _loginButton(context),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.grey.shade500),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  RaisedButton _loginButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        // Panggil Cubit untuk sigin user & spesifikan bloc yg mana
        final _requestData = LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        );
        context.bloc<AuthCubit>().siginUser(_requestData);
      },
      color: Colors.cyan,
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white70, fontSize: 16.0),
      ),
    );
  }

  RaisedButton _loadingButton() {
    return RaisedButton(
      onPressed: null,
      color: Colors.cyan,
      child: CircularProgressIndicator(),
    );
  }
}
