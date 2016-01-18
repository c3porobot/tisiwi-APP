//
//  TSWTalentDetailViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentDetailViewController.h"
#import "TSWTalentDetail.h"
#import "TSWTalentDetailCell.h"
#import "TSWSendEmail.h"
#import "LHBTalentCheckController.h"
#import "TSWTalentCheckViewController.h"
#import "LHBCopyLabel.h"
@interface TSWTalentDetailViewController ()<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWTalentDetail *talentDetail;
@property (nonatomic, strong) TSWSendEmail *sendEmail;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *baseLabel2; //工作经验
@property (nonatomic, strong) UILabel *workExperience; //工作经验(传值)
@property (nonatomic, strong) UILabel *baseLabel3; //薪水
@property (nonatomic, strong) UILabel *salary; //薪水(传值)
@property (nonatomic, strong) UILabel *directLabel1; //意向
@property (nonatomic, strong) UILabel *directLabel2;
@property (nonatomic, strong) UILabel *jianLabel2;

@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) LHBCopyLabel *weixinContent; //微信
@property (nonatomic, strong) UILabel *lineOne;
@property (nonatomic, strong) UILabel *phoneLabel ;
@property (nonatomic, strong) LHBCopyLabel *phoneContent;  //手机
@property (nonatomic, strong) UILabel *lineTwo;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) LHBCopyLabel *emailContent;  //邮箱
@property (nonatomic, strong) UILabel *jianLabel1; //天使湾评价
@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIButton *phoneBtn;  //电话按钮
@property (nonatomic, strong) UIButton *emailBtn;  //邮箱按钮
@property (nonatomic, strong) UIButton *wechatBtn; //微信按钮
@property (nonatomic, strong) UIButton *checkBtn;  //查看简历按钮
@property (nonatomic, copy) NSString *attachment;
@end

