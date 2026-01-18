import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/cv_data.dart';

class PDFGenerator {
  static Future<void> generateAndPrint(CVData cvData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      cvData.userProfile.fullName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '${cvData.userProfile.email} | ${cvData.userProfile.phoneNumber ?? ""} | ${cvData.userProfile.location ?? ""}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
              pw.Divider(height: 20),

              // Summary
              _buildSectionHeader('PROFESSIONAL SUMMARY'),
              pw.Text(
                cvData.generatedSummary,
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 16),

              // Skills
              _buildSectionHeader('SKILLS'),
              pw.Wrap(
                spacing: 8,
                runSpacing: 4,
                children: cvData.tailoredSkills.map((skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(skill, style: const pw.TextStyle(fontSize: 10)),
                )).toList(),
              ),
              pw.SizedBox(height: 16),
              
              // Experience (Mocked for now in PDF too)
              _buildSectionHeader('EXPERIENCE'),
              if (cvData.userProfile.experience.isEmpty)
                 pw.Text('No experience listed.', style: const pw.TextStyle(fontSize: 12)),
                 
              pw.SizedBox(height: 16),

               // Education
              _buildSectionHeader('EDUCATION'),
              if (cvData.userProfile.education.isEmpty)
                 pw.Text('No education listed.', style: const pw.TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${cvData.userProfile.fullName.replaceAll(' ', '_')}_CV.pdf',
    );
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(height: 1, color: PdfColors.black, width: 200), // Underline equivalent
        pw.SizedBox(height: 8),
      ],
    );
  }
}
