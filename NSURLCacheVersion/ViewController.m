//
//  ViewController.m
//  NSURLCacheVersion
//
//  Created by Masaru Sakai on 11/12/07.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import "ViewController.h"
#import "CustomURLCache.h"
#import "ASIHTTPRequest.h"

@implementation ViewController
@synthesize webView = _webView;
@synthesize encoding = _encoding;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	NSLog(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 初期文字コード
    self.encoding = @"AUTO";
    
    // CustomURLCacheの準備
    [self setCustomCache];
    
    // 読み込み開始
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    _webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setCustomCache
{
    NSLog(@"%s", __func__);
    
    // CustomURLCacheの準備
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* diskCachePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"_CustomCache"];
    NSError* error; 
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    CustomURLCache *cache = [[CustomURLCache alloc] initWithMemoryCapacity: [[NSURLCache sharedURLCache] memoryCapacity] diskCapacity: [[NSURLCache sharedURLCache] diskCapacity] diskPath:diskCachePath];
    cache.userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    cache.encoding = self.encoding;
    
    [NSURLCache setSharedURLCache:cache];
}


#pragma mark -
#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"%s", __func__);
    
    // CustomURLCacheの更新
    [self setCustomCache];
    
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
- (IBAction)reloadWebView:(id)sender
{
    
    NSLog(@"%s", __func__);
    
    NSURL *url = [NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"]];
    
    
    NSLog(@"encoding : %@", self.encoding);
    
    // CustomCacheの更新
    [self setCustomCache];
    
    // 文字コードがAUTOの時は普通にリロード
    if ([self.encoding isEqualToString:@"AUTO"]) {
        [self.webView reload];
        return;
    }
    
    // ASIHTTPRequestの準備
    ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setUserAgent:[self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
    [asiRequest setDelegate:self];
    [asiRequest startAsynchronous];
    
}

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
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"キャンセル"]) {
        return;
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"AUTO"]){
        self.encoding = @"AUTO";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"UTF-8"]){
        self.encoding = @"UTF-8";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"SJIS"]){
        self.encoding = @"SJIS";
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"EUC-JP"]){
        self.encoding = @"EUC-JP";
    }
    
    [self reloadWebView:nil];
    
}

#pragma mark - ASIHttpRequest Delegate
- (void) requestFinished:(ASIHTTPRequest *)asiRequest
{
	NSLog(@"%s", __func__);
    NSData *responseData = [asiRequest responseData];
    
    NSDictionary *responseHeaders = [asiRequest responseHeaders];
    NSArray *contentTypeArray = [[responseHeaders objectForKey:@"Content-Type"] componentsSeparatedByString:@";"];
    NSString *contentType;
    if ([contentTypeArray count] >= 1) {
        contentType = [contentTypeArray objectAtIndex:0];
    }else {
        contentType = nil;
    }
    
    [self.webView loadData:responseData MIMEType:contentType textEncodingName:self.encoding baseURL:asiRequest.url];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"%s", __func__);
    NSError *error = [request error];
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
}

@end
