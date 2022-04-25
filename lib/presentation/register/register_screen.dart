import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cupid_test/constants/color.dart';
import 'package:cupid_test/constants/text.dart';
import 'package:cupid_test/constants/widgets/confirm_button.dart';
import 'package:cupid_test/constants/widgets/loading_dialog.dart';
import 'package:cupid_test/constants/widgets/my_form_field.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:cupid_test/presentation/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => RegisterBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const RegisterScreen(),
      ),
    );
  }

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String? dropdownValue = 'Female';
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final _currencies = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(
      context,
      // BoxConstraints(
      //     maxWidth: MediaQuery.of(context).size.width,
      //     maxHeight: MediaQuery.of(context).size.height),
      designSize: const Size(720, 1280),
      orientation: Orientation.portrait,
    );
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            loadingDialog(context: context, msg: 'Registering..');
          }
          if (state is RegisterSuccess) {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              '/registerSuccess',
              arguments: state.msg,
            );
          }
          if (state is RegisterFailure) {
            Navigator.pop(context);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Failed Register',
              desc: state.msg,
              btnCancelOnPress: () {},
            ).show();
          }
        },
        child: Stack(
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
              top: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: BaseColor.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Create new account',
                    style: TextStyle(color: BaseColor.white, fontSize: 20),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  MyFormField(
                    textEditingController: _name,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'enter your name..',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyFormField(
                    textEditingController: _email,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'enter your email..',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyFormField(
                    textEditingController: _phoneNumber,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'enter your phone no..',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 20,
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
                        !_isShowPassword ? Icons.lock_outline : Icons.lock_open,
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
                  const SizedBox(
                    height: 20,
                  ),
                  MyFormField(
                    textEditingController: _confirmPassword,
                    keyboardType: TextInputType.text,
                    hintText: 'confirm your password',
                    prefixIcon: const Icon(FontAwesomeIcons.key),
                    onFieldSubmitted: print,
                    obscureText: _isShowConfirmPassword ? false : true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_isShowConfirmPassword
                            ? Icons.lock_outline
                            : Icons.lock_open,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (!_isShowConfirmPassword) {
                              _isShowConfirmPassword = true;
                            } else {
                              _isShowConfirmPassword = false;
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyFormField(
                    readOnly: true,
                    textEditingController: _dob,
                    hintText: 'enter of dob..',
                    prefixIcon: const Icon(FontAwesomeIcons.baby),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        final formatter = DateFormat('yyyy-MM-dd');
                        final formatted = formatter.format(date);

                        _dob.text = formatted;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(FontAwesomeIcons.user),
                            hintText: 'enter your gender',
                            border: InputBorder.none,
                            fillColor: BaseColor.white,
                            filled: true,
                            focusColor: BaseColor.purple2,
                          ),
                          isEmpty: dropdownValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ConfirmButton(
                    onTap: () {
                      if (_name.text.isEmpty ||
                          _email.text.isEmpty ||
                          _phoneNumber.text.isEmpty ||
                          _password.text.isEmpty ||
                          _confirmPassword.text.isEmpty ||
                          _dob.text.isEmpty ||
                          dropdownValue == '') {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Failed Register',
                          desc: 'Please fill all the fields',
                          btnCancelOnPress: () {},
                        ).show();
                      } else if (_password.text != _confirmPassword.text) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Failed Register',
                          desc: 'Password and confirm password not match',
                          btnCancelOnPress: () {},
                        ).show();
                      } else {
                        context.read<RegisterBloc>().add(
                              RegisterBtnPressed(
                                name: _name.text,
                                email: _email.text,
                                password: _password.text,
                                confirmPassword: _confirmPassword.text,
                                phone: _phoneNumber.text,
                                dob: _dob.text,
                                gender: dropdownValue,
                              ),
                            );
                      }
                    },
                    height: 130.w,
                    width: size.width,
                    text: Center(
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: BaseColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
