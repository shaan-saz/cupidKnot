import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  MyProfileBloc({UserRepository? userRepository})
      : _userRepository = userRepository,
        super(MyProfileInitial());

  final UserRepository? _userRepository;

  Stream<MyProfileState> mapEventToState(
    MyProfileEvent event,
  ) async* {
    final currentState = state;

    if (currentState is MyProfileFailure) {
      yield MyProfileInitial();
    }
    if (event is MyProfileFetch) {
      yield MyProfileLoading();
      try {
        final response = await _userRepository!.getUser();
        yield MyProfileLoaded(userProfileModel: response);
      } catch (e) {
        yield MyProfileFailure(msg: e.toString());
      }
    }
    if (event is MyProfileEdit) {
      yield MyProfileEditing(userProfileModel: event.userProfileModel);
    }
    if (event is MyProfileSave) {
      yield MyProfileLoading();

      await _userRepository!.updateProfile(profile: event.userProfileModel!);
      final response = await _userRepository!.getUser();
      yield MyProfileLoaded(userProfileModel: response);
    }
  }
}
