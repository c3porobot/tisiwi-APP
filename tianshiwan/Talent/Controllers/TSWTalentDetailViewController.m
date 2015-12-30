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
@interface TSWTalentDetailViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWTalentDetail *talentDetail;
@property (nonatomic, strong) TSWSendEmail *sendEmail;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *baseLabel2;
@property (nonatomic, strong) UILabel *baseLabel3;
@property (nonatomic, strong) UILabel *directLabel2;
@property (nonatomic, strong) UILabel *jianLabel2;

@property (nonatomic, strong) UILabel *wechatLabel; //微信
@property (nonatomic, strong) UILabel *phoneLabel;  //手机
@property (nonatomic, strong) UILabel *emailLabel;  //邮箱

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
    self.navigationBar.title = @"人才详情";
    self.view.backgroundColor = RGB(234, 234, 234);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight-20.0f)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //头部
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, width-2*15.0f, 14.0f)];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (width-2*15.0f)/2, 14.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(32, 158, 217);
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_headerView addSubview:_nameLabel];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-15.0f, 2.0f, width/2-15.0f, 12.0f)];
    _locationLabel.textAlignment = NSTextAlignmentRight;
    _locationLabel.textColor = RGB(127, 127, 127);
    _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.text = @"";
    CGSize size = [_locationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    [_headerView addSubview:_locationLabel];
    
    _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.0f - size.width - 2.0f - 11.0f, 2.0f, 11.0f, 15.0f)];
    _mapImageView.image = [UIImage imageNamed:@"location"];
    _mapImageView.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:_mapImageView];
    
    [_scrollView addSubview:_headerView];
    
    
    // 分层次介绍
    UILabel *baseLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f, width-2*15.0f, 12.0f)];
    baseLabel1.textAlignment = NSTextAlignmentLeft;
    baseLabel1.textColor = RGB(127, 127, 127);
    baseLabel1.font = [UIFont systemFontOfSize:12.0f];
    baseLabel1.backgroundColor = [UIColor clearColor];
    baseLabel1.text = @"基本信息:";
    [_scrollView addSubview:baseLabel1];
    _baseLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+12.0f+5.0f, width-2*20.0f, 12.0f)];
    _baseLabel2.textAlignment = NSTextAlignmentLeft;
    _baseLabel2.textColor = RGB(155, 155, 155);
    _baseLabel2.font = [UIFont systemFontOfSize:12.0f];
    _baseLabel2.backgroundColor = [UIColor clearColor];
    _baseLabel2.text = @"";
    [_scrollView addSubview:_baseLabel2];
    _baseLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+2*(12.0f+5.0f), width-2*20.0f, 12.0f)];
    _baseLabel3.textAlignment = NSTextAlignmentLeft;
    _baseLabel3.textColor = RGB(155, 155, 155);
    _baseLabel3.font = [UIFont systemFontOfSize:12.0f];
    _baseLabel3.backgroundColor = [UIColor clearColor];
    _baseLabel3.text = @"";
    [_scrollView addSubview:_baseLabel3];
    /**
     *新添加的联系人信息模块
     */
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.baseLabel3.frame) + 10, width-2*15.0f, 12.0f)];
    contactLabel.textAlignment = NSTextAlignmentLeft;
    contactLabel.textColor = RGB(127, 127, 127);
    contactLabel.font = [UIFont systemFontOfSize:12.0f];
    contactLabel.backgroundColor = [UIColor clearColor];
    contactLabel.text = @"联系信息:";
    [_scrollView addSubview:contactLabel];
    
    self.wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(contactLabel.frame)+5, width-2*20.0f, 12.0f)];
    _wechatLabel.textAlignment = NSTextAlignmentLeft;
    _wechatLabel.textColor = RGB(155, 155, 155);
    _wechatLabel.font = [UIFont systemFontOfSize:12.0f];
    _wechatLabel.backgroundColor = [UIColor clearColor];
    _wechatLabel.text = @"微信:";
    [_scrollView addSubview:_wechatLabel];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.wechatLabel.frame) + 5, width-2*20.0f, 12)];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = RGB(155, 155, 155);
    _phoneLabel.font = [UIFont systemFontOfSize:12.0f];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.text = @"手机:";
    [_scrollView addSubview:_phoneLabel];
    
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneLabel.frame) + 5, width - 2*20, 12)];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.textColor = RGB(155, 155, 155);
    _emailLabel.font = [UIFont systemFontOfSize:12.0f];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = @"邮箱:";
    [_scrollView addSubview:_emailLabel];
    
    UILabel *directLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.emailLabel.frame) + 10, width-2*15.0f, 12.0f)];
    directLabel1.textAlignment = NSTextAlignmentLeft;
    directLabel1.textColor = RGB(127, 127, 127);
    directLabel1.font = [UIFont systemFontOfSize:12.0f];
    directLabel1.backgroundColor = [UIColor clearColor];
    directLabel1.text = @"意向岗位:";
    [_scrollView addSubview:directLabel1];
    _directLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(directLabel1.frame) + 5, width-2*20.0f, 12.0f)];
    _directLabel2.textAlignment = NSTextAlignmentLeft;
    _directLabel2.textColor = RGB(155, 155, 155);
    _directLabel2.font = [UIFont systemFontOfSize:12.0f];
    _directLabel2.backgroundColor = [UIColor clearColor];
    _directLabel2.text = @"";
    [_scrollView addSubview:_directLabel2];
    
    UILabel *jianLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.directLabel2.frame) + 10, width-2*15.0f, 12.0f)];
    jianLabel1.textAlignment = NSTextAlignmentLeft;
    jianLabel1.textColor = RGB(127, 127, 127);
    jianLabel1.font = [UIFont systemFontOfSize:12.0f];
    jianLabel1.backgroundColor = [UIColor clearColor];
    jianLabel1.text = @"天使湾评价:";
    [_scrollView addSubview:jianLabel1];
    _jianLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(jianLabel1.frame) + 17, width-2*20.0f, 12.0f)];
    _jianLabel2.textAlignment = NSTextAlignmentLeft;
    _jianLabel2.textColor = RGB(155, 155, 155);
    _jianLabel2.font = [UIFont systemFontOfSize:12.0f];
    _jianLabel2.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _jianLabel2.text = titleContent;
    _jianLabel2.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _jianLabel2.frame = CGRectMake(20.0f, CGRectGetMaxY(jianLabel1.frame) + 5, titleSize.width, titleSize.height);
    [_scrollView addSubview:_jianLabel2];
    
    UIView *btnsView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, height-60.0f, width, 60.0f)];
    btnsView.backgroundColor = RGB(255, 255, 255);
    //_phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width/3-2, 60.0f)];
