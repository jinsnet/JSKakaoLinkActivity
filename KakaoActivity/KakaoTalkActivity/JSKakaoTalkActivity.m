//
//  KakaoTalkActivity.m
//  JSKakaoLinkActivity
//
//  Created by JinS on 15/10/13.
//  Copyright (c) 2013 JinS. All rights reserved.
//

#import "JSKakaoTalkActivity.h"
#import "KakaoLinkCenter.h"

@implementation JSKakaoTalkActivity {
    
    NSString *_msg;
    NSString *_url;
    NSMutableArray *_meta;
}

- (id)initWithMetaInfo:(NSMutableArray *)metaInfo
{
    _meta = metaInfo;
    
    return self;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return @"KakaoTalkActivity";
}

- (UIImage *)activityImage
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        return [UIImage imageNamed:@"icon_kakaotalk_ios7"];
    else
        return [UIImage imageNamed:@"icon_kakaotalk"];
}

- (NSString *)activityTitle
{
    return NSLocalizedString(@"KakaoTalk", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if([KakaoLinkCenter canOpenKakaoLink]) return YES;
    
    // if you want to show even an app is not installed then return YES
    // 카카오 앱이 설치 안되어있어도 아이콘이 노출되기 원하면 YES로 변경    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if([activityItem isKindOfClass:[NSString class]]) {
            _msg = activityItem;
        } else if([activityItem isKindOfClass:[NSURL class]]) {
            _url = [activityItem absoluteString];
        }
    }
}


- (void)openiTunes
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id362057947?mt=8"]];
}

- (void)performActivity{
    
    if (![KakaoLinkCenter canOpenKakaoLink]) {
        [self openiTunes];
        return;
    }
    
    NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    if(![KakaoLinkCenter openKakaoAppLinkWithMessage:_msg URL:_url appBundleID:appBundleID appVersion:appVersion appName:appName metaInfoArray:_meta])
    {
        // no kakaotalk
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No KakaoTalk", nil)
                                    message:NSLocalizedString(@"You have to install a Kakaotalk to use this feature.", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
}

@end
