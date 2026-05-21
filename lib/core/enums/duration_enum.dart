/// Uygulama genelinde kullanılan süre sabitleri (enhanced enum).
enum DurationEnum {
  splashDelay(1500),
  pageTransition(300),
  snackBarShort(2500),
  debounceSearch(400),
  retryDelay(800),
  scanLaserCycle(1300),
  /// Tarama yükleme ekranının en az görünür kalma süresi.
  scanLoadingMin(450);

  const DurationEnum(this.milliseconds);
  final int milliseconds;

  Duration get duration => Duration(milliseconds: milliseconds);
}
