//
//  AppDelegate.m
//  DeviceInform
//
//  Created by 满孝意 on 15/12/23.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import "AppDelegate.h"
#import "MYHeaderFile.h"
#import <CoreLocation/CoreLocation.h>
#import "sys/utsname.h"

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, copy) NSString *currentLatitude;
@property (nonatomic, copy) NSString *currentLongitude;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    // - 设备信息
    UIDevice *current_device = [[UIDevice alloc] init];
    NSLog(@"设备所有者姓名 : %@", current_device.name);
    NSLog(@"设备的具体机型 : %@", current_device.model);
    NSLog(@"设备本地化版本 : %@", current_device.localizedModel);
    NSLog(@"设备运行的系统 : %@", current_device.systemName);
    NSLog(@"设备系统的版本 : %@", current_device.systemVersion);//系统
    NSLog(@"设备自身识别码 : %@", current_device.identifierForVendor.UUIDString);//下载量
    
    
    // - iPhone具体型号
    NSString *device_model = [self getDeviceModel];//机型
    NSLog(@"设备的现实机型 : %@",device_model);
    
    
    // - 设备屏幕高度、宽度
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"设备的屏幕高度 : %.0f",screenHeight);
    NSLog(@"设备的屏幕宽度 : %.0f",screenWidth);
    
    
    // - 设备屏幕分辨率
    float screenScale = [UIScreen mainScreen].scale;//分辨率
    float screenScale_height = screenScale * screenHeight;
    float screenScale_width = screenScale * screenWidth;
    NSLog(@"设备屏幕分辨率 : %.0f * %.0f",screenScale_height, screenScale_width);
    
    
    // - 设备是否越狱
    BOOL isJailbroken = [self isJailbroken];//是否越狱
    NSLog(@"设备是否已越狱 : %@", isJailbroken ? @"Yes": @"No");
    
    
    // - 设备网络环境 - 方法一 - Reachability
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable: NSLog(@"设备的网络环境 : 无_Reachability"); break;
        case ReachableViaWWAN: NSLog(@"设备的网络环境 : 3G_Reachability"); break;
        case ReachableViaWiFi: NSLog(@"设备的网络环境 : WIFI_Reachability"); break;
        default: break;
    }
    
    // - 设备网络环境 - 方法二 - JudgeNetwork_Type
    int netType = [NetworkType getNetworkTypeFromStatusBar];
    switch (netType) {
        case 0: NSLog(@"设备的网络环境 : 无_JudgeNetwork_Type"); break;
        case 1: NSLog(@"设备的网络环境 : 2G_JudgeNetwork_Type"); break;
        case 2: NSLog(@"设备的网络环境 : 3G_JudgeNetwork_Type"); break;
        case 3: NSLog(@"设备的网络环境 : 4G_JudgeNetwork_Type"); break;
        case 4: NSLog(@"设备的网络环境 : 5G_JudgeNetwork_Type"); break;
        case 5: NSLog(@"设备的网络环境 : WIFI_JudgeNetwork_Type"); break;
        default: break;
    }
    
    
    // - 获取当前经纬度
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"你的GPS还没有打开");
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // - iOS8 前台定位
        [self.locationManager requestWhenInUseAuthorization];
        // - iOS8 前后台定位
        //[locationManager requestAlwaysAuthorization];
    }
    
    
    [self.locationManager startUpdatingLocation];
    self.locationManager.distanceFilter = 1000.0f;
    
    self.currentLatitude = [[NSString alloc] initWithFormat:@"%g", self.locationManager.location.coordinate.latitude];
    self.currentLongitude = [[NSString alloc] initWithFormat:@"%g", self.locationManager.location.coordinate.longitude];
    NSLog(@"设备所处的经度 : Latitude = %@", self.currentLatitude);
    NSLog(@"设备所处的纬度 : Longitude = %@", self.currentLongitude);// - 获取当前经纬度
    
    
    // - 应用名称
    NSString *app_name = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]];
    NSLog(@"应用定义名称 - %@",app_name);
    
    // - 应用版本号
    NSString *app_version = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
    NSLog(@"应用当前版本 - %@",app_version);
    
    
    // - 启动次数
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"应用启动次数 - 第一次启动");
    } else {
        NSLog(@"应用启动次数 - 不是第一次启动");
    }
    
    return YES;
}

#pragma mark -
#pragma mark - getDeviceModel - 设备具体型号
-(NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            
                            @"iPad4,1",
                            @"iPad4,2",
                            @"iPad4,3",
                            @"iPad4,4",
                            @"iPad4,5",
                            @"iPad4,6",
                            ];
    NSArray *modelNameArray = @[
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iPhone 6 Plus",
                                @"iPhone 6",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)",
                                
                                @"iPad Air (A1474)",
                                @"iPad Air (A1475)",
                                @"iPad Air (A1476)",
                                @"iPad Mini 2G (A1489)",
                                @"iPad Mini 2G (A1490)",
                                @"iPad Mini 2G (A1491)",
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    return modelNameString;
}

#pragma mark -
#pragma mark - isJailbroken - 是否越狱
- (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
