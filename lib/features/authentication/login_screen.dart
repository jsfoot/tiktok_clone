import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/features/authentication/widgets/login_form_screen.dart';
import 'package:tiktok_clone/utils.dart';

class LogInScreen extends StatelessWidget {
  static String routeName = "/login";

  const LogInScreen({Key? key}) : super(key: key);

  void _onSignUpTap(BuildContext context) {
    context.pop();
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
                  child: Column(
                    children: [
                      Gaps.v80,
                      const Text(
                        "Log in for TikTok",
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gaps.v20,
                      const Opacity(
                        opacity: 0.7,
                        child: Text(
                          "Manage your account, check notifications, comment on videos, and more.",
                          style: TextStyle(
                            fontSize: Sizes.size16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.v40,
                      if (orientation == Orientation.portrait) ...[
                        GestureDetector(
                          onTap: () => _onEmailLoginTap(context),
                          child: const AuthButton(
                            icon: FaIcon(FontAwesomeIcons.user),
                            text: "Use email & password",
                          ),
                        ),
                        Gaps.v16,
                        const AuthButton(
                          icon: FaIcon(FontAwesomeIcons.apple),
                          text: "Continue with Apple",
                        ),
                      ],
                      if (orientation == Orientation.landscape)
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onEmailLoginTap(context),
                                child: const AuthButton(
                                  icon: FaIcon(FontAwesomeIcons.user),
                                  text: "Use email & password",
                                ),
                              ),
                            ),
                            Gaps.h16,
                            const Expanded(
                              child: AuthButton(
                                icon: FaIcon(FontAwesomeIcons.apple),
                                text: "Continue with Apple",
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
                  const Text(
                    "Don't have an account?",
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onSignUpTap(context),
                    child: Text(
                      "Sign up",
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
