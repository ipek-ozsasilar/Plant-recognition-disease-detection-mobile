import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';

/// Profil fotoğrafı veya varsayılan avatar.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.profile,
    required this.fallbackName,
    this.localBytes,
    this.uploading = false,
    super.key,
  });

  final UserProfileModel? profile;
  final String fallbackName;
  final Uint8List? localBytes;
  final bool uploading;

  static double get diameter => ImageSizesEnum.thumb.value * 1.6;

  @override
  Widget build(BuildContext context) {
    final Widget imageChild = _buildImage(context);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.palSurfaceCard,
            border: Border.all(
              color: context.palOutline.withValues(alpha: 0.55),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: context.palPrimary.withValues(alpha: 0.18),
                blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                offset: Offset(
                  0,
                  WidgetSizesEnum.cardShadowOffsetY.value * 0.85,
                ),
              ),
            ],
          ),
          child: ClipOval(child: imageChild),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 6),
            decoration: BoxDecoration(
              color: context.palPrimary,
              shape: BoxShape.circle,
              border: Border.all(color: context.palSurfaceCard, width: 2),
            ),
            child: uploading
                ? SizedBox(
                    width: IconSizesEnum.small.value,
                    height: IconSizesEnum.small.value,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.palOnPrimary,
                    ),
                  )
                : Icon(
                    Icons.camera_alt_rounded,
                    size: IconSizesEnum.small.value,
                    color: context.palOnPrimary,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    if (localBytes != null) {
      return Image.memory(localBytes!, fit: BoxFit.cover);
    }
    final String? url = profile?.photoUrl;
    if (url != null && url.isNotEmpty) {
      final Object cacheKey = profile?.updatedAt?.millisecondsSinceEpoch ?? url;
      return Image.network(
        url,
        key: ValueKey<Object>(cacheKey),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.palPrimarySoftBg,
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: ImageSizesEnum.thumb.value * 0.85,
          color: context.palPrimary,
        ),
      ),
    );
  }
}
