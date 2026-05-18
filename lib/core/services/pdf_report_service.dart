import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/services/disease_info_catalog.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Scan sonucunu PDF rapora çevirir (paylaşım UI'si üst katmanda).
class PdfReportService {
  const PdfReportService();

  Future<Uint8List> buildScanReportPdf({
    required PlantScanModel record,
    required AppLocalizations l10n,
  }) async {
    final pw.Document doc = pw.Document();

    // Türkçe karakter desteği için Roboto fontlarını yüklüyoruz
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    final pw.Font mainFont = pw.Font.ttf(fontData);
    final pw.Font boldFont = pw.Font.ttf(fontBoldData);

    final DiseaseInfo info = const DiseaseInfoCatalog().get(
      record.diseaseKey,
      l10n,
    );
    final String diseaseDisplay = diseaseClassKeyToDisplay(
      record.diseaseKey,
      l10n,
    );
    final String speciesDisplay = speciesClassDisplayForExport(
      l10n,
      record.speciesLabel,
    );
    final String lang = l10n.localeName;
    final String dateLine = DateFormat.yMMMd(
      lang,
    ).add_Hm().format(record.createdAt);

    final double pad = WidgetSizesEnum.pdfPagePadding.value;
    final double titleSize = WidgetSizesEnum.pdfTitleFont.value;
    final double bodySize = WidgetSizesEnum.pdfBodyFont.value;
    final double sectionGap = WidgetSizesEnum.pdfSectionSpacing.value;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: mainFont, bold: boldFont),
        margin: pw.EdgeInsets.all(pad),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                l10n.pdfReportTitle,
                style: pw.TextStyle(font: boldFont, fontSize: titleSize),
              ),
              pw.SizedBox(height: sectionGap),
              _kv(l10n.pdfReportDate, dateLine, bodySize, mainFont, boldFont),
              _kv(
                l10n.pdfReportSpecies,
                speciesDisplay,
                bodySize,
                mainFont,
                boldFont,
              ),
              _kv(
                l10n.pdfReportSpeciesConfidence,
                confidencePercentLabel(
                  record.speciesConfidence,
                ), // Zaten 0-1 aralığında
                bodySize,
                mainFont,
                boldFont,
              ),
              _kv(
                l10n.pdfReportDisease,
                diseaseDisplay,
                bodySize,
                mainFont,
                boldFont,
              ),
              _kv(
                l10n.pdfReportDiseaseConfidence,
                confidencePercentLabel(
                  record.diseaseConfidence,
                ), // Zaten 0-1 aralığında
                bodySize,
                mainFont,
                boldFont,
              ),
              pw.SizedBox(height: sectionGap),
              _section(
                l10n.diseaseDetailSectionDescription,
                info.description,
                bodySize,
                mainFont,
                boldFont,
              ),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(
                l10n.diseaseDetailSectionCauses,
                info.causes,
                bodySize,
                mainFont,
                boldFont,
              ),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(
                l10n.diseaseDetailSectionTreatment,
                info.treatment,
                bodySize,
                mainFont,
                boldFont,
              ),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(
                l10n.diseaseDetailSectionPrevention,
                info.prevention,
                bodySize,
                mainFont,
                boldFont,
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                l10n.pdfReportDisclaimer,
                style: pw.TextStyle(
                  font: mainFont,
                  fontSize: bodySize,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _kv(String k, String v, double size, pw.Font main, pw.Font bold) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.SizedBox(
            width: 160,
            child: pw.Text(
              k,
              style: pw.TextStyle(font: bold, fontSize: size),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              v,
              style: pw.TextStyle(font: main, fontSize: size),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _section(
    String title,
    String body,
    double size,
    pw.Font main,
    pw.Font bold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          title,
          style: pw.TextStyle(font: bold, fontSize: size + 1),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          body,
          style: pw.TextStyle(font: main, fontSize: size),
        ),
      ],
    );
  }
}
