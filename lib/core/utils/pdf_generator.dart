import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/user_profile.dart';

class PDFGenerator {
  static Future<void> generateAndPrint(CVData cvData) async {
    final pdf = pw.Document();

    pw.ImageProvider? profileImage;
    if (cvData.userProfile.profilePicturePath != null) {
      try {
        final imageBytes = await File(cvData.userProfile.profilePicturePath!).readAsBytes();
        profileImage = pw.MemoryImage(imageBytes);
      } catch (e) {
        // Fallback or log error
        // print('Error loading profile image: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32), // Standard margin
        build: (pw.Context context) {
          // Dispatch to specific layout based on styleId
          switch (cvData.styleId) {
            case 'Modern':
              return _buildModernLayout(cvData, profileImage);
            case 'Creative':
              return _buildCreativeLayout(cvData, profileImage);
            case 'Executive':
              return _buildExecutiveLayout(cvData);
            case 'ATS':
            default:
              return _buildATSLayout(cvData);
          }
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${cvData.userProfile.fullName.replaceAll(' ', '_')}_CV.pdf',
    );
  }

  // --- 1. ATS Layout (Clean, Standard, Text-based) ---
  static pw.Widget _buildATSLayout(CVData cvData) {
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
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
              ),
            ],
          ),
        ),
        pw.Divider(height: 20, thickness: 1),

        // Summary
        _buildSectionHeader(title: 'PROFESSIONAL SUMMARY', styleId: 'ATS'),
        pw.Text(
          cvData.summary,
          style: const pw.TextStyle(fontSize: 11),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 16),

      // Skills
      _buildSectionHeader(title: 'SKILLS', styleId: 'ATS'),
      pw.Wrap(
        spacing: 8,
        runSpacing: 4,
        children: cvData.userProfile.skills.map((skill) => pw.Text(
          '• $skill', 
          style: const pw.TextStyle(fontSize: 11),
        )).toList(),
      ),
        pw.SizedBox(height: 16),

        // Experience
        _buildSectionHeader(title: 'EXPERIENCE', styleId: 'ATS'),
        if (cvData.userProfile.experience.isEmpty)
           pw.Text('No experience listed.', style: const pw.TextStyle(fontSize: 11))
        else
           ...cvData.userProfile.experience.map((exp) => _buildExperienceItem(exp, isATS: true)),
           
        pw.SizedBox(height: 16),

         // Education
        _buildSectionHeader(title: 'EDUCATION', styleId: 'ATS'),
        if (cvData.userProfile.education.isEmpty)
           pw.Text('No education listed.', style: const pw.TextStyle(fontSize: 11))
        else
           ...cvData.userProfile.education.map((edu) => _buildEducationItem(edu, isATS: true)),
           
        // Certifications (New)
        if (cvData.userProfile.certifications.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          _buildSectionHeader(title: 'CERTIFICATIONS', styleId: 'ATS'),
           ...cvData.userProfile.certifications.map((cert) => _buildCertificationItem(cert, isATS: true)),
        ],
      ],
    );
  }

  // --- 2. Modern Layout (Two Columns, Sidebar, Blue Accents) ---
  static pw.Widget _buildModernLayout(CVData cvData, pw.ImageProvider? profileImage) {
    const accentColor = PdfColor.fromInt(0xFF1E88E5); // Blue 600

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Sidebar (Left) - Contact, Skills, Education, Certifications
        pw.Container(
          width: 180,
          padding: const pw.EdgeInsets.only(right: 16),
          decoration: const pw.BoxDecoration(
            border: pw.Border(right: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Profile Image
              if (profileImage != null) ...[
                 pw.Container(
                   height: 100,
                   width: 100,
                   decoration: pw.BoxDecoration(
                     shape: pw.BoxShape.circle,
                     image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
                   ),
                 ),
                 pw.SizedBox(height: 24),
              ],

              // Contact
              _buildSectionHeader(title: 'CONTACT', styleId: 'Modern', color: accentColor),
              pw.Text(cvData.userProfile.email, style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Text(cvData.userProfile.phoneNumber ?? "", style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Text(cvData.userProfile.location ?? "", style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 24),

              // Skills
              _buildSectionHeader(title: 'SKILLS', styleId: 'Modern', color: accentColor),
              pw.Wrap(
                runSpacing: 6,
                children: cvData.userProfile.skills.map((skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const pw.EdgeInsets.only(right: 4),
                  decoration: pw.BoxDecoration(
                    color: accentColor,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(skill, style: const pw.TextStyle(fontSize: 9, color: PdfColors.white)),
                )).toList(),
              ),
              pw.SizedBox(height: 24),

              // Education
              _buildSectionHeader(title: 'EDUCATION', styleId: 'Modern', color: accentColor),
              if (cvData.userProfile.education.isEmpty)
                 pw.Text('No education listed.', style: const pw.TextStyle(fontSize: 9))
              else
                 ...cvData.userProfile.education.map((edu) => pw.Padding(
                   padding: const pw.EdgeInsets.only(bottom: 8),
                   child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                       pw.Text(edu.schoolName, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                       pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 9)),
                       pw.Text('${edu.startDate} - ${edu.endDate ?? "Present"}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                     ]
                   )
                 )),
                 
              // Certifications (New)
              if (cvData.userProfile.certifications.isNotEmpty) ...[
                pw.SizedBox(height: 24),
                _buildSectionHeader(title: 'CERTIFICATIONS', styleId: 'Modern', color: accentColor),
                ...cvData.userProfile.certifications.map((cert) => pw.Padding(
                   padding: const pw.EdgeInsets.only(bottom: 8),
                   child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                       pw.Text(cert.name, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                       pw.Text(cert.issuer, style: const pw.TextStyle(fontSize: 9)),
                       pw.Text(cert.date.year.toString(), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                     ]
                   )
                 )),
              ],
            ],
          ),
        ),

        // Main Content (Right) - Header, Summary, Experience
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                 pw.Text(
                    cvData.userProfile.fullName.toUpperCase(),
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: accentColor),
                  ),
                  pw.Text(
                    cvData.jobTitle.toUpperCase(),
                    style: const pw.TextStyle(fontSize: 12, letterSpacing: 1.2, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 24),

                  _buildSectionHeader(title: 'PROFILE', styleId: 'Modern', color: accentColor),
                  pw.Text(cvData.summary, style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 24),

                  _buildSectionHeader(title: 'WORK EXPERIENCE', styleId: 'Modern', color: accentColor),
                  ...cvData.userProfile.experience.map((exp) => _buildExperienceItem(exp, isATS: false)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. Creative Layout (Bold Header, Distinct Sections) ---
  static pw.Widget _buildCreativeLayout(CVData cvData, pw.ImageProvider? profileImage) {
    const headerColor = PdfColor.fromInt(0xFF2E004B); // Dark Purple
    const accentColor = PdfColor.fromInt(0xFF9C27B0); // Purple

    return pw.Column(
      children: [
        // Bold Top Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(20),
          decoration: const pw.BoxDecoration(
            color: headerColor,
             borderRadius: pw.BorderRadius.only(
               bottomLeft: pw.Radius.circular(20), 
               bottomRight: pw.Radius.circular(20)
             ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (profileImage != null) ...[
                 pw.Container(
                   height: 80,
                   width: 80,
                   decoration: pw.BoxDecoration(
                     shape: pw.BoxShape.circle,
                     border: pw.Border.all(color: PdfColors.white, width: 2),
                     image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
                   ),
                 ),
                 pw.SizedBox(width: 20),
              ],
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      cvData.userProfile.fullName,
                      style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                    ),
                    pw.Text(
                       '${cvData.userProfile.email}  •  ${cvData.userProfile.phoneNumber ?? ""}',
                       style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Content
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
               // Summary
               pw.Container(
                 padding: const pw.EdgeInsets.all(12),
                 decoration: pw.BoxDecoration(
                   color: PdfColors.purple50,
                   border: pw.Border.all(color: PdfColors.purple100),
                   borderRadius: pw.BorderRadius.circular(8),
                 ),
                 child: pw.Text(
                   cvData.summary,
                   style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
                 ),
               ),
               pw.SizedBox(height: 20),
               
               // Experience
               pw.Row(
                 children: [
                   pw.Container(width: 4, height: 18, color: accentColor),
                   pw.SizedBox(width: 8),
                   pw.Text('EXPERIENCE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: headerColor)),
                 ]
               ),
               pw.SizedBox(height: 12),
               ...cvData.userProfile.experience.map((exp) => pw.Padding(
                 padding: const pw.EdgeInsets.only(left: 12, bottom: 16),
                 child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(exp.jobTitle, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: accentColor)),
                    pw.Text('${exp.companyName} | ${exp.startDate} - ${exp.endDate ?? "Present"}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text(exp.description, style: const pw.TextStyle(fontSize: 10)),
                 ]),
               )),

               // Skills & Education Grid
               pw.Row(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                   // Skills
                   pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text('SKILLS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: headerColor)),
                      pw.Divider(color: accentColor),
                      pw.Wrap(spacing: 4, runSpacing: 4, children: cvData.userProfile.skills.map((s) => 
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(10), border: pw.Border.all(color: accentColor)),
                          child: pw.Text(s, style: const pw.TextStyle(fontSize: 9, color: accentColor))
                        )
                      ).toList())
                   ])),
                   pw.SizedBox(width: 20),
                   // Education & Certifications
                   pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text('EDUCATION & CERTIFICATIONS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: headerColor)),
                      pw.Divider(color: accentColor),
                      ...cvData.userProfile.education.map((edu) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Text('${edu.schoolName}\n${edu.degree}', style: const pw.TextStyle(fontSize: 10))
                      )),
                      // Certifications
                       if (cvData.userProfile.certifications.isNotEmpty) ...[
                          pw.SizedBox(height: 8),
                          ...cvData.userProfile.certifications.map((cert) => pw.Padding(
                             padding: pw.EdgeInsets.only(bottom: 4),
                             child: pw.Text('${cert.name}\n${cert.issuer} (${cert.date.year})', style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                          )),
                       ]
                   ])),
                 ]
               )
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. Executive Layout (Classic, Serif-like, Formal) ---
  static pw.Widget _buildExecutiveLayout(CVData cvData) {
    // Note: Standard fonts don't include many serif options by default without imports,
    // but Times-Roman is standard PDF font.

    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Classic Header
        pw.Container(
          width: double.infinity,
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 2)),
          ),
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            children: [
              pw.Text(
                cvData.userProfile.fullName.toUpperCase(),
                style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, letterSpacing: 2),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                '${cvData.userProfile.location ?? ""}  |  ${cvData.userProfile.phoneNumber ?? ""}  |  ${cvData.userProfile.email}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Summary
        pw.Text('PROFESSIONAL PROFILE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(cvData.summary, style: const pw.TextStyle(fontSize: 11, lineSpacing: 2)),
        pw.SizedBox(height: 16),
        pw.Divider(thickness: 0.5),
        pw.SizedBox(height: 16),

        // Experience
        pw.Text('PROFESSIONAL EXPERIENCE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        ...cvData.userProfile.experience.map((exp) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
               pw.SizedBox(
                 width: 80, 
                 child: pw.Text(
                   '${exp.startDate}\n-\n${exp.endDate ?? "Present"}', 
                   style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                   textAlign: pw.TextAlign.right,
                 ),
               ),
               pw.SizedBox(width: 16),
               pw.Expanded(
                 child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(exp.jobTitle.toUpperCase(), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(exp.companyName, style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
                    pw.SizedBox(height: 4),
                    pw.Text(exp.description, style: const pw.TextStyle(fontSize: 11)),
                 ])
               )
            ],
          ),
        )),

        // Education, Skills & Certifications
        pw.Divider(thickness: 0.5),
        pw.SizedBox(height: 16),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
               child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children:[
                 pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                 pw.SizedBox(height: 8),
                 ...cvData.userProfile.education.map((edu) => pw.Text('${edu.degree}, ${edu.schoolName}', style: const pw.TextStyle(fontSize: 11)))
               ])
            ),
            pw.SizedBox(width: 24),
            pw.Expanded(
               child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children:[
                 pw.Text('CORE COMPETENCIES', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                 pw.SizedBox(height: 8),
                 pw.Text(cvData.userProfile.skills.join(' • '), style: const pw.TextStyle(fontSize: 11)),
                 
                 // Certifications (New)
                 if (cvData.userProfile.certifications.isNotEmpty) ...[
                   pw.SizedBox(height: 12),
                   pw.Text('CERTIFICATIONS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                   pw.SizedBox(height: 4),
                   ...cvData.userProfile.certifications.map((cert) => pw.Text(
                      '${cert.name} - ${cert.issuer}',
                      style: const pw.TextStyle(fontSize: 10),
                   )),
                 ]
               ])
            ),
          ]
        )
      ],
    );
  }

  // Helper Methods
  static pw.Widget _buildSectionHeader({
    required String title, 
    required String styleId, 
    PdfColor color = PdfColors.black
  }) {
    if (styleId == 'ATS') {
        return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 2),
          pw.Container(height: 1, color: PdfColors.black), // Full width underline
          pw.SizedBox(height: 8),
        ],
      );
    } else if (styleId == 'Modern') {
       return pw.Padding(
         padding: const pw.EdgeInsets.only(bottom: 8),
         child: pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: color, letterSpacing: 1)),
       );
    }
    // Default fallback
    return pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold));
  }

  static pw.Widget _buildExperienceItem(Experience exp, {required bool isATS}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${exp.jobTitle} at ${exp.companyName}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
              if (isATS)
                pw.Text(
                  '${exp.startDate} - ${exp.endDate ?? "Present"}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
            ],
          ),
          if (!isATS) ...[
             pw.Text(
              '${exp.startDate} - ${exp.endDate ?? "Present"}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
          pw.SizedBox(height: 2),
          pw.Text(
            exp.description,
            style: const pw.TextStyle(fontSize: 11), // Slightly bigger for readability
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildEducationItem(Education edu, {required bool isATS}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            edu.schoolName, 
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),
          pw.Text(
            '${edu.degree} (${edu.startDate} - ${edu.endDate ?? "Present"})',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
  
  static pw.Widget _buildCertificationItem(Certification cert, {required bool isATS}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            cert.name, 
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),
          pw.Text(
            '${cert.issuer} (${cert.date.year})',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
}
