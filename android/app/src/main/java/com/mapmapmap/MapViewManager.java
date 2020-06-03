package com.mapmapmap;

import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import net.daum.mf.map.api.MapPOIItem;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;

public class MapViewManager extends SimpleViewManager<DVMapView> {
    public static final String REACT_CLASS = "RCTMapView";
    public static final String TAG = "MapViewManager";

    ReactApplicationContext mCallerContext;
    private boolean initialRegionSet 	= false;

    public MapViewManager(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public DVMapView  createViewInstance(ThemedReactContext context) {
        DVMapView dvMapView = new DVMapView(context, mCallerContext);
        MapView mMapView = dvMapView.mMapView;
        mMapView.setMapType(MapView.MapType.Standard);
        mMapView.setOpenAPIKeyAuthenticationResultListener(new MapView.OpenAPIKeyAuthenticationResultListener() {
            public void onDaumMapOpenAPIKeyAuthenticationResult(MapView mapView, int resultCode, String resultMessage) {
                Log.i(TAG, String.format("Open API Key Authentication Result : code=%d, message=%s", resultCode, resultMessage));
            }
        });

        return dvMapView;
    }

    @ReactProp(name = "initialRegion")
    public void setInitialRegion(DVMapView dvMapView, ReadableMap initialRegion) {
        MapView mMapView = dvMapView.mMapView;
        double latitude 	= initialRegion.hasKey("latitude") ? initialRegion.getDouble("latitude") : 36.143099;
        double longitude	= initialRegion.hasKey("longitude") ? initialRegion.getDouble("longitude") : 128.392905;
        int    zoomLevel 	= initialRegion.hasKey("zoomLevel") ? initialRegion.getInt("zoomLevel") : 2;

        if (!initialRegionSet) {
            mMapView.setMapCenterPointAndZoomLevel(MapPoint.mapPointWithGeoCoord(latitude, longitude), zoomLevel, true);
            initialRegionSet = true;
        }
    }


    @ReactProp(name = "markers")
    public void setMarkers(DVMapView dvMapView, ReadableArray markers) {
        MapView mMapView = dvMapView.mMapView;
        for (int i = 0; i < markers.size(); i++) {
            ReadableMap markerInfo = markers.getMap(i);
            double latitude = markerInfo.hasKey("latitude") ? markerInfo.getDouble("latitude") : 36.143099;
            double longitude = markerInfo.hasKey("longitude") ? markerInfo.getDouble("longitude") : 128.392905;

            MapPOIItem.MarkerType markerType = MapPOIItem.MarkerType.BluePin;

            if (markerInfo.hasKey("pinColor")) {
                String pinColor = markerInfo.getString("pinColor").toLowerCase();
                if (pinColor.equals("red")) {
                    markerType = MapPOIItem.MarkerType.RedPin;
                } else if (pinColor.equals("yellow")) {
                    markerType = MapPOIItem.MarkerType.YellowPin;
                } else if (pinColor.equals("blue")) {
                    markerType = MapPOIItem.MarkerType.BluePin;
                } else if (pinColor.equals("image") || pinColor.equals("custom")) {
                    markerType = MapPOIItem.MarkerType.CustomImage;
                }
            }

            MapPOIItem.MarkerType sMarkerType = MapPOIItem.MarkerType.RedPin;
            if (markerInfo.hasKey("pinColorSelect")) {
                String pinColor = markerInfo.getString("pinColorSelect").toLowerCase();
                if (pinColor.equals("red")) {
                    sMarkerType = MapPOIItem.MarkerType.RedPin;
                } else if (pinColor.equals("yellow")) {
                    sMarkerType = MapPOIItem.MarkerType.YellowPin;
                } else if (pinColor.equals("blue")) {
                    sMarkerType = MapPOIItem.MarkerType.BluePin;
                } else if (pinColor.equals("image") || pinColor.equals("custom")) {
                    sMarkerType = MapPOIItem.MarkerType.CustomImage;
                } else if (pinColor.equals("none")) {
                    sMarkerType = null;
                }
            }

            MapPOIItem marker = new MapPOIItem();
            if (markerInfo.hasKey("title")) {
                marker.setItemName(markerInfo.getString("title"));
            }

            marker.setTag(i);

            // 마커 좌표
            marker.setMapPoint(MapPoint.mapPointWithGeoCoord(latitude, longitude));

            // 기본 마커 모양
            marker.setMarkerType(markerType);
            if (markerType == MapPOIItem.MarkerType.CustomImage) {
                if (markerInfo.hasKey("markerImage")) {
                    String markerImage = markerInfo.getString("markerImage");
                    int resID = mCallerContext.getResources().getIdentifier(markerImage, "drawable", mCallerContext.getApplicationContext().getPackageName());
                    marker.setCustomImageResourceId(resID);
                }
            }

            // 마커를 선택한 경우
            marker.setSelectedMarkerType(sMarkerType);
            if (sMarkerType == MapPOIItem.MarkerType.CustomImage) {
                if (markerInfo.hasKey("markerImageSelect")) {
                    String markerImage = markerInfo.getString("markerImageSelect");
                    int resID = mCallerContext.getResources().getIdentifier(markerImage, "drawable", mCallerContext.getApplicationContext().getPackageName());
                    marker.setCustomImageResourceId(resID);
                }
            }
            marker.setShowAnimationType(MapPOIItem.ShowAnimationType.SpringFromGround); // 마커 추가시 효과
            marker.setShowDisclosureButtonOnCalloutBalloon(false);                        // 마커 클릭시, 말풍선 오른쪽에 나타나는 > 표시 여부

            // 마커 드래그 가능 여부
            boolean draggable = false;
            if (markerInfo.hasKey("draggable")) {
                draggable = markerInfo.getBoolean("draggable");
            }
            marker.setDraggable(draggable);

            mMapView.addPOIItem(marker);
        }
    }

}
