// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get welcomeBack => 'Selamat Datang Kembali';

  @override
  String get signInSubtitle => 'Masuk untuk sinkronisasi CV di semua perangkat';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get login => 'Masuk';

  @override
  String get or => 'ATAU';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get signUp => 'Daftar';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get createAccountSubtitle =>
      'Mulai perjalanan karirmu yang lebih baik';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get logIn => 'Masuk';

  @override
  String get pleaseEnterEmail => 'Mohon masukkan email Anda';

  @override
  String get pleaseEnterPassword => 'Mohon masukkan kata sandi Anda';

  @override
  String get pleaseEnterName => 'Mohon masukkan nama Anda';

  @override
  String get passwordMinLength => 'Kata sandi minimal 6 karakter';

  @override
  String get accountCreatedSuccess => 'Akun berhasil dibuat!';

  @override
  String get welcomeBackSuccess => 'Selamat datang kembali!';

  @override
  String get googleSignInSuccess => 'Berhasil masuk dengan Google!';

  @override
  String googleSignInError(Object error) {
    return 'Gagal masuk dengan Google: $error';
  }

  @override
  String get errorDetailsCopied => 'Detail kesalahan disalin ke papan klip';

  @override
  String get technicalDetails => 'DETAIL TEKNIS';

  @override
  String get goHome => 'Ke Beranda';

  @override
  String get close => 'Tutup';

  @override
  String get rewrite => 'Tulis Ulang';

  @override
  String get typeHere => 'Ketik di sini...';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Miring';

  @override
  String get header => 'Judul';

  @override
  String get locationLabel => 'Lokasi (Cari Kota/Kabupaten)';

  @override
  String get locationHint => 'Cth: Palu -> Sulawesi Tengah, Kota Palu';

  @override
  String get schoolLabel => 'Sekolah / Universitas';

  @override
  String get schoolHint => 'Cth: Universitas Indonesia';

  @override
  String get requiredField => 'Wajib diisi';

  @override
  String get syncData => 'Sinkronisasi Data';

  @override
  String get logOut => 'Keluar';

  @override
  String get completeProfileFirst => 'Lengkapi profil dulu untuk hasil terbaik';

  @override
  String get validatingData => 'Memvalidasi data...';

  @override
  String get preparingProfile => 'Menyiapkan profil...';

  @override
  String get continuingToForm => 'Melanjutkan ke form...';

  @override
  String analyzeProfileError(Object error) {
    return 'Gagal menganalisis profil: $error';
  }

  @override
  String get fillJobTitle => 'Isi judul pekerjaan dulu!';

  @override
  String get scanJobPosting => 'Pindai Lowongan Kerja';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get ocrScanning => 'PEMINDAIAN OCR';

  @override
  String get analyzingText => 'Menganalisis teks...';

  @override
  String get identifyingVacancy => 'Mengidentifikasi lowongan...';

  @override
  String get organizingData => 'Menyusun data...';

  @override
  String get finalizing => 'Memproses...';

  @override
  String get jobExtractionSuccess => 'Lowongan kerja berhasil diekstrak!';

  @override
  String get noTextFound => 'Tidak ada teks ditemukan dalam gambar';

  @override
  String get jobExtractionFailed => 'Gagal mengekstrak lowongan kerja';

  @override
  String get targetPosition => 'Target Posisi';

  @override
  String get continueToReview => 'Lanjut: Review Data';

  @override
  String get whatJobApply => 'Mau lamar kerja apa?';

  @override
  String get aiHelpCreateCV =>
      'AI bakal bantuin bikin CV yang pas banget buat tujuan ini.';

  @override
  String get positionHint => 'Posisi (Misal: UI Designer)';

  @override
  String get companyHint => 'Nama Perusahaan (Opsional)';

  @override
  String get requiredFieldFriendly => 'Wajib diisi ya';

  @override
  String get jobDetailLabel => 'Detail / Kualifikasi (Opsional)';

  @override
  String get jobDetailHint =>
      'Paste deskripsi posisi, persyaratan, atau kualifikasi di sini...';

  @override
  String get reviewedByAI => 'Data & Summary telah disesuaikan oleh AI';

  @override
  String get autoFillFromMaster =>
      'Data otomatis diisi dari Master Profile kamu';

  @override
  String get jobInputMissing => 'Error: Job Input tidak ditemukan';

  @override
  String generateSummaryFailed(Object error) {
    return 'Gagal membuat ringkasan: $error';
  }

  @override
  String get masterProfileUpdated => 'Master Profile berhasil diperbarui';

  @override
  String get reviewData => 'Tinjau Data';

  @override
  String get continueChooseTemplate => 'Lanjut: Pilih Template';

  @override
  String get tailoredDataMessage =>
      'Data ini sudah disesuaikan AI agar relevan dengan posisi yang kamu tuju. Cek lagi ya!';

  @override
  String get personalInfo => 'Informasi Personal';

  @override
  String get professionalSummary => 'Ringkasan Profesional';

  @override
  String get workExperience => 'Pengalaman Kerja';

  @override
  String get educationHistory => 'Riwayat Pendidikan';

  @override
  String get certifications => 'Sertifikasi';

  @override
  String get skills => 'Keahlian (Skills)';

  @override
  String get summaryHint =>
      'Tulis ringkasan profesional Anda secara singkat...';

  @override
  String get summaryEmpty => 'Ringkasan tidak boleh kosong';

  @override
  String get generateWithAI => 'Buat dengan AI';

  @override
  String get phoneNumber => 'Nomor HP';

  @override
  String get add => 'Tambah';

  @override
  String get noExperience => 'Belum ada pengalaman kerja.';

  @override
  String get present => 'Sekarang';

  @override
  String get schoolName => 'Nama Sekolah';

  @override
  String get degree => 'Gelar / Jurusan';

  @override
  String get degreeHint => 'Sarjana Komputer';

  @override
  String get startDate => 'Masuk';

  @override
  String get endDate => 'Lulus';

  @override
  String get year => 'Tahun';

  @override
  String get addEducation => 'TAMBAH PENDIDIKAN';

  @override
  String get editEducation => 'EDIT PENDIDIKAN';

  @override
  String get cancelAllCaps => 'BATAL';

  @override
  String get saveAllCaps => 'SIMPAN';

  @override
  String get noEducation => 'Belum ada riwayat pendidikan.';

  @override
  String get certificationsLicenses => 'Sertifikasi & Lisensi';

  @override
  String get noCertifications => 'Belum ada sertifikasi.';

  @override
  String get addSkill => 'Tambah Skill';

  @override
  String get skillHint => 'contoh: Flutter, Leadership';

  @override
  String get noSkills => 'Belum ada skill.';

  @override
  String get thinking => 'Berpikir...';

  @override
  String get writing => 'Menulis...';

  @override
  String get fillDescriptionFirst =>
      'Isi deskripsi dulu baru bisa di-rewrite AI!';

  @override
  String get jobTitle => 'Posisi / Jabatan';

  @override
  String get company => 'Perusahaan';

  @override
  String get companyPlaceholder => 'PT Teknologi Maju';

  @override
  String get selectDate => 'Pilih Tanggal';

  @override
  String get untilNow => 'Sampai Sekarang';

  @override
  String get shortDescription => 'Deskripsi Singkat';

  @override
  String get improving => 'Memperbaiki...';

  @override
  String get polishing => 'Memoles...';

  @override
  String get rephrasing => 'Menyusun ulang...';

  @override
  String get rewriteAI => 'Rewrite AI';

  @override
  String get descriptionHint =>
      'Jelaskan tanggung jawab utama dan pencapaianmu...';

  @override
  String get addExperience => 'TAMBAH PENGALAMAN';

  @override
  String get editExperienceTitle => 'EDIT PENGALAMAN';

  @override
  String get addCertification => 'Tambah Sertifikasi';

  @override
  String get editCertification => 'Edit Sertifikasi';

  @override
  String get certificationName => 'Nama Sertifikasi';

  @override
  String get issuer => 'Penerbit (Issuer)';

  @override
  String get dateLabel => 'Tanggal:';

  @override
  String get myDrafts => 'Draft Saya';

  @override
  String get searchJob => 'Cari lowongan...';

  @override
  String get noDrafts => 'Belum ada draft.';

  @override
  String get noMatchingJobs => 'Ga ada lowongan yang cocok.';

  @override
  String get folderEmpty => 'Folder kosong';

  @override
  String get untitled => 'Tanpa Judul';

  @override
  String get created => 'Dibuat';

  @override
  String get atsStandard => 'ATS Standard';

  @override
  String get modernProfessional => 'Modern Professional';

  @override
  String get creativeDesign => 'Creative Design';

  @override
  String get aiPowered => 'AI POWERED';

  @override
  String get createProfessionalCV => 'Buat CV\nProfesional.';

  @override
  String get createFirstCV => 'Buat CV\nPertama Kamu.';

  @override
  String get startNow => 'MULAI SEKARANG';

  @override
  String get importCV => 'Import CV';

  @override
  String get viewDrafts => 'Lihat Draft';

  @override
  String get statistics => 'Statistik';

  @override
  String get createCV => 'Buat CV';

  @override
  String get cvImportedSuccess =>
      'CV berhasil diimport! Mari lengkapi profilmu.';

  @override
  String get cvDataExists => 'Data CV sudah ada di profilmu.';

  @override
  String get loginToSave => 'Login agar datamu tersimpan';

  @override
  String get syncAnywhere => 'Akses dari device manapun, sync otomatis';

  @override
  String get importFromCV => 'IMPORT DARI CV';

  @override
  String get saveProfile => 'Simpan Profil';

  @override
  String get helpSupport => 'Bantuan & Dukungan';

  @override
  String get premiumBadge => 'BELI KREDIT';

  @override
  String get unlockFeatures => 'Isi ulang kredit CV kamu';

  @override
  String get premiumFeaturesDesc =>
      '• Template optimasi ATS\n• Ekspor CV tanpa batas\n• Sinkronisasi cloud antar perangkat\n• Dukungan prioritas';

  @override
  String get premiumComingSoon => 'Premium - Segera hadir!';

  @override
  String get viewPremiumFeatures => 'Lihat Fitur Premium';

  @override
  String get complete => 'Selesai';

  @override
  String get cvs => 'CV';

  @override
  String get experience => 'Pengalaman';

  @override
  String cvImportSuccessWithCount(Object eduCount, Object expCount) {
    return 'CV berhasil diimport!\nDitambahkan: $expCount pengalaman, $eduCount pendidikan';
  }

  @override
  String helloName(Object name) {
    return 'Halo, $name';
  }

  @override
  String get userLevelRookie => 'Pencari Kerja Pemula';

  @override
  String get userLevelMid => 'Profesional Tingkat Menengah';

  @override
  String get userLevelExpert => 'Pembangun Karir Ahli';

  @override
  String get notificationsTitle => 'Notifikasi';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get noNotifications => 'Belum ada notifikasi';

  @override
  String get welcomeTitle => 'Selamat Datang!';

  @override
  String get welcomeMessage => 'Mulai buat CV profesional pertamamu sekarang.';

  @override
  String get cvTipsTitle => 'Tips CV';

  @override
  String get cvTipsMessage =>
      'Cantumkan angka di pencapaian kerjamu agar lebih menarik bagi rekruter.';

  @override
  String get justNow => 'Baru saja';

  @override
  String hoursAgo(Object hours) {
    return '$hours jam yang lalu';
  }

  @override
  String get fillNameError => 'Tolong isi nama lengkap dulu ya.';

  @override
  String get termsAgreePrefix =>
      'Dengan menekan \"MULAI SEKARANG\", kamu setuju dengan ';

  @override
  String get termsOfService => 'Syarat & Ketentuan';

  @override
  String get and => ' dan ';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsAgreeSuffix => ' kami.';

  @override
  String get savingProfile => 'Menyimpan Profil...';

  @override
  String get ready => 'Siap!';

  @override
  String get checkingSystem => 'Mengecek sistem...';

  @override
  String get validatingLink => 'Memvalidasi link...';

  @override
  String get almostThere => 'Sesaat lagi...';

  @override
  String get nextStep => 'LANJUT';

  @override
  String get back => 'Kembali';

  @override
  String get youreAllSet => 'SIAP MELUNCUR!';

  @override
  String get dropYourDetails => 'ISI DATAMU.';

  @override
  String get onboardingSubtitle =>
      'Isi data sekali, generate ribuan CV tanpa ngetik ulang. Hemat waktu, fokus \"grinding\".';

  @override
  String get experienceTitle => 'Pengalaman Kerja';

  @override
  String get experienceSubtitle =>
      'Ceritakan pengalamanmu (kerja, magang, organisasi). AI akan memilih yang paling relevan dengan tujuanmu.';

  @override
  String get educationTitle => 'Riwayat Pendidikan';

  @override
  String get educationSubtitle =>
      'Isi semua riwayat pendidikanmu. AI akan memilih jenjang yang paling relevan untuk ditaruh di CV.';

  @override
  String get certificationTitle => 'Sertifikasi & Lisensi';

  @override
  String get certificationSubtitle =>
      'Masukkan sertifikasi, lisensi, atau penghargaan yang relevan. Ini bisa jadi nilai tambah besar.';

  @override
  String get skillsTitle => 'Skill Kamu Apa Aja?';

  @override
  String get skillsSubtitle =>
      'Tulis semua keahlianmu. AI akan menonjolkan skill yang paling sesuai dengan kebutuhan posisi yang kamu tuju.';

  @override
  String get careerAnalytics => 'Analisis Karir';

  @override
  String get activityOverview => 'Ringkasan Aktivitas';

  @override
  String get keyMetrics => 'Metrik Kunci';

  @override
  String get currentLevel => 'Level Saat Ini';

  @override
  String get keepBuilding =>
      'Terus lengkapi profilmu untuk mencapai level berikutnya!';

  @override
  String get onboardingFinalMessage =>
      'Master Profile aman. Sekarang tinggal sat-set bikin CV.';

  @override
  String get saveChangesTitle => 'Simpan Perubahan?';

  @override
  String get saveChangesMessage =>
      'Kamu punya perubahan yang belum disimpan. Yakin mau keluar?';

  @override
  String get exitWithoutSaving => 'Keluar Tanpa Simpan';

  @override
  String get stayHere => 'Tetap di Sini';

  @override
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  ) {
    return 'CV berhasil diimport!\nDitambahkan: $expCount pengalaman, $eduCount pendidikan, $skillsCount skill';
  }

  @override
  String get profileSavedSuccess =>
      'Profil Disimpan! Bakal dipake buat CV-mu selanjutnya.';

  @override
  String profileSaveError(Object error) {
    return 'Gagal simpan profil: $error';
  }

  @override
  String get importCVTitle => 'Import CV';

  @override
  String get importCVMessage => 'Pilih cara import CV kamu:';

  @override
  String get pdfFile => 'File PDF';

  @override
  String get importingCVBadge => 'IMPORT CV';

  @override
  String get readingCV => 'Membaca CV...';

  @override
  String get extractingData => 'Mengekstrak data...';

  @override
  String get compilingProfile => 'Menyusun profil...';

  @override
  String get readingPDF => 'Membaca PDF...';

  @override
  String get noTextFoundInCV => 'Tidak ada teks yang ditemukan di CV';

  @override
  String get importFailedMessage => 'Gagal mengimport CV. Coba lagi ya!';

  @override
  String get totalCVs => 'Total CV';

  @override
  String get mon => 'Sen';

  @override
  String get tue => 'Sel';

  @override
  String get wed => 'Rab';

  @override
  String get thu => 'Kam';

  @override
  String get fri => 'Jum';

  @override
  String get sat => 'Sab';

  @override
  String get sun => 'Min';

  @override
  String get sendFeedback => 'Kirim Masukan';

  @override
  String get howCanWeHelp => 'Apa yang bisa kami bantu?';

  @override
  String get feedbackSubtitle =>
      'Ceritakan pengalamanmu atau laporkan masalah.';

  @override
  String get category => 'Kategori';

  @override
  String get bugReport => 'Lapor Bug';

  @override
  String get featureRequest => 'Saran Fitur';

  @override
  String get question => 'Pertanyaan';

  @override
  String get other => 'Lainnya';

  @override
  String get messageDetail => 'Pesan / Detail';

  @override
  String get writeSomething => 'Tulis sesuatu dong';

  @override
  String get contactOptional => 'Email / WhatsApp (Opsional)';

  @override
  String get contactHint => 'Biar kami bisa bales...';

  @override
  String get thankYou => 'Terima Kasih!';

  @override
  String get feedbackThanksMessage =>
      'Masukan Anda sangat berharga buat pengembangan CV Master.';

  @override
  String get contactSupport => 'Hubungi Support';

  @override
  String get feedback => 'Masukan';

  @override
  String get suggestionsBugs => 'Saran & Bug';

  @override
  String get frequentQuestions => 'Pertanyaan Umum';

  @override
  String get faqFreeQuestion => 'Apakah CV Master gratis?';

  @override
  String get faqFreeAnswer =>
      'Ya, fitur dasar gratis. Kami mungkin menambahkan fitur premium nanti.';

  @override
  String get faqEditQuestion => 'Bagaimana cara mengubah profil?';

  @override
  String get faqEditAnswer =>
      'Pergi ke menu Profile, edit bagian yang diinginkan, lalu simpan.';

  @override
  String get faqDataQuestion => 'Apakah data saya aman?';

  @override
  String get faqDataAnswer =>
      'Data disimpan lokal. Data ke AI hanya diproses sesaat dan tidak disimpan pihak ketiga.';

  @override
  String get faqPdfQuestion => 'Bisa export ke PDF?';

  @override
  String get faqPdfAnswer =>
      'Tentu! Setelah selesai, tekan tombol Download/Print PDF di preview.';

  @override
  String get cantOpenEmail => 'Tidak bisa membuka aplikasi email.';

  @override
  String get incompleteData =>
      'Data tidak lengkap. Kembali ke form sebelumnya.';

  @override
  String pdfOpenError(Object error) {
    return 'Gagal membuka PDF: $error';
  }

  @override
  String pdfGenerateError(Object error) {
    return 'Gagal membuat PDF: $error';
  }

  @override
  String templateLoadError(Object error) {
    return 'Gagal memuat template: $error';
  }

  @override
  String get retry => 'Coba Lagi';

  @override
  String get generatingPdfBadge => 'MEMBUAT PDF';

  @override
  String get processingData => 'Memproses Data...';

  @override
  String get applyingDesign => 'Menerapkan Desain...';

  @override
  String get creatingPages => 'Membuat Halaman...';

  @override
  String get finalizingPdf => 'Finalisasi PDF...';

  @override
  String get loadingTemplatesBadge => 'MEMUAT TEMPLATE';

  @override
  String get fetchingTemplates => 'Mengambil Template...';

  @override
  String get preparingGallery => 'Menyiapkan Galeri...';

  @override
  String get loadingPreview => 'Memuat Preview...';

  @override
  String get selectTemplate => 'PILIH TEMPLATE';

  @override
  String get premium => 'PREMIUM';

  @override
  String get exportPdf => 'EKSPORT PDF';

  @override
  String get failed => 'Gagal';

  @override
  String get unknownError => 'Kesalahan Tidak Diketahui';

  @override
  String get unknownErrorDesc =>
      'Terjadi kesalahan, tapi kami tidak yakin apa penyebabnya.';

  @override
  String get readyToAchieve => 'Siap mencapai tujuan karirmu?';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteAccount => 'Hapus Akun';

  @override
  String get deleteMyData => 'Hapus Data Saya';

  @override
  String get deleteAccountQuestion => 'Hapus Akun?';

  @override
  String get deleteAccountWarning =>
      'Tindakan ini tidak dapat dibatalkan. Semua data Anda, termasuk CV yang dihasilkan dan kredit, akan dihapus secara permanen.';

  @override
  String get accountDeletedGoodbye => 'Akun berhasil dihapus. Sampai jumpa!';

  @override
  String accountDeleteError(Object error) {
    return 'Gagal menghapus akun: $error';
  }

  @override
  String get keepLocalData => 'Simpan data lokal saya (Master Profile)';

  @override
  String get clearLocalData => 'Hapus juga data lokal (Reset Total)';

  @override
  String creditWarning(int count) {
    return 'Peringatan: Anda masih memiliki $count kredit. Kredit ini tidak dapat diuangkan kembali.';
  }

  @override
  String get confirmDelete => 'Konfirmasi Penghapusan';

  @override
  String get deleteConfirmation =>
      'Apakah Anda yakin ingin menghapus item ini?';

  @override
  String get verifyYourEmail => 'Verifikasi Email Anda';

  @override
  String verificationSentTo(String email) {
    return 'Link verifikasi telah dikirim ke $email. Silakan cek kotak masuk dan folder spam Anda.';
  }

  @override
  String get checkSpamFolder =>
      'Tidak ketemu? Coba cek folder Spam atau Junk kamu.';

  @override
  String get iHaveVerified => 'SAYA SUDAH VERIFIKASI';

  @override
  String get resendEmail => 'Kirim Ulang Email Verifikasi';

  @override
  String get backToLogin => 'Kembali ke Login';

  @override
  String get sending => 'Mengirim...';

  @override
  String get verificationEmailSent => 'Email verifikasi terkirim!';

  @override
  String get emailVerifiedSuccess => 'Email berhasil diverifikasi!';

  @override
  String get emailNotVerifiedYet =>
      'Email belum diverifikasi. Silakan cek kotak masuk Anda.';

  @override
  String get alreadyHaveCV => 'Sudah punya CV?';

  @override
  String get alreadyHaveCVSubtitle =>
      'Percepat prosesnya! Import CV yang sudah ada, semua data langsung terisi otomatis.';

  @override
  String get importExistingCV => 'Import CV Saya';

  @override
  String get importExistingCVDesc => 'Upload PDF atau foto — AI isi sisanya.';

  @override
  String get startFromScratch => 'Mulai dari Awal';

  @override
  String get startFromScratchDesc =>
      'Isi setiap bagian secara manual, langkah demi langkah.';

  @override
  String get skipForNow => 'Lewati dulu';

  @override
  String stepLabel(Object current, Object label, Object total) {
    return 'Langkah $current dari $total — $label';
  }

  @override
  String get stepPersonalInfo => 'Info Pribadi';

  @override
  String get stepImportCV => 'Setup Cepat';

  @override
  String get stepExperience => 'Pengalaman';

  @override
  String get stepEducation => 'Pendidikan';

  @override
  String get stepCertifications => 'Sertifikasi';

  @override
  String get stepSkills => 'Keahlian';

  @override
  String get stepFinish => 'Selesai';

  @override
  String get home => 'Beranda';

  @override
  String get wallet => 'Dompet';

  @override
  String get profile => 'Profil';

  @override
  String get creditBalance => 'Saldo Kredit';

  @override
  String get credits => 'kredit';

  @override
  String get usageHistoryComingSoon => 'Riwayat penggunaan segera hadir';

  @override
  String get myCVs => 'CV Saya';

  @override
  String get drafts => 'Draf';

  @override
  String get generated => 'Dihasilkan';

  @override
  String get noCompletedCVs => 'Belum ada CV yang dihasilkan';

  @override
  String get generateCVFirst => 'Buat CV pertama Anda untuk melihatnya di sini';

  @override
  String get openPDF => 'Buka PDF';

  @override
  String get newNotification => 'Notifikasi Baru';

  @override
  String get cvGeneratedSuccess => 'CV Berhasil Dibuat';

  @override
  String cvReadyMessage(Object jobTitle) {
    return 'CV Anda untuk $jobTitle sudah siap!';
  }

  @override
  String get forgotPassword => 'Lupa Kata Sandi';

  @override
  String get forgotPasswordResetMessage =>
      'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.';

  @override
  String get sendResetLink => 'Kirim Tautan Reset';

  @override
  String get notificationNew => 'Notifikasi Baru';

  @override
  String get notificationChannelCVTitle => 'Pembuatan CV';

  @override
  String get notificationChannelCVDesc =>
      'Notifikasi untuk update pembuatan CV';

  @override
  String get notificationChannelGeneralTitle => 'Peringatan Umum';

  @override
  String get notificationChannelGeneralDesc => 'Notifikasi aplikasi umum';

  @override
  String get authWallCreateCV => 'Login untuk membuat CV';

  @override
  String get authWallCreateCVDesc =>
      'Kamu perlu login untuk membuat dan menyimpan CV';

  @override
  String get authWallBuyCredits => 'Login untuk beli kredit';

  @override
  String get authWallBuyCreditsDesc =>
      'Kamu perlu login untuk bisa membeli kredit';

  @override
  String get authWallSelectTemplate => 'Login untuk pilih template';

  @override
  String get authWallSelectTemplateDesc =>
      'Kamu perlu login untuk bisa memilih template';

  @override
  String get onboardingHeadline1 => 'Masih ngedit CV jam 1 pagi?';

  @override
  String get onboardingSubtext1 =>
      'Bikin satu CV \'sapu jagat\' itu gak mempan. Tapi ngedit manual buat tiap lamaran juga capek banget. Kami paham.';

  @override
  String get onboardingHeadline2 => 'Kualifikasi masuk, tapi tetep ditolak?';

  @override
  String get onboardingSubtext2 =>
      'CV kamu mungkin udah ditolak sistem sebelum dibaca HR. Kalau formatnya gak ramah ATS atau kurang keyword persis, kamu otomatis gugur.';

  @override
  String get onboardingHeadline3 => 'Gak perlu mulai dari nol.';

  @override
  String get onboardingSubtext3 =>
      'Punya riwayat karir yang berceceran di CV lama? Upload PDF-nya, kami akan ekstrak dan rapikan seluruh riwayatmu secara instan.';

  @override
  String get onboardingHeadline4 => 'Satukan semuanya di sini.';

  @override
  String get onboardingSubtext4 =>
      'Barista. Kurir. Admin. Konten Kreator. Masukin aja semua pengalamanmu. Urusan relevansi biar kami yang atur.';

  @override
  String get onboardingHeadline5 => 'Screenshot loker. Biar AI yang kerja.';

  @override
  String get onboardingSubtext5 =>
      'Nemu info loker? Screenshot aja. AI kami akan menganalisis syaratnya dan langsung menyorot pengalamanmu yang paling relevan.';

  @override
  String get onboardingHeadline6 => 'Satu profil. CV unlimited.';

  @override
  String get onboardingSubtext6 =>
      'Gak perlu bayar jasa pembuat CV. Gak perlu desain manual. Langsung ganti ke template profesional ramah ATS dengan limit pemakaian yang banyak.';

  @override
  String get onboardingHeadline7 =>
      'Kami pengen bantu kamu dengan clever secara gratis.';

  @override
  String get onboardingSubtext7 =>
      'Kamu gak akan pernah ngetik CV dari nol lagi. Siap buat direkrut?';

  @override
  String get takesLessThan3Min => 'Cuma butuh waktu kurang dari 3 menit.';

  @override
  String get skipIntro => 'Lewati Intro';

  @override
  String get getStarted => 'Mulai Sekarang';

  @override
  String get next => 'Lanjut';

  @override
  String get cvLanguage => 'Bahasa CV';

  @override
  String get previewCV => 'Pratinjau CV';

  @override
  String get regenerateSummary => 'Regenerasi Ringkasan';

  @override
  String get summaryRegenerating => 'Meregenerasi ringkasan...';
}
