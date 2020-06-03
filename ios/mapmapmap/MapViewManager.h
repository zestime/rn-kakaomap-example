	//
//  MapViewManager.h
//  mapmapmap
//
//  Created by 황수경 on 2020/06/03.
//

// import RCTViewManager
#if __has_include(<React/RCTViewManager.h>)
#import <React/RCTViewManager.h>
#elif __has_include("RCTViewManager.h")
#import "RCTViewManager.h"
#else
#import "React/RCTViewManager.h" // Required when used as a Pod in a Swift project
#endif

#import <DaumMap/MTMapView.h>

@interface MapViewManager : RCTViewManager
@end
