import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/core/common/widgets/omt_button.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authFunctionsProvider = ref.read(authProvider.notifier);
    return Scaffold(
      body: Center(
        child: OmtButton(
          onPressed: () async {
            await authFunctionsProvider.signOut();
          },
          text: 'Log out',
        ),
      ),
    );
  }
}