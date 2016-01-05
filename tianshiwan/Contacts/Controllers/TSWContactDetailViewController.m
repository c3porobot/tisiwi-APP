//
//  TSWContactDetailViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactDetailViewController.h"
#import "TSWContactDetail.h"
#import "TSWContactDetailCell.h"
#import "UIImageView+WebCache.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface TSWContactDetailViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWContactDetail *contactDetail;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *projectInfoLabel;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *titleLabel3;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *weixinLabel;

@property (nonatomic, strong) UIImageView *faceImageView; //头像

@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *emailBtn;
@property (nonatomic, strong) UIButton *wechatBtn;

@end

@implementation TSWContactDetailViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc
{
    [_contactDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithContactId:(NSString *)contactId {
    self = [super init];
    if (self) {
        self.sid = contactId;
        
        self.contactDetail = [[TSWContactDetail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[CONTACT_DETAIL stringByAppendingString:@"/"] stringByAppendingString:self.sid]];
        
        [self.contactDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = self.contectName;
    self.view.backgroundColor = RGB(234, 234, 234);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight-20.0f)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //头部
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width-2*15.0f, 90.0f)];
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 60.0f, 60.0f)];
//    _faceImageView.image = [UIImage imageNamed:@"default_face"];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 30;
    [_headerView addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+15.0f,22.0f, width - (15.0f+60.0f+15.0f+15.0f), 14.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(32, 158, 217);
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_headerView addSubview:_nameLabel];
    
    _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f+60.0f+15.0f, CGRectGetMaxY(self.nameLabel.frame) + 10, width - (15.0f+60.0f+15.0f+15.0f), 12.0f)];
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    _positionLabel.textColor = RGB(132, 132, 132);
    _positionLabel.font = [UIFont systemFontOfSize:12.0f];
    _positionLabel.backgroundColor = [UIColor clearColor];
    _positionLabel.text = @"";
    [_headerView addSubview:_positionLabel];
    
    [_scrollView addSubview:_headerView];
    
    // 分层次介绍
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f, width-2*15.0f, 12.0f)];
    titleLabel1.textAlignment = NSTextAlignmentLeft;
    titleLabel1.textColor = RGB(105, 105, 105);
    titleLabel1.font = [UIFont systemFontOfSize:12.0f];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.text = @"项目信息";
    [_scrollView addSubview:titleLabel1];
    
    _projectInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.faceImageView.frame) + 10, width, 50.0f)];
    _projectInfoLabel.textAlignment = NSTextAlignmentLeft;
    _projectInfoLabel.textColor = RGB(155, 155, 155);
    _projectInfoLabel.font = [UIFont systemFontOfSize:12.0f];
    _projectInfoLabel.backgroundColor = [UIColor clearColor];
    NSString *titleContent = @"";
    _projectInfoLabel.text = titleContent;
    _projectInfoLabel.numberOfLines = 0;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _projectInfoLabel.frame = CGRectMake(20.0f, 10.0f+60.0f+15.0f+12.0f+5.0f, titleSize.width, titleSize.height);
    [_scrollView addSubview:_projectInfoLabel];
    
    _titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f+12.0f+5.0f+CGRectGetHeight(_projectInfoLabel.frame)+15.0f, width-2*15.0f, 12.0f)];
    _titleLabel2.textAlignment = NSTextAlignmentLeft;
    _titleLabel2.textColor = RGB(105, 105, 105);
    _titleLabel2.font = [UIFont systemFontOfSize:12.0f];
    _titleLabel2.backgroundColor = [UIColor clearColor];
    _titleLabel2.text = @"公司信息";
    [_scrollView addSubview:_titleLabel2];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+2*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
    _cityLabel.textAlignment = NSTextAlignmentLeft;
    _cityLabel.textColor =RGB(155, 155, 155);
    _cityLabel.font = [UIFont systemFontOfSize:12.0f];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.text = @"";
    [_scrollView addSubview:_cityLabel];
    _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+3*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
    _companyLabel.textAlignment = NSTextAlignmentLeft;
    _companyLabel.textColor = RGB(155, 155, 155);
    _companyLabel.font = [UIFont systemFontOfSize:12.0f];
    _companyLabel.backgroundColor = [UIColor clearColor];
    _companyLabel.text = @"";
    [_scrollView addSubview:_companyLabel];
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 10.0f+60.0f+15.0f+4*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f, width-2*20.0f, 12.0f)];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.textColor = RGB(155, 155, 155);
    _addressLabel.font = [UIFont systemFontOfSize:12.0f];
    _addressLabel.backgroundColor = [UIColor clearColor];
    NSString *titleContent1 = @"";
    _addressLabel.text = titleContent1;
    _addressLabel.numberOfLines = 0;
    CGSize titleSize1 = [titleContent1 boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _addressLabel.frame = CGRectMake(20.0f, 10.0f+60.0f+15.0f+4*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f, titleSize1.width, titleSize1.height);
    [_scrollView addSubview:_addressLabel];
    
    _titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 10.0f+60.0f+15.0f+3*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f+12.0f+CGRectGetHeight(_addressLabel.frame)+15.0f, width-2*15.0f, 12.0f)];
    _titleLabel3.textAlignment = NSTextAlignmentLeft;
    _titleLabel3.textColor = RGB(105, 105, 105);
    _titleLabel3.font = [UIFont systemFontOfSize:12.0f];
    _titleLabel3.backgroundColor = [UIColor clearColor];
    _titleLabel3.text = @"联系方式";
    [_scrollView addSubview:_titleLabel3];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.titleLabel3.frame)+ 5.0f, width-2*20.0f, 12.0f)];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = RGB(155, 155, 155);
    _phoneLabel.font = [UIFont systemFontOfSize:12.0f];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.text = @"";
    [_scrollView addSubview:_phoneLabel];
    
    _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.phoneLabel.frame) + 5.0f, width-2*20.0f, 12.0f)];
    _weixinLabel.textAlignment = NSTextAlignmentLeft;
    _weixinLabel.textColor = RGB(155, 155, 155);
    _weixinLabel.font = [UIFont systemFontOfSize:12.0f];
    _weixinLabel.backgroundColor = [UIColor clearColor];
    _weixinLabel.text = @"";
    [_scrollView addSubview:_weixinLabel];
    
    _emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.weixinLabel.frame) + 5.0f, width-2*20.0f, 12.0f)];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.textColor = RGB(155, 155, 155);
    _emailLabel.font = [UIFont systemFontOfSize:12.0f];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = @"";
    [_scrollView addSubview:_emailLabel];
    
    
    UIView *btnsView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, height-60.0f, width, 60.0f)];
    btnsView.backgroundColor = RGB(255, 255, 255);
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width / 3, 60.0f)];
    _phoneBtn.backgroundColor = RGB(234, 234, 234);
    [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_disale"] forState:UIControlStateNormal];
    [btnsView addSubview:_phoneBtn];
    
    _wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneBtn.frame), 0.0f, [UIScreen mainScreen].bounds.size.width / 3, 60.0f)];
    _wechatBtn.backgroundColor = RGB(234, 234, 234);
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_wechat_disable"] forState:UIControlStateNormal];
    [btnsView addSubview:_wechatBtn];
    
    _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.wechatBtn.frame), 0.0f, [UIScreen mainScreen].bounds.size.width / 3, 60.0f)];
    _emailBtn.backgroundColor = RGB(234, 234, 234);
    [_emailBtn setImage:[UIImage imageNamed:@"btn_mail_disable"] forState:UIControlStateNormal];
    [btnsView addSubview:_emailBtn];
    
    
    [self.view addSubview:btnsView];
    
    _scrollView.contentSize = CGSizeMake(width, 10.0f+60.0f+15.0f+7*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f+12.0f+15.0f+12.0f+15.0f+60.0f);
    
    [self refreshData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) refreshData{
    [self.contactDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _contactDetail) {
            if (_contactDetail.isLoaded) {
                [self setDetail:_contactDetail];
            }
            else if (_contactDetail.error) {
                [self showErrorMessage:[_contactDetail.error localizedFailureReason]];
            }
        }
    }
}

