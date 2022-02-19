import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        .then((QuerySnapshot querySnapshot) async {
      posts.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

        var likes = await FirebaseFirestore.instance
            .collection("posts")
            .doc(json["postId"])
            .collection("likes")
            .get();

        Post post = Post.fromJson(json);
        post.likesCount = likes.docs.length;

        for (var element in likes.docs) {
          if (element.data()["userId"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            post.isLiked = true;
          }
          else{
            post.isLiked = false;
          }
        }

        posts.add(post);
      }

      emit(PostsGetSuccessState());
    });
  }

  // void likeUnLikePost(Post post) {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   FirebaseFirestore.instance
  //       .collection("posts")
  //       .doc(post.postId)
  //       .collection("likes")
  //       .doc(uid)
  //       .get()
  //       .then(
  //     (value) {
  //       if (value.data() == null) {
  //         _likePost(post.postId);
  //       } else {
  //         _unLikePost(post.postId);
  //       }
  //     },
  //   );
  // }

  void likePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .set({"userId": uid});

    emit(LikePostSuccessState());
  }

  void unLikePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .delete();

    emit(UnLikePostSuccessState());
  }
}
