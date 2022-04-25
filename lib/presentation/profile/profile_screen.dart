import 'package:cupid_test/constants/color.dart';
import 'package:cupid_test/constants/widgets/confirm_button.dart';
import 'package:cupid_test/constants/widgets/my_form_field.dart';
import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:cupid_test/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.user, this.isEditable}) : super(key: key);

  final Profile? user;
  final bool? isEditable;

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => MyProfileBloc(
          userRepository: context.read<UserRepository>(),
        ),
        child: const ProfileScreen(),
      ),
    );
  }

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? dropdownValue;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final _currencies = ['Male', 'Female'];

  @override
  void initState() {
    _name.text = widget.user!.fullName!;
    _dob.text = widget.user!.dob!;
    _phoneNumber.text = widget.user!.mobileNo!;
    dropdownValue =
        toBeginningOfSentenceCase(widget.user!.gender!.toLowerCase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(
      context,
      designSize: const Size(720, 1280),
      orientation: Orientation.portrait,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        child: ListView(
          children: [
            Center(
              child: Text(
                widget.user!.email!,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            MyFormField(
              readOnly: !widget.isEditable!,
              textEditingController: _name,
              prefixIcon: const Icon(Icons.person),
              hintText: 'enter your name..',
            ),
            const SizedBox(
              height: 20,
            ),
            MyFormField(
              readOnly: !widget.isEditable!,
              textEditingController: _phoneNumber,
              prefixIcon: const Icon(Icons.phone),
              hintText: 'enter your phone no..',
              keyboardType: TextInputType.phone,
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
                if (widget.isEditable!) {
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
                          if (widget.isEditable!) {
                            setState(() {
                              dropdownValue = newValue;
                              state.didChange(newValue);
                            });
                          }
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
                if (widget.isEditable!) {
                  context.read<MyProfileBloc>().add(
                        MyProfileSave(
                          userProfileModel: widget.user!.copyWith(
                            fullName: _name.text,
                            dob: _dob.text,
                            mobileNo: _phoneNumber.text,
                            gender: dropdownValue!.toUpperCase(),
                          ),
                        ),
                      );
                } else {
                  context.read<MyProfileBloc>().add(
                        MyProfileEdit(userProfileModel: widget.user),
                      );
                }
              },
              height: 130.w,
              width: size.width,
              text: Center(
                child: Text(
                  !widget.isEditable! ? 'Edit Profile' : 'Save Profile',
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
      ),
    );
  }
}
