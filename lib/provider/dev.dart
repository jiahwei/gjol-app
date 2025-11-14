import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gjol_app/services/dev.dart';

final devServiceProvider = Provider<DevService>((ref) => DevService());

final devTestResolveProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, testDate) {
      return ref.read(devServiceProvider).testResolve(testDate: testDate);
    });

final devTranModelProvider = FutureProvider<void>((ref) async {
  await ref.read(devServiceProvider).tranModel();
});

final devFixBulletinRanksProvider = FutureProvider.family<void, int>((
  ref,
  versionId,
) async {
  await ref.read(devServiceProvider).fixBulletinRanks(versionId: versionId);
});

final devFixAllBulletinProvider =
    FutureProvider.family<void, ({int pageNum, bool reversed})>((
      ref,
      params,
    ) async {
      await ref
          .read(devServiceProvider)
          .fixAllBulletin(pageNum: params.pageNum, reversed: params.reversed);
    });
