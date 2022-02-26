part of 'users_cubit.dart';

@immutable
abstract class UsersStates {}

class UsersInitialState extends UsersStates {}

class GetUsersSuccessState extends UsersStates {}

class GetUsersFailureState extends UsersStates {
  final String errorMessage;

  GetUsersFailureState(this.errorMessage);
}
