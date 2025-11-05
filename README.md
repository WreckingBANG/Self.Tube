
# Self.Tube

**Self.Tube** will be a sleek, lightweight client for [TubeArchivist](https://github.com/tubearchivist/tubearchivist), designed to bring your personal YouTube archive right to your Android or Linux phone.

With a streamlined interface and direct connection to your TubeArchivist server, Self.Tube will make it easy to browse, search, and stream your archived content from anywhere.


## Info

⚠️ This is an early-stage, experimental project. It works, but the code is messy and evolving. I'm not a professional developer — just someone learning Flutter. Contributions and constructive feedback are welcome!
## Features

- [x]  Browse TubeArchivist library
- [x]  Search archived videos
- [x]  Stream directly from your server
- [x]  Android phone support
- [x]  Sponsorblock support
- [ ]  Linux phone support ([#1](https://codeberg.org/WreckingBANG/Self.Tube/issues/1))
- [ ]  Subtitle support ([#6](https://codeberg.org/WreckingBANG/Self.Tube/issues/6))
- [ ]  Library management ([#15](https://codeberg.org/WreckingBANG/Self.Tube/issues/15))
- [ ]  Sponsorblock support ([#14](https://codeberg.org/WreckingBANG/Self.Tube/issues/14))
- [ ]  Offline playback ([#23](https://codeberg.org/WreckingBANG/Self.Tube/issues/23))
- [ ]  Playlist management ([#15](https://codeberg.org/WreckingBANG/Self.Tube/issues/15))
- [ ]  Jellyfin Integration for Transcoding ([#18](https://codeberg.org/WreckingBANG/Self.Tube/issues/18))


## Why Self.Tube

TubeArchivist is amazing for archiving, but it’s built for use in a Web-Browser. Self.Tube fills the gap by giving you a native app experience tailored for mobile devices. It’s open-source, privacy-respecting, and built for power users who want full control of their media.
## Building

You can build and run Self.Tube using the provided Nix Flake setup. This ensures a reproducible development environment with all dependencies preconfigured.

### Prerequisites
- Install [Nix](https://nixos.org/download)
- Enable experimental features for flakes and the `nix develop` command

### Steps

```bash
1. Install Nix (if not already installed)
    → https://nixos.org/download

2. Clone the repository
   git clone https://codeberg.org/wreckingbang/self.tube
   cd self.tube

3. Enter the development shell using flakes
   nix develop --experimental-features 'nix-command flakes'

4. Run the app with Flutter
   flutter run
```
## Contributing

Every help is welcome. Feel free to open issues, suggest improvements, or submit pull requests.


## License

Self.Tube is [Free Software](https://en.wikipedia.org/wiki/Free_software). You have the freedom to use, study, share, and modify it as you wish.

This app is licensed under the terms of the [GNU Affero General Public License version 3 or later](https://www.gnu.org/licenses/agpl-3.0.html), as published by the [Free Software Foundation](https://www.fsf.org/). This ensures that any modifications or networked use of the software must also remain free and open.