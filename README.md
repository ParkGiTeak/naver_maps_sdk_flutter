# NaverMaps API를 간편하게 Widget으로 사용할 수 있는 SDK입니다.
**지원 플랫폼: `Android`, `iOS`, `Web`**

## 시작하기
### 1. NaverMapSDK 초기화
- `NaverMapWidget`을 사용하기 전에 [NaverCloudConsole](https://www.ncloud.com)에 등록된 **Client ID**를 `NaverMapSDK` 초기화 시 입력해줍니다.
- 앱의 시작점에서 `NaverMapSDK.initialize()`를 호출하여 SDK를 초기화합니다.
- `webServiceUrl`은 Android 및 iOS 플랫폼의 `WebView` 모드에서만 내부적으로 사용되며, 웹 플랫폼에서는 필요하지 않습니다.
- `kIsWeb` 상수를 사용하여 플랫폼에 따라 조건부로 설정할 수 있습니다.

```dart
NaverMapSDK.initialize(
    clientId: 'YOUR_CLIENT_ID',
    webServiceUrl: kIsWeb ? null : 'http://localhost', // 웹이 아닐 경우에만 webServiceUrl 설정
    language: NaverMapLanguageType.english, // language는 option으로 한국어, 영어, 중국어, 일본어를 지원
);
```

### 2. 플랫폼별 SDK Import
- App(Android, iOS)과 Web은 사용하는 SDK가 다르므로, 개발하는 플랫폼에 따라 적절한 파일을 임포트해야 합니다.

#### 단일 플랫폼 개발 (App 또는 Web 중 하나만 개발하는 경우)
- **App (Android, iOS) 개발 시:**
```dart
import 'package:naver_maps_sdk_flutter/sdk_app/naver_maps_sdk_flutter_app.dart';
```
- **Web 개발 시:**
```dart
import 'package:naver_maps_sdk_flutter/sdk_web/naver_maps_sdk_flutter_web.dart';
```

#### 멀티 플랫폼 개발 (App과 Web을 동시에 개발하는 경우)
- 조건부 임포트를 사용하면, 코드 한 벌로 모든 플랫폼을 지원할 수 있습니다.
```dart
import 'package:naver_maps_sdk_flutter/sdk_app/naver_maps_sdk_flutter_app.dart'
    if (dart.library.html) 'package:naver_maps_sdk_flutter/sdk_web/naver_maps_sdk_flutter_web.dart';
```

### 3. NaverMapManager API

#### 지도 제어
| Method | Parameters | Return | Description |
| :--- | :--- | :--- | :--- |
| `setCenter` | `center`: `Coord` | `Future<void>` | 지도의 중심 좌표를 이동합니다. |
| `setZoom` | `zoom`: `int` | `Future<void>` | 지도의 줌 레벨을 설정합니다. |
| `getCenter` | `shouldReturnLatLng`: `bool` | `Future<Coord>` | 현재 지도의 중심 좌표를 가져옵니다. `shouldReturnLatLng` 값에 따라 `NLatLng` 또는 `NPoint`를 반환합니다. |
| `getZoom` | - | `Future<int>` | 현재 지도의 줌 레벨을 가져옵니다. |
| `getBounds` | `shouldReturnLatLng`: `bool` | `Future<Bounds>` | 현재 보이는 지도의 영역을 가져옵니다. `shouldReturnLatLng` 값에 따라 `NLatLngBounds` 또는 `NPointBounds`를 반환합니다. |
| `hasLatLng` | `bounds`: `NLatLngBounds`, `coord`: `Coord` | `Future<bool>` | 주어진 `bounds` 내에 특정 `coord`가 포함되는지 확인합니다. |
| `hasPoint` | `bounds`: `NPointBounds`, `coord`: `Coord` | `Future<bool>` | 주어진 `bounds` 내에 특정 `coord`가 포함되는지 확인합니다. |

#### 마커
| Method | Parameters | Return | Description |
| :--- | :--- | :--- | :--- |
| `addMarker` | `markerId`: `String`, `markerOptions`: `MarkerOptions` | `Future<void>` | 지도에 마커를 추가합니다. |
| `updateMarker` | `markerId`: `String`, `markerOptions`: `MarkerOptions` | `Future<void>` | 기존 마커의 옵션을 업데이트합니다. |
| `removeMarker` | `markerId`: `String` | `Future<void>` | 특정 마커를 지도에서 제거합니다. |
| `removeMarkerAll` | - | `Future<void>` | 지도 위의 모든 마커를 제거합니다. |
| `getMarkerIds` | - | `Future<List<int>>` | 현재 지도에 추가된 모든 마커의 ID 목록을 가져옵니다. |

#### 이벤트 리스너
| Method | Parameters | Return | Description |
| :--- | :--- | :--- | :--- |
| `addMarkerClickEvent` | `markerId`: `String` | `Future<void>` | 특정 마커에 클릭 이벤트를 추가합니다. |
| `removeMarkerClickEvent` | `markerId`: `String` | `Future<void>` | 특정 마커의 클릭 이벤트를 제거합니다. |
| `addMapClickEventListener` | - | `Future<void>` | 지도 클릭 이벤트를 추가합니다. |
| `removeMapClickEventListener` | - | `Future<void>` | 지도 클릭 이벤트를 제거합니다. |
| `addMapLongTapEventListener` | - | `Future<void>` | 지도 롱탭 이벤트를 추가합니다. |
| `removeMapLongTapEventListener` | - | `Future<void>` | 지도 롱탭 이벤트를 제거합니다. |
| `addMapIdleEventListener` | - | `Future<void>` | 지도 Idle 이벤트를 추가합니다. |
| `removeMapIdleEventListener` | - | `Future<void>` | 지도 Idle 이벤트를 제거합니다. |
| `addMapZoomChangedEventListener` | - | `Future<void>` | 지도 줌 변경 이벤트를 추가합니다. |
| `removeMapZoomChangedEventListener` | - | `Future<void>` | 지도 줌 변경 이벤트를 제거합니다. |
| `addMapZoomEndEventListener` | - | `Future<void>` | 지도 줌 종료 이벤트를 추가합니다. |
| `removeMapZoomEndEventListener` | - | `Future<void>` | 지도 줌 종료 이벤트를 제거합니다. |
| `addMapZoomStartEventListener` | - | `Future<void>` | 지도 줌 시작 이벤트를 추가합니다. |
| `removeMapZoomStartEventListener` | - | `Future<void>` | 지도 줌 시작 이벤트를 제거합니다. |
| `addMapCenterChangedEventListener` | - | `Future<void>` | 지도 중심 좌표 변경 이벤트를 추가합니다. |
| `removeMapCenterChangedEventListener` | - | `Future<void>` | 지도 중심 좌표 변경 이벤트를 제거합니다. |

### 4. NaverMapManager 생성 및 이벤트 스트림 구독
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
}
```

### 5. NaverMapWidget 사용
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

### 6. NaverMap 조작
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
            markerId: i.toString(), // markerId는 String 타입입니다.
            markerOptions: MarkerOptions(
                position: NLatLng(37.466259 + i * 0.001, 126.889611),
                animation: NAnimation.drop,
            ),
        );
        // 마커 클릭 이벤트를 활성화합니다.
        _naverMapManager.addMarkerClickEvent(markerId: i.toString());
    }
}
```

