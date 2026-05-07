class PDFGenerationResult {
  final List<int> bytes;
  final String pdfUrl;
  final String? remotePath;

  PDFGenerationResult({
    required this.bytes,
    required this.pdfUrl,
    this.remotePath,
  });
}