//    _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(width *2/3+3, 0, width/3-1, 60)];
    _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(width *2/3, 0, width/3, 60)];

    _phoneBtn.backgroundColor = RGB(234, 234, 234);
    [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_disale"] forState:UIControlStateNormal];
    
    [btnsView addSubview:_phoneBtn];
    
//    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(width/3+1, 0.0f, width/3-2, 60.0f)];
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(width/3, 0.0f, width/3, 60.0f)];

    _emailBtn.backgroundColor = RGB(234, 234, 234);
    [_emailBtn setImage:[UIImage imageNamed:@"btn_download_disable"] forState:UIControlStateNormal];
    [btnsView addSubview:_emailBtn];
    
    _wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(width/2, 0, width/4, 60)];
    _wechatBtn.backgroundColor = RGB(234, 234, 234);
    [_wechatBtn setImage:[UIImage imageNamed:@"wechat_disabled"] forState:UIControlStateNormal];
    //[btnsView addSubview:_wechatBtn];
    /**
     *查找按钮
     */
    self.checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width/3, 60.0f)];
    _checkBtn.backgroundColor = RGB(234, 234, 234);
    [_checkBtn setImage:[UIImage imageNamed:@"btn_resume_disable"] forState:UIControlStateNormal];
    [btnsView addSubview:_checkBtn];
    
    [self.view addSubview:btnsView];
    
    
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
    _wechatLabel.text = [NSString stringWithFormat:@"微信: %@", talentDetail.wechat];
    _emailLabel.text = [NSString stringWithFormat:@"邮箱: %@", talentDetail.email];
    _phoneLabel.text = [NSString stringWithFormat:@"手机: %@", talentDetail.tel];
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
                _locationLabel.text = [NSString stringWithFormat:@"%@ %@", [[cities objectAtIndex:j] objectForKey:@"CityName"], status];
                cityName = [[cities objectAtIndex:j] objectForKey:@"CityName"];
                break;
            }
        }
    }
//    _locationLabel.text = [NSString stringWithFormat:@"%@ %@", talentDetail.cityName, status];
    CGSize size = [cityName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    CGSize size2 = [status sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    _mapImageView.frame = CGRectMake(width - 15.0f - size.width - size2.width - 6.0f - 2.0f - 15.0f - 15.0f, 2.0f, 11.0f, 15.0f);
    
    _baseLabel2.text = [NSString stringWithFormat:@"工作年限: %@",talentDetail.seniority];
    
    //_baseLabel2.text = [NSString stringWithFormat:@"工作年限: %@", talentDetail.attachment];
    _baseLabel3.text = [NSString stringWithFormat:@"月薪要求: %@元",talentDetail.salary];
    _directLabel2.text = talentDetail.titles;
    _jianLabel2.text = talentDetail.introduction;
    _jianLabel2.numberOfLines = 0;
    CGSize titleSize = [talentDetail.introduction boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _jianLabel2.frame = CGRectMake(20.0f, CGRectGetMaxY(self.directLabel2.frame) + 10 + 12 + 5, titleSize.width, titleSize.height);
    /**
     *添加了一个按钮的高度,不然按钮会把内容覆盖掉
     */
    _scrollView.contentSize = CGSizeMake(width, 22.0f+CGRectGetHeight(_headerView.frame)+28.0f+4*(12.0f+5.0f)+2*(12.0f+15.0f)+titleSize.height+15.0f+60.0f + self.wechatBtn.frame.size.height);
    
    if(_talentDetail.tel!=nil && ![_talentDetail.tel isEqualToString:@""]){
        [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_n"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_talentDetail.hasAttachment == 1){
        [_emailBtn setImage:[UIImage imageNamed:@"btn_download_n"] forState:UIControlStateNormal];
        [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    }
    /**
     *  添加判断,没有简历则不能进入查看界面
     */
    if (_talentDetail.hasAttachment == 1) {
        [_checkBtn setImage:[UIImage imageNamed:@"btn_resume_n"] forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(handleCheck:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark -- 按钮响应事件
- (void)handleCheck:(UIButton *)sender {
    TSWTalentCheckViewController *talentCheckViewController = [[TSWTalentCheckViewController alloc] init];
    talentCheckViewController.PDFid = self.sid; //赋值
    talentCheckViewController.attachment = _talentDetail.attachment;
    talentCheckViewController.name = _talentDetail.name;
    [self.navigationController pushViewController:talentCheckViewController animated:YES];
}

-(void)call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_talentDetail.tel];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//提示是否发送邮件
-(void)email{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否发送邮件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
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
