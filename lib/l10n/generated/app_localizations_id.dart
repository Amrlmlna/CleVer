// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String years(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tahun',
    );
    return '$_temp0';
  }

  @override
  String months(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulan',
    );
    return '$_temp0';
  }

  @override
  String weeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minggu',
    );
    return '$_temp0';
  }

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
    );
    return '$_temp0';
  }

  @override
  String hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam',
    );
    return '$_temp0';
  }

  @override
  String minutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit',
    );
    return '$_temp0';
  }

  @override
  String get add => 'tambah';

  @override
  String get added => 'ditambahkan';

  @override
  String get analyzingText => 'menganalisis teks...';

  @override
  String get and => ' dan ';

  @override
  String get applyingDesign => 'menerapkan desain...';

  @override
  String get back => 'kembali';

  @override
  String get bold => 'tebal';

  @override
  String get camera => 'kamera';

  @override
  String get cancel => 'batal';

  @override
  String get checkingSystem => 'mengecek sistem...';

  @override
  String get clearLocalData => 'hapus juga data lokal (reset total)';

  @override
  String get close => 'tutup';

  @override
  String get complete => 'selesai';

  @override
  String get continueChooseTemplate => 'lanjut: pilih template';

  @override
  String get continueToReview => 'lanjut: review data';

  @override
  String get creatingPages => 'membuat halaman...';

  @override
  String get download => 'unduh';

  @override
  String get downloadPDF => 'unduh pdf';

  @override
  String get downloadPDFDescription =>
      'pdf ini tersimpan di cloud. apakah anda ingin mengunduhnya sekarang?';

  @override
  String get downloadComplete => 'unduhan selesai';

  @override
  String downloadFailed(String error) {
    return 'unduhan gagal: $error';
  }

  @override
  String get downloading => 'mengunduh...';

  @override
  String get finalStatus => 'final';

  @override
  String get untitled => 'tanpa judul';

  @override
  String get openPDF => 'buka pdf';

  @override
  String get delete => 'hapus';

  @override
  String get exitWithoutSaving => 'Abaikan';

  @override
  String get failed => 'gagal';

  @override
  String get male => 'laki-laki';

  @override
  String get female => 'perempuan';

  @override
  String get gender => 'jenis kelamin';

  @override
  String get viewAll => 'lihat semua';

  @override
  String get finalizing => 'memproses...';

  @override
  String get finalizingPdf => 'finalisasi pdf...';

  @override
  String get gallery => 'galeri';

  @override
  String get generatingPdfBadge => 'membuat pdf';

  @override
  String get goHome => 'ke beranda';

  @override
  String get identifyingVacancy => 'mengidentifikasi lowongan...';

  @override
  String get improving => 'memperbaiki...';

  @override
  String get italic => 'miring';

  @override
  String get keepLocalData => 'simpan data lokal saya (master profile)';

  @override
  String get loadingPreview => 'memuat preview...';

  @override
  String get next => 'lanjut';

  @override
  String get or => 'atau';

  @override
  String get organizingData => 'menyusun data...';

  @override
  String get other => 'lainnya';

  @override
  String get pdfFile => 'file pdf';

  @override
  String get polishing => 'memoles...';

  @override
  String get preparingGallery => 'menyiapkan galeri...';

  @override
  String get preparingProfile => 'menyiapkan profil...';

  @override
  String get present => 'sekarang';

  @override
  String get previewCV => 'pratinjau cv';

  @override
  String get processingData => 'memproses data...';

  @override
  String get ready => 'siap!';

  @override
  String get rephrasing => 'menyusun ulang...';

  @override
  String get requiredField => 'wajib diisi';

  @override
  String get requiredFieldFriendly => 'wajib diisi ya';

  @override
  String get retry => 'coba lagi';

  @override
  String get save => 'simpan';

  @override
  String get saveAllCaps => 'simpan';

  @override
  String get selectDate => 'pilih tanggal';

  @override
  String get skipIntro => 'lewati';

  @override
  String get startNow => 'mulai sekarang';

  @override
  String get stayHere => 'Batal';

  @override
  String get syncAnywhere => 'akses dari device manapun, sync otomatis';

  @override
  String get syncData => 'sinkronisasi data';

  @override
  String get typeHere => 'ketik di sini...';

  @override
  String get unknownError => 'kesalahan tidak diketahui';

  @override
  String get unknownErrorDesc =>
      'terjadi kesalahan, tapi kami tidak yakin apa penyebabnya.';

  @override
  String get update => 'perbarui';

  @override
  String get untilNow => 'sampai sekarang';

  @override
  String get uploadInstruction =>
      'ketuk untuk mengunggah foto profesional anda';

  @override
  String get uploadingPhoto => 'mengunggah foto...';

  @override
  String get validatingData => 'memvalidasi data...';

  @override
  String get validatingLink => 'memvalidasi link...';

  @override
  String get writeSomething => 'tulis sesuatu dong';

  @override
  String get year => 'tahun';

  @override
  String get uploadPhoto => 'unggah foto';

  @override
  String get cleverYes => 'iya';

  @override
  String get cleverNo => 'tidak';

  @override
  String get total => 'total';

  @override
  String get searchResult => 'hasil pencarian';

  @override
  String get alreadyHaveAccount => 'sudah punya akun?';

  @override
  String get authWallBuyCredits => 'masuk untuk dapat pass';

  @override
  String get authWallBuyCreditsDesc =>
      'kamu perlu masuk untuk mengaktifkan job hunter pass';

  @override
  String get authWallCreateCV => 'masuk untuk membuat cv';

  @override
  String get authWallCreateCVDesc =>
      'masuk biar kamu bisa akses master profile dan draft kamu dimana aja.';

  @override
  String get authWallSelectTemplate => 'masuk untuk pilih template';

  @override
  String get authWallSelectTemplateDesc =>
      'kamu perlu masuk untuk bisa memilih template';

  @override
  String get cantOpenEmail => 'tidak bisa membuka aplikasi email.';

  @override
  String get checkSpamFolder =>
      'tidak ketemu? coba cek folder spam atau junk kamu.';

  @override
  String get continueWithGoogle => 'lanjutkan dengan google';

  @override
  String get createAccount => 'buat akun';

  @override
  String get dontHaveAccount => 'belum punya akun?';

  @override
  String get email => 'email';

  @override
  String get emailNotVerifiedYet =>
      'email belum diverifikasi. silakan cek kotak masuk anda.';

  @override
  String get emailVerifiedSuccess => 'email berhasil diverifikasi!';

  @override
  String get forgotPassword => 'lupa kata sandi';

  @override
  String get forgotPasswordResetMessage =>
      'masukkan alamat email anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi anda.';

  @override
  String get iHaveVerified => 'saya sudah verifikasi';

  @override
  String get logIn => 'masuk';

  @override
  String get login => 'masuk';

  @override
  String get loginToSave => 'login untuk akses semua fitur';

  @override
  String get password => 'kata sandi';

  @override
  String get passwordMinLength => 'kata sandi minimal 6 karakter';

  @override
  String get pleaseEnterEmail => 'mohon masukkan email anda';

  @override
  String get resendEmail => 'kirim ulang email verifikasi';

  @override
  String get sendResetLink => 'kirim tautan reset';

  @override
  String get signUp => 'daftar';

  @override
  String get unlockFeatures => 'aktifkan job hunter pass';

  @override
  String get userNotLoggedIn => 'pengguna tidak masuk';

  @override
  String get verificationEmailSent => 'email verifikasi terkirim!';

  @override
  String verificationSentTo(String email) {
    return 'link verifikasi telah dikirim ke $email. silakan cek kotak masuk dan folder spam anda.';
  }

  @override
  String get verifyYourEmail => 'verifikasi email anda';

  @override
  String get cleverGetStartedTitle => 'Kenalan dulu, Yuk!';

  @override
  String get cleverGetStartedSubtitle1 =>
      'lebih percaya diri dengan tailored cv.';

  @override
  String get cleverGetStartedSubtitle2 => 'tanpa perlu ngedit manual lagi.';

  @override
  String get cleverSignInGreeting => 'selamat datang kembali!';

  @override
  String get cleverGoogleSignUp => 'Daftar dengan Google';

  @override
  String get cleverGoogleSignIn => 'Masuk dengan Google';

  @override
  String get cleverEmailInvalid => 'masukkan email yang valid';

  @override
  String get cleverConsentLine =>
      'Saya sudah membaca Kebijakan Privasi dan S&K';

  @override
  String get addCertification => 'tambah sertifikasi';

  @override
  String get addEducation => 'tambah pendidikan';

  @override
  String get addExperience => 'tambah pengalaman';

  @override
  String get addSubject => 'tambah mata kuliah';

  @override
  String get addSkill => 'tambah skill';

  @override
  String get birthDate => 'tanggal lahir';

  @override
  String get certificationName => 'nama sertifikasi';

  @override
  String get certificationTitle => 'sertifikasi & lisensi';

  @override
  String get certifications => 'sertifikasi';

  @override
  String get certificationsLicenses => 'sertifikasi & lisensi';

  @override
  String get company => 'perusahaan';

  @override
  String get companyHint => 'nama perusahaan (opsional)';

  @override
  String get contactHint => 'biar kami bisa bales...';

  @override
  String get contactOptional => 'email / whatsapp (opsional)';

  @override
  String get degree => 'gelar / jurusan';

  @override
  String get descriptionHint =>
      'jelaskan tanggung jawab utama dan pencapaianmu...';

  @override
  String get educationHistory => 'riwayat pendidikan';

  @override
  String get educationTitle => 'riwayat pendidikan';

  @override
  String get endDate => 'lulus';

  @override
  String get experience => 'pengalaman';

  @override
  String get experienceTitle => 'pengalaman kerja';

  @override
  String get fullName => 'nama lengkap';

  @override
  String get header => 'judul';

  @override
  String get issuer => 'penerbit (issuer)';

  @override
  String get jobTitle => 'posisi / jabatan';

  @override
  String get locationHint => 'cth: palu -> sulawesi tengah, kota palu';

  @override
  String get locationLabel => 'lokasi (cari kota/kabupaten)';

  @override
  String get noCertifications => 'belum ada sertifikasi.';

  @override
  String get noEducation => 'belum ada riwayat pendidikan.';

  @override
  String get noExperience => 'belum ada pengalaman kerja.';

  @override
  String get noSkills => 'belum ada skill.';

  @override
  String get personalInfo => 'informasi kontak';

  @override
  String get phoneNumber => 'nomor hp';

  @override
  String get positionHint => 'posisi (misal: ui designer)';

  @override
  String get professionalSummary => 'ringkasan profesional';

  @override
  String get scanKHSTitle => 'Scan Kartu Hasil Studi (KHS)';

  @override
  String get scanKHSMessage =>
      'Pilih sumber untuk mengambil IPK dan mata kuliah';

  @override
  String get academicSubjects => 'mata kuliah akademik';

  @override
  String get subjectName => 'nama mata kuliah';

  @override
  String get gradeOptional => 'nilai (opsional)';

  @override
  String get whatDidYouLearn => 'apa yang kamu pelajari? (opsional)';

  @override
  String get gpaLabel => 'GPA / IPK';

  @override
  String get educationDescriptionLabel => 'deskripsi / penghargaan';

  @override
  String get educationDescriptionHint =>
      'cth: Summa Cum Laude, Jurusan Ilmu Komputer';

  @override
  String get schoolHint => 'cth: universitas indonesia';

  @override
  String get schoolLabel => 'sekolah / universitas';

  @override
  String get schoolName => 'nama sekolah';

  @override
  String get shortDescription => 'deskripsi singkat';

  @override
  String get skills => 'keahlian';

  @override
  String get skillsSubtitle =>
      'tulis semua keahlianmu. ai akan menonjolkan skill yang paling sesuai dengan kebutuhan posisi yang kamu tuju.';

  @override
  String get skillsTitle => 'skill kamu apa aja?';

  @override
  String get startDate => 'masuk';

  @override
  String get summaryEmpty => 'ringkasan tidak boleh kosong';

  @override
  String get summaryHint =>
      'tulis ringkasan profesional anda secara singkat...';

  @override
  String get targetPosition => 'target posisi';

  @override
  String get whatJobApply => 'mau lamar kerja apa?';

  @override
  String get workExperience => 'pengalaman kerja';

  @override
  String get mascotWelcome => 'tetap update ya';

  @override
  String get mascotWelcomeSub =>
      'jangan lupa update profil master kamu setiap kali ada pengalaman baru!';

  @override
  String get mascotEncourage => 'mari kita mulai';

  @override
  String get mascotEncourageSub =>
      'perjalanan karir yang lebih baik dimulai dari sini.';

  @override
  String get mascotExciting => 'wih, keren!';

  @override
  String get mascotExcitingSub =>
      'kamu baru saja membuat cv pertama! yuk, lanjut terus semangatnya.';

  @override
  String get cleverWelcomePersonaTitle => 'Kamu tim yang mana?';

  @override
  String get cleverPersonaStudent => 'pelajar';

  @override
  String get cleverPersonaJobSeeker => 'pencari kerja aktif';

  @override
  String get cleverPersonaCareerSwitcher => 'berpindah karir';

  @override
  String get cleverWelcomeBudgetTitle =>
      'Berapa budget yang pernah kamu keluarin untuk jasa satu CV?';

  @override
  String get cleverWelcomeSingleCvTitle =>
      'apakah kamu hanya punya 1 CV untuk semua lowongan?';

  @override
  String get cleverWelcomeAppsTitle =>
      'berapa lowongan yang kamu apply dalam sehari?';

  @override
  String get cleverWelcomeReasonTitle =>
      'apa alasan kamu mager bikin CV tailored?';

  @override
  String get cleverReasonCompanyResearch => 'riset perusahaan';

  @override
  String get cleverReasonRepromptAi => 're-prompt chatGPT';

  @override
  String get cleverReasonManualTemplate => 'edit template manual';

  @override
  String get cleverReasonRepeatedForms => 'isi form berulang';

  @override
  String get cleverWelcomeThanksTitle => 'Terimakasih telah mempercayai kami.';

  @override
  String get cleverWelcomePrivacyNote =>
      'Privasi dan Keamanan pribadi anda merupakan prioritas utama kami.';

  @override
  String get cleverReadMore => 'baca selengkapnya';

  @override
  String get cleverLegalPendingBody =>
      'Dokumen ini sedang disiapkan dan akan tersedia di sini segera.';

  @override
  String get cleverWelcomeSocialProofTitle =>
      'Apply ke 100 lowongan menjadi efektif dengan CV tailored!';

  @override
  String get cleverIntroTagline => 'Pengalamanmu, selalu dalam jangkauan.';

  @override
  String get cleverIntroSupport =>
      'bangun rekam jejak profesional yang bisa kamu manfaatkan setiap kali peluang datang.';

  @override
  String get cleverIntroCta => 'mulai sekarang';

  @override
  String get cleverPanelHeaderTitle => 'header';

  @override
  String get cleverPanelHeaderSubtitle =>
      'informasi akan ditampilkan pada header CV kamu sebagai detail kontak.';

  @override
  String get cleverPhoneField => 'nomor telepon';

  @override
  String get cleverTooltipBirthDate =>
      'beberapa lowongan punya persyaratan usia — AI tailoring memakai ini untuk mencocokkan kamu.';

  @override
  String get cleverTooltipGender =>
      'beberapa lowongan menyasar gender tertentu — AI tailoring memakai ini untuk mencocokkan kamu.';

  @override
  String cleverYearsOld(Object age) {
    return '$age tahun';
  }

  @override
  String get cleverGenderMale => 'pria';

  @override
  String get cleverGenderFemale => 'wanita';

  @override
  String get cleverGenderNone => 'none';

  @override
  String get cleverConfirmTitle => 'simpan perubahan?';

  @override
  String get cleverConfirmMessage =>
      'ada progres yang belum kamu simpan di profil kamu.';

  @override
  String get cleverConfirmSave => 'simpan draft';

  @override
  String get cleverConfirmDiscard => 'buang';

  @override
  String get cleverMethodTitle => 'pilih metode kamu';

  @override
  String get cleverMethodSubtitle =>
      'Pilih cara yang paling nyaman buat mengisi career Bank kamu.';

  @override
  String get cleverMethodScan => 'scan';

  @override
  String get cleverMethodScanDesc =>
      'import riwayat profesional dari draft cv lama kamu.';

  @override
  String get cleverMethodCerita => 'cerita';

  @override
  String get cleverMethodCeritaDesc =>
      'belum punya CV? ceritain semua riwayat profesional kamu';

  @override
  String get cleverScanSheetSubtitle =>
      'semua riwayat profesional akan diekstrak secara otomatis oleh AI.';

  @override
  String get cleverUploadPhoto => 'unggah foto';

  @override
  String get cleverUploadPhotoHint => 'gunakan kamera atau pilih dari galeri.';

  @override
  String get cleverUploadFile => 'unggah file';

  @override
  String get cleverUploadFileHint => 'pilih dokumen dari perangkat ini.';

  @override
  String get cleverExperienceSubtitle =>
      'masukkan semua pengalaman yang kamu miliki.';

  @override
  String get cleverListLabel => 'daftar';

  @override
  String get cleverEmptyTitle => 'masih kosong nih';

  @override
  String get cleverEmptyExperiencePrompt =>
      'yuk mulai tambahkan pengalaman kerja!';

  @override
  String get cleverSkip => 'lewati';

  @override
  String get cleverDeleteExperienceTitle => 'hapus pengalaman ini?';

  @override
  String get cleverConfirmDelete => 'hapus';

  @override
  String get cleverToggleType => 'ketik';

  @override
  String get cleverToggleDictate => 'dikte';

  @override
  String get cleverEducationSubtitle =>
      'tambahkan dan kelola riwayat pendidikan kamu di sini.';

  @override
  String get cleverEmptyEducationPrompt =>
      'yuk mulai tambahkan pendidikan kamu!';

  @override
  String get cleverDeleteEducationTitle => 'hapus pendidikan ini?';

  @override
  String get cleverCertificationSubtitle =>
      'tambahkan dan kelola sertifikasi kamu disini. mulai dari SIM hingga sertifikat profesional.';

  @override
  String get cleverEmptyCertificationPrompt =>
      'yuk mulai tambahkan sertifikasi kamu!';

  @override
  String get cleverDeleteCertificationTitle => 'hapus sertifikasi ini?';

  @override
  String get cleverEmptySkillsPrompt => 'yuk mulai tambahkan keahlian kamu!';

  @override
  String get cleverCompleteTitle => 'semua siap!';

  @override
  String get cleverCompleteSubtitle =>
      'profil kamu sudah lengkap.\nsekarang tinggal bikin CV pertamamu.';

  @override
  String get cleverCompleteSummary => 'ringkasan profil';

  @override
  String cleverCompleteProgress(int completed) {
    return '$completed dari 5';
  }

  @override
  String cleverCompleteCount(int count) {
    return '$count entri';
  }

  @override
  String get cleverCompleteRowHeader => 'header — nama, kontak, tanggal lahir';

  @override
  String get cleverCompleteFootnote =>
      'semua data bisa kamu ubah kapan saja di profil.';

  @override
  String get cleverImportingTitle => 'sedang mengimpor';

  @override
  String get aiAnalyzingProfile => 'ai sedang menganalisis profilmu...';

  @override
  String get aiExtractingInsights => 'mengekstrak wawasan...';

  @override
  String get cvDataExists => 'data cv sudah ada di profilmu.';

  @override
  String get cvImportedSuccess =>
      'cv berhasil diimport! mari lengkapi profilmu.';

  @override
  String get importCV => 'import cv';

  @override
  String get importCVMessage => 'pilih cara import cv kamu:';

  @override
  String get importCVTitle => 'import cv';

  @override
  String get importFailedMessage => 'gagal mengimport cv. coba lagi ya!';

  @override
  String get importFromCV => 'import dari cv';

  @override
  String importSuccessMessage(
    Object eduCount,
    Object expCount,
    Object skillsCount,
  ) {
    return 'cv berhasil diimport!\nditambahkan: $expCount pengalaman, $eduCount pendidikan, $skillsCount skill';
  }

  @override
  String get importSuccessTitle => 'import berhasil!';

  @override
  String get importSuccessSubtitle =>
      'berikut data yang kami temukan dari cv-mu:';

  @override
  String get importSuccessPersonalInfo => 'info personal terdeteksi';

  @override
  String importSuccessExperience(int count) {
    return '$count pengalaman';
  }

  @override
  String importSuccessEducation(int count) {
    return '$count pendidikan';
  }

  @override
  String importSuccessSkills(int count) {
    return '$count keahlian';
  }

  @override
  String importSuccessCertifications(int count) {
    return '$count sertifikasi';
  }

  @override
  String get importSuccessContinue => 'lanjutkan';

  @override
  String get importSuccessNoNewData => 'semua data sudah ada di profilmu.';

  @override
  String get jobExtractionFailed => 'gagal mengekstrak lowongan kerja';

  @override
  String get jobExtractionSuccess => 'lowongan kerja berhasil diekstrak!';

  @override
  String get noTextFound => 'tidak ada teks ditemukan dalam gambar';

  @override
  String get noTextFoundInCV => 'tidak ada teks yang ditemukan di cv';

  @override
  String get ocrScanning => 'pemindaian ocr';

  @override
  String get scanJobPosting => 'pindai lowongan kerja';

  @override
  String get searchJob => 'cari folder...';

  @override
  String get cv => 'cv';

  @override
  String get aiAnalysisTitle => 'analisis ai';

  @override
  String get aiTailoringOptions => 'opsi penyesuaian ai';

  @override
  String get aiHelpCreateCV =>
      'ai bakal bantuin bikin cv yang pas banget buat tujuan ini.';

  @override
  String get aiTestingConstraints => 'menguji terhadap batasan ats...';

  @override
  String get maxSkills => 'maksimal skill';

  @override
  String get honestAiFeedback => 'feedback ai jujur';

  @override
  String get honestAiFeedbackDesc => 'dapatkan saran yang tegas & kritis';

  @override
  String get conciseFormat => 'format ringkas';

  @override
  String get conciseFormatDesc => 'fokus pada singkat & dampak';

  @override
  String get cvOutputLanguage => 'bahasa output cv';

  @override
  String get cvOutputLanguageDesc =>
      'ai akan menulis konten cv kamu dalam bahasa ini';

  @override
  String get cvOutputLanguageAuto => 'otomatis';

  @override
  String get atsStandard => 'ats standard';

  @override
  String get autoFillFromMaster =>
      'data otomatis diisi dari master profile kamu';

  @override
  String get createCV => 'buat cv';

  @override
  String get creativeDesign => 'creative design';

  @override
  String get cvGeneratedSuccess => 'cv berhasil dibuat';

  @override
  String cvReadyMessage(Object jobTitle) {
    return 'cv $jobTitle anda sudah siap!';
  }

  @override
  String get generateCVFirst => 'buat cv pertama anda untuk melihatnya di sini';

  @override
  String get cvs => 'cv';

  @override
  String get drafts => 'draf';

  @override
  String get exportPdf => 'eksport pdf';

  @override
  String get fetchingTemplates => 'mengambil template...';

  @override
  String get folderEmpty => 'folder kosong';

  @override
  String get includeProfilePhoto => 'sertakan foto profil';

  @override
  String get jobListScannerHint =>
      'nemu lowongan di sini? screenshot terus pake smart scanner kita buat rapihin data seketika!';

  @override
  String get locked => 'terkunci';

  @override
  String get loadingTemplatesBadge => 'memuat template';

  @override
  String get myCVs => 'cv saya';

  @override
  String get myDrafts => 'draft saya';

  @override
  String get noDrafts => 'belum ada draft.';

  @override
  String get noMatchingPdfs => 'ga ada pdf yang cocok.';

  @override
  String get searchGeneratedCvs => 'cari cv yang dihasilkan...';

  @override
  String get premium => 'premium';

  @override
  String get previewTemplate => 'pratinjau template';

  @override
  String get requirementsCheckLabel => 'cek persyaratan:';

  @override
  String get reviewData => 'tinjau data';

  @override
  String get reviewedByAI => 'data & summary telah disesuaikan oleh ai';

  @override
  String get selectTemplate => 'pilih template';

  @override
  String get tailoredDataMessage =>
      'data ini sudah disesuaikan ai agar relevan dengan posisi yang kamu tuju. cek lagi ya!';

  @override
  String templateLoadError(Object error) {
    return 'gagal memuat template: $error';
  }

  @override
  String get usingMasterPhoto => 'menggunakan foto master profile';

  @override
  String get viewDrafts => 'lihat draft';

  @override
  String get generateCvFree => 'buat cv';

  @override
  String get cvExport => 'ekspor cv';

  @override
  String freeExportsLeft(Object count) {
    return 'sisa $count ekspor gratis';
  }

  @override
  String get exports => 'ekspor';

  @override
  String get templateRequiresPhoto => 'template ini membutuhkan gambar';

  @override
  String get templateRequiresPhotoDesc =>
      'kamu memilih versi template dengan foto profil, tapi belum ada foto yang diunggah.';

  @override
  String get useStyleWithoutPhoto => 'gunakan versi template tanpa foto';

  @override
  String accountDeleteError(Object error) {
    return 'gagal menghapus akun: $error';
  }

  @override
  String get accountDeletedGoodbye => 'akun berhasil dihapus. sampai jumpa!';

  @override
  String get quickActions => 'aksi cepat';

  @override
  String get cleverUser => 'pengguna clever';

  @override
  String get bugReport => 'lapor bug';

  @override
  String get completeProfileFirst => 'lengkapi profil dulu untuk hasil terbaik';

  @override
  String get confirmDelete => 'konfirmasi penghapusan';

  @override
  String get contactSupport => 'hubungi support';

  @override
  String get noCompletedCVs => 'belum ada cv yang dihasilkan';

  @override
  String get deleteAccount => 'hapus akun';

  @override
  String get deleteAccountQuestion => 'hapus akun?';

  @override
  String get deleteAccountWarning =>
      'tindakan ini tidak dapat dibatalkan. semua data anda, termasuk cv yang dihasilkan dan langganan aktif, akan dihapus secara permanen.';

  @override
  String get deleteConfirmation =>
      'apakah anda yakin ingin menghapus item ini?';

  @override
  String get editExperienceTitle => 'edit pengalaman';

  @override
  String get faqDataAnswer =>
      'data disimpan lokal. data ke ai hanya diproses sesaat dan tidak disimpan pihak ketiga.';

  @override
  String get faqDataQuestion => 'apakah data saya aman?';

  @override
  String get faqEditAnswer =>
      'pergi ke menu profile, edit bagian yang diinginkan, lalu simpan.';

  @override
  String get faqEditQuestion => 'bagaimana cara mengubah profil?';

  @override
  String get faqFreeAnswer =>
      'ya, fitur dasar gratis. kami mungkin menambahkan fitur premium nanti.';

  @override
  String get faqFreeQuestion => 'apakah cv master gratis?';

  @override
  String get faqPdfAnswer =>
      'tentu! setelah selesai, tekan tombol download/print pdf di preview.';

  @override
  String get faqPdfQuestion => 'bisa export ke pdf?';

  @override
  String get featureRequest => 'saran fitur';

  @override
  String get feedback => 'masukan';

  @override
  String get feedbackSubtitle =>
      'ceritakan pengalamanmu atau laporkan masalah.';

  @override
  String get message => 'pesan';

  @override
  String get recentTransactions => 'transaksi terakhir';

  @override
  String get feedbackThanksMessage =>
      'masukan anda sangat berharga buat pengembangan clever.';

  @override
  String get frequentQuestions => 'pertanyaan umum';

  @override
  String get helpSupport => 'bantuan & dukungan';

  @override
  String get home => 'beranda';

  @override
  String get howCanWeHelp => 'apa yang bisa kami bantu?';

  @override
  String get logOut => 'keluar';

  @override
  String get masterProfileUpdated => 'master profile berhasil diperbarui';

  @override
  String get noMatchingJobs => 'ga ada lowongan yang cocok.';

  @override
  String get noNotifications => 'belum ada notifikasi';

  @override
  String get notificationChannelCVDesc =>
      'notifikasi untuk update pembuatan cv';

  @override
  String get notificationChannelCVTitle => 'pembuatan cv';

  @override
  String get notificationChannelGeneralDesc => 'notifikasi aplikasi umum';

  @override
  String get notificationChannelGeneralTitle => 'peringatan umum';

  @override
  String get notificationNew => 'notifikasi baru';

  @override
  String get notifications => 'notifikasi';

  @override
  String get photoSettings => 'pengaturan foto';

  @override
  String photoUpdateError(String error) {
    return 'gagal mengunggah foto: $error';
  }

  @override
  String get photoUpdateSuccess => 'foto profil berhasil diperbarui!';

  @override
  String get profilePhotoExportTooltip =>
      'foto ini akan digunakan untuk setiap ekspor pdf yang menyertakan foto.';

  @override
  String get privacyPolicy => 'kebijakan privasi';

  @override
  String get profile => 'profil';

  @override
  String get profileSavedSuccess =>
      'profil disimpan! bakal dipake buat cv-mu selanjutnya.';

  @override
  String get saveChangesMessage =>
      'Ada perubahan yang belum disimpan. Ingin simpan dulu sebelum keluar?';

  @override
  String get saveChangesTitle => 'Perubahan Belum Tersimpan';

  @override
  String get saveProfile => 'simpan profil';

  @override
  String get sendFeedback => 'kirim masukan';

  @override
  String get suggestionsBugs => 'saran & bug';

  @override
  String get termsOfService => 'syarat & ketentuan';

  @override
  String get wallet => 'premium';

  @override
  String get noTransactionsYet => 'belum ada transaksi';

  @override
  String get failedToLoadTransactions => 'gagal memuat transaksi';

  @override
  String get transactionHistory => 'riwayat transaksi';

  @override
  String get reviewPromptTitle => 'suka dengan CV barumu?';

  @override
  String get reviewPromptContent =>
      'dukunganmu bikin Clever tetap hidup. kalau kamu senang, ulasan singkat darimu sangat berarti buat kami!';

  @override
  String get reviewPromptPositive => 'ya, saya suka!';

  @override
  String get reviewPromptNegative => 'perlu diperbaiki';

  @override
  String get tutorialJobOcrTitle => 'scan lowongan kerja';

  @override
  String get tutorialJobOcrDesc =>
      'tau gak? ada fitur scan screenshot lowongan kerja buat kamu yang mager ngetik';

  @override
  String get tutorialDraftsTitle => 'draft kamu';

  @override
  String get tutorialDraftsDesc =>
      'kamu bisa edit draft kamu di sini dan export dengan desain lain kapan saja.';

  @override
  String get tutorialProfileTitle => 'profil master';

  @override
  String get tutorialProfileDesc =>
      'rutin update dan kelola master profile kamu disini biar bikin cv makin low effort!.';

  @override
  String get tutorialNext => 'lanjut';

  @override
  String get tutorialFinish => 'siap!';

  @override
  String get active => 'aktif';

  @override
  String get activePass => 'pass aktif';

  @override
  String get free => 'gratis';

  @override
  String get membershipStatus => 'status keanggotaan';

  @override
  String get subscriptionWarning =>
      'anda memiliki job hunter pass yang aktif. menghapus akun akan menghentikan akses anda segera dan tidak dapat dikembalikan.';

  @override
  String get jobHunterPass => 'job hunter pass';

  @override
  String get getJobHunterPassNow => 'berlangganan';

  @override
  String get paywallHeadline => 'Raih Pekerjaan Impianmu';

  @override
  String get bestValue => 'Nilai Terbaik';

  @override
  String get downsellHeadline => 'Butuh Buat Hari Ini Aja?';

  @override
  String get downsellCta => 'Coba Selama 24 Jam';

  @override
  String get downsellTrust => 'Tanpa perpanjangan otomatis · Sekali beli';

  @override
  String get noThanks => 'Tidak, terima kasih';

  @override
  String get paywallSimpleBenefit =>
      'akses semua fitur dan template secara unlimited. tanpa iklan';

  @override
  String get product24hTitle => 'Pass 24 Jam';

  @override
  String get product24hDesc => 'Akses penuh selama 24 jam';

  @override
  String get product3dTitle => 'Pass 3 Hari';

  @override
  String get product3dDesc => 'Akses penuh selama 3 hari';

  @override
  String get productWeeklyTitle => 'Mingguan';

  @override
  String productWeeklyDesc(String price) {
    return 'setara $price/hari';
  }

  @override
  String get productMonthlyTitle => 'Bulanan';

  @override
  String productMonthlyDesc(String price) {
    return 'setara $price/hari';
  }

  @override
  String get productYearlyTitle => 'Tahunan';

  @override
  String productYearlyDesc(String price) {
    return 'setara $price/hari';
  }

  @override
  String get productLifetimeTitle => 'Akses Selamanya';

  @override
  String get productLifetimeDesc => 'Sekali bayar · Selamanya';

  @override
  String get passLifetime => 'selamanya';

  @override
  String get activate => 'aktifkan';

  @override
  String subscriptionExpiryCount(String time) {
    return 'berakhir dalam $time';
  }

  @override
  String get upgradeNow => 'upgrade';

  @override
  String get weekly => 'mingguan';

  @override
  String get yearly => 'tahunan';

  @override
  String get deviceLimitReached =>
      'Batas perangkat tercapai. Ekspor gratis dibatasi 2 per perangkat.';

  @override
  String get lifetimeAccessActive => 'Akses Selamanya Aktif!';

  @override
  String get lifetimeAccessActiveDesc =>
      'Nikmati pembuatan CV tanpa batas dan template premium selamanya. Tidak perlu tindakan lebih lanjut.';

  @override
  String get upgradeToLifetime => 'Upgrade ke Akses Selamanya';

  @override
  String get upgradeToLifetimeDesc =>
      'Dapatkan akses tanpa batas selamanya dan hentikan tagihan berulang.';

  @override
  String get cancelRecurringWarning =>
      'Kamu masih memiliki langganan aktif. Konfirmasi sekarang untuk langsung beralih ke Akses Selamanya!';

  @override
  String get almostThere => 'sesaat lagi...';

  @override
  String analyzeProfileError(Object error) {
    return 'gagal menganalisis profil: $error';
  }

  @override
  String get category => 'kategori';

  @override
  String get continuingToForm => 'melanjutkan ke form...';

  @override
  String get created => 'dibuat';

  @override
  String get dateLabel => 'tanggal:';

  @override
  String get errorDetailsCopied => 'detail kesalahan disalin ke papan klip';

  @override
  String get fillDescriptionFirst =>
      'isi deskripsi dulu baru bisa di-rewrite ai!';

  @override
  String get fillJobTitle => 'isi judul pekerjaan dulu!';

  @override
  String get fillNameError => 'tolong isi nama lengkap dulu ya.';

  @override
  String get generated => 'pdf';

  @override
  String get getStarted => 'bangun master profile';

  @override
  String get jobDetailHint =>
      'paste deskripsi posisi, persyaratan, atau kualifikasi di sini...';

  @override
  String get jobDetailLabel => 'detail / kualifikasi (opsional)';

  @override
  String get messageDetail => 'pesan / detail';

  @override
  String get allFilter => 'semua';

  @override
  String get question => 'pertanyaan';

  @override
  String get rewrite => 'tulis ulang';

  @override
  String get rewriteAI => 'rewrite ai';

  @override
  String rewriteFailed(String error) {
    return 'gagal menulis ulang: $error';
  }

  @override
  String get sending => 'mengirim...';

  @override
  String get skillHint => 'contoh: flutter, leadership';

  @override
  String get technicalDetails => 'detail teknis';

  @override
  String get thankYou => 'terima kasih!';

  @override
  String get voiceListening => 'mendengarkan...';

  @override
  String get voiceProcessing => 'memproses...';

  @override
  String get voiceParseError => 'gagal memproses suara kamu. coba lagi ya.';

  @override
  String get voiceUseSuara => 'dikte AI';

  @override
  String get voiceAnalyzing => 'menganalisa...';

  @override
  String get voiceAlmostDone => 'hampir selesai...';

  @override
  String get voiceSpeechUnavailable =>
      'Layanan pengenalan suara tidak tersedia';

  @override
  String get voiceTapMicHint => 'Ketuk mikrofon & berbicaralah secara alami';
}
