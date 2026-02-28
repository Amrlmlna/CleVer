import '../../domain/entities/banner_ad.dart';
import '../datasources/remote_banner_datasource.dart';

class BannerRepositoryImpl {
  final RemoteBannerDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  Future<List<BannerAd>> getActiveBanners() async {
    try {
      final data = await remoteDataSource.getActiveBanners();
      return data.map((json) => BannerAd.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch banners: $e');
    }
  }
}
