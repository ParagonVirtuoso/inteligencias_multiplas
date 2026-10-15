import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DeveloperItem extends StatelessWidget {
  final String name;
  final String email;
  final String githubUrl;
  final String linkedinUrl;
  final String instagramUrl;
  final String? imageUrl;
  final String? imageAsset;
  final String cargo;

  const DeveloperItem({
    super.key,
    required this.name,
    required this.email,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.instagramUrl,
    this.imageUrl,
    this.imageAsset,
    required this.cargo,
  });

  ImageProvider? _getImageProvider() {
    final asset = imageAsset?.trim();
    if (asset != null && asset.isNotEmpty) {
      if (asset.startsWith('http://') || asset.startsWith('https://')) {
        return NetworkImage(asset);
      }
      return AssetImage(asset);
    }
    final url = imageUrl?.trim();
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return NetworkImage(url);
      }
      return AssetImage(url);
    }
    return null;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Não foi possível abrir: $url');
      }
    } catch (e) {
      debugPrint('Erro ao abrir link: $e');
    }
  }

  Widget _buildSocialIcon({
    required String url,
    required String asset,
    required String tooltip,
    required double size,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: size,
            height: size,
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();

    final cardHorizontalPadding = (50.w).clamp(16.0, 24.0);
    final cardVerticalPadding = (30.h).clamp(12.0, 20.0);
    final avatarSize = (220.r).clamp(64.0, 88.0);
    final textLeftPadding = (50.w).clamp(14.0, 22.0);
    final iconSize = (60.r).clamp(20.0, 26.0);
    final socialRowMaxWidth = (400.w).clamp(120.0, 150.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: cardHorizontalPadding,
        vertical: cardVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Cores.kGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: imageProvider != null
                      ? DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          onError: (exception, stackTrace) {
                            debugPrint(
                                'Erro ao carregar imagem do desenvolvedor: $exception');
                          },
                        )
                      : null,
                ),
                child: imageProvider == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: textLeftPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: (45.sp).clamp(16.0, 20.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: (10.h).clamp(4.0, 8.0)),
                      GestureDetector(
                        onTap: () async {
                          final normalizedEmail = email.trim().toLowerCase();
                          await Clipboard.setData(
                            ClipboardData(text: normalizedEmail),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(Strings.emailCopiado),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            message: Strings.copiarEmail,
                            child: Text(
                              email.trim().toLowerCase(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: (38.sp).clamp(13.0, 16.0),
                                color: Cores.kDeepGreyColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: (10.h).clamp(6.0, 10.0)),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: socialRowMaxWidth),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: socialRowMaxWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildSocialIcon(
                                  url: githubUrl,
                                  asset: Strings.githubIconAsset,
                                  tooltip: 'GitHub',
                                  size: iconSize,
                                ),
                                _buildSocialIcon(
                                  url: linkedinUrl,
                                  asset: Strings.linkedinIconAsset,
                                  tooltip: 'LinkedIn',
                                  size: iconSize,
                                ),
                                _buildSocialIcon(
                                  url: instagramUrl,
                                  asset: Strings.instagramIconAsset,
                                  tooltip: 'Instagram',
                                  size: iconSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: (15.h).clamp(8.0, 14.0)),
            child: Text(
              cargo,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (32.sp).clamp(11.0, 14.0),
                fontWeight: FontWeight.bold,
                color: Cores.kDeepGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
