import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

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
  bool isPublicAccount =
      false; // This will hold the current value for the switch

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    final int userId = firebaseAuthRepository.getUser()!.uid.hashCode;
    bool publicStatus = await supabaseRepository.checkUserSettingsInSupabase(
      userId: userId,
    );
    setState(() {
      isPublicAccount = publicStatus;
    });
  }

  Future<void> _updatePublicSetting(bool newValue) async {
    final int userId = firebaseAuthRepository.getUser()!.uid.hashCode;
    await supabaseRepository.updateSettingsRowInSupabase(
      userId: userId,
      isPublic: newValue,
    );
    setState(() {
      isPublicAccount = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onChanged: _updatePublicSetting,
                  ),
                  onTap: () => _updatePublicSetting(!isPublicAccount),
                ),
                const TileDivider(),
                const ListTile(
                  title: Text('Other'),
                ),
                const TileDivider(),
                ListTile(
                  tileColor: const Color(0xff1c1a1e),
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
            onPressed: () => _updatePublicSetting(isPublicAccount),
            child: const Icon(Icons.save, size: 35),
          ),
        );
      },
    );
  }
}
