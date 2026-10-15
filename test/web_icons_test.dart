import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Web Icons Verification Tests', () {
    const defaultFlutterIconLengths = {
      'favicon.png': 917,
      'Icon-192.png': 5292,
      'Icon-512.png': 8252,
      'Icon-maskable-192.png': 5594,
      'Icon-maskable-512.png': 20998,
    };

    (int width, int height) getPngDimensions(File file) {
      final bytes = file.readAsBytesSync();
      expect(bytes.length, greaterThanOrEqualTo(24));
      // PNG magic number: 0x89 0x50 0x4E 0x47 0x0D 0x0A 0x1A 0x0A
      expect(bytes[0], 0x89);
      expect(bytes[1], 0x50);
      expect(bytes[2], 0x4E);
      expect(bytes[3], 0x47);
      expect(bytes[4], 0x0D);
      expect(bytes[5], 0x0A);
      expect(bytes[6], 0x1A);
      expect(bytes[7], 0x0A);

      final data = ByteData.sublistView(bytes);
      final width = data.getUint32(16);
      final height = data.getUint32(20);
      return (width, height);
    }

    test('web/favicon.png exists with correct 16x16 dimensions and is replaced from app icon', () {
      final file = File('web/favicon.png');
      expect(file.existsSync(), isTrue, reason: 'web/favicon.png must exist');
      final (width, height) = getPngDimensions(file);
      expect(width, 16);
      expect(height, 16);
      expect(file.lengthSync(), greaterThan(100));
    });

    test('web/icons/Icon-192.png exists with 192x192 dimensions', () {
      final file = File('web/icons/Icon-192.png');
      expect(file.existsSync(), isTrue, reason: 'web/icons/Icon-192.png must exist');
      final (width, height) = getPngDimensions(file);
      expect(width, 192);
      expect(height, 192);
    });

    test('web/icons/Icon-512.png exists with 512x512 dimensions', () {
      final file = File('web/icons/Icon-512.png');
      expect(file.existsSync(), isTrue, reason: 'web/icons/Icon-512.png must exist');
      final (width, height) = getPngDimensions(file);
      expect(width, 512);
      expect(height, 512);
    });

    test('web/icons/Icon-maskable-192.png exists with 192x192 dimensions', () {
      final file = File('web/icons/Icon-maskable-192.png');
      expect(file.existsSync(), isTrue, reason: 'web/icons/Icon-maskable-192.png must exist');
      final (width, height) = getPngDimensions(file);
      expect(width, 192);
      expect(height, 192);
    });

    test('web/icons/Icon-maskable-512.png exists with 512x512 dimensions', () {
      final file = File('web/icons/Icon-maskable-512.png');
      expect(file.existsSync(), isTrue, reason: 'web/icons/Icon-maskable-512.png must exist');
      final (width, height) = getPngDimensions(file);
      expect(width, 512);
      expect(height, 512);
    });

    test('All web icons are updated from the app icon and differ from default Flutter template icons', () {
      final iconsToCheck = [
        ('web/favicon.png', 'favicon.png'),
        ('web/icons/Icon-192.png', 'Icon-192.png'),
        ('web/icons/Icon-512.png', 'Icon-512.png'),
        ('web/icons/Icon-maskable-192.png', 'Icon-maskable-192.png'),
        ('web/icons/Icon-maskable-512.png', 'Icon-maskable-512.png'),
      ];

      for (final (filePath, defaultKey) in iconsToCheck) {
        final file = File(filePath);
        expect(file.existsSync(), isTrue);
        final defaultLength = defaultFlutterIconLengths[defaultKey];
        expect(
          file.lengthSync(),
          isNot(equals(defaultLength)),
          reason: '$filePath must not match the old Flutter template icon length',
        );
      }
    });

    test('web/manifest.json references all icon files correctly', () {
      final manifestFile = File('web/manifest.json');
      expect(manifestFile.existsSync(), isTrue);

      final content = manifestFile.readAsStringSync();
      final manifestJson = jsonDecode(content) as Map<String, dynamic>;
      final icons = manifestJson['icons'] as List<dynamic>;

      expect(icons.length, greaterThanOrEqualTo(4));

      final iconSrcs = icons.map((e) => e['src'] as String).toSet();
      expect(iconSrcs.contains('icons/Icon-192.png'), isTrue);
      expect(iconSrcs.contains('icons/Icon-512.png'), isTrue);
      expect(iconSrcs.contains('icons/Icon-maskable-192.png'), isTrue);
      expect(iconSrcs.contains('icons/Icon-maskable-512.png'), isTrue);

      for (final icon in icons) {
        final src = icon['src'] as String;
        final iconFile = File('web/$src');
        expect(iconFile.existsSync(), isTrue, reason: 'File referenced in manifest web/$src must exist');
      }
    });

    test('web/index.html links to apple-touch-icon and favicon correctly', () {
      final indexHtmlFile = File('web/index.html');
      expect(indexHtmlFile.existsSync(), isTrue);

      final html = indexHtmlFile.readAsStringSync();
      expect(html.contains('rel="apple-touch-icon" href="icons/Icon-192.png"'), isTrue);
      expect(html.contains('rel="icon" type="image/png" href="favicon.png"'), isTrue);

      expect(File('web/icons/Icon-192.png').existsSync(), isTrue);
      expect(File('web/favicon.png').existsSync(), isTrue);
    });

    test('build/web icons match web source icons if build/web directory exists', () {
      final buildWebDir = Directory('build/web');
      if (!buildWebDir.existsSync()) return;

      final files = [
        'favicon.png',
        'icons/Icon-192.png',
        'icons/Icon-512.png',
        'icons/Icon-maskable-192.png',
        'icons/Icon-maskable-512.png',
      ];

      for (final path in files) {
        final srcFile = File('web/$path');
        final buildFile = File('build/web/$path');
        if (buildFile.existsSync()) {
          expect(
            listEquals(srcFile.readAsBytesSync(), buildFile.readAsBytesSync()),
            isTrue,
            reason: 'build/web/$path should be in sync with web/$path',
          );
        }
      }
    });

    test('Web icons have non-trivial size and valid PNG data', () {
      final files = [
        ('web/favicon.png', 300),
        ('web/icons/Icon-192.png', 10000),
        ('web/icons/Icon-512.png', 50000),
        ('web/icons/Icon-maskable-192.png', 10000),
        ('web/icons/Icon-maskable-512.png', 50000),
      ];

      for (final (path, minSize) in files) {
        final f = File(path);
        expect(f.lengthSync(), greaterThanOrEqualTo(minSize));
      }
    });

    test('Standard and maskable icons are tailored distinctly for their respective roles', () {
      final std192 = File('web/icons/Icon-192.png').readAsBytesSync();
      final mask192 = File('web/icons/Icon-maskable-192.png').readAsBytesSync();
      expect(
        listEquals(std192, mask192),
        isFalse,
        reason: 'Icon-192.png (standard display) and Icon-maskable-192.png (PWA safe-zone) must be distinct assets',
      );

      final std512 = File('web/icons/Icon-512.png').readAsBytesSync();
      final mask512 = File('web/icons/Icon-maskable-512.png').readAsBytesSync();
      expect(
        listEquals(std512, mask512),
        isFalse,
        reason: 'Icon-512.png and Icon-maskable-512.png must be distinct assets',
      );
    });

    test('web/favicon.png has valid RGBA color type (type 6) allowing transparency', () {
      final bytes = File('web/favicon.png').readAsBytesSync();
      // PNG IHDR color type is at byte offset 25 (0 = grayscale, 2 = RGB, 6 = RGBA)
      expect(bytes[25], equals(6), reason: 'Favicon must be RGBA for transparent browser tab rendering');
    });
  });
}

