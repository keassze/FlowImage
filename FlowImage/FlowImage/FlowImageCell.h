//
//  FlowImageCell.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowImageCell : UIView

/** 图片 */
@property (nonatomic, strong) UIImageView *mainImageView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 蒙层 */
@property (nonatomic, strong) UIView *coverView;

/** 点击block */
@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, FlowImageCell *cell);


/**
 设置子控件frame

 @param superViewBounds 父容器的Bounds
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;


/**
 设置数据

 @param model 模型
 */
- (void)setCellWithModel:(id)model;

@end






