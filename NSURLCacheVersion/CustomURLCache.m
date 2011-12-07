//
//  CustomURLCache.m
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/07.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import "CustomURLCache.h"
#import "ASIHTTPRequest.h"

@implementation CustomURLCache
@synthesize encoding;
@synthesize userAgent;

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSLog(@"%s", __func__);
    
    NSCachedURLResponse* cacheResponse  = nil;
    cacheResponse = [super cachedResponseForRequest:request];
    
    // 文字コードがAUTOならスルー
    if ([self.encoding isEqualToString:@"AUTO"]) {
        return cacheResponse;
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
        return cacheResponse;
    }
    
    // 同期でHTMLファイルを取得
    NSURL *url = [NSURL URLWithString:[[request URL] absoluteString]];
    
    ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setUserAgent:self.userAgent];
    [asiRequest startSynchronous];
    
    NSDictionary *responseHeaders = [asiRequest responseHeaders];
    NSLog(@"responseHeaders : %@", [responseHeaders description]);
    NSArray *contentTypeArray = [[responseHeaders objectForKey:@"Content-Type"] componentsSeparatedByString:@";"];
    NSString *contentType;
    if ([contentTypeArray count] >= 1) {
        contentType = [contentTypeArray objectAtIndex:0];
    }else {
        contentType = nil;
    }
    NSLog(@"contentType : %@", contentType);
    
    // Content-Typeがtext/htmlならcacheResponseを作り直す
    if ([contentType isEqualToString:@"text/html"]) {
        
        NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:contentType expectedContentLength:[[asiRequest responseData] length] textEncodingName:self.encoding];
        cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:[asiRequest responseData]];
    }

    
    return cacheResponse;
}
@end
