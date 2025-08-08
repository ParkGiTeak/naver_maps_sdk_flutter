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

- NaverMapWidget 사용전에 [NaverCloudConsole](https://www.ncloud.com)에 등록된 Web 서비스 URL과 Client ID를 NaverMapSDK 초기화 시 입력해줍니다.
```dart
    NaverMapSDK.initialize(
        clientId: 'YOUR_CLIENT_ID',
        webServiceUrl: 'http://localhost',
        language: NaverMapLanguageType.english, // language는 option으로 한국어, 영어, 중국어, 일본어를 지원
    );
```
### 2. NaverMapWidget 사용 전 MapLoadStatusListener, MarkerEventListener 등 implements 추가

- NaverMap 로딩 성공, 실패에 대한 콜백과 그외의 콜백을 받기위해 Listener를 구현합니다. 
```dart
    class MyHomePage extends StatefulWidget implements MapLoadStatusListener, MarkerEventListener {
        
        ...
        @override
        void onMapLoadFail() {}

        @override
        void onMapLoadSuccess(NaverMapManager naverMapManager) async {}

        @override
        void onMarkerClick(int markerId) {}
    }
```
### 3. NaverMapWidget 사용

- NaverMapWidget을 생성할 때 MapOptions와 필요한 Listener Interface 구현체를 등록해줘야합니다.
- mapOptions는 Optional 이며, 추가하지 않으면 지도 기본 설정으로 표출 됩니다.

```dart
    class _MyHomePageState extends State<MyHomePage> {
        @override
        Widget build(BuildContext context) {
            final MapOptions mapOptions = MapOptions(
                center: NLatLng(37.528821, 126.876431),
                zoom: 15,
                zoomControl: true,
                mapTypeId: NaverMapMapTypeId.normal,
                zoomControlOptions: ZoomControlOptions(
                    position: NaverMapPositionType.rightCenter,
                    style: NaverMapZoomControlStyle.large,
                ),
                mapTypeControl: true,
                mapTypeControlOptions: MapTypeControlOptions(
                    position: NaverMapPositionType.leftCenter,
                    mapTypeIds: [
                        NaverMapMapTypeId.hybrid,
                        NaverMapMapTypeId.normal,
                        NaverMapMapTypeId.terrain,
                    ],
                    style: NaverMapTypeControlStyle.button,
                ),
            );
            return Scaffold(
                body: NaverMapWidget(
                    mapOptions: mapOptions,
                    mapLoadStatusListener: widget, // 에제의 Listener는 2번 항목의 MyHomePage Widget을 구현체로 넣었습니다.
                    markerEventListener: widget,
                ),
            );
        }
    }
```
### 4. NaverMap 조작
- MapLoadStatusListener의 onMapLoadSuccess 콜백으로 들어오는 NaverMapManager를 통해서 지도를 조작할 수 있습니다.
- NaverMapWidget과 1:1로 매칭되기 때문에 onMapLoadSuccess 콜백으로 들어오는 NaverMapManager 인스턴스를 참조할 변수에 넣어서 사용하면 됩니다.

```dart
    final Coord coord = await naverMapManager.getCenter(resultTypeLatLng: true);
    if (coord is NLatLng) {
        debugPrint("lat:: ${coord.lat}, lng:: ${coord.lng}");
    } else if (coord is NPoint) {
        debugPrint("x:: ${coord.x}, y:: ${coord.y}");
    }
    await Future.delayed(Duration(seconds: 2));
    await naverMapManager.setCenter(center: NLatLng(37.466259, 126.889611));
    print('zoomLevel:: ${await naverMapManager.getZoom()}');
    await naverMapManager.setZoom(zoom: 18);
    print('zoomLevel:: ${await naverMapManager.getZoom()}');

    for (int i = 0; i < 10; i++) {
        await naverMapManager.addMarker(
            markerId: i,
            markerOptions: MarkerOptions(
                position: NLatLng(37.466259 + i * 0.15, 126.889611),
                animation: NAnimation.drop,
                title: 'SOS',
            ),
        );
        naverMapManager.addMarkerClickEvent(markerId: i);
    }
```   
* 모든 저작권은 Naver에 있으며, 해당 SDK는 Naver 공식SDK가 아닙니다. *
