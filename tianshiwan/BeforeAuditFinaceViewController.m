//
//  BeforeAuditFinaceViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/12.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "BeforeAuditFinaceViewController.h"
#import "TSWFinanceDetailCell.h"
#import "TSWFinanceDetail.h"
#import "TSWSendZan.h"
#import "TSWSendEmail.h"
#import "CXImageLoader.h"
#import "CXResource.h"
#import "TSWSendRequest.h"
#import "TSWSendGet.h"
#import "GVUserDefaults+TSWProperties.h"
@interface BeforeAuditFinaceViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWFinanceDetail *financeDetail;
@property (nonatomic, strong) TSWSendRequest *sendRequest; //发送请求
@property (nonatomic, strong) TSWSendGet *sendGet;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *domainLabel; //领域
@property (nonatomic, strong) UILabel *domainContent;
@property (nonatomic, strong) UILabel *periodLabel; //阶段
@property (nonatomic, strong) UILabel *periodContent;
@property (nonatomic, strong) UILabel *caseLabel; //案例
@property (nonatomic, strong) UILabel *caseContent;
@property (nonatomic, strong) UILabel *informationLabel; //个人信息
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *contectBtn; //获取联系人按钮
@end

@implementation BeforeAuditFinaceViewController
- (void)dealloc {
    [self.financeDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [self.sendRequest removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}
- (instancetype)initWithFinanceId:(NSString *)financeId {
    self = [super init];
    if (self) {
        self.sid = financeId;
        
        self.financeDetail = [[TSWFinanceDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[FINANCE_DETAIL stringByAppendingString:@"/id/"] stringByAppendingString:self.sid] stringByAppendingString:@"/member/"] stringByAppendingString:[GVUserDefaults standardUserDefaults].member]];
        
        [self.financeDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    self.sendGet = [[TSWSendGet alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[SENS_GET stringByAppendingString:self.sidValue] stringByAppendingString:@"/member/"] stringByAppendingString:[GVUserDefaults standardUserDefaults].member]];
    [self.sendGet loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = self.investorName;
    self.view.backgroundColor = RGB(234, 234, 234);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, width, 22)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(90, 90, 90);
    _nameLabel.font = [UIFont systemFontOfSize:22.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_scrollView addSubview:_nameLabel];
    
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, width, 15)];
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    _positionLabel.textColor = RGB(127, 127, 127);
    _positionLabel.font = [UIFont systemFontOfSize:15];
    _positionLabel.backgroundColor = [UIColor clearColor];
    _positionLabel.text = @"";
    [_scrollView addSubview:_positionLabel];
    
    self.domainLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.positionLabel.frame), CGRectGetMaxY(self.positionLabel.frame) + 30, 80, 15)];
    _domainLabel.textAlignment = NSTextAlignmentLeft;
    _domainLabel.textColor = RGB(90, 90, 90);
    _domainLabel.font = [UIFont systemFontOfSize:15];
    _domainLabel.backgroundColor = [UIColor clearColor];
    _domainLabel.text = @"投资领域:";
    [_scrollView addSubview:_domainLabel];
    
    self.domainContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.domainLabel.frame), CGRectGetMinY(self.domainLabel.frame), width, 15)];
    _domainContent.textAlignment = NSTextAlignmentLeft;
    _domainContent.textColor = RGB(127, 127, 127);
    _domainContent.font = [UIFont systemFontOfSize:15];
    _domainContent.backgroundColor = [UIColor clearColor];
    _domainContent.text = @"";
    [_scrollView addSubview:_domainContent];
    
    self.periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.domainLabel.frame), CGRectGetMaxY(self.domainLabel.frame) + 15, 80, 15)];
    _periodLabel.textAlignment = NSTextAlignmentLeft;
    _periodLabel.textColor = RGB(90, 90, 90);
    _periodLabel.font = [UIFont systemFontOfSize:15];
    _periodLabel.backgroundColor = [UIColor clearColor];
    _periodLabel.text = @"投资阶段:";
    [_scrollView addSubview:_periodLabel];
    
    self.periodContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _periodContent.textAlignment = NSTextAlignmentLeft;
    _periodContent.textColor = RGB(127, 127, 127);
    _periodContent.font = [UIFont systemFontOfSize:15];
    _periodContent.backgroundColor = [UIColor clearColor];
    _periodContent.text = @"";
    [_scrollView addSubview:_periodContent];
    
    self.caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.periodLabel.frame), CGRectGetMaxY(self.periodLabel.frame) + 15, 80, 15)];
    _caseLabel.textAlignment = NSTextAlignmentLeft;
    _caseLabel.textColor = RGB(90, 90, 90);
    _caseLabel.font = [UIFont systemFontOfSize:15];
    _caseLabel.backgroundColor = [UIColor clearColor];
    _caseLabel.text = @"投资案例:";
    [_scrollView addSubview:_caseLabel];
    
    self.caseContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _caseContent.textAlignment = NSTextAlignmentLeft;
    _caseContent.textColor = RGB(127, 127, 127);
    _caseContent.font = [UIFont systemFontOfSize:15];
    _caseContent.backgroundColor = [UIColor clearColor];
    _caseContent.numberOfLines = 0;
    _caseContent.text = @"";
    [_scrollView addSubview:_caseContent];
    
    self.informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.caseLabel.frame), CGRectGetMaxY(self.caseContent.frame), width - 2 * 20, 100)];
    _informationLabel.textAlignment = NSTextAlignmentLeft;
    _informationLabel.textColor = RGB(127, 127, 127);
    _informationLabel.font = [UIFont systemFontOfSize:15];
    _informationLabel.backgroundColor = [UIColor clearColor];
    _informationLabel.text = @"";
    [_scrollView addSubview:_informationLabel];
    
    self.contectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.contectBtn.frame = CGRectZero;
    _contectBtn.layer.masksToBounds = YES;
    _contectBtn.layer.cornerRadius = 5;
    [_contectBtn addTarget:self action:@selector(handleContact:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_contectBtn];
    
    self.locationLabel = [[UILabel alloc] init];
    
    self.sendRequest = [[TSWSendRequest alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_POST];
    [self.sendRequest addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];

    [self refreshData];
}

- (void) refreshData{
    [self.financeDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _financeDetail) {
            if (_financeDetail.isLoaded) {
                [self setDetail:_financeDetail];
            }
            else if (_financeDetail.error) {
                [self showErrorMessage:[_financeDetail.error localizedFailureReason]];
            }
       }
    }
    
    if (_sendRequest.isLoaded) {
        //可以在这里写加载成功的方法
    }
    else if (_sendRequest.error) {
        [self showErrorMessage:[_sendRequest.error localizedFailureReason]];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setDetail:(TSWFinanceDetail *)financeDetal {
    _financeDetail = financeDetal;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    // 布局，塞数据
    _nameLabel.text = financeDetal.name;
    NSString *cityName = @"";
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: financeDetal.cityCode]){
                _locationLabel.text = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
            _positionLabel.text = [NSString stringWithFormat:@"%@ · %@     %@", financeDetal.title, financeDetal.company, _locationLabel.text];
        }
    }
    
    _domainContent.text = financeDetal.fields; //领域
    _periodContent.text = financeDetal.rounds; //阶段
    _periodContent.numberOfLines = 0;
    CGSize titleSize1 = [financeDetal.rounds boundingRectWithSize:CGSizeMake(width - 2 *20 - CGRectGetWidth(self.periodLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _periodContent.frame = CGRectMake(CGRectGetMaxX(self.periodLabel.frame), CGRectGetMinY(self.periodLabel.frame) - 2, titleSize1.width, titleSize1.height);
    _caseContent.text = financeDetal.cases;    //案例
    _caseLabel.frame = CGRectMake(CGRectGetMinX(self.periodLabel.frame), CGRectGetMaxY(self.periodContent.frame) + 15, 80, 15);
    CGSize titleSize2 = [financeDetal.cases boundingRectWithSize:CGSizeMake(width - 2 *20 - CGRectGetWidth(self.caseLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _caseContent.frame = CGRectMake(CGRectGetMaxX(self.caseLabel.frame), CGRectGetMinY(self.caseLabel.frame) - 2, titleSize2.width, titleSize2.height);
    _caseContent.numberOfLines = 0;
    _informationLabel.text = financeDetal.introduction;
    _informationLabel.numberOfLines = 0;
    CGSize titleSize3 = [financeDetal.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _informationLabel.frame = CGRectMake(CGRectGetMinX(self.caseLabel.frame), CGRectGetMaxY(self.caseContent.frame) + 30, titleSize3.width, titleSize3.height);
    self.contectBtn.frame = CGRectMake(CGRectGetMinX(self.periodLabel.frame), CGRectGetMaxY(self.informationLabel.frame) + 30,  width - 2 * 20, 50);
    
    if ([_financeDetail.fields isEqualToString:@""] || [_financeDetail.fields length] == 0) {
        _domainContent.text = @"暂无";
        self.domainContent.frame = CGRectMake(CGRectGetMaxX(self.domainLabel.frame), CGRectGetMinY(self.domainLabel.frame), width - CGRectGetMaxX(self.domainLabel.frame), 15);
    }
    
    if ([_financeDetail.rounds isEqualToString:@""] || [_financeDetail.rounds length] == 0) {
        _periodContent.text = @"暂无";
        self.periodContent.frame = CGRectMake(CGRectGetMaxX(self.periodLabel.frame), CGRectGetMinY(self.periodLabel.frame), width, 15.0f);
    }
    
    if ([_financeDetail.cases isEqualToString:@""] || [_financeDetail.cases length] == 0) {
        _caseContent.text = @"暂无";
        _caseContent.frame = CGRectMake(CGRectGetMaxX(self.caseLabel.frame), CGRectGetMinY(self.caseLabel.frame), width, 15);
    }

    
    if ([financeDetal.currentstatus isEqualToString:@"-1"] || [financeDetal.currentstatus isEqualToString:@"-2"]) {
        [self.contectBtn setTitle:@"我想要这个投资人的联系方式" forState:UIControlStateNormal];
        _contectBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
        _contectBtn.tintColor = [UIColor whiteColor];
    } else if ([financeDetal.currentstatus isEqualToString:@"0"]) {
        [self.contectBtn setTitle:@"稍等片刻,我们马上处理" forState:UIControlStateNormal];
        _contectBtn.backgroundColor = RGB(175, 175, 175);
        _contectBtn.tintColor = [UIColor whiteColor];
        _contectBtn.userInteractionEnabled = NO;
    } else if ([financeDetal.currentstatus isEqualToString:@"1"]) {
        [self.contectBtn setTitle:@"稍等片刻,我们马上处理" forState:UIControlStateNormal];
        _contectBtn.backgroundColor = RGB(175, 175, 175);
        _contectBtn.tintColor = [UIColor whiteColor];
        _contectBtn.userInteractionEnabled = NO;
    }
    
    _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.positionLabel.frame) + CGRectGetHeight(self.domainContent.frame) + CGRectGetHeight(self.periodContent.frame) + CGRectGetHeight(self.caseContent.frame) + CGRectGetHeight(self.informationLabel.frame) + CGRectGetHeight(self.contectBtn.frame) + 200);
    
}
#pragma mark -- 按钮点击申请事件
- (void)handleContact:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定申请此人的联系方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.contectBtn setTitle:@"稍等片刻,我们马上处理" forState:UIControlStateNormal];
        _contectBtn.backgroundColor = RGB(175, 175, 175);
        _contectBtn.tintColor = [UIColor whiteColor];
        _contectBtn.userInteractionEnabled = NO;
        
        /**
         *  向服务端发起POST请求
         */
       [self.sendRequest loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"member":[GVUserDefaults standardUserDefaults].member ,@"sid":self.sidValue} dataType:kHttpRequestDataTypeNormal];
        NSLog(@"******************%@, %@", [GVUserDefaults standardUserDefaults].member, self.sidValue);
    } else {
        
    }
    
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
