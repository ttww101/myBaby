//
//  Feature1ViewController.m
//  iHealthS
//
//  Created by Wu on 2019/3/13.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "myBabyViewController.h"
#import "UIView+Constraint.h"
#import "ExpandCell.h"
#import "BabyData.h"
#import "AnswerData.h"

#define kCell_Height 44

@interface myBabyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTable;
@property NSMutableArray * TableData; //內文
@property NSMutableArray * AnswerData; //內文
@property NSMutableArray * sectionArray; //標題
@property NSMutableArray * stateArray; //閉合狀態

@end

int pageNum;
NSString *Sp;

@implementation myBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _TableData = [[NSMutableArray alloc] init];
    _AnswerData = [[NSMutableArray alloc] init];
    _sectionArray = [[NSMutableArray alloc] init];
    _stateArray = [[NSMutableArray alloc] init];
    
    [self getJson];
}

-(void)getJson{
   
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://47.75.131.189/a3cf7dd66c5871ee94171ce44b86f377/"];
    NSDictionary *jsonBodyDict = @{@"type":@"problem"};
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"POST"];
    //设置参数
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    BabyData *BData = [[BabyData alloc] initWithString:jsonString error:nil];
        for(int i = 0 ; i < [BData.data count]; i += 1){
        DATA *data = BData.data[i];
         [_sectionArray addObject:data.problem];
    }
    
    for(int i = 0; i < [_sectionArray count]; i++){
        [_stateArray addObject:@"0"];
        [_TableData addObject:@[@""]];
        [_AnswerData addObject:@[@""]];
    }
    
    [self initTable];
}

-(void)getAnswerJson{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://47.75.131.189/3d50ebc808a63f8bc8fdd14de6c9f20a/"];
    NSDictionary *jsonBodyDict = @{@"type":@"answer", @"id":Sp};
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"POST"];
    //设置参数
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    AnswerData *AData = [[AnswerData alloc] initWithString:jsonString error:nil];
    for(int i = 0 ; i < [AData.data count]; i += 1){
        Answer *data = AData.data[i];
        NSString *s = [[NSString alloc] initWithFormat:@"%@", data.answer];
        NSString *a = [[NSString alloc] initWithFormat:@"%@", data.des];
        
        [_TableData replaceObjectAtIndex:pageNum -1 withObject:@[s]];
        [_AnswerData replaceObjectAtIndex:pageNum -1 withObject:@[a]];
    }
    
}

-(void)initTable{
    self.mTable.dataSource = self;
    self.mTable.delegate =  self;
    self.mTable.tableFooterView = [UIView new];
    [self.mTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.mTable registerNib:[UINib nibWithNibName:@"ExpandCell" bundle:nil] forCellReuseIdentifier:@"ExpandCell"];
    [self.view addSubview:self.mTable];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _TableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_stateArray[section] isEqualToString:@"1"]){
        //如果是展开状态
        NSArray *array = [_TableData objectAtIndex:section];
        return array.count;
    }else{
        //如果是闭合，返回0
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpandCell";
    //自訂Cell的類別
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        //載入CustomCell.xib檔
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ExpandCell" owner:nil options:nil];
        for (UIView *view in views) {
            if ([view isKindOfClass:[myBabyViewController class]]){
                cell = (myBabyViewController *)view;
            }
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.expand_lab.text = _TableData[indexPath.section][indexPath.row];
    cell.expand_des.text = _AnswerData[indexPath.section][indexPath.row];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionArray[section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [button setTag:section+1];
    button.backgroundColor = [UIColor colorWithRed:24.0f/255.0f
                                             green:204.0f/255.0f
                                              blue:255.0f/255.0f
                                             alpha:1.0f];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (kCell_Height-20)/2, self.view.frame.size.width, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setText:_sectionArray[section]];
    [tlabel setTextColor:[UIColor colorWithRed:0.0f/255.0f
                                         green:111.0f/255.0f
                                          blue:152.0f/255.0f
                                         alpha:1.0f]];
    [button addSubview:tlabel];
    return button;
}
#pragma mark
#pragma mark  -select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)buttonPress:(UIButton *)sender//headButton点击
{
    //判断状态值
    if ([_stateArray[sender.tag - 1] isEqualToString:@"1"]){
        //關
        [_stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"0"];
    }else{
        [_stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"1"];
        //開
                pageNum = (int)sender.tag;
                Sp = [[NSString alloc] initWithFormat:@"%d", pageNum];
                [self getAnswerJson];
    }
    [_mTable reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCell_Height;
}


@end
