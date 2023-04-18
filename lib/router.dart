import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

import 'features/authentication/views/login_screen.dart';
import 'features/authentication/views/sign_up_screen.dart';
import 'features/inbox/views/activity_screen.dart';
import 'features/inbox/views/chat_detail_screen.dart';
import 'features/inbox/views/chat_user_list_screen.dart';
import 'features/inbox/views/chats_screen.dart';
import 'features/notifications/notifications_provider.dart';
import 'features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);
  return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL && state.subloc != LogInScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            ref.read(notificationsProvider(context));
            return child;
          },
          routes: [
            GoRoute(
              name: SignUpScreen.routeName,
              path: SignUpScreen.routeURL,
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              name: LogInScreen.routeName,
              path: LogInScreen.routeURL,
              builder: (context, state) => const LogInScreen(),
            ),
            GoRoute(
              name: InterestsScreen.routeName,
              path: InterestsScreen.routeURL,
              builder: (context, state) => const InterestsScreen(),
            ),
            GoRoute(
              path: "/:tab(home|discover|inbox|profile)",
              name: MainNavigationScreen.routeName,
              builder: (context, state) {
                final tab = state.params["tab"]!;
                return MainNavigationScreen(tab: tab);
              },
            ),
            GoRoute(
              name: ActivityScreen.routeName,
              path: ActivityScreen.routeURL,
              builder: (context, state) => const ActivityScreen(),
            ),
            GoRoute(
              name: ChatsScreen.routeName,
              path: ChatsScreen.routeURL,
              builder: (context, state) => const ChatsScreen(),
            ),
            GoRoute(
              path: ChatDetailScreen.routeURL,
              name: ChatDetailScreen.routeName,
              builder: (context, state) {
                final extra = state.extra as Map;
                return ChatDetailScreen(
                  chatRoomId: extra['chatRoomId'],
                  yourUid: extra['yourUid'],
                );
              },
            ),
            GoRoute(
              path: ChatUserListScreen.routeURL,
              name: ChatUserListScreen.routeName,
              builder: (context, state) => const ChatUserListScreen(),
            ),
            GoRoute(
              path: VideoRecordingScreen.routeURL,
              name: VideoRecordingScreen.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 200),
                child: const VideoRecordingScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final position = Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ]);
});
