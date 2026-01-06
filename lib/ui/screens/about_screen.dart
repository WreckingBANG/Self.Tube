import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/constants/dependencies.dart';
import 'package:Self.Tube/constants/urls.dart';
import 'package:Self.Tube/ui/widgets/containers/list_section_container.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                        Image.asset(
                          'assets/appicon_filled.png',
                          width: 100,
                          height: 100,
                        ),
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
                ListSectionContainer(
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
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.aboutScrollDependencies,
                  style: Theme.of(context).textTheme.bodyMedium,
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
