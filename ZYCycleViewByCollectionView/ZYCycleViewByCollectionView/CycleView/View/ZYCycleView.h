//
//  ZYCycleView.h
//  ZYCycleViewByCollectionView
//
//  Created by  xiazhiyao on 2018/4/3.
//  Copyright © 2018年  xiazhiyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYCycleView;

typedef void(^ClickImageBlock)(NSInteger imageIndex);//点击图片回调block

@protocol ZYCycleViewDelegate<NSObject>

/*点击图片delegate*/
- (void)cycleView:(ZYCycleView *)cycleView didSelectImageAtIndex:(NSInteger)imageIndex;

@end

@interface ZYCycleView : UIView

@property (nonatomic,copy) ClickImageBlock backIndexBlock;//点击图片block

@property (nonatomic,copy) NSArray *imageArr;//轮播图片数据源

@property (nonatomic,assign) CGFloat scrollTimeInterval;//轮播间隔,默认2s

@property (nonatomic,weak)id<ZYCycleViewDelegate>delegate;//点击图片代理

@property (nonatomic,assign) UIViewContentMode imageViewContentMode;//轮播图片模式

@property (nonatomic,assign) BOOL isShowPageControl;//是否显示分页控件,默认yes

@property (nonatomic,assign) CGRect pageControlFrame;//分页控件位置

@property (nonatomic,strong) UIColor *currentPageDotColor;//当前分页控件小圆标颜色

@property (nonatomic,strong) UIColor *pageDotColor;//小圆标颜色

//初始化
+ (instancetype)initWithFrameCycleViewFrame:(CGRect)frame
                                 imageArray:(NSArray *)imageArr;

@end
