// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/user_model.dart';
// import '../models/auth_response_model.dart';
//
// class FirebaseService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   // static final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   // Get current user
//   static User? get currentUser => _auth.currentUser;
//
//   // Sign in with email and password
//   static Future<AuthResponse> signInWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (credential.user != null) {
//         final userModel = await _getUserModel(credential.user!.uid);
//         if (userModel != null) {
//           await _updateLastLogin(credential.user!.uid);
//
//           // Set custom claims for role-based security
//           await _setUserClaims(credential.user!, userModel);
//
//           return AuthResponse.success(
//             user: userModel,
//             token: await credential.user!.getIdToken(true), // Force refresh to get new claims
//           );
//         } else {
//           return AuthResponse.failure('User profile not found. Please contact administrator.');
//         }
//       }
//
//       return AuthResponse.failure('Authentication failed');
//     } on FirebaseAuthException catch (e) {
//       return AuthResponse.failure(_getAuthErrorMessage(e.code));
//     } catch (e) {
//       return AuthResponse.failure('An unexpected error occurred: ${e.toString()}');
//     }
//   }
//
//   // Sign up with email and password
//   static Future<AuthResponse> signUpWithEmailPassword({
//     required String email,
//     required String password,
//     required String username,
//     String? displayName,
//     String role = 'field_staff',
//     String layer = 'Layer1',
//     String assignedCity = 'Pune',
//     List<String>? assignedWard,
//   }) async {
//     try {
//       // Check if user already exists in Firestore
//       final existingUser = await _checkUserExists(email, username);
//       if (existingUser) {
//         return AuthResponse.failure('User already exists with this email or username');
//       }
//
//       final UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (credential.user != null) {
//         final userModel = UserModel(
//           id: credential.user!.uid,
//           username: username,
//           email: email,
//           displayName: displayName ?? username,
//           role: role,
//           layer: layer,
//           assignedCity: assignedCity,
//           assignedWard: assignedWard ?? ['Ward 1'],
//           permissions: _getDefaultPermissions(role),
//           lastLogin: DateTime.now(),
//           isActive: true,
//         );
//
//         await _saveUserToFirestore(userModel);
//
//         // Set custom claims for the new user
//         await _setUserClaims(credential.user!, userModel);
//
//         return AuthResponse.success(
//           user: userModel,
//           token: await credential.user!.getIdToken(true),
//           message: 'Account created successfully',
//         );
//       }
//
//       return AuthResponse.failure('Account creation failed');
//     } on FirebaseAuthException catch (e) {
//       return AuthResponse.failure(_getAuthErrorMessage(e.code));
//     } catch (e) {
//       return AuthResponse.failure('Account creation failed: ${e.toString()}');
//     }
//   }
//
//   // Sign in with Google
//   static Future<AuthResponse> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return AuthResponse.failure('Google sign-in was cancelled');
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//
//       if (userCredential.user != null) {
//         final userModel = await _getOrCreateUserModel(userCredential.user!);
//         await _updateLastLogin(userCredential.user!.uid);
//
//         // Set custom claims
//         await _setUserClaims(userCredential.user!, userModel);
//
//         return AuthResponse.success(
//           user: userModel,
//           token: await userCredential.user!.getIdToken(true),
//         );
//       }
//
//       return AuthResponse.failure('Google authentication failed');
//     } catch (e) {
//       return AuthResponse.failure('Google sign-in failed: ${e.toString()}');
//     }
//   }
//
//   // Sign out
//   static Future<void> signOut() async {
//     await _auth.signOut();
//     // await _googleSignIn.signOut();
//   }
//
//   // Reset password
//   static Future<AuthResponse> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       return AuthResponse.success(message: 'Password reset email sent to $email');
//     } on FirebaseAuthException catch (e) {
//       return AuthResponse.failure(_getAuthErrorMessage(e.code));
//     } catch (e) {
//       return AuthResponse.failure('Failed to send password reset email: ${e.toString()}');
//     }
//   }
//
//   // Update user profile
//   static Future<AuthResponse> updateUserProfile({
//     required String userId,
//     String? displayName,
//     String? email,
//     String? phone,
//     List<String>? assignedWard,
//     bool? isActive,
//   }) async {
//     try {
//       final updateData = <String, dynamic>{};
//
//       if (displayName != null) updateData['displayName'] = displayName;
//       if (email != null) updateData['email'] = email;
//       if (phone != null) updateData['phone'] = phone;
//       if (assignedWard != null) updateData['assignedWard'] = assignedWard;
//       if (isActive != null) updateData['isActive'] = isActive;
//
//       updateData['updatedAt'] = FieldValue.serverTimestamp();
//
//       await _firestore.collection('users').doc(userId).update(updateData);
//
//       final updatedUser = await _getUserModel(userId);
//       return AuthResponse.success(
//         user: updatedUser,
//         message: 'Profile updated successfully',
//       );
//     } catch (e) {
//       return AuthResponse.failure('Failed to update profile: ${e.toString()}');
//     }
//   }
//
//   // Get user by ID
//   static Future<UserModel?> getUserById(String userId) async {
//     return await _getUserModel(userId);
//   }
//
//   // Get users by role
//   static Future<List<UserModel>> getUsersByRole(String role) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('role', isEqualTo: role)
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
//           .toList();
//     } catch (e) {
//       print('Error fetching users by role: $e');
//       return [];
//     }
//   }
//
//   // Get users by city and ward
//   static Future<List<UserModel>> getUsersByLocation({
//     required String city,
//     String? ward,
//   }) async {
//     try {
//       Query query = _firestore
//           .collection('users')
//           .where('assignedCity', isEqualTo: city)
//           .where('isActive', isEqualTo: true);
//
//       if (ward != null) {
//         query = query.where('assignedWard', arrayContains: ward);
//       }
//
//       final querySnapshot = await query.get();
//
//       return querySnapshot.docs
//           .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
//           .toList();
//     } catch (e) {
//       print('Error fetching users by location: $e');
//       return [];
//     }
//   }
//
//   // Check if user exists
//   static Future<bool> _checkUserExists(String email, String username) async {
//     try {
//       final emailQuery = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();
//
//       final usernameQuery = await _firestore
//           .collection('users')
//           .where('username', isEqualTo: username)
//           .limit(1)
//           .get();
//
//       return emailQuery.docs.isNotEmpty || usernameQuery.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking user existence: $e');
//       return false;
//     }
//   }
//
//   // Get user model from Firestore
//   static Future<UserModel?> _getUserModel(String uid) async {
//     try {
//       final doc = await _firestore.collection('users').doc(uid).get();
//       if (doc.exists && doc.data() != null) {
//         return UserModel.fromFirestore(doc.data()!, doc.id);
//       }
//       return null;
//     } catch (e) {
//       print('Error fetching user model: $e');
//       return null;
//     }
//   }
//
//   // Get or create user model for Google Sign-In
//   static Future<UserModel> _getOrCreateUserModel(User user) async {
//     UserModel? userModel = await _getUserModel(user.uid);
//
//     if (userModel == null) {
//       userModel = UserModel(
//         id: user.uid,
//         username: user.email?.split('@').first ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
//         email: user.email ?? '',
//         displayName: user.displayName ?? user.email?.split('@').first,
//         photoUrl: user.photoURL,
//         role: 'field_staff', // Default role for Google sign-in users
//         layer: 'Layer1',
//         assignedCity: 'Pune', // Default city
//         assignedWard: ['Ward 1'], // Default ward
//         permissions: _getDefaultPermissions('field_staff'),
//         lastLogin: DateTime.now(),
//         isActive: true,
//       );
//
//       await _saveUserToFirestore(userModel);
//     }
//
//     return userModel;
//   }
//
//   // Save user to Firestore
//   static Future<void> _saveUserToFirestore(UserModel user) async {
//     try {
//       final userData = user.toFirestore();
//       userData['createdAt'] = FieldValue.serverTimestamp();
//       userData['updatedAt'] = FieldValue.serverTimestamp();
//
//       await _firestore.collection('users').doc(user.id).set(userData);
//     } catch (e) {
//       print('Error saving user to Firestore: $e');
//       throw Exception('Failed to save user data');
//     }
//   }
//
//   // Update last login
//   static Future<void> _updateLastLogin(String uid) async {
//     try {
//       await _firestore.collection('users').doc(uid).update({
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error updating last login: $e');
//     }
//   }
//
//   // Set custom claims for user (for Firestore security rules)
//   static Future<void> _setUserClaims(User user, UserModel userModel) async {
//     try {
//       // Note: Custom claims can only be set from backend/cloud functions
//       // For now, we'll store this in the user document
//       // In production, you should use Firebase Cloud Functions to set custom claims
//
//       await _firestore.collection('users').doc(user.uid).update({
//         'customClaims': {
//           'role': userModel.role,
//           'layer': userModel.layer,
//           'assignedCity': userModel.assignedCity,
//           'assignedWard': userModel.assignedWard,
//         }
//       });
//     } catch (e) {
//       print('Error setting user claims: $e');
//     }
//   }
//
//   // Get default permissions based on role (aligned with Firebase schema)
//   static Map<String, dynamic> _getDefaultPermissions(String role) {
//     switch (role) {
//       case 'admin':
//         return {
//           'sterilization': {'create': true, 'read': true, 'update': true, 'delete': true},
//           'vaccination': {'create': true, 'read': true, 'update': true, 'delete': true},
//           'biteCases': {'create': true, 'read': true, 'update': true, 'delete': true},
//           'quarantine': {'create': true, 'read': true, 'update': true, 'delete': true},
//           'rabies': {'create': true, 'read': true, 'update': true, 'delete': true},
//           'education': {'create': true, 'read': true, 'update': true, 'delete': true},
//         };
//       case 'ngo_supervisor':
//         return {
//           'sterilization': {'create': false, 'read': true, 'update': true, 'delete': false},
//           'vaccination': {'create': true, 'read': true, 'update': true, 'delete': false},
//           'biteCases': {'create': true, 'read': true, 'update': true, 'delete': false},
//           'quarantine': {'create': true, 'read': true, 'update': true, 'delete': false},
//           'rabies': {'create': true, 'read': true, 'update': true, 'delete': false},
//           'education': {'create': true, 'read': true, 'update': true, 'delete': false},
//         };
//       case 'field_staff':
//         return {
//           'sterilization': {'create': true, 'read': true, 'update': false, 'delete': false},
//           'vaccination': {'create': true, 'read': true, 'update': true, 'delete': false},
//           'biteCases': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'quarantine': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'rabies': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'education': {'create': false, 'read': true, 'update': false, 'delete': false},
//         };
//       case 'municipal_readonly':
//         return {
//           'sterilization': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'vaccination': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'biteCases': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'quarantine': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'rabies': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'education': {'create': false, 'read': true, 'update': false, 'delete': false},
//         };
//       default:
//         return {
//           'sterilization': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'vaccination': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'biteCases': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'quarantine': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'rabies': {'create': false, 'read': true, 'update': false, 'delete': false},
//           'education': {'create': false, 'read': true, 'update': false, 'delete': false},
//         };
//     }
//   }
//
//   // Get auth error message
//   static String _getAuthErrorMessage(String code) {
//     switch (code) {
//       case 'user-not-found':
//         return 'No user found with this email address';
//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';
//       case 'email-already-in-use':
//         return 'This email address is already registered';
//       case 'weak-password':
//         return 'Password is too weak. Please choose a stronger password.';
//       case 'invalid-email':
//         return 'Please enter a valid email address';
//       case 'user-disabled':
//         return 'This account has been disabled. Please contact support.';
//       case 'too-many-requests':
//         return 'Too many failed attempts. Please try again later.';
//       case 'network-request-failed':
//         return 'Network error. Please check your internet connection.';
//       case 'invalid-credential':
//         return 'Invalid credentials. Please check your email and password.';
//       case 'account-exists-with-different-credential':
//         return 'An account with this email already exists with different sign-in method.';
//       case 'requires-recent-login':
//         return 'This operation requires recent authentication. Please sign in again.';
//       default:
//         return 'Authentication failed. Please try again.';
//     }
//   }
//
//   // Utility method to check if user has specific permission
//   static Future<bool> checkUserPermission(String userId, String module, String action) async {
//     try {
//       final userModel = await _getUserModel(userId);
//       if (userModel != null) {
//         return userModel.hasPermission(module, action);
//       }
//       return false;
//     } catch (e) {
//       print('Error checking user permission: $e');
//       return false;
//     }
//   }
//
//   // Delete user account (admin only)
//   static Future<AuthResponse> deleteUserAccount(String userId) async {
//     try {
//       // Soft delete - mark as inactive
//       await _firestore.collection('users').doc(userId).update({
//         'isActive': false,
//         'deletedAt': FieldValue.serverTimestamp(),
//       });
//
//       return AuthResponse.success(message: 'User account deactivated successfully');
//     } catch (e) {
//       return AuthResponse.failure('Failed to delete user account: ${e.toString()}');
//     }
//   }
//
//   // Reactivate user account (admin only)
//   static Future<AuthResponse> reactivateUserAccount(String userId) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'isActive': true,
//         'reactivatedAt': FieldValue.serverTimestamp(),
//       });
//
//       return AuthResponse.success(message: 'User account reactivated successfully');
//     } catch (e) {
//       return AuthResponse.failure('Failed to reactivate user account: ${e.toString()}');
//     }
//   }
//
//   // Get all cities
//   static Future<List<Map<String, dynamic>>> getCities() async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('cities')
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => {'id': doc.id, ...doc.data()})
//           .toList();
//     } catch (e) {
//       print('Error fetching cities: $e');
//       return [];
//     }
//   }
//
//   // Get hospitals by city
//   static Future<List<Map<String, dynamic>>> getHospitalsByCity(String city) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('hospitals')
//           .where('city', isEqualTo: city)
//           .where('isActive', isEqualTo: true)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => {'id': doc.id, ...doc.data()})
//           .toList();
//     } catch (e) {
//       print('Error fetching hospitals: $e');
//       return [];
//     }
//   }
// }
