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
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/%@?api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822",self.playerId] for:@"rankedInfo"];
    
}

-(void)theDataIs:(NSData *)data{
    
    if ([downloader.name isEqualToString:@"rankedInfo"]) {
     
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        soloLeague = [dict objectForKey:[NSString stringWithFormat:@"%@",self.playerId]];
        
        if(soloLeague == nil)
        {
            tier = @"Unranked";
            
        }else{
            
            for (int i = 0; i<soloLeague.count; i++) {
                if([[[soloLeague objectAtIndex:i] objectForKey:@"queue"] isEqualToString:@"RANKED_SOLO_5x5"]){
                    
                    tier = [[soloLeague objectAtIndex:i] objectForKey:@"tier"];
                    playersInThisLeague = [[soloLeague objectAtIndex:i] objectForKey:@"entries"];
                    break;
                }
            }
            
            NSString *playerName = [self.playerInfo objectForKey:@"name"];
            
            for(int i = 0; i<playersInThisLeague.count; i++)
            {
                if([[[playersInThisLeague objectAtIndex:i] objectForKey:@"playerOrTeamName"] isEqualToString:playerName])
                {
                    playerStats = [playersInThisLeague objectAtIndex:i];
                    NSLog(@"%@",playerStats);
                    break;
                }
            }
            
            division = [playerStats objectForKey:@"division"];
            leaguePts = [playerStats objectForKey:@"leaguePoints"];
            loss = [playerStats objectForKey:@"losses"];
            wins = [playerStats objectForKey:@"wins"];
            
        }
        
        [self setData];
    }
    
}

-(void)setData{
    
    if([tier isEqualToString:@"Unranked"])
    {
        self.soloRank.text = tier;
        self.soloLP.text = @"";
        self.soloWins.text = @"";
        self.soloLoss.text = @"";
        [self.soloWinLbl setHidden:YES];
        [self.soloLossLbl setHidden:YES];
        
        self.soloImg.image = [UIImage imageNamed:@"provisional.png"];
    }else{
        
        self.soloRank.text = [NSString stringWithFormat:@"%@ %@", tier,division];
        self.soloLP.text = [NSString stringWithFormat:@"%@ League Points",leaguePts];
        self.soloWins.text = [NSString stringWithFormat:@"%@",wins];
        self.soloLoss.text = [NSString stringWithFormat:@"%@",loss];
        
        [tier lowercaseString];
        [division lowercaseString];
        
        self.soloImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.png",tier,division]];
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
