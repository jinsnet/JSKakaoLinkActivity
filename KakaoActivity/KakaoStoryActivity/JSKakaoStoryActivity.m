//
//  JSKakaoStoryActivity.m
//  JSKakaoLinkActivity
//
//  Created by JinS on 15/10/13.
//  Copyright (c) 2013 JinS. All rights reserved.
//

#import "JSKakaoStoryActivity.h"
#import "KakaoLinkCenter.h"

@implementation JSKakaoStoryActivity{
    
    NSString *_msg;
    NSString *_url;
    NSDictionary *_meta;
    
}

- (id)initWithMetaInfo:(NSDictionary *)metaInfo
{
    _meta = metaInfo;
    
    return self;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return @"KakaoStoryActivity";
}

- (UIImage *)activityImage
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        return [UIImage imageNamed:@"icon_kakaostory_ios7"];
    else
        return [UIImage imageNamed:@"icon_kakaostory"];
}

- (NSString *)activityTitle
{
    return NSLocalizedString(@"KakaoStory", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if([KakaoLinkCenter canOpenStoryLink]) return YES;
    
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

// if no app installed, go to app store.
- (void)openiTunes {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id486244601?mt=8"]];
}

- (void)performActivity {
    
    if (![KakaoLinkCenter canOpenStoryLink]) {
        [self openiTunes];
        return;
    }
    
    NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSString *msg = [NSString stringWithFormat:@"%@ %@", _msg, _url];
    
    if(![KakaoLinkCenter openStoryLinkWithPost:msg appBundleID:appBundleID appVersion:appVersion appName:appName urlInfo:_meta]) {
        // no app installed
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No KakaoStory", nil)
                                    message:NSLocalizedString(@"You have to install a KakaoStory to use this feature.", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
}

@end
