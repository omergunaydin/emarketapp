part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserSignIn extends UserState {
  final MyUser user;
  UserSignIn({required this.user});
}

class UserSignInFailed extends UserState {}

class UserSignOut extends UserState {}

class UserDataChanged extends UserState {
  final MyUser user;
  UserDataChanged({required this.user});
}
