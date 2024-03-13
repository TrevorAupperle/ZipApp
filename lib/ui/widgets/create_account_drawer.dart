import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zipapp/business/auth.dart';
import 'package:zipapp/business/validator.dart';

import 'package:zipapp/constants/zip_colors.dart';
import 'package:zipapp/models/user.dart';
import 'package:zipapp/ui/widgets/authentication_drawer_widgets.dart';
import 'package:zipapp/ui/widgets/custom_flat_button.dart';

class CreateAccountDrawer extends StatefulWidget {
  final Function closeDrawer;
  final Function switchDrawers;
  const CreateAccountDrawer(
      {super.key, required this.closeDrawer, required this.switchDrawers});

  @override
  State<CreateAccountDrawer> createState() => _CreateAccountDrawerState();
}

class _CreateAccountDrawerState extends State<CreateAccountDrawer> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthenticationDrawerWidgets adw = AuthenticationDrawerWidgets();

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy > 200) {
          widget.closeDrawer.call();
        }
      },
      child: Container(
          alignment: Alignment.topCenter,
          width: width,
          height: 703,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32)),
          ),
          child: SizedBox(
            width: width - 96,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                Center(child: adw.draggableIcon()),
                const SizedBox(height: 16),
                const Center(
                    child: Text('Create an account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ))),
                const SizedBox(height: 26),
                adw.promptTextLabel('First name'),
                adw.inputTextField(
                    _firstNameController, false, Validator.validateName),
                adw.promptTextLabel('Last name'),
                adw.inputTextField(
                    _lastNameController, false, Validator.validateName),
                adw.promptTextLabel('Email'),
                adw.inputTextField(
                    _emailController, false, Validator.validateEmail),
                adw.promptTextLabel('Phone'),
                adw.inputTextField(
                    _phoneController, false, Validator.validateNumber),
                adw.promptTextLabel('Password'),
                adw.inputTextField(
                    _passwordController, true, Validator.validatePassword),
                Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 53.0),
                    child: CustomTextButton(
                        title: 'Sign up',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        onPressed: () => _signUp(
                            firstname: _firstNameController.text,
                            lastname: _lastNameController.text,
                            number: _phoneController.text,
                            email: _emailController.text,
                            password: _passwordController.text),
                        color: ZipColors.zipYellow)),
                // Positioned(bottom: 32, child: _buildSignInButton())
                _buildSignInButton(),
                const SizedBox(height: 33)
              ],
            ),
          )),
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
        onTap: () {
          widget.switchDrawers.call();
        },
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already have an account? Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Icon(Icons.arrow_forward, color: Colors.black, size: 12),
            ]));
  }

  void _signUp({
    required String firstname,
    required String lastname,
    required String number,
    required String email,
    required String password,
  }) async {
    /// Test to see if the user has entered valid information
    if (Validator.validateName(firstname) &&
        Validator.validateName(lastname) &&
        Validator.validateEmail(email) &&
        Validator.validateNumber(number) &&
        Validator.validatePassword(password)) {
      try {
        /// Hides native keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await auth.signUp(email, password).then((uid) {
          auth.addUser(User(
            uid: uid,
            email: email,
            firstName: firstname,
            lastName: lastname,
            phone: number,
            profilePictureURL: '',
            lastActivity: DateTime.now(),
            pastRides: [],
            pastDrives: [],
          ));
        });
      } catch (e) {
        String exception = auth.getExceptionText(e as PlatformException);
        print('The error is $exception');
      }
    }
  }
}
