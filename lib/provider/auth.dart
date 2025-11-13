import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gjol_app/services/auth.dart';
import 'package:gjol_app/models/auth/is_open_manage.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final isOpenManageProvider = FutureProvider<IsOpenManageResponse>(
  (ref) => ref.read(authServiceProvider).isOpenManage(),
);

