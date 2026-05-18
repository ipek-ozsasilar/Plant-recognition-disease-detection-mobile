import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/firebase_storage_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Yeni bitki ekleme (ad + foto + tür etiketi).
class PlantsAddView extends ConsumerStatefulWidget {
  const PlantsAddView({super.key});

  @override
  ConsumerState<PlantsAddView> createState() => _PlantsAddViewState();
}

class _PlantsAddViewState extends ConsumerState<PlantsAddView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _species = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _photoBytes;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      return;
    }
    setState(() => _loading = true);
    final String plantId = const Uuid().v4();
    String? photoUrl;
    if (_photoBytes != null) {
      photoUrl = await sl<FirebaseStorageService>().uploadJpegBytes(
        path: 'users/$uid/plants/$plantId.jpg',
        bytes: _photoBytes!,
      );
    }
    final PlantModel plant = PlantModel(
      id: plantId,
      ownerUid: uid,
      name: _name.text.trim(),
      speciesLabel: _species.text.trim(),
      createdAt: DateTime.now(),
      photoUrl: photoUrl,
    );
    await ref.read(plantsProvider.notifier).add(plant);
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    context.pop();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final double maxPx = ImageSizesEnum.galleryPickMax.value;
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: maxPx,
        maxHeight: maxPx,
      );
      if (file == null) {
        return;
      }
      final Uint8List bytes = await file.readAsBytes();
      if (!mounted) {
        return;
      }
      setState(() => _photoBytes = bytes);
    } catch (e, st) {
      sl<AppLogger>().e('plant_photo_pick', e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.myPlantsAddTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(pad),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: WidgetSizesEnum.cardRadius.value * 3.2,
                    height: WidgetSizesEnum.cardRadius.value * 3.2,
                    decoration: BoxDecoration(
                      color: context.palPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
                      border: Border.all(color: context.palOutline.withValues(alpha: 0.45)),
                    ),
                    child: _photoBytes == null
                        ? Icon(Icons.photo_rounded, color: context.palPrimary)
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
                            child: Image.memory(_photoBytes!, fit: BoxFit.cover),
                          ),
                  ),
                  SizedBox(width: WidgetSizesEnum.cardRadius.value),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppPrimaryButton(
                          label: context.l10n.scanPickCamera,
                          onPressed: () => _pickPhoto(ImageSource.camera),
                        ),
                        SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                        OutlinedButton(
                          onPressed: () => _pickPhoto(ImageSource.gallery),
                          child: Text(context.l10n.scanPickGallery),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              AppTextField(
                label: context.l10n.myPlantsNameLabel,
                controller: _name,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? context.l10n.validationRequired : null,
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              AppTextField(
                label: context.l10n.myPlantsSpeciesLabel,
                controller: _species,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? context.l10n.validationRequired : null,
              ),
              const Spacer(),
              AppPrimaryButton(
                label: context.l10n.save,
                isLoading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

