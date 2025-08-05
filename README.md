## WebViewFlutter를 사용하여 NaverMaps API를 표출하는 SDK입니다.

### 사용전 준비사항
#### Android 9(API 레벨 28) 이상부터는 앱의 보안을 강화하기 위해 HTTP 평문 통신이 기본적으로 차단됩니다.

네이버 지도 API는 내부적으로 일부 HTTP 통신을 사용하는데, 이로 인해 지도가 로딩되지 않는 문제가 발생할 수 있습니다.

이 문제를 해결하려면, 앱의 네트워크 보안 구성(network-security-config.xml)을 수정하여 네이버 지도 관련 도메인에 대한 평문 통신을 명시적으로 허용해야 합니다.  

    1. android/app/src/main/res/xml/ 경로에 network_security_config.xml 파일을 만들고 아래 내용을 추가하세요. (만약 res/xml 폴더가 없다면 새로 생성하면 됩니다.)
```xml
    <?xml version="1.0" encoding="utf-8"?>
    <network-security-config>
        <domain-config cleartextTrafficPermitted="true">
            <domain includeSubdomains="true">map.naver.com</domain>
            <domain includeSubdomains="true">map.naver.net</domain>
            <domain includeSubdomains="true">oapi.map.naver.com</domain>
        </domain-config>
    </network-security-config>
```
    
    2. android/app/src/main/AndroidManifest.xml 파일을 열어 <application> 태그에 android:networkSecurityConfig 속성을 추가합니다.
```xml
    <application
        ...
        android:networkSecurityConfig="@xml/network_security_config" // 이부분 추가.
        ...>
    </application>
```
