//
//  NormalViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bg.image = [UIImage imageNamed:@"greyBg.jpg"];
    [self.view insertSubview:bg atIndex:0];
    
    [self.playerStatsTitles setBackgroundColor:[UIColor clearColor]];
    
    playerName = [self.playerInfo objectForKey:@"name"];
    
    downloader = [[DataDownloader alloc] init];
    downloader.delegate = self;
    
    [self getData];
}

-(void)viewDidAppear:(BOOL)animated
{
    animated = YES;
    
    self.tabBarController.title = playerName;

}

-(void)getData{
    
    currentData = @"playerSummary";
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/%@/summary?season=SEASON2015&api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822",self.playerID] for:currentData];
    
    
}

-(void)theDataIs:(NSData *)data{
    
    if([downloader.name isEqualToString:@"playerSummary"])
    {
        playerSummary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"playerStatSummaries"];
        
        for (int i=0; i<playerSummary.count; i++) {
            
            if([[[playerSummary objectAtIndex:i] objectForKey:@"playerStatSummaryType"] isEqualToString:@"Unranked"]){
                
                unrankedData = [playerSummary objectAtIndex:i];
                break;
            }
        }
        
        [self setData];
    }
}

-(void)setData{
    
    urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/profileicon/%@.png",[self.playerInfo objectForKey:@"profileIconId"]]];
    
    self.playerIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
    [self.playerIcon.layer setBorderWidth:5];
    self.playerIcon.layer.borderColor = [UIColor colorWithRed:42.0/255.0 green:103.0/255.0 blue:100.0/255.0 alpha:1].CGColor;
    self.playerIcon.layer.cornerRadius = 50;
    self.playerIcon.layer.masksToBounds = YES;
    
    self.tabBarController.title = playerName;
    
    self.level.textColor = [UIColor whiteColor];
    self.level.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:30];
    
    self.level.layer.borderColor = [UIColor colorWithRed:57.0/255.0 green:138.0/255.0 blue:135.0/255.0 alpha:1].CGColor;
    self.level.layer.borderWidth = 2;
    
    self.level.text = [NSString stringWithFormat:@"Level %@",[self.playerInfo objectForKey:@"summonerLevel"]];
    
    self.totalWins.font = [UIFont fontWithName:@"Courier" size:30];
    self.totalWins.textColor = [UIColor whiteColor];
    self.totalWins.text = [NSString stringWithFormat:@"%@",[unrankedData objectForKey:@"wins"]];
    
    self.playerStatsTitles.text = @"Kills:\n\nAssists:\n\nMinion Kills:\n\nNeutral Minion Kills:\n\nTurrets Destroyed:";
    
    NSDictionary *stats = [unrankedData objectForKey:@"aggregatedStats"];

    self.playerStats.textColor = [UIColor whiteColor];

    self.playerStats.text = [NSString stringWithFormat:@"%@",[stats objectForKey:@"totalChampionKills"]];
    self.playerStats.text = [self.playerStats.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[stats objectForKey:@"totalAssists"]]];
    self.playerStats.text = [self.playerStats.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[stats objectForKey:@"totalMinionKills"]]];
    self.playerStats.text = [self.playerStats.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[stats objectForKey:@"totalNeutralMinionsKilled"]]];
    self.playerStats.text = [self.playerStats.text stringByAppendingString:[NSString stringWithFormat:@"\n\n\n%@",[stats objectForKey:@"totalTurretsKilled"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//
//}


@end
