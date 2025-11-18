import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    // Fallback to initials
    final initials = _getInitials(name);
    final colors = _getColorForName(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors['background'],
      child: Text(
        initials,
        style: TextStyle(
          color: colors['text'],
          fontSize: radius * 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, Color> _getColorForName(String name) {
    // Generate consistent colors based on name
    final hash = name.hashCode;
    final colors = [
      {'background': Colors.blue, 'text': Colors.white},
      {'background': Colors.green, 'text': Colors.white},
      {'background': Colors.purple, 'text': Colors.white},
      {'background': Colors.orange, 'text': Colors.white},
      {'background': Colors.pink, 'text': Colors.white},
      {'background': Colors.teal, 'text': Colors.white},
      {'background': Colors.indigo, 'text': Colors.white},
      {'background': Colors.cyan, 'text': Colors.white},
    ];

    return colors[hash.abs() % colors.length];
  }
}
