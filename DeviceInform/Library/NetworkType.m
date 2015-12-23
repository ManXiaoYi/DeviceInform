//
//  NetworkType.m
//  DeviceInform
//
//  Created by 满孝意 on 15/12/23.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import "NetworkType.h"

@implementation NetworkType

#pragma mark -
#pragma mark - 根据状态栏获取网络状态
+ (NETWORK_TYPE)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber *num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    
    return nettype;
}

@end
