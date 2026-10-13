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

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Cores.kGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 220.w,
                height: 220.h,
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
                  padding: EdgeInsets.only(left: 50.w),
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
                          fontSize: 45.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
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
                        child: Tooltip(
                          message: Strings.copiarEmail,
                          child: Text(
                            email.trim().toLowerCase(),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 38.sp,
                              color: Cores.kDeepGreyColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 400.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchUrl(githubUrl);
                              },
                              child: SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child: Image.asset(
                                  Strings.githubIconAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(linkedinUrl);
                              },
                              child: SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child: Image.asset(
                                  Strings.linkedinIconAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(instagramUrl);
                              },
                              child: SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child: Image.asset(
                                  Strings.instagramIconAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
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
              margin: EdgeInsets.only(top: 15.h),
              child: Text(
                cargo,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Cores.kDeepGreyColor,
                ),
              )),
        ],
      ),
    );
  }
}
