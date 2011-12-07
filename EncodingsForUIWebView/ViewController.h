//
//  ViewController.h
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/06.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UIWebView *_webView;
    UIActionSheet *_encodingsSheet;
}
@property(weak, nonatomic) UIWebView *webView;
@property(strong, nonatomic) UIActionSheet *encodingsSheet;

- (IBAction)selectEncoding:(id)sender;
@end
