//
//  MapViewManager.m
//  mapmapmap
//
//  Created by 황수경 on 2020/06/03.
//

#import <Foundation/Foundation.h>
#import "MapView.h"
#import "MapViewManager.h"

@implementation MapViewManager

RCT_EXPORT_MODULE(RNTMapView);
// Return the native view that represents your React component
- (UIView *) view {
    MapView* map = [[MapView alloc] init];
    return map;
}

RCT_EXPORT_VIEW_PROPERTY(initialRegion, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(mapType, NSString)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray)
RCT_EXPORT_VIEW_PROPERTY(isTracking, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isCompass, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isCurrentMarker, BOOL)
RCT_EXPORT_VIEW_PROPERTY(region, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(polyLines, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(circles, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onMarkerSelect, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMarkerPress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMarkerMoved, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onRegionChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCurrentLocation, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCurrentHeading, RCTDirectEventBlock)

// 임시 디렉토리에 저장된 지도 타일 캐쉬 데이터를 모두 삭제
RCT_EXPORT_METHOD(clearMapCache:(nonnull NSNumber *)reactTag) {
    [MTMapView clearMapTilePersistentCache];
}
@end
