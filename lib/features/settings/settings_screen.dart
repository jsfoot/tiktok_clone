import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(Localizations.localeOf(context));
    return Localizations.override(
      context: context,
      locale: const Locale("ko"),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.md,
            ),
            child: ListView(
              children: [
                SwitchListTile.adaptive(
                  value: context.watch<PlaybackConfigViewModel>().muted,
                  onChanged: (value) => context.read<PlaybackConfigViewModel>().setMuted(value),
                  title: const Text("Mute video"),
                  subtitle: const Text("Video will be muted by default."),
                ),
                SwitchListTile.adaptive(
                  value: context.watch<PlaybackConfigViewModel>().autoPlay,
                  onChanged: (value) => context.read<PlaybackConfigViewModel>().setAutoPlay(value),
                  title: const Text("Autoplay"),
                  subtitle: const Text("Video will start playing automatically."),
                ),
                ListTile(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1980),
                      lastDate: DateTime(2030),
                    );
                    if (kDebugMode) {
                      print(date);
                    }
                    if (!mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (kDebugMode) {
                      print(time);
                    }
                    if (!mounted) return;
                    final booking = await showDateRangePicker(
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            appBarTheme: const AppBarTheme(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      firstDate: DateTime(1980),
                      lastDate: DateTime(2030),
                    );
                    if (kDebugMode) {
                      print(booking);
                    }
                  },
                  title: const Text(
                    "What is your birthday?",
                  ),
                ),
                CheckboxListTile(
                  title: const Text("Enable notifications"),
                  checkColor: Colors.white,
                  activeColor: Colors.black,
                  value: _notifications,
                  onChanged: _onNotificationsChanged,
                ),
                SwitchListTile.adaptive(
                  title: const Text("Enable notifications"),
                  subtitle: const Text("Enable notifications"),
                  value: _notifications,
                  onChanged: _onNotificationsChanged,
                ),
                const AboutListTile(),
                ListTile(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("Please don't go"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Yes"),
                          ),
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            isDestructiveAction: true,
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  title: const Text(
                    "Log out (iOS)",
                  ),
                  textColor: Colors.red,
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: const FaIcon(FontAwesomeIcons.skull),
                        title: const Text("Are you sure?"),
                        content: const Text("Please don't go"),
                        actions: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const FaIcon(
                              FontAwesomeIcons.car,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  title: const Text(
                    "Log out (Android)",
                  ),
                  textColor: Colors.red,
                ),
                ListTile(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text("Are you sure?"),
                        message: const Text("Plz dooont go away~!"),
                        actions: [
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () {},
                            child: const Text("Yes!!"),
                          ),
                          CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {},
                            child: const Text("Not log out"),
                          ),
                        ],
                      ),
                    );
                  },
                  title: const Text(
                    "Log out (iOS / Bottom)",
                  ),
                  textColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
