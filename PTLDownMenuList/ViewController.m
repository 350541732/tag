//
//  ViewController.m
//  PTLDownMenuList
//
//  Created by soliloquy on 2017/11/20.
//  Copyright © 2017年 soliloquy. All rights reserved.
// 

#import "ViewController.h"

#import "KMTagListView.h"

@interface ViewController ()< KMTagListViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // tag标签
    KMTagListView *tag = [[KMTagListView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width, 0)];
    tag.delegate_ = self;
    [tag setupSubViewsWithTitles:@[@"哈哈哈哈哈哈", @"哈试发",@"哈你发",@"哈哈试会计给你发",@"哈哈你发",@"哈哈哈哈哈发", @"哈哈哈哈哈哈考试会计给你发",@"哈哈哈哈哈发",@"哈哈发",@"哈哈哈哈哈发",@"哈哈计给你发",@"哈哈哈哈哈发",@"哈哈哈发",@"哈哈哈哈哈发",@"哈哈你发",@"哈发"]];
    [self.view addSubview:tag];

    CGRect rect = tag.frame;
    rect.size.height = tag.contentSize.height;
    tag.frame = rect;
     
     
}

#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content {
    NSLog(@"content: %@ index: %zd", content, index);
    
}

@end
