//
//  CustomURLCache.h
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/07.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLCache : NSURLCache
{
    NSString *_encoding;
    NSString *_userAgent;
}
@property (strong, nonatomic) NSString *encoding;
@property (strong, nonatomic) NSString *userAgent;
@end
