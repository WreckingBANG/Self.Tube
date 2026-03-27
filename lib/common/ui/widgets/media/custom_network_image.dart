import 'package:Self.Tube/common/data/services/api/api_headers.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageLink;
  final int? logicalWidth;

  const CustomNetworkImage({
    super.key,
    required this.imageLink,
    this.logicalWidth
  });

  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final ratio = MediaQuery.of(context).devicePixelRatio;

    final memCacheWidth = logicalWidth != null
        ? (logicalWidth! * ratio).round()
        : null;

    return CachedNetworkImage(
      imageUrl: "$baseUrl/$imageLink",
      httpHeaders: ApiHeaders.authHeaders(),
      fit: BoxFit.cover,
      memCacheWidth: memCacheWidth,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
