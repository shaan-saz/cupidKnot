import 'package:cupid_test/constants/color.dart';
import 'package:cupid_test/constants/widgets/confirm_button.dart';
import 'package:cupid_test/constants/widgets/my_form_field.dart';
import 'package:cupid_test/data/models/contact.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:cupid_test/presentation/add_contact/cubit/add_contact_cubit.dart';
import 'package:cupid_test/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => AddContactCubit(
          contactRepository: context.read<ContactRepository>(),
        ),
        child: const AddContact(),
      ),
    );
  }

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = context.select<AuthenticationBloc, String?>(
      (AuthenticationBloc bloc) => bloc.state.user.email,
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              MyFormField(
                textEditingController: _name,
                keyboardType: TextInputType.name,
                hintText: 'enter your full name..',
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 30,
              ),
              MyFormField(
                textEditingController: _number,
                keyboardType: TextInputType.phone,
                hintText: 'enter your mobile no..',
                prefixIcon: const Icon(Icons.dialpad),
              ),
              const SizedBox(
                height: 30,
              ),
              MyFormField(
                textEditingController: _email,
                keyboardType: TextInputType.emailAddress,
                hintText: 'enter your email address..',
                prefixIcon: const Icon(Icons.mail),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocListener<AddContactCubit, AddContactState>(
                listener: (context, state) {
                  if (state is AddContactSuccess) {
                    Navigator.of(context).pop();
                  }
                },
                child: BlocBuilder<AddContactCubit, AddContactState>(
                  builder: (context, state) {
                    if (state is AddContactLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is AddContactSuccess) {
                      return const Center(
                        child: Text('Contact added successfully'),
                      );
                    } else if (state is AddContactFailure) {
                      return const Center(
                        child: Text('Failed to add contact'),
                      );
                    } else {
                      return ConfirmButton(
                        onTap: () async {
                          if (_name.text.isEmpty ||
                              _number.text.isEmpty ||
                              _email.text.isEmpty) {
                            return;
                          } else {
                            await context.read<AddContactCubit>().saveContact(
                                  contact: Contact(
                                    name: _name.text,
                                    email: _email.text,
                                    contact: _number.text,
                                  ),
                                  email: email,
                                );
                          }
                        },
                        height: 50,
                        width: size.width,
                        text: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: BaseColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
