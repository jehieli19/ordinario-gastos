import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  const ProfileAvatar({super.key, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null ? const Icon(Icons.person) : null,
    );
  }
}
