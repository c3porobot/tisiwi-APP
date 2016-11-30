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
#import "LHBCopyLabel.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface TSWContactDetailViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) TSWContactDetail *contactDetail;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *projectInfoLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) LHBCopyLabel *phoneContent;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) LHBCopyLabel *emailContent;
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) LHBCopyLabel *weixinContent;

@property (nonatomic, strong) UILabel *lineOne;
@property (nonatomic, strong) UILabel *lineTwo;

@property (nonatomic, strong) UILabel *companySum; //公司简介

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
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_scrollView];
    
    //头部
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 90.0f)];
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 20.0f, 60.0f, 60.0f)];
//    _faceImageView.image = [UIImage imageNamed:@"default_face"];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 30;
    [_headerView addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImageView.frame) + 20,30.0f, width - (15.0f+60.0f+15.0f+15.0f), 22.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(90, 90, 90);
    _nameLabel.font = [UIFont systemFontOfSize:22.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"";
    [_headerView addSubview:_nameLabel];
    
    _projectInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, width - (15.0f+60.0f+15.0f+15.0f), 12.0f)];
    _projectInfoLabel.backgroundColor = [UIColor redColor];
    _projectInfoLabel.textAlignment = NSTextAlignmentLeft;
    _projectInfoLabel.textColor = RGB(132, 132, 132);
    _projectInfoLabel.font = [UIFont systemFontOfSize:15.0f];
    _projectInfoLabel.backgroundColor = [UIColor clearColor];
    _projectInfoLabel.text = @"";
    [_headerView addSubview:_projectInfoLabel];
    
    [_scrollView addSubview:_headerView];
    //添加父视图
    [_scrollView addSubview:_headerView];
    /**
     *  联系方式
     */
    _weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(self.headerView.frame) + 20, 50, 20)];
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
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20)];
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
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineTwo.frame) + 15, 50, 20)];
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
    
    /**
     * 公司全称和公司地址
     */
    
    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.weixinLabel.frame), CGRectGetMaxY(self.emailLabel.frame) + 30, width, 20)];
    _companyLabel.textAlignment = NSTextAlignmentLeft;
    _companyLabel.textColor = RGB(155, 155, 155);
    _companyLabel.font = [UIFont systemFontOfSize:15.0f];
    _companyLabel.backgroundColor = [UIColor clearColor];
    _companyLabel.text = @"";
    [_scrollView addSubview:_companyLabel];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.companyLabel.frame), CGRectGetMaxY(self.companyLabel.frame) + 15, width, 20)];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.textColor = RGB(155, 155, 155);
    _addressLabel.font = [UIFont systemFontOfSize:15.0f];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.text = @"";
    [_scrollView addSubview:_addressLabel];
   
    /**
     *公司简介
     */
    self.companySum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.addressLabel.frame) + 30, width - 40, 100)];
    _companySum.textAlignment = NSTextAlignmentLeft;
    _companySum.textColor = RGB(155, 155, 155);
    _companySum.font = [UIFont systemFontOfSize:15.0f];
    _companySum.backgroundColor = [UIColor clearColor];
    _companySum.text = @"";
    [_scrollView addSubview:_companySum];
    
    _scrollView.contentSize = CGSizeMake(width, 10.0f+60.0f+15.0f+7*(12.0f+5.0f)+CGRectGetHeight(_companySum.frame)+15.0f+12.0f+15.0f+12.0f+15.0f+60.0f);
    
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
    /**
     *设计默认图片,如果有网络数据,则从网络下载
     */
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:contactDetail.imgUrl_3x] placeholderImage:[UIImage imageNamed:@"default_face"]];
    _nameLabel.text = contactDetail.name;
    /**
     *  拼接字符串
     */
    _positionLabel.text = [NSString stringWithFormat:@"%@ %@", contactDetail.title,contactDetail.company];
    NSString *newStr = contactDetail.companyCityName;
    newStr = [newStr stringByReplacingOccurrencesOfString:@" " withString:@" · "];
    _projectInfoLabel.text = [NSString stringWithFormat:@"%@ · %@     %@", contactDetail.title, contactDetail.project, newStr];
    _companyLabel.text = contactDetail.companyFullName;
    
    _addressLabel.text = contactDetail.companyAddress;
    _addressLabel.numberOfLines = 0;
    
    /**
     * 如果用户微信字符串为空,则重新布局
     */
    
    if ([contactDetail.wechat isEqualToString:@""] || contactDetail.wechat == nil) {
        _weixinLabel.frame = CGRectZero;
        _wechatBtn.frame = CGRectZero;
        _phoneLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(self.headerView.frame) + 20, 50, 20);
        _phoneContent.frame =CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMinY(self.phoneLabel.frame), width - CGRectGetWidth(self.phoneLabel.frame) - 80, 20);
        _phoneBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneContent.frame) - 10, CGRectGetMinY(self.phoneContent.frame) - 10, 40, 40);
        _emailLabel.frame = CGRectMake(CGRectGetMinX(self.faceImageView.frame), CGRectGetMaxY(_lineOne.frame) + 15, 50, 20);
        _emailContent.frame = CGRectMake(CGRectGetMaxX(self.emailLabel.frame), CGRectGetMinY(self.emailLabel.frame), width - CGRectGetWidth(self.emailLabel.frame) - 80, 20);
        _emailBtn.frame = CGRectMake(CGRectGetMaxX(self.emailContent.frame) - 10, CGRectGetMinY(self.emailContent.frame) - 10, 40, 40);
        _lineTwo.frame = CGRectZero;
        _companyLabel.frame = CGRectMake(CGRectGetMinX(self.phoneLabel.frame), CGRectGetMaxY(self.emailLabel.frame) + 30, width, 20);
        _addressLabel.frame = CGRectMake(CGRectGetMinX(self.phoneLabel.frame), CGRectGetMaxY(self.companyLabel.frame) + 30, width, 20);
    }
    _phoneContent.text = [NSString stringWithFormat:@"%@", contactDetail.phone];
    
    _emailContent.text = [NSString stringWithFormat:@"%@", contactDetail.email];
    
    _weixinContent.text = [NSString stringWithFormat:@"%@", contactDetail.wechat];
    
    /**
     * 项目简介自适应
     */
    _companySum.text = contactDetail.summary;
    _companySum.numberOfLines = 0;
    CGSize companyTextSize = [contactDetail.summary boundingRectWithSize:CGSizeMake(width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    if ([contactDetail.companyAddress isEqualToString:@""] || contactDetail.companyAddress == nil) {
         _companySum.frame = CGRectMake(CGRectGetMinX(self.companyLabel.frame), CGRectGetMaxY(self.companyLabel.frame) + 30, companyTextSize.width, companyTextSize.height); //自适应高度
    } else {
        _companySum.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.addressLabel.frame) +30, companyTextSize.width, companyTextSize.height); //自适应高度
        [self.view reloadInputViews];
    }
    
    
    _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(self.faceImageView.frame) + CGRectGetHeight(self.weixinLabel.frame) + CGRectGetHeight(self.phoneLabel.frame) + CGRectGetHeight(self.emailLabel.frame) + CGRectGetHeight(self.companyLabel.frame) + CGRectGetHeight(self.addressLabel.frame) + companyTextSize.height + 200 );
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制微信号" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.weixinContent.text;
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
