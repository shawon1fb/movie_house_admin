import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../layout/highlight_focus.dart';
import '../../../layout/image_placeholder.dart';
import '../../../layout/text_scale.dart';
import '../../../main.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(width: 30);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: 80,
                  child: FadeInImagePlaceholder(
                    image: const AssetImage('logo.png', package: 'rally_assets'),
                    placeholder: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                      );
                    }),
                  ),
                ),
              ),
              spacing,
              Text(
                'Log in to Admin',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 35 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HighlightFocus(
                onPressed: (){
                  print('Logged in');
                },
                child: SelectableText(
                  "Don't have an account?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              spacing,
              const BorderButton(
                text: 'SIGN UP',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  const BorderButton({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: RallyColors.buttonColor),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
      },
      child: Text(text),
    );
  }
}
