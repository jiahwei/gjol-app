# gjol_app

gjoldb.info的APP版本

## 调试相关内容

### ADB

```shell
adb devices
# 启用 TCP/IP 模式（默认端口 5555）
adb tcpip 5555
adb connect <手机IP>:5555
```

### 无线调试

```shell
# 配对接口
adb pair 192.168.31.105:43005
# 调试接口
adb connect 192.168.31.105:43005
```

## 打包到手机

```shell
# 说是要java version > 17，用最新的算了
# mac
sdk use java 17.0.17-tem
# Windows
jabba use temurin@17.0.

adb devices
flutter run --release -d adb-d0dda941-uH0Kn0._adb-tls-connect._tcp

flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
