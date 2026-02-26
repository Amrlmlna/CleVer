import '../../domain/entities/curated_account.dart';

class StaticCuratedAccounts {
  static const List<CuratedAccount> accounts = [
    CuratedAccount(
      id: 'ig_ehenyari',
      name: 'Ehe Nyari Kerja',
      handle: '@ehe.nyari.kerja',
      platform: 'instagram',
      url: 'https://www.instagram.com/ehe.nyari.kerja',
      description: 'Daily updated curated job postings across Indonesia for Gen-Z.',
      tags: ['Fresh Grad', 'Startup', 'Tech'],
      profileImageUrl: 'https://ui-avatars.com/api/?name=Ehe+Nyari&background=random',
    ),
    CuratedAccount(
      id: 'ig_lokerjkt',
      name: 'Loker Jakarta',
      handle: '@loker.jakarta',
      platform: 'instagram',
      url: 'https://www.instagram.com/loker.jakarta.id',
      description: 'The biggest job board specific to the Greater Jakarta area.',
      tags: ['Jakarta', 'Corporate', 'FMCG'],
      profileImageUrl: 'https://ui-avatars.com/api/?name=Loker+JKT&background=random',
    ),
    CuratedAccount(
      id: 'ig_hrd_bacot',
      name: 'HRD Bacot',
      handle: '@hrdbacot',
      platform: 'instagram',
      url: 'https://www.instagram.com/hrdbacot',
      description: 'Career tips, salary transparenty, and premium job postings.',
      tags: ['Tips', 'Premium', 'Remote'],
      profileImageUrl: 'https://ui-avatars.com/api/?name=HRD+Bacot&background=random',
    ),
    CuratedAccount(
      id: 'ig_kinobi',
      name: 'Kinobi',
      handle: '@kinobi.id',
      platform: 'instagram',
      url: 'https://www.instagram.com/kinobi.id',
      description: 'Career accelerator and highly curated entry-level jobs.',
      tags: ['Entry Level', 'Accelerator'],
      profileImageUrl: 'https://ui-avatars.com/api/?name=Kinobi&background=random',
    ),
  ];
}
