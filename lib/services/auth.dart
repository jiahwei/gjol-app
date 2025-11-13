import 'package:gjol_app/core/network/api_provider.dart';
import 'package:gjol_app/models/auth/is_open_manage.dart';
import 'package:gjol_app/core/desvice_id.dart';
import 'package:gjol_app/core/crypto.dart';

class AuthService {
  Future<IsOpenManageResponse> isOpenManage() async {
    final deviceId = await getStableDeviceId();
    final info = MyCrypto.buildPayload(deviceId);

    final response = await request<IsOpenManageResponse>(
      '/auth/isOpenManage',
      method: 'POST',
      data: info,
      fromJson: IsOpenManageResponse.fromJson,
    );

    return response;
  }
}