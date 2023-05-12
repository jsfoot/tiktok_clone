import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class UpdateProfileViewModel extends AsyncNotifier<void> {
  // ignore: unused_field
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> updateProfile(String bio, String link) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(usersProvider.notifier).onProfileUpdate(bio, link);
    });
  }
}

final UpdateProfileProvider = AsyncNotifierProvider<UpdateProfileViewModel, void>(
  () => UpdateProfileViewModel(),
);
