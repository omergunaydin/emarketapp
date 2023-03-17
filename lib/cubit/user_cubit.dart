import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/user_api_client.dart';
import '../models/myuser.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final MyUser? user;
  StreamSubscription? streamUser;
  StreamSubscription? streamUserData;

  UserCubit({this.user}) : super(UserInitial()) {
    debugPrint('UserCubit started!');
    streamUser = FirebaseAuth.instance.authStateChanges().listen((user) async {
      debugPrint('usercubit ${user.toString()}');

      if (user != null) {
        debugPrint('user signed in');
        MyUser? myUser = await UserApiClient().fetchUserData(user.uid);
        if (myUser != null) {
          emit(UserSignIn(user: myUser));
        } else {
          /*emit(UserSignOut());
          FirebaseAuth.instance.signOut();*/
        }

        streamUserData = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((event) async {
          //print('streamUserData $event');
          if (event.data() != null) {
            MyUser? myUser = MyUser.fromJson(event.data() as Map<String, dynamic>);
            emit(UserDataChanged(user: myUser));
            emit(UserSignIn(user: myUser));
          }
        });
      } else if (user == null) {
        debugPrint('user signed out');
        emit(UserSignOut());
      }
    });
  }
}
