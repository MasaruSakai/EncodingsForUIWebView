//
//  CustomURLProtocol.h
//  EncodingsForUIWebView
//
//  Created by Masaru Sakai on 11/12/06.
//  Copyright (c) 2011年 Masaru Sakai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

@interface CustomURLProtocol : NSURLProtocol
{
    NSOperationQueue *_queue;
    ASIHTTPRequest *_asiRequest;
}
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) ASIHTTPRequest *asiRequest;

@end
