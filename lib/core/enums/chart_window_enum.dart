/// Grafik zaman penceresi (gün).
enum ChartWindowEnum {
  fourteen(14),
  thirty(30);

  const ChartWindowEnum(this.days);
  final int days;
}
