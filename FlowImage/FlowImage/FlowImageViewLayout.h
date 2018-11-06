//
//  FlowImageViewLayout.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/5.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlowImageView.h"

@class FlowImageView;

@interface FlowImageViewLayout : NSObject

/** 间隔 */
@property (nonatomic, assign) UIEdgeInsets edgeInsetsMargin;
/** 阴影透明度 默认0.5 */
@property (nonatomic, assign) CGFloat alpha;
/** 单个Page大小 */
@property (nonatomic, assign) CGSize itemSize;


/**
 刷新当前所看见的page的样式，在scrollViewDidScroll 以及 reloadData时都需要及时更新

 @param cell 需要刷新的cell
 @param index 该cell的索引值
 @param contentOffset cell父类的偏移量
 */
- (void)refreshVisibleCell:(FlowImageCell *_Nullable)cell forIndex:(NSInteger)index withScrollContentOffset:(CGPoint)contentOffset;

@end





