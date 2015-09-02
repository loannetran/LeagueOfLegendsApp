//
//  SearchViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "SearchViewController.h"
#import "MyTabBarViewController.h"
#import "NormalViewController.h"
#import "ChampionViewController.h"
#import "Data.h"

@interface SearchViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{

    NSString *searchName;
    NSURL *url;
    NSData *summonerData;
    NSDictionary *playerInfo;
    NSDictionary *dictChamps;
    NSArray *champNames;
    NSString *selectedChamp;
    UIImageView *imgView;
    BOOL isFiltered;
    NSMutableArray *filteredData;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self getChampNames];
    
    [self.champTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"champ"];
    
}

-(void)setUp{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bg.image = [UIImage imageNamed:@"bg.jpeg"];
    [bg setAlpha:0.50];
    [self.view insertSubview:bg atIndex:0];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.7]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:0.7]];
    
    [self.champTable setBackgroundColor:[UIColor clearColor]];
    
    [self.champTable setBounces:NO];
    [self.searchBtn setTitleColor:[UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.searchBtn.layer setBorderWidth:2];
    [self.searchBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.searchBtn.layer.cornerRadius = 10;
    self.searchBtn.layer.masksToBounds = YES;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:1];
    title.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:30];
    title.shadowColor = [UIColor lightGrayColor];
    title.text = @"Champions";
    [title setBackgroundColor:[UIColor grayColor]];
    [title.layer setBorderWidth:1];
    [title.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(isFiltered)
    {
        return filteredData.count;
    }else{
        return champNames.count;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
 
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    if(searchText.length == 0)
    {
        isFiltered = NO;
        
    }else
    {
        isFiltered = YES;
        
        filteredData = [[NSMutableArray alloc] init];
        
        for (NSObject *champ in champNames)
        {
            NSString *name = [NSString stringWithFormat:@"%@", champ];
            
            NSRange champRange = [name rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            
            if(champRange.location != NSNotFound)
            {
                [filteredData addObject:champ];
            }
        }
    
    }
    
    [self.champTable reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"champ"];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 80, 80)];
    
    UILabel *champName = [[UILabel alloc] initWithFrame:CGRectMake(117, 8, 195, 73)];
    champName.font = [UIFont fontWithName:@"GurmukhiMN" size:25];
    champName.textColor = [UIColor whiteColor];
    
    if(isFiltered)
    {
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/%@.png", [filteredData objectAtIndex:indexPath.row]]]]];
        
        champName.text = [NSString stringWithFormat:@"%@",[filteredData objectAtIndex:indexPath.row]];
        
    }else{
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/%@.png", [champNames objectAtIndex:indexPath.row]]]]];
        
        champName.text = [NSString stringWithFormat:@"%@",[champNames objectAtIndex:indexPath.row]];
    }
    
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imgView];
    
    champName.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:champName];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if([self.searchTxtFld isFirstResponder])
    {
        [self.searchTxtFld resignFirstResponder];
    }
    
    indexPath = [self.champTable indexPathForSelectedRow];
    
    UIAlertView *noInfo;
    
    if([[champNames objectAtIndex:indexPath.row] isEqual:@"Bard"] || [[champNames objectAtIndex:indexPath.row] isEqual:@"Ekko"] || [[champNames objectAtIndex:indexPath.row] isEqual:@"TahmKench"])
    {
        noInfo = [[UIAlertView alloc] initWithTitle:@"Champ Info" message:@"Champ information not available at this time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
    }if([[filteredData objectAtIndex:indexPath.row] isEqual:@"Bard"] || [[filteredData objectAtIndex:indexPath.row] isEqual:@"Ekko"] || [[filteredData objectAtIndex:indexPath.row] isEqual:@"TahmKench"]){
        
        noInfo = [[UIAlertView alloc] initWithTitle:@"Champ Info" message:@"Champ information not available at this time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
    }
        
    if(isFiltered)
    {
        selectedChamp = [NSString stringWithFormat:@"%@", [filteredData objectAtIndex:indexPath.row]];
       
        
    }else{
            selectedChamp = [NSString stringWithFormat:@"%@", [champNames objectAtIndex:indexPath.row]];
       
    }
    
    [self.champTable deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"champion" sender:self];
    
    
    [noInfo show];
}

-(void)getChampNames{
    
    dictChamps = [Data getChampData];
    
    champNames = [dictChamps allKeys];
    
    champNames = [champNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    searchName = [self.searchTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    summonerData = [Data getSummonerData:searchName];
    
    if(summonerData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summoner's name" message:@"Summoner's name does not exist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        [self.searchTxtFld becomeFirstResponder];
        summonerData = [Data getSummonerData:searchName];
        
    }else{
        
        [self.searchTxtFld resignFirstResponder];
        playerInfo = [NSJSONSerialization JSONObjectWithData:summonerData options:NSJSONReadingMutableContainers error:nil];
        
        [self performSegueWithIdentifier:@"search" sender:self];
        
    }
    
    
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    searchName = [self.searchTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    summonerData = [Data getSummonerData:searchName];
    
    if(summonerData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summoner's name" message:@"Summoner's name does not exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        [self.searchTxtFld becomeFirstResponder];
        
        summonerData = [Data getSummonerData:searchName];
        
        return NO;
        
    }else{
        [self.searchTxtFld resignFirstResponder];
        playerInfo = [NSJSONSerialization JSONObjectWithData:summonerData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"search"])
    {
        MyTabBarViewController *tbVc = segue.destinationViewController;
        
        tbVc.playerInfo = [playerInfo objectForKey:searchName];

    }
    
    if([[segue identifier] isEqualToString:@"champion"])
    {
        ChampionViewController *cVc = segue.destinationViewController;
        
        cVc.champName = selectedChamp;
    }
    
}

@end
