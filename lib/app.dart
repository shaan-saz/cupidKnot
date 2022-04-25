import 'package:cupid_test/constants/text.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:cupid_test/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:cupid_test/presentation/home/home_screen.dart';
import 'package:cupid_test/presentation/login/login_screen.dart';
import 'package:cupid_test/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    AuthenticationRepository? authenticationRepository,
    UserRepository? userRepository,
    ContactRepository? contactRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _contactRepository = contactRepository,
        super(key: key);

  final AuthenticationRepository? _authenticationRepository;
  final UserRepository? _userRepository;
  final ContactRepository? _contactRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _userRepository,
        ),
        RepositoryProvider.value(
          value: _contactRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const MyAppView(),
      ),
    );
  }
}

class MyAppView extends StatefulWidget {
  const MyAppView({Key? key}) : super(key: key);

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: BaseText.appName,
      theme: ThemeData(
        fontFamily: BaseText.fProductSans,
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator!.pushAndRemoveUntil<void>(
                  HomeScreen.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator!.pushAndRemoveUntil<void>(
                  LoginScreen.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}
