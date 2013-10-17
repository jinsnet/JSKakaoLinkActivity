//
//  JSViewController.m
//  JSKakaoLink
//
//  Created by JinS on 16/10/13.
//  Copyright (c) 2013 JinS. All rights reserved.
//

#import "JSViewController.h"

#import "JSKakaoTalkActivity.h"
#import "JSKakaoStoryActivity.h"

@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowActivity:(id)sender {
    
    NSString *text = @"Test Share Message";
    NSURL *url = [NSURL URLWithString:@"http://itsmybb.com"];

    NSArray *activityItems = @[text, url];

    // your app's URL scheme
    NSString *appUrl = @"itsmybb://";
    
    // store link for downloading when a user has not been installed your app
    NSString *appStoreLink = @"http://itunes.apple.com/app/id642297187?mt=8";
    NSString *playStoreLink = @"market://details?id=com.itsmybb.android";

    // refer http://www.kakao.com/services/api/kakao_link
    NSMutableArray *metaInfoArray = [NSMutableArray array];
    
    NSDictionary *metaInfoIOS = @{
                                 @"os":@"ios",
                                 @"installurl":appStoreLink,
                                 @"executeurl":appUrl
                                 };
    [metaInfoArray addObject:metaInfoIOS];
    NSDictionary *metaInfoAndroid = @{
                                     @"os":@"android",
                                     @"installurl":playStoreLink,
                                     @"executeurl":appUrl
                                     };
    [metaInfoArray addObject:metaInfoAndroid];
    
    JSKakaoTalkActivity *kakaoTalkActivity = [[JSKakaoTalkActivity alloc] initWithMetaInfo:metaInfoArray];
    
    // refer http://www.kakao.com/services/api/story_link
    //    NSDictionary *metaStory = @{@"title":text};
    JSKakaoStoryActivity *kakoStoryActivity = [[JSKakaoStoryActivity alloc] initWithMetaInfo:nil];
    
    NSArray *activities = @[kakaoTalkActivity, kakoStoryActivity];
    
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems                                                                               applicationActivities:activities];
    
    activityView.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    
    [self presentViewController:activityView animated:YES completion:nil];
    
    
}



@end
