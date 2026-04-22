import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../domain/entities/banner_ad.dart';
import '../../../../data/datasources/remote_banner_datasource.dart';
import '../../../../data/repositories/banner_repository_impl.dart';

final bannerRepositoryProvider = Provider<BannerRepositoryImpl>((ref) {
  return BannerRepositoryImpl(
    remoteDataSource: RemoteBannerDataSource(client: http.Client()),
  );
});

final bannerProvider = FutureProvider<List<BannerAd>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getActiveBanners();
});
