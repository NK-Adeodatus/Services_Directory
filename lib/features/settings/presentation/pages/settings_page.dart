import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _locationNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logged in as',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.user.email ?? state.user.uid,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }
              return const Text(
                'Not logged in.',
                style: TextStyle(color: Colors.white),
              );
            },
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text(
              'Location-based notifications',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Simulated preference stored locally.',
              style: TextStyle(color: Colors.white70),
            ),
            value: _locationNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _locationNotificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

