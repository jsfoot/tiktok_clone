import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/breakpoints.dart';
import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../authentication/views/widgets/form_button.dart';
import '../view_models/update_profile_view_model.dart';
import '../view_models/users_view_model.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onUpdateTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(UpdateProfileProvider.notifier).updateProfile(formData['bio']!, formData['link']!);
      }
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bio = ref.read(usersProvider).value!.bio;
    final link = ref.read(usersProvider).value!.link;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update profile'),
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
                    initialValue: bio,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Input your bio',
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        formData['bio'] = newValue;
                      }
                    },
                  ),
                  Gaps.v28,
                  TextFormField(
                    initialValue: link,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Input your link',
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        formData['link'] = newValue;
                      }
                    },
                  ),
                  Gaps.v16,
                  GestureDetector(
                    onTap: _onUpdateTap,
                    child: const FormButton(
                      formText: "Update",
                      disabled: false,
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
