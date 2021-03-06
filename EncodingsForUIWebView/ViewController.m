//
//  ViewController.m
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/06.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "CustomURLProtocol.h"

@implementation ViewController
@synthesize webView = _webView;

- (void)didReceiveMemoryWarning
{
	NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)dealloc
{
    self.webView.delegate = nil;
}

- (void)viewDidLoad
{
	NSLog(@"%s", __func__);
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.encoding = @"AUTO";
    appDelegate.userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSURL *url = [NSURL URLWithString:@"http://www.yahoo.co.jp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
}

- (void)viewDidUnload
{
	NSLog(@"%s", __func__);
    self.webView.delegate = nil;
    self.webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"%s", __func__);
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@"%s", __func__);
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@"%s", __func__);
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"%s", __func__);
    return YES;
}

- (void) webViewDidStartLoad: (UIWebView *) view {
	NSLog(@"%s", __func__);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)view {
	NSLog(@"%s", __func__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"%s", __func__);
    
}


#pragma mark - Actions
- (IBAction)selectEncoding:(id)sender
{
	NSLog(@"%s", __func__);
    UIActionSheet *encodingsSheet = [[UIActionSheet alloc] initWithTitle:@"文字コード" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"AUTO", @"UTF-8", @"SJIS", @"EUC-JP", nil];
    
    [encodingsSheet showInView:self.webView];
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"キャンセル"]) {
        return;
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"AUTO"]){
        appDelegate.encoding = @"AUTO";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"UTF-8"]){
        appDelegate.encoding = @"UTF-8";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"SJIS"]){
        appDelegate.encoding = @"SJIS";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"EUC-JP"]){
        appDelegate.encoding = @"EUC-JP";
    }
    
    [self.webView reload];
    
}

@end
