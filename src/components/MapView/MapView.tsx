import React, {useState, useEffect} from 'react';
import Geolocation from '@react-native-community/geolocation';
import {WaveIndicator} from 'react-native-indicators';
import MapViewNative from './MapViewNative';

/**
 * MapView
 * KakaoMap 바인딩
 * 기본적으로 parant 사이즈에 종속적
 * @param defaultLocation 현재 위치를 가져오지 못하는 경우 보여줄 위치
 * @param markers 화면에 표시해야 할 markers { latidue, longtitude, pinColor, title}
 */
const MapView = ({defaultLocation, useCurrentLocation = false, markers}) => {
  const [location, setLocation] = useState({
    ...defaultLocation,
    loaded: false, // GPS 수신 완료/실패 여부, indicator 표시
  });

  useEffect(() => {
    if (useCurrentLocation) {
      Geolocation.getCurrentPosition(
        (info) => {
          setLocation((state) => ({
            ...state,
            ...info.coords,
            loaded: true,
            title: '현재 위치',
          }));
          console.log('MapView Geolocation Success - ', info);
        },
        (err) => {
          console.log('MapView Geolocation failed - ', err);
          setLocation((state) => ({...state, loaded: true}));
        },
        {
          timeout: 20000, // GPS 대기 시간
          maximumAge: 10 * 60 * 1000, // 기존 캐슁 허용 시간
          enableHighAccuracy: false, // 정확도 wifi로 geo location 허용 여부
        },
      );
    } else {
      // Current Location이 필요없는 경우
      // 지점 표시시에 사용
      setLocation((state) => ({...state, loaded: true}));
    }
  }, []);

  const {loaded} = location;

  return (
    <>
      {!loaded && <WaveIndicator />}
      {loaded && (
        <MapViewNative
          style={{flex: 1}}
          initialRegion={location}
          markers={[location, ...markers]}
        />
      )}
    </>
  );
};

export default MapView;
