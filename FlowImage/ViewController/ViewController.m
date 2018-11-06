//
//  ViewController.m
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "ViewController.h"
#import "FlowImageView.h"
#import "FlowImageViewLayout.h"
#import "BannerModel.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<FlowImageViewDelegate,FlowImageViewDataSorce>

@property (nonatomic, strong) FlowImageView *pageFlowView;
@property (nonatomic, strong) FlowImageViewLayout *flowImageViewLayout;
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];;
    for (int i = 1; i <= 4; i++) {
        BannerModel *model = [BannerModel new];
        model.title = [NSString stringWithFormat:@"%d",i];
        model.imageName = [NSString stringWithFormat:@"%d.jpg",i];
        [tempArr addObject:model];
    }
    _modelArr = [tempArr copy];
    
//    _pageFlowView = [[FlowImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 150)];
    _pageFlowView = [[FlowImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 150) forLayout:self.flowImageViewLayout];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.isForeverFlow = YES;
    _pageFlowView.isAutoScroll  = YES;
    _pageFlowView.flowTime = 3.0;
    [self.view addSubview:_pageFlowView];
    
    [_pageFlowView reloadData];
}

#pragma mark - FlowImageViewDataSource
- (NSInteger)numberOfFlowImageView:(FlowImageView *)flowImageView
{
    return _modelArr.count;
}

- (FlowImageCell *)flowView:(FlowImageView *)flowImageView cellInFlowViewWithIndex:(NSInteger)index
{
    FlowImageCell *bannerView = (FlowImageCell *)[flowImageView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[FlowImageCell alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    
    //加载本地图片
    [bannerView setCellWithModel:self.modelArr[index]];
//    bannerView.mainImageView.image = [UIImage imageNamed:self.modelArr[index]];
    
    return bannerView;
}

#pragma mark - FlowImageViewDelegate
- (void)didSelectCell:(FlowImageCell *)cell withIndex:(NSInteger)index
{
    NSLog(@"点击%ld",(long)index);
}

#pragma mark - Lazy Load
- (FlowImageViewLayout *)flowImageViewLayout
{
    if (!_flowImageViewLayout) {
        _flowImageViewLayout = [[FlowImageViewLayout alloc] init];
        _flowImageViewLayout.edgeInsetsMargin = UIEdgeInsetsMake(10, 10, 10, 10);
//        _flowImageViewLayout.alpha = 0.5f;    // 设置未展示Page 阴影的透明度
        _flowImageViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 60, 150);
    }
    return _flowImageViewLayout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





