//
//  FlowImageViewLayout.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/5.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FlowImageView;

@interface FlowImageViewLayout : NSObject

// 左右间隔
@property (nonatomic, assign) CGFloat leftRightMargin;
// 上下间隔
@property (nonatomic, assign) CGFloat topBottomMargin;
// 单个Page大小
@property (nonatomic, assign) CGSize itemSize;

@end
