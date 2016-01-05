//
//  TSWContactsViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactsViewController.h"
#import "RDVTabBarController.h"
#import "TSWContactsCell.h"
#import "TSWContactsLetterCell.h"
#import "ChineseString.h"
#import "TSWContactList.h"
#import "GVUserDefaults.h"
#import "TSWContactDetailViewController.h"
#import "TSWSearchCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface TSWContactsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TSWContactsCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *letterArr;
@property (nonatomic, strong) NSMutableArray *sortContactsArr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *tempDataArray;
@property (nonatomic, strong) NSMutableArray *letterCellsIndexPath;
@property (nonatomic, strong) TSWContactList *contactList;

@property (nonatomic, strong) UIView *searchBox;
@property (nonatomic, strong) UIView *searchBoxView;
@property (nonatomic, strong) UIImageView *imageView; //搜索栏照片照片
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *letterBar; //右侧字母栏

@property (nonatomic, assign) NSInteger dataArrayLength;

@end

@implementation TSWContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *分割线问题
     */
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(234, 234, 234);
    
    self.navigationBar.title = @"湾仔";
    self.letterCellsIndexPath = [[NSMutableArray alloc] init];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    _searchBox = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationBarHeight, width, 48.0f)];
    _searchBox.backgroundColor = [UIColor whiteColor];
    
    _searchBoxView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f)];
    _searchBoxView.backgroundColor = [UIColor whiteColor];
    _searchBoxView.layer.cornerRadius = 14.0f;
    _searchBoxView.layer.borderWidth = 0.5f;
    _searchBoxView.layer.borderColor = [RGB(226, 226, 226) CGColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 21.0f, 21.0f)];
    self.imageView.image = [UIImage imageNamed:@"search"];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [_searchBoxView addSubview:self.imageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:14.0f];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.autocapitalizationType = NO;
    _textField.placeholder = @"搜索姓名、公司、项目";
    [_textField addTarget:self action:@selector(searchBegin) forControlEvents: UIControlEventTouchDown];
    [_textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_searchBoxView addSubview:_textField];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 60.0f, 0.0f, 60.0f, 48.0f)];
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    [self.cancelBtn setTitleColor:RGB(32, 158, 217) forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.hidden = YES;
    
    [_searchBox addSubview:_searchBoxView];
    [_searchBox addSubview:self.cancelBtn];
    [self.view addSubview:_searchBox];

    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight+48.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight-48.0f) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TSWContactsLetterCell class] forCellWithReuseIdentifier:@"TSWContactsLetterCell"];
    [_collectionView registerClass:[TSWContactsCell class] forCellWithReuseIdentifier:@"TSWContactsCell"];
    
    _letterBar = [[UIView alloc] initWithFrame:CGRectMake(width-30.0f, 150.0f, 30.0f, height-150.0f)];
    [self.view addSubview:_letterBar];
    
    // 处理数据
    self.contactList = [[TSWContactList alloc] initWithBaseURL:TSW_API_BASE_URL path:CONTACT_LIST];
    [self.contactList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    _dataArray = [NSMutableArray array];

    [self refreshData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
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
}

- (void)dealloc
{
    [_contactList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _contactList) {
            if (_contactList.isLoaded) {
                
                self.array= [[NSMutableArray alloc] init];
                NSArray *contactArr = [_contactList.contacts mutableCopy];
                self.array = [ChineseString IndexArray:contactArr];
                NSMutableArray *letterResultArr = [[NSMutableArray alloc] init];
                letterResultArr = [ChineseString LetterSortArray:contactArr];
                self.letterArr = self.array;
                self.sortContactsArr = letterResultArr;
                
                _dataArray = [NSMutableArray array];
                
                for(TSWContactList * obj in self.sortContactsArr){
                    NSArray *t = [NSArray arrayWithObject:obj.pinYin];
                    [self.dataArray addObject:t];
                    [self.dataArray addObject:obj.contacts];
                }
                
                _dataArrayLength = self.dataArray.count;
                
                [self loadLetterBar];
                
                [self.collectionView reloadData];
            }
            else if (_contactList.error) {
                [self showErrorMessage:[_contactList.error localizedFailureReason]];
            }
        }
    }
}

-(void) loadLetterBar{
    // 增加字母索引侧边栏
    for(UIView *view in [_letterBar subviews])
    {
        [view removeFromSuperview];
    }
    NSUInteger count = self.array.count;
    for(int i=0; i<count;i++){
        
        UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(0, i*20.0f, 30.0f, 20.0f)];
        [l setTitleColor:[UIColor colorWithRed:0.55f green:0.55f blue:0.57f alpha:1.0] forState:UIControlStateNormal];
        l.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        NSString *s = [self.array objectAtIndex:i];
        [l setTitle:s forState:UIControlStateNormal];
        [l addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        l.tag = i;
        [_letterBar addSubview:l];
    }
}

