part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitialState extends PostsState {}

class PostsGetSuccessState extends PostsState {}

class PostsGetFailureState extends PostsState {}
