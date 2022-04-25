import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cupid_test/constants/text.dart';
import 'package:cupid_test/constants/widgets/confirm_button.dart';
import 'package:cupid_test/constants/widgets/loading_dialog.dart';
import 'package:cupid_test/constants/widgets/my_form_field.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:cupid_test/presentation/login/bloc/sign_in_bloc.dart';
import 'package:cupid_test/presentation/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../constants/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => SignInBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const LoginScreen(),
      ),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isShowPassword = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SignInBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      // BoxConstraints(
      //     maxWidth: MediaQuery.of(context).size.width,
      //     maxHeight: MediaQuery.of(context).size.height),
      designSize: const Size(720, 2000),
      orientation: Orientation.portrait,
    );
    final size = MediaQuery.of(context).size;
    final now = DateTime.now();
    final timeNow = DateFormat('hh:mm').format(now);
    final parseTime = int.parse(DateFormat('kk').format(now));

    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          print('login state $state');
          if (state is SignInLoading) {
            loadingDialog(context: context, msg: 'LoginIn...');
          }
          if (state is SignInSuccess) {
            Navigator.pop(context);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.msg!,
                    style: TextStyle(color: BaseColor.white),
                  ),
                  backgroundColor: BaseColor.purple1,
                ),
              );
            Navigator.pushNamed(context, '/home');
          }
          if (state is SignInFailure) {
            Navigator.pop(context);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Failed Login',
              desc: state.msg,
              btnCancelOnPress: () {},
            ).show();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(BaseText.wp1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView(
                    children: [
                      Text(
                        _greetings(parseTime),
                        style: TextStyle(
                          color: BaseColor.white,
                          fontSize: setFontSize(100),
                        ),
                      ),
                      Text(
                        "it's $timeNow",
                        style: TextStyle(
                          color: BaseColor.white,
                          fontSize: setFontSize(100),
                        ),
                      ),
                      SizedBox(
                        height: 180.h,
                      ),
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          color: BaseColor.white,
                          fontSize: setFontSize(60),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      MyFormField(
                        textEditingController: _email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'enter your email address..',
                        prefixIcon: const Icon(Icons.mail),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      MyFormField(
                        textEditingController: _password,
                        keyboardType: TextInputType.text,
                        hintText: 'enter your password',
                        prefixIcon: const Icon(FontAwesomeIcons.key),
                        onFieldSubmitted: print,
                        obscureText: _isShowPassword ? false : true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            !_isShowPassword
                                ? Icons.lock_outline
                                : Icons.lock_open,
                          ),
                          onPressed: () {
                            setState(() {
                              if (!_isShowPassword) {
                                _isShowPassword = true;
                              } else {
                                _isShowPassword = false;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account ? ",
                                style: TextStyle(color: BaseColor.grey3),
                                children: [
                                  TextSpan(
                                    text: 'Create',
                                    style: TextStyle(color: BaseColor.black),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push<void>(
                                RegisterScreen.route(),
                              );
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      ConfirmButton(
                        onTap: () {
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Failed Login',
                              desc: 'Please fill all field',
                              btnCancelOnPress: () {},
                            ).show();
                          } else {
                            context.read<SignInBloc>().add(
                                  SignInBtnPressed(
                                    email: _email.text,
                                    password: _password.text,
                                  ),
                                );
                          }
                        },
                        height: 130.w,
                        width: size.width,
                        text: Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: BaseColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 450.h,
                      ),
                      Center(
                        child: Text(
                          'CupidKnot Test',
                          style: TextStyle(
                            fontFamily: BaseText.fBillabong,
                            fontSize: setFontSize(100),
                            color: BaseColor.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _greetings(int time) {
    if (time <= 12) {
      return 'Good Morning,';
    } else if ((time > 12) && (time <= 16)) {
      return 'Good Afternoon,';
    } else if ((time > 16) && (time <= 20)) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }
}

double setFontSize(double size) => ScreenUtil().setSp(size);
