//
//  DeviceInfo.m
//  千人计划
//
//  Created by rockontrol on 14/11/27.
//  Copyright (c) 2014年 rockontrol. All rights reserved.
//

#import "DeviceInfo.h"

//  get mac
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation DeviceInfo

//获取设备大小
+(CGSize)ScreenSize
{
    CGSize size_screen = [[UIScreen mainScreen] bounds].size;
    return size_screen;
}

//设备顶部
+(CGFloat)ScreenTop
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}

+(CGFloat)ScreenNavgationBarHeight
{
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    CGRect rectNav = navigationController.navigationBar.frame;
    return rectNav.size.height;
}

+(CGFloat)ScreenNavgationBarHeightBy:(UINavigationController *)navigationController
{
    CGRect rectNav = navigationController.navigationBar.frame;
    return rectNav.size.height;
}

+ (CGFloat)ScreenTTop{
    return [DeviceInfo ScreenTop] + [DeviceInfo ScreenNavgationBarHeight];
}

+ (CGFloat)ScreenMiddleHeight{
    return [DeviceInfo ScreenSize].height - [DeviceInfo ScreenTTop];
}

+(CGFloat)TabBarHeight
{
    return 48;
}

+(NSString*)AppBasePath:(NSString*)pathtype
{
    if([pathtype isEqualToString:@"resource"])
    {
        NSString *resPath = [[NSBundle mainBundle] resourcePath];
        return resPath;
    }
    else if ([pathtype isEqualToString:@"document"])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        return docDir;
    }
    else
    {
        return nil;
    }
}

+(NSString*)AppBaseResourcePath:(NSString*)filename
{
    return [NSString stringWithFormat:@"%@/%@", [DeviceInfo AppBasePath:@"resource"], filename];
}

+(NSString*)AppBaseDocumentPath:(NSString*)filename
{
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [NSString stringWithFormat:@"%@/%@", DocumentsPath, filename];
}

+ (NSString*)AppBaseCachePath:(NSString*)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", path, filename];
}

//除去顶部剩下的高度
+(int)OtherTopHeight
{
    return [DeviceInfo ScreenSize].height-[DeviceInfo ScreenTop];
}

//获取屏幕缩放率
+(CGFloat)ScreenScale
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return scale_screen;
}

//系统的名字
+(NSString*)SystemName
{
    return [[UIDevice currentDevice] systemName];
}

//系统的版本
+(NSString*)SystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//设备的唯一识别码
+(NSString*)DeviceUniqueIdentifier
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

//设备的名字
+(NSString*)DeviceName
{
    return [[UIDevice currentDevice] name];
}

//App的信息
+(NSDictionary*)AppInfo
{
//    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    // app build版本
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}

+ (NSString *)macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+(NSString*)uuid
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid);
    NSString * result = (NSString*)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result lowercaseString];
}

+ (CGFloat)scalHeightByWidth:(CGFloat)width
                      BySize:(CGSize)size{
    return size.height*width/size.width;
}

+ (CGFloat)scalWidthByHeight:(CGFloat)height
                      BySize:(CGSize)size{
    return height*size.width/size.height;
}

@end









