import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final Uri privacypolicyUrl = Uri.parse(
        'https://codeberg.org/WreckingBANG/Self.Tube/src/branch/main/docs/PRIVACY_POLICY.md');
    final Uri licenseUrl = Uri.parse(
        'https://codeberg.org/WreckingBANG/Self.Tube/src/branch/main/LICENSE');
    final Uri sourceCodeUrl = Uri.parse(
        'https://codeberg.org/WreckingBANG/Self.Tube');
    final Uri codebergAccountUrl = Uri.parse(
        'https://codeberg.org/WreckingBANG');
    final Uri changelogUrl = Uri.parse(
        'https://codeberg.org/WreckingBANG/Self.Tube/releases');
    final dependencies = [
      {
        "name": "http",
        "license": "BSD-3-Clause",
        "url": "https://github.com/dart-lang/http/blob/master/LICENSE"
      },
      {
        "name": "media_kit",
        "license": "MIT",
        "url": "https://github.com/media-kit/media-kit/blob/main/LICENSE"
      },
      {
        "name": "media_kit_video",
        "license": "MIT",
        "url": "https://github.com/media-kit/media-kit/blob/main/LICENSE"
      },
      {
        "name": "media_kit_libs_video",
        "license": "MIT",
        "url": "https://github.com/media-kit/media-kit/blob/main/LICENSE"
      },
      {
        "name": "volume_controller",
        "license": "MIT",
        "url": "https://github.com/yosemiteyss/flutter_volume_controller/blob/main/LICENSE"
      },
      {
        "name": "flutter_localizations",
        "license": "BSD-3-Clause",
        "url": "https://github.com/flutter/flutter/blob/master/LICENSE"
      },
      {
        "name": "intl",
        "license": "BSD-3-Clause",
        "url": "https://github.com/dart-lang/i18n/blob/main/pkgs/intl/LICENSE"
      },
      {
        "name": "cached_network_image",
        "license": "MIT",
        "url": "https://github.com/Baseflow/flutter_cached_network_image/blob/develop/cached_network_image/LICENSE"
      },
      {
        "name": "share_plus",
        "license": "BSD-3-Clause",
        "url": "https://github.com/fluttercommunity/plus_plugins/blob/main/packages/share_plus/share_plus/LICENSE"
      },
      {
        "name": "shared_preferences",
        "license": "BSD-3-Clause",
        "url": "https://github.com/flutter/packages/blob/main/packages/shared_preferences/shared_preferences/LICENSE"
      },
      {
        "name": "dynamic_color",
        "license": "Apache-2.0",
        "url": "https://github.com/material-foundation/flutter-packages/blob/main/packages/dynamic_color/LICENSE"
      },
      {
        "name": "url_launcher",
        "license": "BSD-3-Clause",
        "url": "https://github.com/flutter/packages/blob/main/packages/url_launcher/url_launcher/LICENSE"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FlutterLogo(size: 100),
                        const SizedBox(height: 16),
                        Text(
                          localizations.appTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text("${localizations.aboutVersion}: 0.1.0"),
                        Text("${localizations.aboutLicense}: AGPL-v3-or-Later"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => launchUrl(codebergAccountUrl),
                          child: Text(
                            localizations.aboutDeveloper,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(localizations.aboutLicense),
                      onTap: () => launchUrl(licenseUrl),
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text(localizations.aboutPrivacyPolicy),
                      onTap: () => launchUrl(privacypolicyUrl),
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(localizations.aboutSourceCode),
                      onTap: () => launchUrl(sourceCodeUrl),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: Text(localizations.aboutReleases),
                      onTap: () => launchUrl(changelogUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizations.aboutScrollDependencies,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Dependencies",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dep = dependencies[index];
                return ListTile(
                  leading: const Icon(Icons.extension),
                  title: Text(dep["name"]!),
                  subtitle: Text("${localizations.aboutLicense}: ${dep["license"]}"),
                  onTap: () => launchUrl(Uri.parse(dep["url"]!)),
                );
              },
              childCount: dependencies.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