-(void) setDetail:(TSWContactDetail *)contactDetail{
    _contactDetail = contactDetail;
    // 塞数据 布局
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //[_faceImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:contactDetail.imgUrl_3x]]]];
    /**
     *设计默认图片,如果有网络数据,则从网络下载
     */
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:contactDetail.imgUrl_3x] placeholderImage:[UIImage imageNamed:@"default_face"]];
    _nameLabel.text = contactDetail.name;
    _positionLabel.text = [NSString stringWithFormat:@"%@ %@", contactDetail.title,contactDetail.company];
    _projectInfoLabel.text = contactDetail.project;
    _projectInfoLabel.numberOfLines = 0;
    CGSize titleSize = [contactDetail.project boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _projectInfoLabel.frame = CGRectMake(20.0f, 10.0f+60.0f+15.0f+12.0f+5.0f, titleSize.width, titleSize.height);
    
    _titleLabel2.frame = CGRectMake(15.0f, CGRectGetMaxY(self.projectInfoLabel.frame) + 10, width-2*15.0f, 12.0f);
    
    _cityLabel.text = contactDetail.companyCityName;
    _cityLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.titleLabel2.frame) + 5, width-2*20.0f, 12.0f);
    
    _companyLabel.text = contactDetail.companyFullName;
    _companyLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.cityLabel.frame) + 5, width-2*20.0f, 12.0f);
    
    _addressLabel.text = contactDetail.companyAddress;
    _addressLabel.numberOfLines = 0;
    CGSize titleSize1 = [contactDetail.companyAddress boundingRectWithSize:CGSizeMake(width - 20*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _addressLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.companyLabel.frame) + 5, titleSize1.width, titleSize1.height);
    
    _titleLabel3.frame = CGRectMake(15.0f, CGRectGetMaxY(self.addressLabel.frame) + 10, width-2*15.0f, 12.0f);
    
    _phoneLabel.text = [NSString stringWithFormat:@"手机: %@", contactDetail.phone];
    _phoneLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.titleLabel3.frame) + 5, width-2*20.0f, 12.0f);
    
    _emailLabel.text = [NSString stringWithFormat:@"邮箱: %@", contactDetail.email];
    _emailLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.phoneLabel.frame) + 5, width-2*20.0f, 12.0f);
    
    _weixinLabel.text = [NSString stringWithFormat:@"微信: %@", contactDetail.wechat];
    _weixinLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.emailLabel.frame) + 5, width-2*20.0f, 12.0f);
    
    _scrollView.contentSize = CGSizeMake(width, 10.0f+60.0f+15.0f+7*(12.0f+5.0f)+CGRectGetHeight(_projectInfoLabel.frame)+15.0f+12.0f+15.0f+12.0f+15.0f+60.0f);
    
    if(_contactDetail.phone!=nil && ![_contactDetail.phone isEqualToString:@""]){
        [_phoneBtn setImage:[UIImage imageNamed:@"btn_phone_n"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_contactDetail.email!=nil && ![_contactDetail.email isEqualToString:@""]){
        [_emailBtn setImage:[UIImage imageNamed:@"btn_mail_n"] forState:UIControlStateNormal];
        [_emailBtn addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_contactDetail.wechat!=nil && ![_contactDetail.wechat isEqualToString:@""]){
        [_wechatBtn setImage:[UIImage imageNamed:@"btn_wechat_n"] forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_contactDetail.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)email{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]){
        [controller setSubject:@" "];
        [controller setMessageBody:@" " isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject: _contactDetail.email];
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
}

-(void)wechat{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，微信号:" message:_contactDetail.wechat delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)gotoEmail:(TSWContactDetailCell *)cell withContact:(TSWContactDetail *)contactDetail{
    NSString *url = @"mailto:foo@example.com?cc=bar@example.com&amp;subject=Greetings%20from%20Cupertino!&amp; body=Wish%20you%20were%20here!";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)gotoWeixin:(TSWContactDetailCell *)cell withContact:(TSWContactDetail *)contactDetail{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，微信号:" message:_contactDetail.wechat delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
