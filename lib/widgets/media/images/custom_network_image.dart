import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/services/api_headers.dart';

class CustomNetwokImage extends StatelessWidget {
  final String imageLink;

  const CustomNetwokImage({
    Key? key,
    required this.imageLink,
  }) : super(key: key);

  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$baseUrl/${imageLink}",
      httpHeaders: ApiHeaders.authHeaders(),
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}