---

## 플랫폼별 참고사항
### Web: HTTPS 환경 필요
- 웹 플랫폼에서 Naver Maps API를 사용하려면, **HTTPS** 환경에서 애플리케이션을 실행해야 합니다.
- `localhost` 또는 HTTP 환경에서는 API 인증이 실패하여 지도가 정상적으로 표시되지 않을 수 있습니다. 개발 시 이 점에 유의하여 HTTPS를 지원하는 호스팅 환경에서 테스트하시기 바랍니다.

### Android: HTTP 통신 설정
- **Android 9 (API 28) 이상**에서는 보안 강화를 위해 HTTP 통신이 기본적으로 차단됩니다.
- 네이버 지도 API는 일부 HTTP 통신을 사용하므로, `webServiceUrl`을 HTTP로 설정한 경우 아래와 같이 네트워크 보안 구성을 추가해야 합니다.
- `android/app/src/main/res/xml/network_security_config.xml` 파일을 생성하고 다음 내용을 추가합니다.

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

- `android/app/src/main/AndroidManifest.xml` 파일의 `<application>` 태그에 `android:networkSecurityConfig` 속성을 추가합니다.

```xml
<application
    ...
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
</application>
```

### iOS: 로컬 네트워크 및 HTTP 접근 권한 설정
- **iOS 14 이상**에서 `webServiceUrl`을 `localhost`와 같은 로컬 주소로 설정한 경우, 로컬 네트워크 접근 권한이 필요합니다.
- 또한, HTTP 요청을 허용하기 위해 App Transport Security(ATS) 설정을 추가해야 합니다.
- `ios/Runner/Info.plist` 파일에 다음 키-값 쌍을 추가합니다.

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>Your app uses local network to discover and connect to local devices for debugging.</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

* 모든 저작권은 Naver에 있으며, 해당 SDK는 Naver 공식SDK가 아닙니다. *
