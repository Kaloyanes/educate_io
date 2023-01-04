import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerDestination extends StatelessWidget {
  const DrawerDestination(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  final IconData icon;
  final String label;
  final GestureTapCallback onTap;

  @override
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        tileColor: Colors.transparent,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(300)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        title: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 25,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
