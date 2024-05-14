import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';
import 'package:watching/utils/hash_converter.dart';

class TileDivider extends StatelessWidget {
  const TileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseAuthRepository firebaseAuthRepository = FirebaseAuthRepository();
  SupabaseRepository supabaseRepository = SupabaseRepository();
  bool isPublicAccount = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    final int userId = customStringHash(firebaseAuthRepository.getUser()!.uid);
    Logger().i('User ID: $userId');
    final bool publicStatus =
        await supabaseRepository.checkUserSettingsInSupabase(
      userId: userId,
    );
    final String nickName = await supabaseRepository
        .checkUserSettingsNicknameInSupabase(userId: userId);
    if (!context.mounted) return;
    setState(() {
      _controller.text = nickName;
      isPublicAccount = publicStatus;
    });
  }

  Future<void> _updatePublicSetting(bool newValue, String nickName) async {
    final int userId = customStringHash(firebaseAuthRepository.getUser()!.uid);
    await context.read<SettingsCubit>().updateSettingsRowInSupabase(
          userId: userId,
          isPublic: newValue,
          nickName: nickName,
        );
    if (!context.mounted) return;
    setState(() {
      isPublicAccount = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color tileColor = Color(0xff1c1a1e);
    return BlocBuilder<SupabaseCubit, SupabaseCubitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Preferences'),
                ),
                const TileDivider(),
                ListTile(
                  tileColor: const Color(0xff1c1a1e),
                  title: const Text('Public Account'),
                  trailing: Switch(
                    value: isPublicAccount,
                    onChanged: (value) {
                      setState(() {
                        isPublicAccount = !isPublicAccount;
                      });
                    },
                  ),
                  onTap: () => isPublicAccount = !isPublicAccount,
                ),
                const TileDivider(),
                ListTile(
                  tileColor: tileColor,
                  title: const Text('Nickname'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 20,
                        width: 100,
                        child: TextField(
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                  onTap: null,
                ),
                const TileDivider(),
                const ListTile(
                  title: Text('Other'),
                ),
                const TileDivider(),
                ListTile(
                  tileColor: tileColor,
                  title: const Text('Sign out'),
                  onTap: firebaseAuthRepository.signOut,
                ),
                const TileDivider(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _updatePublicSetting(
              isPublicAccount,
              _controller.text,
            ).whenComplete(
                () => context.read<SettingsCubit>().fetchAllSettings()),
            child: const Icon(Icons.save, size: 35),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