@implementation TSWTalentDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc
{
    [_talentDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithTalentId:(NSString *)talentId {
    self = [super init];
    if (self) {
        self.sid = talentId;
        
        self.talentDetail = [[TSWTalentDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[TALENT_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid]];
        
        [self.talentDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = self.talentName;
    self.view.backgroundColor = RGB(234, 234, 234);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //头部
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, (width-2*15.0f)/2, 14.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(90, 90, 90);
    _nameLabel.font = [UIFont systemFontOfSize:22.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_scrollView addSubview:_nameLabel];
    
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _checkBtn.frame = CGRectMake(width - 30 - 70, CGRectGetMinY(self.nameLabel.frame), 100, 20);
    [_checkBtn setTitle:@"完整简历" forState:UIControlStateNormal];
    //_checkBtn.tintColor = [UIColor cyanColor];
    //[_checkBtn addTarget:self action:@selector(handleCheck:) forControlEvents:UIControlEventTouchUpInside];
    _checkBtn.tintColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [_scrollView addSubview:_checkBtn];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, width/2-15.0f, 15.0f)];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabel.textColor = RGB(127, 127, 127);
    _locationLabel.font = [UIFont systemFontOfSize:15.0f];
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.text = @"";
    [_scrollView addSubview:_locationLabel];

    _baseLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.locationLabel.frame), CGRectGetMaxY(self.locationLabel.frame) + 30, 70, 15)];
    _baseLabel2.textAlignment = NSTextAlignmentLeft;
    _baseLabel2.textColor = RGB(90, 90, 90);
    _baseLabel2.font = [UIFont systemFontOfSize:15.0f];
    _baseLabel2.backgroundColor = [UIColor clearColor];
    _baseLabel2.text = @"工作经验:";
    [_scrollView addSubview:_baseLabel2];
    
    self.workExperience = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.baseLabel2.frame), CGRectGetMinY(self.baseLabel2.frame), 200, CGRectGetHeight(self.baseLabel2.frame))];
    _workExperience.textAlignment = NSTextAlignmentLeft;
    _workExperience.textColor = RGB(155, 155, 155);
    _workExperience.font = [UIFont systemFontOfSize:15];
    _workExperience.backgroundColor = [UIColor clearColor];
    _workExperience.text = @"";
    [_scrollView addSubview:_workExperience];
    
    _baseLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.baseLabel2.frame), CGRectGetMaxY(self.baseLabel2.frame) + 15, CGRectGetWidth(self.baseLabel2.frame), CGRectGetHeight(self.baseLabel2.frame))];
    _baseLabel3.textAlignment = NSTextAlignmentLeft;
    _baseLabel3.textColor = RGB(90, 90, 90);
    _baseLabel3.font = [UIFont systemFontOfSize:15.0f];
    _baseLabel3.backgroundColor = [UIColor clearColor];
    _baseLabel3.text = @"月薪要求:";
    [_scrollView addSubview:_baseLabel3];
    
    _salary = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.baseLabel3.frame), CGRectGetMinY(self.baseLabel3.frame), 200, CGRectGetHeight(self.baseLabel3.frame))];
    _salary.textAlignment = NSTextAlignmentLeft;
    _salary.textColor = RGB(155, 155, 155);
    _salary.font = [UIFont systemFontOfSize:15.0f];
    _salary.backgroundColor = [UIColor clearColor];
    _salary.text = @"";
    [_scrollView addSubview:_salary];
    
    self.directLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.baseLabel3.frame), CGRectGetMaxY(self.baseLabel3.frame) + 15, CGRectGetWidth(self.baseLabel2.frame), CGRectGetHeight(self.baseLabel3.frame))];
    _directLabel1.textAlignment = NSTextAlignmentLeft;
    _directLabel1.textColor = RGB(90, 90, 90);
    _directLabel1.font = [UIFont systemFontOfSize:15.0f];
    _directLabel1.backgroundColor = [UIColor clearColor];
    _directLabel1.text = @"意向岗位:";
    [_scrollView addSubview:_directLabel1];
    
    _directLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.directLabel1.frame), CGRectGetMinY(_directLabel1.frame), width-2*20.0f, 15.0f)];
    _directLabel2.textAlignment = NSTextAlignmentLeft;
    _directLabel2.textColor = RGB(155, 155, 155);
    _directLabel2.font = [UIFont systemFontOfSize:15.0f];
    _directLabel2.backgroundColor = [UIColor clearColor];
    _directLabel2.text = @"";
    [_scrollView addSubview:_directLabel2];
    /**
     *新添加的联系人信息模块
     */
    
    self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.directLabel1.frame) + 30, 50, 20)];
    _weixinLabel.textAlignment = NSTextAlignmentLeft;
    _weixinLabel.textColor = RGB(90, 90, 90);
    _weixinLabel.font = [UIFont systemFontOfSize:16.0f];
    _weixinLabel.backgroundColor = [UIColor clearColor];
    _weixinLabel.text = @"微信";
    [_scrollView addSubview:_weixinLabel];
    
    _weixinContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinLabel.frame), CGRectGetMinY(self.weixinLabel.frame), width - CGRectGetWidth(self.weixinLabel.frame) - 80, 20)];
    _weixinContent.textAlignment = NSTextAlignmentLeft;
    _weixinContent.textColor = RGB(155, 155, 155);
    _weixinContent.font = [UIFont systemFontOfSize:15.0f];
    _weixinContent.backgroundColor = [UIColor clearColor];
    _weixinContent.text = @"";
    [_scrollView addSubview:_weixinContent];
    
    _wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinContent.frame), CGRectGetMinY(self.weixinContent.frame) - 10, 40, 40)];
    _wechatBtn.backgroundColor = [UIColor clearColor];
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_copy"] forState:UIControlStateNormal];
    [_wechatBtn addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_wechatBtn];
    
    
    self.lineOne = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.weixinLabel.frame) + 15, width - 30, 0.5)];
    _lineOne.backgroundColor = RGB(155, 155, 155);
    [_scrollView addSubview:_lineOne];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.weixinLabel.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20)];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = RGB(90, 90, 90);
    _phoneLabel.font = [UIFont systemFontOfSize:16.0f];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.text = @"手机";
    [_scrollView addSubview:_phoneLabel];
    
    _phoneContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMinY(self.phoneLabel.frame), width - CGRectGetWidth(self.phoneLabel.frame) - 80, 20)];
    _phoneContent.textAlignment = NSTextAlignmentLeft;
    _phoneContent.textColor = RGB(155, 155, 155);
    _phoneContent.font = [UIFont systemFontOfSize:15.0f];
    _phoneContent.backgroundColor = [UIColor clearColor];
    _phoneContent.text = @"";
    [_scrollView addSubview:_phoneContent];
    
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneContent.frame), CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40)];
    _phoneBtn.backgroundColor = [UIColor clearColor];
    [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone"] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_phoneBtn];
    
    self.lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.phoneLabel.frame) + 15, width - 30, 0.5)];
    _lineTwo.backgroundColor = RGB(155, 155, 155);
    [_scrollView addSubview:_lineTwo];
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneLabel.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 50, 20)];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.textColor = RGB(90, 90, 90);
    _emailLabel.font = [UIFont systemFontOfSize:16.0f];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = @"邮箱";
    [_scrollView addSubview:_emailLabel];
    
    _emailContent = [[LHBCopyLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emailLabel.frame), CGRectGetMinY(self.emailLabel.frame), width - CGRectGetWidth(self.emailLabel.frame) - 80, 20)];
    _emailContent.textAlignment = NSTextAlignmentLeft;
    _emailContent.textColor = RGB(155, 155, 155);
    _emailContent.font = [UIFont systemFontOfSize:15.0f];
    _emailContent.backgroundColor = [UIColor clearColor];
    _emailContent.text = @"";
    [_scrollView addSubview:_emailContent];
    
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.emailContent.frame), CGRectGetMinY(self.emailContent.frame) - 10, 40, 40)];
    _emailBtn.backgroundColor = [UIColor clearColor];
    [_emailBtn setImage:[UIImage imageNamed:@"btn_mail"] forState:UIControlStateNormal];
    [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_emailBtn];
    
    
    
    self.jianLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.emailLabel.frame), CGRectGetMaxY(self.emailLabel.frame) + 30, width-2*15.0f, 15.0f)];
    _jianLabel1.textAlignment = NSTextAlignmentLeft;
    _jianLabel1.textColor = RGB(90, 90, 90);
    _jianLabel1.font = [UIFont systemFontOfSize:15.0f];
    _jianLabel1.backgroundColor = [UIColor clearColor];
    _jianLabel1.text = @"天使湾评价";
    [_scrollView addSubview:_jianLabel1];
    
    _jianLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
    _jianLabel2.textAlignment = NSTextAlignmentLeft;
    _jianLabel2.textColor = RGB(155, 155, 155);
    _jianLabel2.font = [UIFont systemFontOfSize:15.0f];
    _jianLabel2.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _jianLabel2.text = titleContent;
    _jianLabel2.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _jianLabel2.frame = CGRectMake(20.0f, CGRectGetMinY(_jianLabel1.frame), titleSize.width, titleSize.height);
    [_scrollView addSubview:_jianLabel2];
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+4*(12.0f+5.0f)+2*(12.0f+15.0f)+titleSize.height+15.0f+60.0f);
    /**
     *发送邮件
     */
    
    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:@"personnel"] stringByAppendingString:@"/"] stringByAppendingString:self.sid] stringByAppendingString:@"/mail_attachment"]];
    
    [self.sendEmail addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];

    [self refreshData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) refreshData{
    [self.talentDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
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
        if (object == _talentDetail) {
            if (_talentDetail.isLoaded) {
                [self setDetail:_talentDetail];
            }
            else if (_talentDetail.error) {
                [self showErrorMessage:[_talentDetail.error localizedFailureReason]];
            }
        }else if(object == _sendEmail){
            if(_sendEmail.isLoaded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，附件已发送到您的邮箱，请查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else if(_sendEmail.error){
                [self showErrorMessage:[_sendEmail.error localizedFailureReason]];
            }
        }
    }
}

- (void) setDetail:(TSWTalentDetail *)talentDetail{
    _talentDetail = talentDetail;
    _weixinContent.text = [NSString stringWithFormat:@"%@", talentDetail.wechat];
    _emailContent.text = [NSString stringWithFormat:@"%@", talentDetail.email];
    _phoneContent.text = [NSString stringWithFormat:@"%@", talentDetail.tel];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _nameLabel.text = talentDetail.name;
    
    NSString *status = @"";
    if([talentDetail.status isEqualToString:@"seeking"]){
        status = @"求职中";
    }else{
        status = @"在职";
    }
    NSString *cityName = @"";
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    for (int i=0; i<[provinces count]; i++) {
        NSArray *cities = [[provinces objectAtIndex:i] objectForKey:@"cities"];
        for(int j=0; j<[cities count];j++){
            NSString *code = [[cities objectAtIndex:j] objectForKey:@"code"];
            if([code isEqualToString: talentDetail.cityCode]){
                _locationLabel.text = [NSString stringWithFormat:@"%@ %@", status,[[cities objectAtIndex:j] objectForKey:@"CityName"]];
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
    _workExperience.text = [NSString stringWithFormat:@"%@年",talentDetail.seniority];
    
    if ([talentDetail.salary isEqualToString:@"0"]) {
        _salary.text = [NSString stringWithFormat:@"面议"];
    }else {
        _salary.text = [NSString stringWithFormat:@"%@K",talentDetail.salary];
    }
    _directLabel2.text = talentDetail.titles;
    _jianLabel2.text = talentDetail.introduction;
    _jianLabel2.numberOfLines = 0;
    CGSize titleSize = [talentDetail.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _jianLabel2.frame = CGRectMake(20.0f, CGRectGetMaxY(self.jianLabel1.frame) + 15, titleSize.width, titleSize.height);
    /**
     *添加了一个按钮的高度,不然按钮会把内容覆盖掉
     */
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(self.nameLabel.frame) + CGRectGetHeight(self.locationLabel.frame) + CGRectGetHeight(self.baseLabel2.frame) + CGRectGetHeight(self.baseLabel3.frame)+ CGRectGetHeight(self.jianLabel1.frame) + CGRectGetHeight(self.directLabel1.frame) + CGRectGetHeight(self.emailLabel.frame) + CGRectGetHeight(self.phoneLabel.frame) + CGRectGetHeight(self.weixinLabel.frame) + titleSize.height + 250);
    
//    if(_talentDetail.tel!=nil && ![_talentDetail.tel isEqualToString:@""]){
//        [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_n"] forState:UIControlStateNormal];
//        [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
//    }
//    if(_talentDetail.hasAttachment == 1){
//        [_emailBtn setImage:[UIImage imageNamed:@"btn_download_n"] forState:UIControlStateNormal];
//        [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
   // }
    /**
     *  添加判断,没有简历则不能进入查看界面
     */
    if (_talentDetail.hasAttachment == 1) {
        _checkBtn.hidden = NO;
        [_checkBtn addTarget:self action:@selector(handleCheck:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark -- 按钮响应事件
- (void)handleCheck:(UIButton *)sender {
    TSWTalentCheckViewController *talentCheckViewController = [[TSWTalentCheckViewController alloc] init];
    talentCheckViewController.PDFid = self.sid; //赋值
    talentCheckViewController.attachment = _talentDetail.attachment;
    talentCheckViewController.name = _talentDetail.name;
    //[self.navigationController pushViewController:talentCheckViewController animated:YES];
    [self presentViewController:talentCheckViewController animated:NO completion:nil];
}

-(void)call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_talentDetail.tel];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//提示是否发送邮件
//-(void)email{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否发送邮件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
//    [alertView show];
//}
-(void) email{
    //[self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"financing",@"sid":self.sid}];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]){
        [controller setSubject:@" "];
        [controller setMessageBody:@" " isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:_talentDetail.email];
        [controller setToRecipients: toRecipients];
        [self presentModalViewController:controller animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，您还没有设置邮件账户" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)wechat{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制微信号" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.weixinContent.text;
    [alertView show];
}
#pragma mark -- UIAlertViewDelegate
//提示框代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"personnel",@"sid":self.sid}];
    }
}
@end
