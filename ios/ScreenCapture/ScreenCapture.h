//
//  ScreenCapture.h
//  ScreenCapture
//
//  Created by lewin on 2018/10/11.
//  Copyright © 2018年 lewin. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#else
#import "RCTBridgeModule.h"
#endif
#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#elif __has_include("React/RCTEventEmitter.h")
#import "React/RCTEventEmitter.h"
#else
#import "RCTEventEmitter.h"
#endif

@interface ScreenCapture : RCTEventEmitter <RCTBridgeModule>

@end
