//
//  DataDownloader.m
//  LoLApp
//
//  Created by Loanne Tran on 9/2/15.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "DataDownloader.h"

@implementation DataDownloader

-(void)downloadDataForURL:(NSString *)url for:(NSString *)name{
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self performSelectorOnMainThread:@selector(passThisData:) withObject:data waitUntilDone:NO];
        
    }] resume];
    
    self.name = name;
}

-(void)passThisData:(NSData *)data{
    
    if([self.delegate respondsToSelector:@selector(theDataIs:)]){
        
        [self.delegate theDataIs:data];
    }
}

@end
