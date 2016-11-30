//
//  TSWAboutController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWAboutController.h"

@interface TSWAboutController ()
@end

@implementation TSWAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"天使湾App使用协议";
//    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.titleView.textColor = [UIColor whiteColor];
    //self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    //[self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationBar.bottomLineView.hidden = YES;
    
    UIScrollView *top = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    
    UILabel *zeroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    zeroLabel.textAlignment = NSTextAlignmentLeft;
    zeroLabel.textColor = RGB(60, 60, 60);
    zeroLabel.font = [UIFont systemFontOfSize:14.0f];
    zeroLabel.backgroundColor = [UIColor clearColor];
    zeroLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent0= @"特别提示";
    zeroLabel.text = titleContent0;
    zeroLabel.numberOfLines = 0;
    zeroLabel.frame = CGRectMake(12.0f, 12.0f, width-2*12.0f, 20.0f);
    [top addSubview:zeroLabel];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.textColor = RGB(97, 97, 97);
    firstLabel.font = [UIFont systemFontOfSize:12.0f];
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent1 = @"杭州天湾投资管理有限公司（以下简称“天湾”）在此特别提醒您（湾仔）在使用本App之前，请认真阅读本《使用协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。您的登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束";
    firstLabel.text = titleContent1;
    firstLabel.numberOfLines = 0;
    CGSize titleSize1 = [titleContent1 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    firstLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(firstLabel.frame) + 10, titleSize1.width, titleSize1.height);
    NSMutableAttributedString *attributedString1 = [[ NSMutableAttributedString alloc ] initWithString: firstLabel.text ];
    NSMutableParagraphStyle *paragraphStyle1 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle1.firstLineHeadIndent = 24.0f;
    paragraphStyle1.lineHeightMultiple = 1.5;
    [attributedString1 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle1 range: NSMakeRange (0, [firstLabel.text length])];
    firstLabel.attributedText = attributedString1;
    [top addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    secondLabel.textAlignment = NSTextAlignmentLeft;
    secondLabel.textColor = RGB(97, 97, 97);
    secondLabel.font = [UIFont systemFontOfSize:12.0f];
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent2 = @"本协议约定天湾与湾仔之间关于“天使湾”软件服务（以下简称“服务”）的权利义务。“湾仔”是指天湾管理的基金所投资的企业的现任CEO。本协议可由天湾随时更新，湾仔可在App的“设置”板块查阅最新版协议条款。在天湾修改协议条款后，如果湾仔不接受修改后的条款，请立即停止使用天湾提供的服务，湾仔继续使用天湾提供的服务将被视为接受修改后的协议。";
    secondLabel.text = titleContent2;
    secondLabel.numberOfLines = 0;
    CGSize titleSize2 = [titleContent2 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    secondLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(firstLabel.frame) - [UIScreen mainScreen].bounds.size.height / 13.34 , titleSize2.width, titleSize2.height);
    NSMutableAttributedString *attributedString2 = [[ NSMutableAttributedString alloc ] initWithString: secondLabel.text ];
    NSMutableParagraphStyle *paragraphStyle2 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle2.firstLineHeadIndent = 24.0f;
    paragraphStyle2.lineHeightMultiple = 1.5;
    [attributedString2 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle2 range: NSMakeRange (0 , [secondLabel.text length])];
    secondLabel.attributedText = attributedString2;
    [top addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    thirdLabel.textAlignment = NSTextAlignmentLeft;
    thirdLabel.textColor = RGB(60, 60, 60);
    thirdLabel.font = [UIFont systemFontOfSize:14.0f];
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent3 = @"一、帐号使用";
    thirdLabel.text = titleContent3;
    thirdLabel.numberOfLines = 0;
    CGSize titleSize3 = [titleContent3 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    thirdLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(secondLabel.frame), titleSize3.width, titleSize3.height);
    NSMutableAttributedString *attributedString3 = [[ NSMutableAttributedString alloc ] initWithString: thirdLabel.text ];
    NSMutableParagraphStyle *paragraphStyle3 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle3.firstLineHeadIndent = 0.0f;
    paragraphStyle3.lineHeightMultiple = 1.5;
    [attributedString3 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle3 range: NSMakeRange (0 , [thirdLabel.text length])];
    thirdLabel.attributedText = attributedString3;
    [top addSubview:thirdLabel];
    
    UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    fourthLabel.textAlignment = NSTextAlignmentLeft;
    fourthLabel.textColor = RGB(97, 97, 97);
    fourthLabel.font = [UIFont systemFontOfSize:12.0f];
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent4 = @"1.湾仔向天湾提供本人名下的常用手机号码，作为登录App的唯一身份账号，天湾根据湾仔提供的手机号码为湾仔开通账号。";
    fourthLabel.text = titleContent4;
    fourthLabel.numberOfLines = 0;
    CGSize titleSize4 = [titleContent4 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    fourthLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(thirdLabel.frame), titleSize4.width, titleSize4.height);
    NSMutableAttributedString *attributedString4 = [[ NSMutableAttributedString alloc ] initWithString: fourthLabel.text ];
    NSMutableParagraphStyle *paragraphStyle4 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle4.firstLineHeadIndent = 24.0f;
    paragraphStyle4.lineHeightMultiple = 1.5;
    [attributedString4 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle4 range: NSMakeRange (0 , [fourthLabel.text length])];
    fourthLabel.attributedText = attributedString4;
    [top addSubview:fourthLabel];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectZero];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.textColor = RGB(97, 97, 97);
    label5.font = [UIFont systemFontOfSize:12.0f];
    label5.backgroundColor = [UIColor clearColor];
    label5.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent5 = @"2.App账号只限湾仔本人使用，不得转借他人使用。";
    label5.text = titleContent5;
    label5.numberOfLines = 0;
    CGSize titleSize5 = [titleContent5 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    label5.frame = CGRectMake(12.0f, CGRectGetMaxY(fourthLabel.frame), titleSize5.width, titleSize5.height);
    NSMutableAttributedString *attributedString5 = [[ NSMutableAttributedString alloc ] initWithString: label5.text ];
    NSMutableParagraphStyle *paragraphStyle5 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle5.firstLineHeadIndent = 24.0f;
    paragraphStyle5.lineHeightMultiple = 1.5;
    [attributedString5 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle5 range: NSMakeRange (0 , [label5.text length])];
    label5.attributedText = attributedString5;
    [top addSubview:label5];
    
    UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sixthLabel.textAlignment = NSTextAlignmentLeft;
    sixthLabel.textColor = RGB(60, 60, 60);
    sixthLabel.font = [UIFont systemFontOfSize:14.0f];
    sixthLabel.backgroundColor = [UIColor clearColor];
    sixthLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent6 = @"二、保密责任";
    sixthLabel.text = titleContent6;
    sixthLabel.numberOfLines = 0;
    sixthLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(label5.frame), width-2*12.0f, 20.0f);
    CGSize titleSize6 = [titleContent6 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    sixthLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(label5.frame), titleSize6.width, titleSize6.height);
    NSMutableAttributedString *attributedString6 = [[ NSMutableAttributedString alloc ] initWithString: sixthLabel.text ];
    NSMutableParagraphStyle *paragraphStyle6 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle6.firstLineHeadIndent = 0.0f;
    paragraphStyle6.lineHeightMultiple = 1.5;
    [attributedString6 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle6 range: NSMakeRange (0 , [sixthLabel.text length])];
    sixthLabel.attributedText = attributedString6;
    [top addSubview:sixthLabel];
    
    UILabel *sevenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sevenLabel.textAlignment = NSTextAlignmentLeft;
    sevenLabel.textColor = RGB(97, 97, 97);
    sevenLabel.font = [UIFont systemFontOfSize:12.0f];
    sevenLabel.backgroundColor = [UIColor clearColor];
    sevenLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent7 = @"1.App内所有资源的信息，包括但不限于联系人、联系方式、优惠内容，归天湾所有，不得向第三方透露。";
    sevenLabel.text = titleContent7;
    sevenLabel.numberOfLines = 0;
    CGSize titleSize7 = [titleContent7 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    sevenLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(sixthLabel.frame), titleSize7.width, titleSize7.height);
    NSMutableAttributedString *attributedString7 = [[ NSMutableAttributedString alloc ] initWithString: sevenLabel.text ];
    NSMutableParagraphStyle *paragraphStyle7 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle7.firstLineHeadIndent = 24.0f;
    paragraphStyle7.lineHeightMultiple = 1.5;
    [attributedString7 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle7 range: NSMakeRange (0 , [sevenLabel.text length])];
    sevenLabel.attributedText = attributedString7;
    [top addSubview:sevenLabel];
    
    UILabel *eightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    eightLabel.textAlignment = NSTextAlignmentLeft;
    eightLabel.textColor = RGB(97, 97, 97);
    eightLabel.font = [UIFont systemFontOfSize:12.0f];
    eightLabel.backgroundColor = [UIColor clearColor];
    eightLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent8 = @"2.App内资源仅限于湾仔为公司经营需要使用，不得用于其他第三方公司或个人。";
    eightLabel.text = titleContent8;
    eightLabel.numberOfLines = 0;
    CGSize titleSize8 = [titleContent8 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    eightLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(sevenLabel.frame), titleSize8.width, titleSize8.height);
    NSMutableAttributedString *attributedString8 = [[ NSMutableAttributedString alloc ] initWithString: eightLabel.text ];
    NSMutableParagraphStyle *paragraphStyle8 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle8.firstLineHeadIndent = 24.0f;
    paragraphStyle8.lineHeightMultiple = 1.5;
    [attributedString8 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle8 range: NSMakeRange (0 , [eightLabel.text length])];
    eightLabel.attributedText = attributedString8;
    [top addSubview:eightLabel];
    
    UILabel *Label9 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label9.textAlignment = NSTextAlignmentLeft;
    Label9.textColor = RGB(97, 97, 97);
    Label9.font = [UIFont systemFontOfSize:12.0f];
    Label9.backgroundColor = [UIColor clearColor];
    Label9.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent9 = @"3.若湾仔更换账号关联手机号码，必须及时通知天湾投后部门人员更改账号。";
    Label9.text = titleContent9;
    Label9.numberOfLines = 0;
    CGSize titleSize9 = [titleContent9 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label9.frame = CGRectMake(12.0f, CGRectGetMaxY(eightLabel.frame), titleSize9.width, titleSize9.height);
    NSMutableAttributedString *attributedString9 = [[ NSMutableAttributedString alloc ] initWithString: Label9.text ];
    NSMutableParagraphStyle *paragraphStyle9 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle9.firstLineHeadIndent = 24.0f;
    paragraphStyle9.lineHeightMultiple = 1.5;
    [attributedString9 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle9 range: NSMakeRange (0 , [Label9.text length])];
    Label9.attributedText = attributedString9;
    [top addSubview:Label9];
    
    UILabel *Label10 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label10.textAlignment = NSTextAlignmentLeft;
    Label10.textColor = RGB(97, 97, 97);
    Label10.font = [UIFont systemFontOfSize:12.0f];
    Label10.backgroundColor = [UIColor clearColor];
    Label10.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent10 = @"4.若湾仔不再担任天湾管理基金所投资公司的CEO，必须及时通知天湾投后部门人员，天湾投后部门人员将关闭湾仔账号。";
    Label10.text = titleContent10;
    Label10.numberOfLines = 0;
    CGSize titleSize10 = [titleContent10 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label10.frame = CGRectMake(12.0f, CGRectGetMaxY(Label9.frame), titleSize10.width, titleSize10.height);
    NSMutableAttributedString *attributedString10 = [[ NSMutableAttributedString alloc ] initWithString: Label10.text ];
    NSMutableParagraphStyle *paragraphStyle10 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle10.firstLineHeadIndent = 24.0f;
    paragraphStyle10.lineHeightMultiple = 1.5;
    [attributedString10 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle10 range: NSMakeRange (0 , [Label10.text length])];
    Label10.attributedText = attributedString10;
    [top addSubview:Label10];
    
    UILabel *Label11 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label11.textAlignment = NSTextAlignmentLeft;
    Label11.textColor = RGB(60, 60, 60);
    Label11.font = [UIFont systemFontOfSize:14.0f];
    Label11.backgroundColor = [UIColor clearColor];
    Label11.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent11 = @"三、违约责任";
    Label11.text = titleContent11;
    Label11.numberOfLines = 0;
    CGSize titleSize11 = [titleContent11 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label11.frame = CGRectMake(12.0f, CGRectGetMaxY(Label10.frame), titleSize11.width, titleSize11.height);
    NSMutableAttributedString *attributedString11 = [[ NSMutableAttributedString alloc ] initWithString: Label11.text ];
    NSMutableParagraphStyle *paragraphStyle11 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle11.firstLineHeadIndent = 0.0f;
    paragraphStyle11.lineHeightMultiple = 1.5;
    [attributedString11 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle11 range: NSMakeRange (0 , [Label11.text length])];
    Label11.attributedText = attributedString11;
    [top addSubview:Label11];
    
    UILabel *Label12 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label12.textAlignment = NSTextAlignmentLeft;
    Label12.textColor = RGB(97, 97, 97);
    Label12.font = [UIFont systemFontOfSize:12.0f];
    Label12.backgroundColor = [UIColor clearColor];
    Label12.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent12 = @"由于湾仔违约导致天湾商业信息、商业资源泄漏的，天湾有权通过法律手段追究湾仔相应责任，并有权要求湾仔对因此引起的天湾的损失进行赔偿。";
    Label12.text = titleContent12;
    Label12.numberOfLines = 0;
    CGSize titleSize12 = [titleContent12 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label12.frame = CGRectMake(12.0f, CGRectGetMaxY(Label11.frame), titleSize12.width, titleSize12.height);
    NSMutableAttributedString *attributedString12 = [[ NSMutableAttributedString alloc ] initWithString: Label12.text ];
    NSMutableParagraphStyle *paragraphStyle12 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle12.firstLineHeadIndent = 24.0f;
    paragraphStyle12.lineHeightMultiple = 1.5;
    [attributedString12 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle12 range: NSMakeRange (0 , [Label12.text length])];
    Label12.attributedText = attributedString12;
    [top addSubview:Label12];
    
    UILabel *Label13 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label13.textAlignment = NSTextAlignmentLeft;
    Label13.textColor = RGB(60, 60, 60);
    Label13.font = [UIFont systemFontOfSize:14.0f];
    Label13.backgroundColor = [UIColor clearColor];
    Label13.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent13 = @"四、其他";
    Label13.text = titleContent13;
    Label13.numberOfLines = 0;
    CGSize titleSize13 = [titleContent13 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label13.frame = CGRectMake(12.0f, CGRectGetMaxY(Label12.frame), titleSize13.width, titleSize13.height);
    NSMutableAttributedString *attributedString13 = [[ NSMutableAttributedString alloc ] initWithString: Label13.text ];
    NSMutableParagraphStyle *paragraphStyle13 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle13.firstLineHeadIndent = 0.0f;
    paragraphStyle13.lineHeightMultiple = 1.5;
    [attributedString13 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle13 range: NSMakeRange (0 , [Label13.text length])];
    Label13.attributedText = attributedString13;
    [top addSubview:Label13];
    
    UILabel *Label14 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label14.textAlignment = NSTextAlignmentLeft;
    Label14.textColor = RGB(97, 97, 97);
    Label14.font = [UIFont systemFontOfSize:12.0f];
    Label14.backgroundColor = [UIColor clearColor];
    Label14.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent14 = @"1.本协议的效力、解释及纠纷的解决，适用于中华人民共和国法律。若湾仔和天湾之间发生任何纠纷或争议，首先应友好协商解决，协商不成的，湾仔同意将纠纷或争议提交天湾住所地有管辖权的人民法院管辖。";
    Label14.text = titleContent14;
    Label14.numberOfLines = 0;
    CGSize titleSize14 = [titleContent14 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label14.frame = CGRectMake(12.0f, CGRectGetMaxY(Label13.frame), titleSize14.width, titleSize14.height);
    NSMutableAttributedString *attributedString14 = [[ NSMutableAttributedString alloc ] initWithString: Label14.text ];
    NSMutableParagraphStyle *paragraphStyle14 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle14.firstLineHeadIndent = 24.0f;
    paragraphStyle14.lineHeightMultiple = 1.5;
    [attributedString14 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle14 range: NSMakeRange (0 , [Label14.text length])];
    Label14.attributedText = attributedString14;
    [top addSubview:Label14];
    
    UILabel *Label15 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label15.textAlignment = NSTextAlignmentLeft;
    Label15.textColor = RGB(97, 97, 97);
    Label15.font = [UIFont systemFontOfSize:12.0f];
    Label15.backgroundColor = [UIColor clearColor];
    Label15.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent15 = @"2.本协议的任何条款无论因何种原因无效或不具可执行性，其余条款仍有效，对双方具有约束力。";
    Label15.text = titleContent15;
    Label15.numberOfLines = 0;
    CGSize titleSize15 = [titleContent15 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label15.frame = CGRectMake(12.0f, CGRectGetMaxY(Label14.frame), titleSize15.width, titleSize15.height);
    NSMutableAttributedString *attributedString15 = [[ NSMutableAttributedString alloc ] initWithString: Label15.text ];
    NSMutableParagraphStyle *paragraphStyle15 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle15.firstLineHeadIndent = 24.0f;
    paragraphStyle15.lineHeightMultiple = 1.5;
    [attributedString15 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle15 range: NSMakeRange (0 , [Label15.text length])];
    Label15.attributedText = attributedString15;
    [top addSubview:Label15];
    self.view.backgroundColor = RGB(234, 234, 234);
    
    top.contentSize = CGSizeMake(width, CGRectGetHeight(firstLabel.frame) + CGRectGetHeight(secondLabel.frame) + CGRectGetHeight(thirdLabel.frame) + CGRectGetHeight(fourthLabel.frame) + CGRectGetHeight(label5.frame) + CGRectGetHeight(sixthLabel.frame) + CGRectGetHeight(sevenLabel.frame) + CGRectGetHeight(eightLabel.frame) + CGRectGetHeight(Label9.frame) + CGRectGetHeight(Label10.frame) + CGRectGetHeight(Label11.frame) + CGRectGetHeight(Label12.frame) + CGRectGetHeight(Label13.frame) + CGRectGetHeight(Label14.frame) + CGRectGetHeight(Label15.frame) + 40);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
