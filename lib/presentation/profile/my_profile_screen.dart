import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:cupid_test/presentation/profile/bloc/profile_bloc.dart';
import 'package:cupid_test/presentation/profile/profile_loading.dart';
import 'package:cupid_test/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  static Widget route() {
    return BlocProvider(
      create: (context) => MyProfileBloc(
        userRepository: context.read<UserRepository>(),
      )..add(MyProfileFetch()),
      child: const MyProfileScreen(),
    );
  }

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MyProfileBloc, MyProfileState>(
        listener: (context, state) {
          if (state is MyProfileFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.msg),
                ),
              );
          }
        },
        builder: (context, state) {
          print(state);
          if (state is MyProfileLoading) {
            return const ProfileScreenLoading();
          }
          if (state is MyProfileFailure) {
            return Center(
              child: Text(state.msg),
            );
          }
          if (state is MyProfileLoaded) {
            return ProfileScreen(
              user: state.userProfileModel,
              isEditable: false,
            );
          }
          if (state is MyProfileEditing) {
            return ProfileScreen(
              user: state.userProfileModel,
              isEditable: true,
            );
          }
          return Container();
        },
      ),
    );
  }
}