- (void) refreshData{
    [self.contactList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}


- (void)clickAction:(UIButton *)sender{
    // 滚动到相应位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2*sender.tag+1];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataArray count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return [array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    id object = array[indexPath.row];
    
    if ([object isKindOfClass:[TSWContact class]]) {
        TSWContactsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWContactsCell" forIndexPath:indexPath];
        TSWContact *temp =(TSWContact *)object;
        cell.contact = temp;
        cell.delegate = self;
        return cell;
    }else{
        TSWContactsLetterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWContactsLetterCell" forIndexPath:indexPath];
        [self.letterCellsIndexPath addObject:indexPath];
        NSString *temp =(NSString *)object;
        cell.letter = temp;
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    if(indexPath.section%2 == 1) {
        return CGSizeMake(width, 50);
    }else{
        return CGSizeMake(width, 20);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0F;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0F;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)gotoDetail:(TSWContactsCell *)cell withContact:(TSWContact *)contact{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWContactDetailViewController *detailController = [[TSWContactDetailViewController alloc]initWithContactId:contact.sid];
    detailController.contectName = contact.name;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)searchBegin{
        CGFloat width = CGRectGetWidth(self.view.bounds);
        //首尾式动画
        [UIView beginAnimations:nil context:nil];
        //执行动画
        //设置动画执行时间
        [UIView setAnimationDuration:0.5];
        //设置代理
        [UIView setAnimationDelegate:self];
        //设置动画执行完毕调用的事件
        [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
        self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width-15.0f - 60.0f, 28.0f);
        self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-31.0f - 60.0f-20.0f, 28.0f);
        [UIView commitAnimations];
        if(self.dataArray.count == _dataArrayLength){
            // 如果dataArray和原始的dataArray长度一样（这才表明是刚开始搜索，在搜索过程中点击搜索框也会触发这个），则把原始的dataArray暂存
            self.tempDataArray = [self.dataArray mutableCopy];
            self.tempArray = [self.array mutableCopy];
        }
}

-(void)didStopAnimation{
    self.cancelBtn.hidden = NO;
}

-(void)cancel{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation2)];
    self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width - 2 * 15.0f, 28.0f);
    self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f);
    [UIView commitAnimations];
    self.cancelBtn.hidden = YES;
    // 清空
    _textField.text = @"";
    // 使失去焦点
    [_textField resignFirstResponder];
    
    [self.dataArray removeAllObjects];
    self.dataArray = [self.tempDataArray mutableCopy];
    [self.array removeAllObjects];
    self.array = [self.tempArray mutableCopy];
    [self.collectionView reloadData];
    [self loadLetterBar];
}

-(void)didStopAnimation2{
    
}

-(void)valueChanged:(id)sender{
    [self.array removeAllObjects];
    [self.dataArray removeAllObjects];
    NSLog(@"dataArray1:%@",self.dataArray);
    NSLog(@"tempDataArray1:%@",self.tempDataArray);
    if (_textField.text.length>0) {
        for (int i=0; i<self.tempDataArray.count; i++) {
            if(i%2 == 1){
                NSMutableArray *innerArray = self.tempDataArray[i];
                NSMutableArray *tempInnerArray = [[NSMutableArray alloc]init];
                for (int j=0; j<innerArray.count; j++) {
                    NSString *keyStr = @"";
                    if([innerArray[j] isKindOfClass:[TSWContact class]]){
                        TSWContact *temp = innerArray[j];
                        keyStr =[temp.name stringByAppendingString:temp.company];
                    }else{
                        keyStr = innerArray[j];
                    }
                    if (![ChineseInclude isIncludeChineseInString:_textField.text]){
                        if ([ChineseInclude isIncludeChineseInString:keyStr]) {
                            NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:keyStr];
                            NSRange titleResult=[tempPinYinStr rangeOfString:_textField.text options:NSCaseInsensitiveSearch];
                            if (titleResult.length>0) {
                                [tempInnerArray addObject:innerArray[j]];
                            }
                        }
                        else {
                            NSRange titleResult=[keyStr rangeOfString:_textField.text options:NSCaseInsensitiveSearch];
                            if (titleResult.length>0) {
                                [tempInnerArray addObject:innerArray[j]];
                            }
                        }
                    }else{
                        NSRange titleResult=[keyStr rangeOfString:_textField.text options:NSLiteralSearch];
                        if (titleResult.length>0) {
                            [tempInnerArray addObject:innerArray[j]];
                        }
                    }
                    
                }
                if(tempInnerArray.count > 0){
                    [self.dataArray addObject:self.tempDataArray[i-1]];
                    [self.array addObject:self.tempDataArray[i-1][0]];
                    [self.dataArray addObject:tempInnerArray];
                }
            }
            
        }
    }
//    NSLog(@"dataArray2:%@",self.dataArray);
//    NSLog(@"tempDataArray2:%@",self.tempDataArray);
    [self.collectionView reloadData];
    [self loadLetterBar];
}


//collectionView显示分割线
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.05 )];
    aView.backgroundColor = RGB(228, 228, 228);
    if (indexPath.row) {
        [cell addSubview:aView];
    }
}
@end
