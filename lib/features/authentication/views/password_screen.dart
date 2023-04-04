import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

import 'birthday_screen.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  String _password = "";

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid() {
    return _password.isNotEmpty && _password.length > 8;
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (!_isPasswordValid()) return;

    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {...state, "password": _password};

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign up",
          ),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.lg,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v40,
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v16,
                  TextField(
                    controller: _passwordController,
                    onEditingComplete: _onSubmit,
                    obscureText: _obscureText,
                    autocorrect: false,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _onClearTap,
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h16,
                          GestureDetector(
                            onTap: _toggleObscureText,
                            child: FaIcon(
                              _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      hintText: "Make Strong!",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "Your password must have :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: Sizes.size20,
                        color: _isPasswordValid() ? Colors.green : Colors.grey.shade400,
                      ),
                      Gaps.h5,
                      const Text("8 to 20 Characters"),
                    ],
                  ),
                  Gaps.v28,
                  GestureDetector(
                    onTap: _onSubmit,
                    child: FormButton(
                      disabled: !_isPasswordValid(),
                      formText: "Next",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
