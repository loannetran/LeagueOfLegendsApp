//
//  RankedViewController.h
//  LoLApp
//
//  Created by LT on 2015-08-31.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownloader.h"

@interface RankedViewController : UIViewController <DataDownloaderDelegate>{
    
    NSDictionary *jsonDictForRankedDisplay;
    NSDictionary *jsonDictForRankedStats;
    
    NSDictionary *rankedStats;
    NSDictionary *playerStats;
    NSDictionary *soloLeague;
    NSString *soloTier;
    NSString *soloDivision;
    NSString *soloWin;
    NSString *soloLosses;
    NSString *soloLeaguePts;
    NSDictionary *teamStats;
    NSDictionary *teamLeague;
    NSString *teamTier;
    NSString *teamDivision;
    NSString *teamWin;
    NSString *teamLosses;
    NSString *teamLeaguePts;
    DataDownloader *downloader;

}
@property (weak, nonatomic) IBOutlet UITextView *teamRankedStatsTxtView;
@property (weak, nonatomic) IBOutlet UITextView *soloRankedStatsTxtView;
@property (weak, nonatomic) IBOutlet UILabel *rankedTitle;
@property (weak, nonatomic) NSString *playerId;
@property (weak,nonatomic) NSDictionary *playerInfo;
@property (weak, nonatomic) IBOutlet UIImageView *soloImg;
@property (weak, nonatomic) IBOutlet UIImageView *teamImg;
@property (weak, nonatomic) IBOutlet UILabel *soloRank;
@property (weak, nonatomic) IBOutlet UILabel *teamRank;
@property (weak, nonatomic) IBOutlet UILabel *soloLP;
@property (weak, nonatomic) IBOutlet UILabel *soloWins;
@property (weak, nonatomic) IBOutlet UILabel *soloLoss;
@property (weak, nonatomic) IBOutlet UILabel *teamLP;
@property (weak, nonatomic) IBOutlet UILabel *teamWins;
@property (weak, nonatomic) IBOutlet UILabel *teamLoss;
@property (weak, nonatomic) IBOutlet UIView *soloView;
@property (weak, nonatomic) IBOutlet UIView *teamView;

@property (weak, nonatomic) IBOutlet UILabel *soloWinLbl;
@property (weak, nonatomic) IBOutlet UILabel *soloLossLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamWinLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamLossLbl;


@end
