//
//  ViewController.m
//  01-超级猜图
//
//  Created by 蔡钦童 on 15/8/27.
//  Copyright (c) 2015年 Cass. All rights reserved.
//
//13:22

#import "ViewController.h"
#import "QTQuestion.h"

@interface ViewController ()
- (IBAction)tip;
- (IBAction)bigImg;
- (IBAction)help;
- (IBAction)nextQuestion;
- (IBAction)iconClick;


@property (weak, nonatomic) IBOutlet UILabel *noLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;

@property (nonatomic,weak) UIButton *cover;
//存放正确答案的View
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionView;


/** 所有的题目*/
@property (nonatomic,strong) NSArray *questions;
/**当前是第几题*/
@property (nonatomic,assign) int index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = -1;
    self.nextQuestion;
}


- (NSArray *)questions
{
    if (_questions == nil) {
        //1.加载plist
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
        //2.字典转模型
        NSMutableArray *questionArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            QTQuestion *question = [QTQuestion questionWithDict:dict];
            [questionArray addObject:question];
        }

        //3.赋值
        _questions = questionArray;
    }
    return _questions;
}





/**
 *  控制状态栏样式
 */
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)tip {
    //清空答案选项
    for (UIButton *btn in self.answerView.subviews) {
        [self answerClick:btn];
    }
    QTQuestion *quesion = self.questions[self.index];
    //第一个字母
    NSString *aString = quesion.answer;
    NSString *first = [aString substringToIndex:1];
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:first]) {
            [self optionClick:btn];
            break;
        }
    }
    int score = [self.scoreBtn titleForState:UIControlStateNormal].intValue;
    score -= 1000;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
    
}

- (IBAction)bigImg {
    
    
    //1.添加阴影
    UIButton *cover = [[UIButton alloc]init];
    self.cover = cover;
    cover.frame = self.view.bounds;
    cover.backgroundColor = [UIColor blackColor];
    
    //设置监听取消大图
    [cover addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cover];
    [UIView beginAnimations:nil context:nil];
    cover.alpha = 0.7;
    //2.设置显示层级关系
    [self.view bringSubviewToFront:self.iconBtn];
    
    //3.放大
    CGFloat iconW = self.view.frame.size.width;
    CGFloat iconH = iconW;;
    CGFloat iconY = (self.view.frame.size.height - iconH)*0.5;
    self.iconBtn.frame = CGRectMake(0, iconY, iconW, iconH);
    
    
    [UIView commitAnimations];
}

- (void)smallImg
{
    //delete cover
    //[self.cover removeFromSuperview];
    
    //image small
    [UIView beginAnimations:nil context:nil];
   // [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeCover)];
    self.cover.alpha = 0;
    self.iconBtn.frame = CGRectMake(85, 103, 150, 150);
    [UIView commitAnimations];
    //[self.cover removeFromSuperview];
}

- (void) removeCover
{
    [self.cover removeFromSuperview];
    self.cover = nil;
}

- (IBAction)help {
}

/**
 *  下一题
 */
- (IBAction)nextQuestion {
    
    //1.索引增加
    self.index++;
    //2.取出模型
    QTQuestion *quesion = self.questions[self.index];
    //3.使用模型设置控件的数据
    //3.1设置图片编号
    self.noLable.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.questions.count];
    //3.2设置标题
    self.titleLable.text = quesion.title;
    
    //3.3设置图片
    [self.iconBtn setImage:[UIImage imageNamed:quesion.icon] forState:UIControlStateNormal];
    
    //4设置下一题按钮状态
    if (self.index == self.questions.count-1) {
        [self.nextQuestionBtn setEnabled:NO];
    }
    
    //5.添加正确答案
    //5.1移除所有按钮
    for (UIView *subview in self.answerView.subviews) {
        [subview removeFromSuperview];
    }
    
    //添加新的答案按钮
    [self addAnswerBtn:quesion];
    //添加待选项
    [self addOptionBtn:quesion];
    
    
    
}

/**
 *  添加新的答案按钮
 *
 */

- (void) addAnswerBtn:(QTQuestion *)quesion
{
    //5.2添加新的答案按钮
    int length = quesion.answer.length;
    for (int i = 0; i<length; i++) {
        UIButton *answerBtn = [[UIButton alloc]init];
        //btn background
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        //frame
        CGFloat margin = 10;
        CGFloat answerW =35;
        CGFloat answerH = 35;
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin = (viewW -  length * answerW - margin*(length-1))*0.5;
        CGFloat answerX = leftMargin + i*(answerW + margin);
        answerBtn.frame = CGRectMake(answerX, 0, answerW, answerH);
        [self.answerView addSubview:answerBtn];
        //设置监听
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];

    }
}

/**
 *  监听答案按钮
 */
- (void)answerClick:(UIButton *)answerBtn
{
    if ([answerBtn titleColorForState:UIControlStateNormal]==[UIColor redColor]) {
        for (UIButton *btn in self.answerView.subviews) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    
    
    }
    NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
    for(UIButton *optionBtn in self.optionView.subviews ) {
        NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
        if ([optionTitle isEqualToString:answerTitle]) {
            optionBtn.hidden = NO;
            [answerBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        }
    }
    for (UIButton *btn in self.optionView.subviews) {
        btn.enabled =YES;
    }
    
    
}


/**
 *  添加待选项
 *
 */

- (void) addOptionBtn:(QTQuestion *)quesion
{
    for (UIView *subview in self.optionView.subviews) {
        [subview removeFromSuperview];
    }
    
    int count = quesion.options.count;
    for (int i = 0; i<count; i++) {
        UIButton *optionBtn = [[UIButton alloc]init];
        //btn background
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"]forState:UIControlStateHighlighted];
        CGFloat optionW =35;
        CGFloat optionH = 35;
        CGFloat margin = 10;
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin = (viewW -7*optionW-margin*6)*0.5;
        int col = i % 7;
        CGFloat optionX = leftMargin +col*(optionW+margin);
        int row = i/7;
        CGFloat optionY = row*(optionH + margin);
        
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        //set title
        [optionBtn setTitle:quesion.options[i] forState:UIControlStateNormal];
        [self.optionView addSubview:optionBtn];
        //设置监听
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

}


- (void)optionClick:(UIButton *)optionBtn
{
    //1.被点击按钮消失
    optionBtn.hidden = YES;
    //2.显示文字到正确答案上
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerTitle.length == 0) {
            NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        }
        
    }
    //3.检测答案是否填满
    BOOL full = YES;
    NSMutableString *tempAnswerTitle = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerTitle.length==0) {
            full = NO;
        }
        if (answerTitle) {
            [tempAnswerTitle appendString:answerTitle];
        }
        
    }
    
    //4.答案填满了
    if (full) {
       
        for (UIButton *btn in self.optionView.subviews) {
            btn.enabled =NO;
        }
        
        QTQuestion *question = self.questions[self.index];
        if ([tempAnswerTitle isEqualToString:question.answer]) {
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            //add score
            int score = [self.scoreBtn titleForState:UIControlStateNormal].intValue;
            score += 1000;
            [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
            //next question
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:1];
        }
        else{
            
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        
    }
}



- (IBAction)iconClick {
    if (self.cover == nil) {
        [self bigImg];
    }
    else{
        //[self smallImg];
        [self smallImg];
    }
    
    
    
    
}
@end
