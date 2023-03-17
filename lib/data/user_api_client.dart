import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import '../models/myuser.dart';

class UserApiClient {
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection('users');

  Future addUserToDatabase(MyUser user) async {
    final docUser = _usersRef.doc(user.id);
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json).then((value) => debugPrint('New User added!')).catchError((error) => debugPrint('Error!!!'));
  }

  Future<MyUser?> fetchUserData(String id) async {
    final docUser = _usersRef.doc(id);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return MyUser.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserData(MyUser user) async {
    final docUser = _usersRef.doc(user.id);
    docUser.update({
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'userAgreement': user.userAgreement,
      'offers': user.offers,
    });
  }

  Future<void> updateUserData2(MyUser user) async {
    final docUser = _usersRef.doc(user.id);
    final updatedData = user.toJson();
    docUser.update(updatedData);
  }

  addFavToUser(String id, Fav fav) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.fav ??= [];
    myUser.fav!.add(fav);
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'favs': updatedData['favs']});
  }

  deleteFavFromUser(String id, int index) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.fav ??= [];
    myUser.fav!.removeAt(index);
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'favs': updatedData['favs']});
  }

  updateProductsOnUserCart(String id, List<CartItem> cartItems) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.cart = cartItems;
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'cart': updatedData['cart']});
  }

  updateProductOnUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];
    for (int i = 0; i < myUser.cart!.length; i++) {
      if (cartItem.id == myUser.cart![i].id) {
        myUser.cart![i] = cartItem;
        print('updated!!!');
      }
    }
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'cart': updatedData['cart']});
  }

  addProductToUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];
    myUser.cart!.add(cartItem);
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'cart': updatedData['cart']});
  }

  deleteProductFromUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final myUser = MyUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];
    //myUser.cart!.removeAt(index);
    for (int i = 0; i < myUser.cart!.length; i++) {
      if (cartItem.id == myUser.cart![i].id) {
        myUser.cart!.removeAt(i);
        print('deleted!!!');
      }
    }
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('users').doc(id).update({'cart': updatedData['cart']});
  }
}
