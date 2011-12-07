//
//  CustomURLProtocol.m
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/06.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//
#import "AppDelegate.h"
#import "CustomURLProtocol.h"
#import "ASIHTTPRequest.h"

@implementation CustomURLProtocol
@synthesize queue = _queue;
@synthesize asiRequest = _asiRequest;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
	NSLog(@"%s", __func__);
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 文字コードがAUTOならスルー
    if ([appDelegate.encoding isEqualToString:@"AUTO"]) {
        return NO;
    }
    
    // css, javascript, 画像ならスルー
    NSString *pathExtension = [[request URL] pathExtension];
    if ([pathExtension caseInsensitiveCompare:@"css"] == NSOrderedSame ||
        [pathExtension caseInsensitiveCompare:@"js"] == NSOrderedSame ||
        [pathExtension caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
        [pathExtension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame ||
        [pathExtension caseInsensitiveCompare:@"png"] == NSOrderedSame ||
        [pathExtension caseInsensitiveCompare:@"gif"] == NSOrderedSame)
    {
        return NO;
    }
    
    // URLスキームがhttpかhttpsなRequestは扱う
    if ([request.URL.scheme isEqualToString:@"http"] ||
        [request.URL.scheme isEqualToString:@"https"]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
	NSLog(@"%s", __func__);
    return request;
}

- (void)startLoading
{
	NSLog(@"%s", __func__);
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!self.queue) {
        [self setQueue:[[NSOperationQueue alloc] init]];
    }
    
    NSURL *url = [self.request URL];
    NSLog(@"url : %@", [url absoluteURL]);
    
    // ASIHTTPRequestの準備
    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
    [self.asiRequest setUserAgent:appDelegate.userAgent];
    [self.asiRequest setDelegate:self];
    
    // RequestをNSOperationQueueに入れる
    [self.queue addOperation:self.asiRequest];
    
}

- (void)stopLoading
{
	NSLog(@"%s", __func__);
    [self.asiRequest setDelegate:nil];
    [self.queue cancelAllOperations];
}

#pragma mark - ASIHttpRequest Delegate
- (void) requestFinished:(ASIHTTPRequest *)asiRequest
{
	NSLog(@"%s", __func__);
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Response Headersの取得
    NSDictionary *responseHeaders = [asiRequest responseHeaders];
    
    // Content-Typeの取得
    NSArray *contentTypeArray = [[responseHeaders objectForKey:@"Content-Type"] componentsSeparatedByString:@";"];
    NSString *contentType = [responseHeaders objectForKey:@"Content-Type"];
    if ([contentTypeArray count] >= 1) {
        contentType = [contentTypeArray objectAtIndex:0];
    }else {
        contentType = nil;
    }
    NSLog(@"content type : %@", contentType);
    
    // Content-Typeが"text/html"なら文字コードを設定 
    NSString *encoding = nil;
    if ([contentType isEqualToString:@"text/html"] && [appDelegate.encoding length] > 0) {
        encoding = appDelegate.encoding;
    }
    
    // NSURLResponseの設定
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:asiRequest.url MIMEType:contentType expectedContentLength:[[asiRequest responseData] length] textEncodingName:encoding];

    // NSURLResponseとデータを渡す
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:[asiRequest responseData]];
    [self.client URLProtocolDidFinishLoading:self];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"%s", __func__);
    NSError *error = [request error];
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
}

@end
