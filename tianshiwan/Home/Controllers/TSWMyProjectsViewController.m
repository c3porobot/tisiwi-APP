//
//  TSWMyProjectsViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWMyProjectsViewController.h"
#import "TSWMyProjectsEditViewController.h"
#import "TSWMyProject.h"

@interface TSWMyProjectsViewController ()
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TSWMyProject *myProject;

@property (nonatomic, strong) UIView *top;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@end

@implementation TSWMyProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.navigationBar.title = @"我的项目";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [self addRightNavigatorButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, CGRectGetHeight(self.view.bounds)-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _top = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 10.0f, width, 60.0f)];
    _top.backgroundColor = RGB(32, 158, 217);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0f, 8.0f, 44.0f, 44.0f)];
    imageView.image = [UIImage imageNamed:@"project_highlighted"];
    [_top addSubview:imageView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44.0f + 12.0f + 5.0f, (60.0f - 16.0f) / 2, width - 24.0f - 44.0f - 5.0f, 16.0f)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _titleLabel.numberOfLines = 0;
    [_top addSubview:_titleLabel];
    [_scrollView addSubview:_top];
    
    _firstLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _firstLabel.textAlignment = NSTextAlignmentLeft;
    _firstLabel.textColor = RGB(90, 90, 90);
    _firstLabel.font = [UIFont systemFontOfSize:12.0f];
    _firstLabel.backgroundColor = [UIColor clearColor];
    _firstLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent1 = @"";
    _firstLabel.text = titleContent1;
    _firstLabel.numberOfLines = 0;
    CGSize titleSize1 = [titleContent1 boundingRectWithSize:CGSizeMake(width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    _firstLabel.frame = CGRectMake(15.0f, 60.0f+24.0f-6.0f, titleSize1.width, titleSize1.height);
    
    NSMutableAttributedString *attributedString1 = [[ NSMutableAttributedString alloc ] initWithString: titleContent1];
    NSMutableParagraphStyle *paragraphStyle1 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle1.firstLineHeadIndent = 24.0f;
    paragraphStyle1.lineHeightMultiple = 1.5;
    [attributedString1 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle1 range: NSMakeRange (0, [_firstLabel.text length])];
    _firstLabel.attributedText = attributedString1;
    [_scrollView addSubview:_firstLabel];
    
    
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(_top.frame)+CGRectGetHeight(_firstLabel.frame)+30.0f);
    
    self.myProject = [[TSWMyProject alloc] initWithBaseURL:TSW_API_BASE_URL path:MY_PROJECT];
    [self.myProject addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self refreshData];
}

-(void) dealloc{
    [_myProject removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRightNavigatorButton
{
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 58, 20, 48, 12)];
    [self.editBtn setTitleColor:RGB(32, 158, 217) forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editProjects) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.editBtn];
}

-(void) refreshData{
    [self.myProject loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _myProject){
            if (_myProject.isLoaded) {
                [self setDetail:_myProject];
            }
            else if (_myProject.error) {
                [self showErrorMessage:[_myProject.error localizedFailureReason]];
            }
        }
    }
}

-(void) setDetail:(TSWMyProject *)myProject{
    if(myProject.sid != nil){
        CGFloat width = CGRectGetWidth(self.view.bounds);
        
        _titleLabel.text = myProject.name;
        _firstLabel.text = myProject.summary;
        _firstLabel.numberOfLines = 0;
        CGSize titleSize1 = [myProject.summary boundingRectWithSize:CGSizeMake(width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
        _firstLabel.frame = CGRectMake(15.0f, 60.0f+24.0f-6.0f, titleSize1.width, titleSize1.height);
        NSMutableAttributedString *attributedString1 = [[ NSMutableAttributedString alloc ] initWithString: myProject.summary ];
        NSMutableParagraphStyle *paragraphStyle1 = [[ NSMutableParagraphStyle alloc ] init];
        paragraphStyle1.firstLineHeadIndent = 24.0f;
        paragraphStyle1.lineHeightMultiple = 1.5;
        [attributedString1 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle1 range: NSMakeRange (0, [_firstLabel.text length])];
        _firstLabel.attributedText = attributedString1;
        
        _scrollView.contentSize =  CGSizeMake(width,CGRectGetHeight(_top.frame)+CGRectGetHeight(_firstLabel.frame)+30.0f);
    }
}

-(void)editProjects{
    TSWMyProjectsEditViewController *pEditController = [[TSWMyProjectsEditViewController alloc] initWithMyProject:self.myProject];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pEditController];
    [self presentViewController:navigationController animated:YES completion:^{
    }];

}

@end
