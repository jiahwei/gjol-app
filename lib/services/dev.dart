import 'package:gjol_app/core/network/api_provider.dart';

class DevService {
  Future<List<Map<String, dynamic>>> testResolve({String? testDate}) {
    return requestList<Map<String, dynamic>>(
      '/dev/testResolve',
      method: 'GET',
      data: {'testDate': testDate},
      itemFromJson: (m) => Map<String, dynamic>.from(m as Map),
    );
  }

  Future<void> tranModel() async {
    await requestModel<Map<String, dynamic>>(
      '/dev/tranModel',
      method: 'GET',
      fromJson: (_) => <String, dynamic>{},
    );
  }

  Future<void> fixBulletinRanks({required int versionId}) async {
    await requestModel<Map<String, dynamic>>(
      '/dev/fixBulletinRanks',
      method: 'GET',
      data: {'version_id': versionId},
      fromJson: (_) => <String, dynamic>{},
    );
  }

  Future<void> fixAllBulletin({int pageNum = 1, bool reversed = false}) async {
    await requestModel<Map<String, dynamic>>(
      '/dev/fixAllBulletin',
      method: 'GET',
      data: {
        'pageNum': pageNum,
        'reversed': reversed,
      },
      fromJson: (_) => <String, dynamic>{},
    );
  }
}