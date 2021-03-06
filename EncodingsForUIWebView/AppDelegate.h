//
//  AppDelegate.h
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/06.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *_encoding;
    NSString *_userAgent;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *encoding;
@property (strong, nonatomic) NSString *userAgent;
@end
