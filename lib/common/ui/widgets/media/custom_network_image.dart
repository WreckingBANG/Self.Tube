import 'package:Self.Tube/common/data/services/api/api_headers.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomNetwokImage extends StatelessWidget {
  final String imageLink;

  const CustomNetwokImage({
    super.key,
    required this.imageLink,
  });

  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$baseUrl/$imageLink",
      httpHeaders: ApiHeaders.authHeaders(),
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}