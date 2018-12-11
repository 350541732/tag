# tag
ios tag标签

本文章借鉴自[ptlCoder](https://github.com/ptlCoder/PTLDownMenuList/issues/4)，并在该文章上简单修改了一下。
##背景，假设我们需要实现如下的需求，如图
![未命名.gif](https://upload-images.jianshu.io/upload_images/3015045-99bb08e235cc9168.gif?imageMogr2/auto-orient/strip)
可以说这个需求在一些app上都比较常见，比如一些外卖或者商城的app中都会有此类需求，那么我们怎么实现呢。

首先，在** ptlCoder**的示例代码中我发现了一个bug，那就是如果我们在遵循delegate的方法中修改KMTag的UI时，第0个是不改变的，我分析可能是tag值设置的比较小的原因（没有仔细的找问题）

###思路略讲一下：
```
#import <UIKit/UIKit.h>

@interface KMTag : UILabel

- (void)setupWithText:(NSString*)text;

///我自己加的
@property(nonatomic,assign)BOOL isSelected;

@end
```

>首先这里继承UILabel新建了一个KMTag,并添加了一个根据文字text设置frame的方法，并添加了一个是否被点击的属性。

##实现文件(略掉了一些代码)
```
#import "KMTag.h"

@implementation KMTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        //默认未点击
        self.isSelected = NO;
    }
    return self;
}

- (void)setupWithText:(NSString*)text {
        
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width + 20, size.height + 10);    
    self.frame = frame;    
}
@end
```

>实现文件也比较简单，主要是根据text来确定frame,这里作者额外给frame增加了20的宽以及10的高，另外初始化他的点击属性为NO.

##以下是KMTagListView.h的声明文件
```
#import <UIKit/UIKit.h>

@class KMTagListView;
@protocol KMTagListViewDelegate<NSObject>
- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content ifSelected:(BOOL)selected;
@end

@interface KMTagListView : UIScrollView
@property (nonatomic, weak)id<KMTagListViewDelegate> delegate_;
- (void)setupSubViewsWithTitles:(NSArray *)titles;
@end
```
>这里主要是声明一个布局label的方法和声明一个label被点击的protocol.

###实现文件（部分）
```
- (void)setupAllSubViews {
    ///设置x,y间距。
    CGFloat marginX = 20;
    CGFloat marginY = 20;
    ///设置为_block的原因大家都懂得，闭包中需要改变这个值
    __block CGFloat x = 0;
    __block CGFloat y = 10;
    
    [self.tags enumerateObjectsUsingBlock:^(KMTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        
        CGFloat height = CGRectGetHeight(obj.frame);

        if (idx == 0) {
       ///如果是第一个的话，那么直接給值。
            x = marginX;
        }else {
            x = CGRectGetMaxX([self.tags[idx - 1] frame]) + marginX;
     ///这里的判断是是都超出边界，超出换行。
            if ( x + CGRectGetWidth(obj.frame) + marginX > CGRectGetWidth(self.frame) ) {
                x = marginX;
                y += height;
                y += marginY;
            }
        }
        CGRect frame = obj.frame;
        frame.origin = CGPointMake(x, y);
        obj.frame = frame;
        
    }];
    
    // 如果只有一行，居中显示
    if (y == 10) {
        
        [self.tags enumerateObjectsUsingBlock:^(KMTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat height = CGRectGetHeight(obj.frame);
            y = CGRectGetHeight(self.frame) / 2 - height / 2.0;
            
            if (idx == 0) {
                x = marginX;
            }else {
                x = CGRectGetMaxX([self.tags[idx - 1] frame]) + marginX;
            }
            CGRect frame = obj.frame;
            frame.origin = CGPointMake(x, y);
            obj.frame = frame;
            
        }];
        
    }
    
    CGFloat contentHeight = CGRectGetMaxY([self.tags.lastObject frame]) + 10;
    if (contentHeight < CGRectGetHeight(self.frame)) {
        contentHeight = 0;
    }
    
    self.contentSize = CGSizeMake(0, contentHeight);
}
```

###之后既可以在VC中愉快的使用了 ，VC代码如下：

```
#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content ifSelected:(BOOL)selected
{
    NSLog(@"content: %@ index: %zd", content, index);
    KMTag *tag = tagListView.subviews[index-1000]; 
    if (tag.isSelected) {
        tag.layer.borderColor = [UIColor redColor].CGColor;
    }
    else {
        tag.layer.borderColor = tag.textColor.CGColor;
    }
}
```
最后奉上代码下载地址：
