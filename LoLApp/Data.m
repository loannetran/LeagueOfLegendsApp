//
//  Data.m
//  LoLApp
//
//  Created by LT on 2015-09-01.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "Data.h"

@implementation Data

+(id)getChampData{
    
    
    NSURL *url = [NSURL URLWithString:@"https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image&api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
    
    return dict;
}

+(id)getSummonerData:(NSString *)summoner{
    
    [summoner lowercaseString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/%@?api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822",summoner]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}


@end
