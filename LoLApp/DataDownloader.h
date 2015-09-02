//
//  DataDownloader.h
//  LoLApp
//
//  Created by Loanne Tran on 9/2/15.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataDownloaderDelegate <NSObject>

-(void)theDataIs:(NSData *)data;

@end

@interface DataDownloader : NSObject

@property (nonatomic, weak) NSString *name;

@property (nonatomic, assign) id<DataDownloaderDelegate> delegate;

-(void)downloadDataForURL:(NSString *)url for:(NSString *)name;

@end
