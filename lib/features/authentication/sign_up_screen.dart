import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static String routeURL = "/";
  static const routeName = "signUp";

  const SignUpScreen({Key? key}) : super(key: key);

  void _onLogInTap(BuildContext context) async {
    context.push(LogInScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(milliseconds: 1000),
    //     reverseTransitionDuration: const Duration(milliseconds: 1000),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       final offsetAnimation = Tween(
    //         begin: const Offset(0, -1),
    //         end: Offset.zero,
    //       ).animate(animation);
    //       final opacityAnimation = Tween(
    //         begin: 0.5,
    //         end: 0.8,
    //       ).animate(animation);
    //       return SlideTransition(
    //         position: offsetAnimation,
    //         child: FadeTransition(
    //           opacity: opacityAnimation,
    //           child: child,
    //         ),
    //       );
    //     },
    //     pageBuilder: (context, animation, secondaryAnimaion) => const UsernameScreen(),
    //   ),
    // );
    context.pushNamed(UsernameScreen.routeName);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size40,
                  ),
                  child: Column(
                    children: [
                      Gaps.v80,
                      Text(
                        S.of(context).signUpTitle("TikTok", DateTime.now()),
                        style: const TextStyle(
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
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.user),
                            text: S.of(context).emailPasswordButton,
                          ),
                        ),
                        Gaps.v16,
                        AuthButton(
                          icon: const FaIcon(FontAwesomeIcons.apple),
                          text: S.of(context).appleButton,
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
                              child: AuthButton(
                                icon: const FaIcon(FontAwesomeIcons.apple),
                                text: S.of(context).appleButton,
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
                      S.of(context).logIn("female"),
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
