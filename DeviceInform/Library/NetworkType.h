//
//  NetworkType.h
//  DeviceInform
//
//  Created by 满孝意 on 15/12/23.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NETWORK_TYPE) {
    NETWORK_TYPE_NONE = 0,
    NETWORK_TYPE_2G = 1,
    NETWORK_TYPE_3G = 2,
    NETWORK_TYPE_4G = 3,
    NETWORK_TYPE_5G = 4,    //  5G目前为猜测结果
    NETWORK_TYPE_WIFI = 5
};

@interface NetworkType : NSObject <UIApplicationDelegate>

/**
 *  根据状态栏获取网络状态
 *
 *  @return 返回枚举值
 */
+ (NETWORK_TYPE)getNetworkTypeFromStatusBar;

@end
