import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/login_view_model.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(loginProvider.notifier).login(
              formData["email"]!,
              formData["password"]!,
              context,
            );
      }
    }
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        final regEx = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        String? email = value;
                        if (value != null && value.isEmpty) {
                          return "Please write your email.";
                        } else if (!regEx.hasMatch(email!)) {
                          return "Please input right email.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData['email'] = newValue;
                        }
                      },
                    ),
                    Gaps.v28,
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please write your password.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData['password'] = newValue;
                        }
                      },
                    ),
                    Gaps.v16,
                    GestureDetector(
                      onTap: _onSubmitTap,
                      child: FormButton(
                        disabled: ref.watch(loginProvider).isLoading,
                        formText: "Log in",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
