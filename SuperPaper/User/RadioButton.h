//
//  RadioButton.h
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/21.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIView
@property (nonatomic,retain) NSMutableArray *radioButtons;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options
         andColumns:(int)columns;
-(void) radioButtonClicked:(UIButton *) sender;
-(void) removeButtonAtIndex:(int)index;
-(void) setSelected:(int) index;
-(void)clearAll;
@end
