# NaverMaps API를 간편하게 Widget으로 사용할 수 있는 SDK입니다.

## 프로젝트 설정 준비

### 1. Android
#### Android 9(API 레벨 28) 이상부터는 앱의 보안을 강화하기 위해 HTTP 평문 통신이 기본적으로 차단됩니다.

네이버 지도 API는 내부적으로 일부 HTTP 통신을 사용하는데, 이로 인해 지도가 로딩되지 않는 문제가 발생할 수 있습니다.

이 문제를 해결하려면, 앱의 네트워크 보안 구성(network-security-config.xml)을 수정하여 네이버 지도 관련 도메인에 대한 평문 통신을 명시적으로 허용해야 합니다.

- android/app/src/main/res/xml/ path에 network_security_config.xml 파일을 만들고 아래 내용을 추가하세요. (만약 res/xml 폴더가 없다면 새로 생성하면 됩니다.)
```xml
    <?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">map.naver.com</domain>
        <domain includeSubdomains="true">map.naver.net</domain>
        <domain includeSubdomains="true">oapi.map.naver.com</domain>
        <domain includeSubdomains="true">static.naver.net</domain>
        <domain includeSubdomains="true">nrbe.map.naver.net</domain>
    </domain-config>
</network-security-config>
```

- android/app/src/main/AndroidManifest.xml 파일을 열어 <application> 태그에 android:networkSecurityConfig 속성을 추가합니다.
```xml
    <application
    ...
    android:networkSecurityConfig="@xml/network_security_config" // 이부분 추가.
    ...>
    </application>
```

### 2. iOS
#### iOS 14이상 로컬 네트워크 접근 권한 NSLocalNetworkUsageDescription 설정 및 HTTP 접근을 위한 ATS(App Transport Security) 설정 추가
iOS 14 이상에서 로컬 네트워크 접근 권한이 필요하기 떄문에 info.plist에 NSLocalNetworkUsageDescription을 추가한다.
iOS 보안문제로 HTTPS만 요청을 허용하기 때문 HTTP 요청을 위해 info.plist에 ATS(App Transport Security) 설정을 추가한다.

- ios/Runner/ path에 info.plist 파일에 아래 내용을 추가하세요.
```xml
    <key>NSLocalNetworkUsageDescription</key>
<string>Your app uses local network to discover and connect to local devices for debugging.</string>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

---

## 시작하기
### 1. NaverMapSDK 초기화

- `NaverMapWidget` 사용 전에 [NaverCloudConsole](https://www.ncloud.com)에 등록된 Web 서비스 URL과 Client ID를 `NaverMapSDK` 초기화 시 입력해줍니다.
```dart
    NaverMapSDK.initialize(
clientId: 'YOUR_CLIENT_ID',
webServiceUrl: 'http://localhost',
language: NaverMapLanguageType.english, // language는 option으로 한국어, 영어, 중국어, 일본어를 지원
);
```

### 2. NaverMapManager 생성 및 이벤트 스트림 구독

- `StatefulWidget`에서 `NaverMapManager`의 인스턴스를 생성합니다.
- `initState`에서 manager의 이벤트 스트림을 구독(`listen`)하고, `dispose`에서 구독을 취소(`cancel`)하여 메모리 누수를 방지합니다.
- 이벤트는 **Sealed Class**로 그룹화되어 있어, `switch` 문을 사용해 타입에 따라 안전하게 처리할 수 있습니다.

```dart
class _MyHomePageState extends State<MyHomePage> {
  final NaverMapManager _naverMapManager = NaverMapSDK.createNaverMapManager();
  late final StreamSubscription _mapStatusSubscription;
  late final StreamSubscription _markerEventSubscription;

  @override
  void initState() {
    super.initState();
    // 지도 로딩 상태 스트림 구독
    _mapStatusSubscription = _naverMapManager.onMapLoadStatus.listen((status) {
      switch (status) {
        case Success():
          print("NaverMap is Ready!");
          _naverMapManager.setCenter(center: NLatLng(37.466259, 126.889611));
          _addMarkers();
          break;
        case Fail():
          print("NaverMap Load FAILED!");
          break;
      }
    });

    // 마커 이벤트 스트림 구독
    _markerEventSubscription = _naverMapManager.onMarkerEvent.listen((event) {
      switch (event) {
        case MarkerTap(markerId: final id):
          print("Tapped Marker ID: $id");
          break;
      }
    });
  }

  @override
  void dispose() {
    _mapStatusSubscription.cancel();
    _markerEventSubscription.cancel();
    _naverMapManager.dispose(); // manager의 StreamController들을 해제하기 위해서 disopose처리 필수.
    super.dispose();
  }

// ... build 메서드 및 기타 로직
}
```

### 3. NaverMapWidget 사용

- `build` 메서드 안에서 `NaverMapWidget`을 생성하고, `initState`에서 생성한 `NaverMapManager` 인스턴스를 넘겨줍니다.
- `mapOptions`는 선택사항이며, 추가하지 않으면 기본 설정으로 지도가 표시됩니다.

```dart
@override
Widget build(BuildContext context) {
    final MapOptions mapOptions = MapOptions(
        center: NLatLng(37.528821, 126.876431),
        zoom: 15,
        zoomControl: true,
        mapTypeId: NaverMapMapTypeId.normal,
        // ... 기타 옵션들
    );

    return Scaffold(
        body: NaverMapWidget(
            naverMapManager: _naverMapManager,
            mapOptions: mapOptions,
        ),
    );
}
```

### 4. NaverMap 조작

- `NaverMapManager` 인스턴스를 통해 지도를 조작할 수 있습니다.
- `onMapLoadStatus` 스트림을 통해 `Success` 상태가 전달된 이후에 호출하는 것이 안전합니다.

```dart
Future<void> setZoom(zoomLevel) async {
  await _naverMapManager.setZoom(zoom: 18);
  print('zoomLevel:: ${await _naverMapManager.getZoom()}');
}

Future<void> addMarkers() async {
  for (int i = 0; i < 10; i++) {
    await _naverMapManager.addMarker(
      markerId: i,
      markerOptions: MarkerOptions(
        position: NLatLng(37.466259 + i * 0.001, 126.889611),
        animation: NAnimation.drop,
      ),
    );
    // 마커 클릭 이벤트를 활성화합니다.
    _naverMapManager.addMarkerClickEvent(markerId: i);
  }
}
```
* 모든 저작권은 Naver에 있으며, 해당 SDK는 Naver 공식SDK가 아닙니다. *
