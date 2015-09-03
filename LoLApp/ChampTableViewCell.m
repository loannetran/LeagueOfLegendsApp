//
//  ChampTableViewCell.m
//  LoLApp
//
//  Created by LT on 2015-09-02.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "ChampTableViewCell.h"

@implementation ChampTableViewCell

- (void)awakeFromNib {
    // Initialization code
    downloader = [[DataDownloader alloc] init];
    downloader.delegate = self;
}

-(void)getDataForChamp:(NSString *)champName{
    
    currentData = @"champImg";
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/%@.png", champName] for:currentData];
    
    self.champLbl.text = [NSString stringWithFormat:@"%@",champName];
}

-(void)theDataIs:(NSData *)data{
    
    if([currentData isEqualToString:@"champImg"]){
        
        self.champImgView.image = [UIImage imageWithData:data];
        self.champImgView.layer.cornerRadius = 10;
        self.champImgView.layer.masksToBounds = YES;
        self.champLbl.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
