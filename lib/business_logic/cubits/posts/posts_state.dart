part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitialState extends PostsState {}

class PostsGetSuccessState extends PostsState {}

class PostsGetFailureState extends PostsState {}

class LikePostSuccessState extends PostsState {}

class UnLikePostSuccessState extends PostsState {}
