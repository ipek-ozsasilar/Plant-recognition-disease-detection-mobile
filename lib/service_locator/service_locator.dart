import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/services/firebase_storage_service.dart';
import 'package:bitirme_mobile/core/services/google_sign_in_service.dart';
import 'package:bitirme_mobile/core/services/firestore_setup_service.dart';
import 'package:bitirme_mobile/core/services/user_profile_firestore_service.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/inference_api_service.dart';
import 'package:bitirme_mobile/core/services/catalog_firestore_service.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/services/pdf_report_service.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:bitirme_mobile/core/services/plants_firestore_service.dart';
import 'package:bitirme_mobile/core/services/scan_history_service.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/core/services/tflite_plant_inference_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AppLogger>(() => AppLogger());
  sl.registerLazySingleton<AuthStorageService>(
    () => AuthStorageService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ScanHistoryService>(
    () => ScanHistoryService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ImageCropService>(
    () => ImageCropService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<PlantnetSpeciesNameRepository>(() => PlantnetSpeciesNameRepository());
  sl.registerLazySingleton<SinkSpeciesClassRepository>(() => SinkSpeciesClassRepository());
  sl.registerLazySingleton<MlMetadataLoader>(
    () => MlMetadataLoader(
      logger: sl<AppLogger>(),
      plantnetNames: sl<PlantnetSpeciesNameRepository>(),
      sinkSpeciesClasses: sl<SinkSpeciesClassRepository>(),
    ),
  );
  sl.registerLazySingleton<TflitePlantInferenceService>(
    () => TflitePlantInferenceService(
      logger: sl<AppLogger>(),
      plantnetNames: sl<PlantnetSpeciesNameRepository>(),
      sinkSpeciesClasses: sl<SinkSpeciesClassRepository>(),
    ),
  );
  sl.registerLazySingleton<InferenceApiService>(
    () => InferenceApiService(
      logger: sl<AppLogger>(),
      tflite: sl<TflitePlantInferenceService>(),
    ),
  );
  sl.registerLazySingleton<GoogleSignInService>(
    () => GoogleSignInService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<UserProfileFirestoreService>(
    () => UserProfileFirestoreService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<FirestoreSetupService>(
    () => FirestoreSetupService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<FirebaseStorageService>(
    () => FirebaseStorageService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<PdfReportService>(() => const PdfReportService());
  sl.registerLazySingleton<PlantsFirestoreService>(
    () => PlantsFirestoreService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<PlantScansFirestoreService>(
    () => PlantScansFirestoreService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<CatalogFirestoreService>(
    () => CatalogFirestoreService(
      logger: sl<AppLogger>(),
      plantnetNames: sl<PlantnetSpeciesNameRepository>(),
    ),
  );
}
