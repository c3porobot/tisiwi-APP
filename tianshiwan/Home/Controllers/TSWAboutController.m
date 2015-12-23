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
    self.navigationBar.title = @"关于天使湾";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationBar.bottomLineView.hidden = YES;
    
    UIScrollView *top = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight+18.0f, width, height - self.navigationBarHeight-18.0f)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    
    UILabel *zeroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    zeroLabel.textAlignment = NSTextAlignmentLeft;
    zeroLabel.textColor = RGB(60, 60, 60);
    zeroLabel.font = [UIFont systemFontOfSize:14.0f];
    zeroLabel.backgroundColor = [UIColor clearColor];
    zeroLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent0= @"简介";
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
    NSString *titleContent1 = @"浙江天使湾创业投资有限公司成立于 2010 年 9 月,该创投基金由庞小伟先生联合实力雄厚的财团法人等在中国杭州发起设立。 天使湾创投公司是一家专注于互联网产业投资的风险投资公司,也是目前互联网领域国内领先的早期风险投资基金。目前直接管理了 6 支人民币天使投资基金,分别是“天使湾 1 号”至“天使湾 6 号”,天使湾将是一个持续的系列的计划,我们计划未来 5 年在互联网领 域投入不少于 10 亿元人民币的天使投资。";
    firstLabel.text = titleContent1;
    firstLabel.numberOfLines = 0;
    CGSize titleSize1 = [titleContent1 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    firstLabel.frame = CGRectMake(12.0f, 12.0f, titleSize1.width, titleSize1.height);
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
    NSString *titleContent2 = @"天使湾的基金只专注于投资互联网,目前范围主要包括移动互联网、移动电子商务、企 业移动服务、软硬件结合、移动游戏等方向。 供天使投资(1000 万人民币以下、25%以 下)和种子投资(20 万-50 万,10%左右)两种投资服务。经过将近五年的投资实践,天使 湾在互联网投资领域已经建立了独特的投资平台和标准化评估流程,并积累了丰富的投资经 验。";
    secondLabel.text = titleContent2;
    secondLabel.numberOfLines = 0;
    CGSize titleSize2 = [titleContent2 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    secondLabel.frame = CGRectMake(12.0f, 12.0f+titleSize1.height*2/3+15.0f, titleSize2.width, titleSize2.height);
    NSMutableAttributedString *attributedString2 = [[ NSMutableAttributedString alloc ] initWithString: secondLabel.text ];
    NSMutableParagraphStyle *paragraphStyle2 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle2.firstLineHeadIndent = 24.0f;
    paragraphStyle2.lineHeightMultiple = 1.5;
    [attributedString2 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle2 range: NSMakeRange (0 , [secondLabel.text length])];
    secondLabel.attributedText = attributedString2;
    [top addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    thirdLabel.textAlignment = NSTextAlignmentLeft;
    thirdLabel.textColor = RGB(97, 97, 97);
    thirdLabel.font = [UIFont systemFontOfSize:12.0f];
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent3 = @"天使湾下属互联网投资平台网站——天使湾 tisiwi.com,此网站是国内唯一的互联网 领域的早期风险投资项目申请平台。天使湾创投的投资理念:创投务必让世界更美好;对投 资者和创业者负责。";
    thirdLabel.text = titleContent3;
    thirdLabel.numberOfLines = 0;
    CGSize titleSize3 = [titleContent3 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    thirdLabel.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+2*15.0f, titleSize3.width, titleSize3.height);
    NSMutableAttributedString *attributedString3 = [[ NSMutableAttributedString alloc ] initWithString: thirdLabel.text ];
    NSMutableParagraphStyle *paragraphStyle3 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle3.firstLineHeadIndent = 24.0f;
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
    NSString *titleContent4 = @"";
    fourthLabel.text = titleContent4;
    fourthLabel.numberOfLines = 0;
    [top addSubview:fourthLabel];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectZero];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.textColor = RGB(97, 97, 97);
    label5.font = [UIFont systemFontOfSize:12.0f];
    label5.backgroundColor = [UIColor clearColor];
    label5.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent5 = @"天使湾创投的投资团队由具有丰富的互联网创业经验、深厚的技术背景、中外互联网研 究积累的专业人士组成。团队创始人庞小伟为互联网领域知名的创业者,也是中国十大新锐 天使投资人、浙江省十大天使投资人。天使湾创投也是杭州市蒲公英天使投资引导基金第一 家合作对象,也是上海市天使投资引导基金第一批合作对象。";
    label5.text = titleContent5;
    label5.numberOfLines = 0;
    CGSize titleSize5 = [titleContent5 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    label5.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+15.0f+8.0f, titleSize5.width, titleSize5.height);
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
    NSString *titleContent6 = @"信念与愿景";
    sixthLabel.text = titleContent6;
    sixthLabel.numberOfLines = 0;
    sixthLabel.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+4*15.0f+3*8.0f, width-2*12.0f, 20.0f);
    [top addSubview:sixthLabel];
    
    UILabel *sevenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sevenLabel.textAlignment = NSTextAlignmentLeft;
    sevenLabel.textColor = RGB(97, 97, 97);
    sevenLabel.font = [UIFont systemFontOfSize:12.0f];
    sevenLabel.backgroundColor = [UIColor clearColor];
    sevenLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent7 = @"我们相信互联网对人类社会的发展将起到重大推动作用。我们愿意和心怀愿景和梦想的创业者,用互联网精神和方法,对社会发展的重大问题 出解决和改善之道。 我们的目标是成为中国领先的互联网专业天使投资基金,以开创性的投资帮助创业者,促进互联网在中国和全球的应用和发展。";
    sevenLabel.text = titleContent7;
    sevenLabel.numberOfLines = 0;
    CGSize titleSize7 = [titleContent7 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    sevenLabel.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+3*15.0f+3*8.0f, titleSize7.width, titleSize7.height);
    NSMutableAttributedString *attributedString7 = [[ NSMutableAttributedString alloc ] initWithString: sevenLabel.text ];
    NSMutableParagraphStyle *paragraphStyle7 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle7.firstLineHeadIndent = 24.0f;
    paragraphStyle7.lineHeightMultiple = 1.5;
    [attributedString7 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle7 range: NSMakeRange (0 , [sevenLabel.text length])];
    sevenLabel.attributedText = attributedString7;
    [top addSubview:sevenLabel];
    
    UILabel *eightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    eightLabel.textAlignment = NSTextAlignmentLeft;
    eightLabel.textColor = RGB(60, 60, 60);
    eightLabel.font = [UIFont systemFontOfSize:14.0f];
    eightLabel.backgroundColor = [UIColor clearColor];
    eightLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent8 = @"天使湾的独特性 ";
    eightLabel.text = titleContent8;
    eightLabel.numberOfLines = 0;
    eightLabel.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+3*15.0f+3*8.0f+60.0f, width-2*12.0f, 20.0f);
    [top addSubview:eightLabel];
    
    UILabel *Label9 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label9.textAlignment = NSTextAlignmentLeft;
    Label9.textColor = RGB(97, 97, 97);
    Label9.font = [UIFont systemFontOfSize:12.0f];
    Label9.backgroundColor = [UIColor clearColor];
    Label9.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent9 = @"1. 我们是愿景式风险投资商。我们坚信投资的财务回报本质来自于我们所投资的企业为社会所创造的价值,所以我们会选择长期地和有愿景的创业者站在一起。这些价值观方面差异,一旦接触,你必能感受。";
    Label9.text = titleContent9;
    Label9.numberOfLines = 0;
    CGSize titleSize9 = [titleContent9 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label9.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+20.0f+3*15.0f+3*8.0f+60.0f, titleSize9.width, titleSize9.height);
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
    NSString *titleContent10 = @"2. 我们只投互联网。我们自己也是互联网的创业者,所以更理解互联网,更理解互联网代表的方向。";
    Label10.text = titleContent10;
    Label10.numberOfLines = 0;
    CGSize titleSize10 = [titleContent10 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label10.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+20.0f+titleSize9.height*2/3+3*15.0f+3*8.0f+10.0f+60.0f, titleSize10.width, titleSize10.height);
    NSMutableAttributedString *attributedString10 = [[ NSMutableAttributedString alloc ] initWithString: Label10.text ];
    NSMutableParagraphStyle *paragraphStyle10 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle10.firstLineHeadIndent = 24.0f;
    paragraphStyle10.lineHeightMultiple = 1.5;
    [attributedString10 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle10 range: NSMakeRange (0 , [Label10.text length])];
    Label10.attributedText = attributedString10;
    [top addSubview:Label10];
    
    UILabel *Label11 = [[UILabel alloc] initWithFrame:CGRectZero];
    Label11.textAlignment = NSTextAlignmentLeft;
    Label11.textColor = RGB(97, 97, 97);
    Label11.font = [UIFont systemFontOfSize:12.0f];
    Label11.backgroundColor = [UIColor clearColor];
    Label11.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    NSString *titleContent11 = @"3. 我们只做天使投资。因为天然的高风险,这是目前市场上最稀缺,也是最渴望的。";
    Label11.text = titleContent11;
    Label11.numberOfLines = 0;
    CGSize titleSize11 = [titleContent11 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label11.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+20.0f+titleSize9.height*2/3+titleSize10.height*2/3+3*15.0f+3*8.0f+10.0f+60.0f, titleSize11.width, titleSize11.height);
    NSMutableAttributedString *attributedString11 = [[ NSMutableAttributedString alloc ] initWithString: Label11.text ];
    NSMutableParagraphStyle *paragraphStyle11 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle11.firstLineHeadIndent = 24.0f;
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
    NSString *titleContent12 = @"4. 我们倡导用互联网模式和理念来做互联网领域的投资,tisiwi.com网站就是呈现我们理念和方法的重要的平台。 我们是机构型的天使投资,在开放性、方法论、专业性、规模化、认同感等方面具有明显而独特的优势。";
    Label12.text = titleContent12;
    Label12.numberOfLines = 0;
    CGSize titleSize12 = [titleContent12 boundingRectWithSize:CGSizeMake(width - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    Label12.frame = CGRectMake(12.0f, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+20.0f+titleSize9.height*2/3+titleSize10.height*2/3+titleSize11.height*2/3+3*15.0f+3*8.0f+10.0f+60.0f, titleSize12.width, titleSize12.height);
    NSMutableAttributedString *attributedString12 = [[ NSMutableAttributedString alloc ] initWithString: Label12.text ];
    NSMutableParagraphStyle *paragraphStyle12 = [[ NSMutableParagraphStyle alloc ] init];
    paragraphStyle12.firstLineHeadIndent = 24.0f;
    paragraphStyle12.lineHeightMultiple = 1.5;
    [attributedString12 addAttribute: NSParagraphStyleAttributeName value:paragraphStyle12 range: NSMakeRange (0 , [Label12.text length])];
    Label12.attributedText = attributedString12;
    [top addSubview:Label12];
    
    self.view.backgroundColor = RGB(234, 234, 234);
    
    top.contentSize = CGSizeMake(width, 12.0f+8.0f+titleSize1.height*2/3+titleSize2.height*2/3+titleSize3.height*2/3+titleSize5.height*2/3+20.0f+titleSize7.height*2/3+20.0f+titleSize9.height*2/3+titleSize10.height*2/3+titleSize11.height*2/3+3*15.0f+3*8.0f+10.0f+60.0f+titleSize12.height*2/3+40.0f);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
