//
//  ViewController.m
//  Test
//
//  Created by Lizard Yong on 13/07/2018.
//  Copyright © 2018 Chong Chee Yong. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblview;
    NSMutableArray *ShopName;
    NSMutableArray *ShopTime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ShopName = [[NSMutableArray alloc]init];
    ShopTime = [[NSMutableArray alloc]init];
    [self LoadCSVFile];
}
-(void)LoadCSVFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iOS_TakeHomeTest2" ofType:@"csv"];
    NSError *error;
    NSString *csvData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray *gcRawData = [csvData componentsSeparatedByString:@"\n"];
    //NSLog(@"gcRawData --- %@",gcRawData);
    
    for (int i = 0; i < gcRawData.count; i++)
    {
        NSArray *TempArray = [NSArray array];
        NSString *nextGCString = [NSString stringWithFormat:@"%@", gcRawData[i]];
        TempArray = [nextGCString componentsSeparatedByString:@","];
        if (TempArray.count > 1) {
//            NSLog(@"TempArray[0] --- %@",TempArray[0]);
//            NSLog(@"TempArray[1] --- %@",TempArray[1]);
            
            NSString *TempName = TempArray[0];
            NSString *stringWithoutSpaces = [TempName
                                             stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            NSString *TempTime = TempArray[1];
            NSString *stringWithoutSpaces1 = [TempTime
                                             stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            NSString *TempTime2 = @"";
            NSString *FinalTime = @"";
            if (TempArray.count > 2) {
                TempTime2 = TempArray[2];
                NSString *stringWithoutSpaces2 = [TempTime2
                                                  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                FinalTime = [NSString stringWithFormat: @"%@, %@", stringWithoutSpaces1, stringWithoutSpaces2];
                
            }else{
                FinalTime = [NSString stringWithFormat: @"%@", stringWithoutSpaces1];
            }
            
            
            
            [ShopName addObject:stringWithoutSpaces];
            [ShopTime addObject:FinalTime];
        }
    }
    
    [self CheckTime];
}

-(void)CheckTime{
    NSMutableArray *FinalTimeArray = [[NSMutableArray alloc]init];
    
    NSArray *WeeklyNormal = [[NSArray alloc]initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];
    for (int i = 0; i < ShopTime.count; i++)
    {
        NSArray *TempArray = [NSArray array];
        NSString *nextGCString = [NSString stringWithFormat:@"%@", ShopTime[i]];
        TempArray = [nextGCString componentsSeparatedByString:@"/"];
      //  NSLog(@"TempArray === %@",TempArray);
        if(TempArray.count == 1){
           // NSLog(@"TempArray === %@",TempArray);
            NSString *TimeCheck01 = TempArray[0];
            NSArray *CheckWeekly = [NSArray array];
            CheckWeekly = [TimeCheck01 componentsSeparatedByString:@" "];
            NSString *GetWeeklyTemp = CheckWeekly[0];
          //  NSLog(@"GetWeeklyTemp === %@",GetWeeklyTemp);
            
            NSArray *Weekly = [NSArray array];
            Weekly = [GetWeeklyTemp componentsSeparatedByString:@"-"];
            if(Weekly.count > 1){
                NSString *WeekStart = Weekly[0];
                NSString *WeekEnd = Weekly[1];
                
                NSString *CheckWeek = [[NSString alloc]initWithFormat:@"%@-%@",WeekStart,WeekEnd];
                NSArray *TimeArray = [NSArray array];
                TimeArray = [TimeCheck01 componentsSeparatedByString:CheckWeek];
              //  NSLog(@"TimeArray === %@",TimeArray);
                NSString *GetFinalTime = TimeArray[1];
              //  NSLog(@"GetFinalTime === %@",GetFinalTime);
                
                NSMutableArray *TempAddAllTime = [[NSMutableArray alloc]init];
                for (int z = 0; z < WeeklyNormal.count; z++) {
                    NSString *WeeklyCheck = [WeeklyNormal objectAtIndex:z];
                    if ([WeeklyCheck isEqualToString:WeekEnd]) {
                        NSString *LastTime = [[NSString alloc]initWithFormat:@"%@ %@",WeeklyCheck,GetFinalTime];
                        [TempAddAllTime addObject:LastTime];
                        break;
                    }else{
                        NSString *LastTime = [[NSString alloc]initWithFormat:@"%@ %@",WeeklyCheck,GetFinalTime];
                        [TempAddAllTime addObject:LastTime];
                    }
                }
                //NSLog(@"TempAddAllTime === %@",TempAddAllTime);
                
                NSString *result = [TempAddAllTime componentsJoinedByString:@" "];
                [FinalTimeArray addObject:result];
            }
                

            
            
            

        }else if (TempArray.count > 1) {
            NSLog(@"TempArray === %@",TempArray);


        }else{
          //  NSString *TimeCheck01 = TempArray[0];
        }
    }
    
    
     NSLog(@"FinalTimeArray === %@",FinalTimeArray);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ShopName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableViewCell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.ShopName.text = [ShopName objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = [ShopName objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text = [ShopTime objectAtIndex:indexPath.row];
    return cell;
}


@end
