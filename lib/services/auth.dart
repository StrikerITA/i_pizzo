import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:iPizzo/utils/colors.dart';
import 'package:iPizzo/utils/user.dart';

class Authentication {
  User? currentUser;
  String msg = '';

  @override
  String get email => currentUser?.email ?? (throw const UserNotFoundException('User has not been retrieved yet'));

  Future<void> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      if (result.isSignedIn) {
        navigatorKey.currentState!.pushNamed("/home");
      }
      safePrint('User is signed in: ${result.isSignedIn}');
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      final res = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: email,
          },
        ),
      );
    } on AuthException catch (e) {
      switch (e) {
        case UsernameExistsException _:
          msg = 'Username already exist: ${e.message}';
        case InvalidParameterException _:
          msg = 'Invalid parameter: ${e.message}';
        case _:
          msg = 'An unknown error occurred: ${e.message}';
      }
    }
    return msg;
  }

  Future<String?> confirmUser(String email, String confirmationCode) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      safePrint(res);
      if (res.isSignUpComplete && res.nextStep.signUpStep == AuthSignUpStep.done) {
        navigatorKey.currentState!.pushNamed("/home");
      }
    } on AuthException catch (e) {
      safePrint('Error signin out: ${e.message}');
      rethrow;
    }
  }

  Future<String> resendCode(String email) async {
    try {
      final res = await Amplify.Auth.resendSignUpCode(username: email);
      final codeDeliveryDetails = res.codeDeliveryDetails;
      msg = 'A confirmation code has been sent to ${codeDeliveryDetails.destination}. \nPlease check your ${codeDeliveryDetails.deliveryMedium.name} for the code.';
    } on AuthException catch (e) {
      msg = 'Error resending code: ${e.message}';
    }
    return msg;
  }

  Future<String?> logIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      safePrint(result);
      if (!result.isSignedIn && result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        throw const UserNotConfirmedException('User not confirmed');
      }

      if (result.isSignedIn && result.nextStep.signInStep == AuthSignInStep.done) {
        navigatorKey.currentState!.pushNamed("/home");
      }
      await generateCurrentUserInformation();
    } on AuthException catch (e) {
      //don't remove the return (null exception) don't need a rethrow here
      switch (e) {
        case UserNotFoundException _:
          msg = 'User does not exist: ${e.message}';
        case UserNotConfirmedException _:
          msg = 'User is not confirmed exception: ${e.message}';
        case InvalidStateException _:
          msg = 'A user is already signed in. \nPress again if you want to logout from another device.';
          signOut();
        case _:
          msg = 'An unknown error occurred: ${e.message}';
      }
    }
    return msg;
  }

  Future<void> generateCurrentUserInformation() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      currentUser = User(id: user.userId, email: userAttributes.firstWhere((element) => element.userAttributeKey == CognitoUserAttributeKey.email).value);
    } on AuthException catch (e) {
      safePrint('Error fetching auth session: ${e.message}');
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );
      if (result.isSignedIn) {
        await generateCurrentUserInformation();
      }
      return result.isSignedIn;
    } on AuthException catch (e) {
      safePrint('Error fetching auth session: ${e.message}');
      rethrow;
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: email);
      return result.isPasswordReset.toString();
    } on AuthException catch (e) {
      switch (e) {
        case NetworkException _:
          msg = 'Network error happened: ${e.message}';
        case UserNotFoundException _:
          msg = 'User does not exist: ${e.message}';
        case _:
          msg = 'An unknown error occurred: ${e.message}';
      }
      return msg;
    }
  }

  Future<void> confirmPasswordReset(String email, String newPassword, String confirmationCode) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      safePrint('Password reset complete: ${result.isPasswordReset}');
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint('Error signing out: ${e.message}');
      rethrow;
    }
  }
}
