//
//  ViewController.h
//  NSURLCacheVersion
//
//  Created by Masaru Sakai on 11/12/07.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UIWebView *_webView;
    
    NSString *_encoding;
}
@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *encoding;

- (void)setCustomCache;
- (IBAction)reloadWebView:(id)sender;
@end
