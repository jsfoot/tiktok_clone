import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/views/username_screen.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

import 'login_screen.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeURL = "/";
  static const routeName = "signup";

  const SignUpScreen({Key? key}) : super(key: key);

  void _onLogInTap(BuildContext context) async {
    context.pushNamed(LogInScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsernameScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.lg,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size40,
                  ),
                  child: Column(
                    children: [
                      Gaps.v80,
                      const Text(
                        "Sign Up for TikTok",
                        // S.of(context).signUpTitle("TikTok", DateTime.now()),
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gaps.v20,
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          S.of(context).signUpSubtitle(2),
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.v40,
                      if (orientation == Orientation.portrait) ...[
                        GestureDetector(
                          onTap: () => _onEmailTap(context),
                          child: const AuthButton(
                            icon: FaIcon(FontAwesomeIcons.user),
                            // text: S.of(context).emailPasswordButton,
                            text: "Use email & password",
                          ),
                        ),
                        Gaps.v16,
                        GestureDetector(
                          onTap: () => ref.read(socailAuthProvider.notifier).githubSignIn(context),
                          child: const AuthButton(
                            icon: FaIcon(FontAwesomeIcons.github),
                            text: "Continue with Github",
                          ),
                        ),
                      ],
                      if (orientation == Orientation.landscape)
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onEmailTap(context),
                                child: AuthButton(
                                  icon: const FaIcon(FontAwesomeIcons.user),
                                  text: S.of(context).emailPasswordButton,
                                ),
                              ),
                            ),
                            Gaps.h16,
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    ref.read(socailAuthProvider.notifier).githubSignIn(context),
                                child: const AuthButton(
                                  icon: FaIcon(FontAwesomeIcons.github),
                                  text: "Continue with Github",
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).alreadyHaveAnAccount),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLogInTap(context),
                    child: Text(
                      // S.of(context).logIn("female"),
                      "Log In",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
