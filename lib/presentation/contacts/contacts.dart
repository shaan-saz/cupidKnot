import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:cupid_test/presentation/add_contact/add_contact.dart';
import 'package:cupid_test/presentation/authentication/authentication.dart';
import 'package:cupid_test/presentation/contacts/cubit/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  static Widget route() {
    return Builder(
      builder: (context) {
        final user = context.select<AuthenticationBloc, Profile>(
          (AuthenticationBloc bloc) => bloc.state.user,
        );
        return BlocProvider(
          create: (context) => ContactsCubit(
            contactRepository: context.read<ContactRepository>(),
          )..fetchContacts(email: user.email),
          child: const ContactList(),
        );
      },
    );
  }

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContactsLoaded) {
            if (state.contacts.isEmpty) {
              return const Center(
                child: Text('No contacts found'),
              );
            } else {
              return ListView.builder(
                key: Key('${state.contacts.length}'),
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.contacts[index].name!),
                    subtitle: Text(state.contacts[index].email!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        print(state.contacts[index].documentID);
                        context.read<ContactsCubit>().deleteContact(
                              documentId: state.contacts[index].documentID,
                              email: user.email,
                            );
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            AddContact.route(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
