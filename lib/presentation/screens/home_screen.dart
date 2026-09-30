import 'package:connectme_app/presentation/blocs/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConnectMe')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to ConnectMe'),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
