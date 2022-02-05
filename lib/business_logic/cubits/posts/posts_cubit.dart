import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirecourse/data/models/post.dart';
import 'package:meta/meta.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitialState());

  List<Post> posts = [];

  void getPosts() {
    print('Posts => ${posts.length}');

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      posts.clear();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
        Post post = Post.fromJson(json);
        posts.add(post);
      });

      emit(PostsGetSuccessState());
      print('Posts => ${posts.length}');
    });
  }
}
