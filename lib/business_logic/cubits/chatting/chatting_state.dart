part of 'chatting_cubit.dart';

@immutable
abstract class ChattingStates {}

class ChattingInitialState extends ChattingStates {}

class SendMessageSuccessState extends ChattingStates {}

class SendMessageFailureState extends ChattingStates {
  final String errorMessage;

  SendMessageFailureState(this.errorMessage);
}

class GetMessagesSuccessState extends ChattingStates {}

class GetMessagesFailureState extends ChattingStates {
  final String errorMessage;

  GetMessagesFailureState(this.errorMessage);
}
