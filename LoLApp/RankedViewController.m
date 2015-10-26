//
//  RankedViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-31.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "RankedViewController.h"

@interface RankedViewController ()

@end

@implementation RankedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBottomBorderForView:self.rankedTitle];
    [self.soloView.layer setBorderWidth:1];
    [self.soloView setAlpha:0.7];
    [self.teamView setAlpha:0.7];
    
    downloader = [[DataDownloader alloc] init];
    downloader.delegate = self;
    
    [self getData];
}

-(void)getData{
    
//    NSLog(@"%@", self.playerId);
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/%@/entry?api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822",self.playerId] for:@"rankedInfo"];
    
}

-(void)theDataIs:(NSData *)data{
    
    if ([downloader.name isEqualToString:@"rankedInfo"]) {
     
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *ranked = [dict objectForKey:[NSString stringWithFormat:@"%@",self.playerId]];
        
        if (dict == nil) {
            soloTier = @"Unranked";
            teamTier = @"Unranked";
        }else if (ranked.count == 1)
        {
            teamTier = @"Unranked";
            
        }
        
        for (NSDictionary *queueType in ranked) {
            
            if ([[queueType objectForKey:@"queue"] isEqualToString:@"RANKED_SOLO_5x5"]) {
                
                    soloLeague = queueType;
                    
                    if(soloLeague == nil)
                    {
                        soloTier = @"Unranked";
                        
                    }else{
                        
                        soloTier = [soloLeague objectForKey:@"tier"];
                        
                        playerStats = [[soloLeague objectForKey:@"entries"] objectAtIndex:0];
                        
//                        NSString *playerName = [playerStats objectForKey:@"playerOrTeamName"];
                        
                        soloDivision = [playerStats objectForKey:@"division"];
                        soloLeaguePts = [playerStats objectForKey:@"leaguePoints"];
                        soloLosses = [playerStats objectForKey:@"losses"];
                        soloWin = [playerStats objectForKey:@"wins"];
                        
                    }
                
            }else if ([[queueType objectForKey:@"queue"] isEqualToString:@"RANKED_TEAM_5x5"]) {
                
                teamLeague = queueType;
                
                    if(teamLeague == nil)
                    {
                        teamTier = @"Unranked";
                        
                    }else{
                        
                        if (teamTier == nil) {
                            
                            teamTier = [teamLeague objectForKey:@"tier"];
                            
                            teamStats = [[teamLeague objectForKey:@"entries"] objectAtIndex:0];
                            
                            //                        NSString *playerName = [playerStats objectForKey:@"playerOrTeamName"];
                            
                            teamDivision = [teamStats objectForKey:@"division"];
                            teamLeaguePts = [teamStats objectForKey:@"leaguePoints"];
                            teamLosses = [teamStats objectForKey:@"losses"];
                            teamWin = [teamStats objectForKey:@"wins"];

                        }
                    }
                }
            }
        }
    
    [self setData];
    
}

-(void)setData{
    
    if([soloTier isEqualToString:@"Unranked"])
    {
        self.soloRank.text = soloTier;
        self.soloLP.text = @"";
        self.soloWins.text = @"";
        self.soloLoss.text = @"";
        [self.soloWinLbl setHidden:YES];
        [self.soloLossLbl setHidden:YES];
        
        self.soloImg.image = [UIImage imageNamed:@"provisional.png"];
    }else{
        
        self.soloRank.text = [NSString stringWithFormat:@"%@ %@", soloTier,soloDivision];
        self.soloLP.text = [NSString stringWithFormat:@"%@ League Points",soloLeaguePts];
        self.soloWins.text = [NSString stringWithFormat:@"%@",soloWin];
        self.soloLoss.text = [NSString stringWithFormat:@"%@",soloLosses];
        
        [soloTier lowercaseString];
        [soloDivision lowercaseString];
        
        self.soloImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.png",soloTier,soloDivision]];
    }
    
    if([teamTier isEqualToString:@"Unranked"])
    {
        self.teamRank.text = teamTier;
        self.teamLP.text = @"";
        self.teamWins.text = @"";
        self.teamLoss.text = @"";
        [self.teamWinLbl setHidden:YES];
        [self.teamLossLbl setHidden:YES];
        
        self.teamImg.image = [UIImage imageNamed:@"provisional.png"];
    }else{
        
        self.teamRank.text = [NSString stringWithFormat:@"%@ %@", teamTier,teamDivision];
        self.teamLP.text = [NSString stringWithFormat:@"%@ League Points",teamLeaguePts];
        self.teamWins.text = [NSString stringWithFormat:@"%@",teamWin];
        self.teamLoss.text = [NSString stringWithFormat:@"%@",teamLosses];
        
        [teamTier lowercaseString];
        [teamDivision lowercaseString];
        
        self.teamImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.png",teamTier,teamDivision]];
    }

}

-(void)setBottomBorderForView:(UIView *)view{
    
    CALayer *layer = [view layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
