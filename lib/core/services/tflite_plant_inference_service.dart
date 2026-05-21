/// Platforma göre TFLite: mobil/masaüstü (`dart:io`) veya web stub.
export 'tflite_plant_inference_service_stub.dart'
    if (dart.library.io) 'tflite_plant_inference_service_io.dart';
