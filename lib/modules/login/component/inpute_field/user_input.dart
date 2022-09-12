import 'package:flutter/material.dart';

class UsernameInput extends StatelessWidget {
  const UsernameInput({
    super.key,
    this.maxWidth,
    this.usernameController,
  });

  final double? maxWidth;
  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
          ),
        ),
      ),
    );
  }
}
