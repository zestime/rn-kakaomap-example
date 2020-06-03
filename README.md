
Special Thanks for react-native-daummap

https://github.com/asata/react-native-daummap 의 소스를 활용하였습니다.
공유에 감사드립니다.

# Prerequisite

## Kakao SDK 설정

bundle ID 나 market URL은 중요하지 않습니다.
Key hash가 가장 중요합니다.
key tool을 통해서 획득할 수 있으나, 저의 경우에는 잘 작동하지 않았습니다.

대신, 빌드 시에 아래의 함수를 이용해서 실제 값을 가져다 사용했습니다.

```java
private void getAppKeyHash() {
    try {
        PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_SIGNATURES);
        for (Signature signature : info.signatures) {
            MessageDigest md;
            md = MessageDigest.getInstance("SHA");
            md.update(signature.toByteArray());
            String something = new String(Base64.encode(md.digest(), 0));
            Log.e("Hash key", something);
        }
    } catch (Exception e) {
        // TODO Auto-generated catch block
        Log.e("name not found", e.toString());
    }
}
```

library 관련 사항은 tutorial을 참고 부탁드립니다.

## app

위의 SDK가 제대로 설정되었다면 App에서는 할 것이 별로 없습니다. 

현재 위치를 가져오는 library 정도만 추가하면 되겠습니다.

먼저, 현재 location을 가져오는 library가 추가되어야 합니다.

```bash
$ npm install @react-native-community/geolocation --save
```

location과 관련된 권한 설정은 https://github.com/react-native-community/react-native-geolocation 을 참고 부탁드립니다.


# React Components

## MapView 

MapViewNative를 감싸고 있으며, GeoLocation을 이용하여, 현재 위치를 표시할 수 있습니다.

### Props
| Property                  | Type      | Default   | Description |
|----------|-----------|-----------|-------------|
| defaultLocation             | Object    |         | 지도의 중심으로 그려져야 하는 위치|
| useCurrentLocation             | boolean    | false | GeoLocation을 사용하지 않는 경우, 특정 위치 표시시 사용|
| Markers             | Array    |         | 지도안에 같이 표현되어야 하는 markers |

예시는 다음의 App.tsx를 참고 하시면 됩니다.

```javascript
// App.tsx

...

const defaultPosition = {
  latitude: 37.491187,
  longitude: 126.924878,
  title: '제이윈연구소',
};
const markers = [
  {
    latitude: 37.492762,
    longitude: 126.919852,
    pinColor: 'yellow',
    title: '보라매공원',
  },
  {
    latitude: 37.490504,
    longitude: 126.925007,
    pinColor: 'yellow',
    title: '롯데백화점',
  },
];

...

```

pinColor의 경우, 누락시 blue로 표시되게 되어있습니다.

# Run

아래 것들이 필요합니다.

* 빌드 - 기본적으로 React Native 빌드 환경
* install NPM packages
* KakaoMap Native Key - AndroidManifest.xml에 추가하여야 합니다. 

그리고 대망의
```
$ npm run android
```

# Refernece

* https://github.com/asata/react-native-daummap
* https://github.com/react-native-community/react-native-geolocation