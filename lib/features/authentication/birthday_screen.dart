import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BirthdayScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime today = DateTime.now();
  // DateTime initialDate = DateTime.now().add(const Duration(days: -4380));
  late DateTime initialDate = DateTime(today.year - 12, today.month, today.day);

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    ref.read(signUpProvider.notifier).signUp(context);
    // context.pushReplacementNamed(InterestsScreen.routeName);
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
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
                    "Wnen is your birthday?",
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v8,
                  const Text(
                    "Your Birthday won't be shown publictly.",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.black54,
                    ),
                  ),
                  Gaps.v16,
                  TextField(
                    enabled: false,
                    controller: _birthdayController,
                    cursorColor: Theme.of(context).primaryColor,
                    onEditingComplete: _onNextTap,
                    decoration: InputDecoration(
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
                  Gaps.v16,
                  GestureDetector(
                    onTap: _onNextTap,
                    child: FormButton(
                      disabled: ref.watch(signUpProvider).isLoading,
                      formText: "Next",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          height: 300,
          child: CupertinoDatePicker(
            initialDateTime: initialDate,
            maximumDate: initialDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: _setTextFieldDate,
          ),
        ),
      ),
    );
  }
}
