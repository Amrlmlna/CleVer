import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/banner_ad.dart';
import '../datasources/remote_banner_datasource.dart';

class BannerRepositoryImpl {
  final RemoteBannerDataSource remoteDataSource;
  static const String _cacheKey = 'cached_banners';
  static const String _cacheTimeKey = 'cached_banners_time';
  static const int _cacheTtlHours = 168; // 1 week

  BannerRepositoryImpl({required this.remoteDataSource});

  Future<List<BannerAd>> getActiveBanners() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      final cacheTimeStr = prefs.getString(_cacheTimeKey);

      if (cachedData != null && cacheTimeStr != null) {
        final cacheTime = DateTime.parse(cacheTimeStr);
        final now = DateTime.now();

        if (now.difference(cacheTime).inHours < _cacheTtlHours) {
          final List<dynamic> decoded = jsonDecode(cachedData);
          return decoded
              .map((json) => BannerAd.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      final data = await remoteDataSource.getActiveBanners();
      final banners = data.map((json) => BannerAd.fromJson(json)).toList();

      // Save to local cache
      final List<Map<String, dynamic>> serializedBanners = banners
          .map((b) => b.toJson())
          .toList();
      await prefs.setString(_cacheKey, jsonEncode(serializedBanners));
      await prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());

      return banners;
    } catch (e) {
      // Graceful fallback to stale cache on network failure
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_cacheKey);
        if (cachedData != null) {
          final List<dynamic> decoded = jsonDecode(cachedData);
          return decoded
              .map((json) => BannerAd.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {
        // Fall through to throw below
      }
      throw Exception('Failed to fetch banners: $e');
    }
  }
}
