//
//  JournalsPressView.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/24.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "JournalsPressView.h"

@interface JournalsPressView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSDictionary *infoDic;

@end

@implementation JournalsPressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTestData];
        [self layoutCustomizedViewWithFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) createTestData {
    _leftArray  = @[@"One",@"Two",@"Three",@"Four"];
    NSArray *aArray = @[@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA",@"AAAA"];
    NSArray *bArray = @[@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB",@"BBBB"];
    NSArray *cArray = @[@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC",@"CCCC"];
    NSArray *dArray = @[@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD",@"DDDD"];
    _infoDic = [NSDictionary dictionaryWithObjectsAndKeys:aArray,_leftArray[0],bArray,_leftArray[1],cArray,_leftArray[2],dArray,_leftArray[3], nil];
    _rightArray = _infoDic[_leftArray[0]];
}

- (void)layoutCustomizedViewWithFrame:(CGRect)frame {
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tableFooterView = [[UIView alloc] init];
    _leftTableView.scrollEnabled = NO;
    [self addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_rightTableView];
    
    [_leftTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *leftTableToTop = [NSLayoutConstraint constraintWithItem:_leftTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0];
    NSLayoutConstraint *leftTableToLeft = [NSLayoutConstraint constraintWithItem:_leftTableView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:0];
    NSLayoutConstraint *leftTableToBottom = [NSLayoutConstraint constraintWithItem:_leftTableView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0];
    NSLayoutConstraint *leftTableWidth = [NSLayoutConstraint constraintWithItem:_leftTableView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:100.0f];
    NSArray *leftTableContraints = @[leftTableToTop, leftTableToLeft, leftTableToBottom, leftTableWidth];
    [self addConstraints:leftTableContraints];
    
    [_rightTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *rightTableToTop = [NSLayoutConstraint constraintWithItem:_rightTableView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0];
    NSLayoutConstraint *rightTableToLeft = [NSLayoutConstraint constraintWithItem:_rightTableView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_leftTableView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0];
    NSLayoutConstraint *rightTableToRight = [NSLayoutConstraint constraintWithItem:_rightTableView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0];
    NSLayoutConstraint *rightTableToBottom = [NSLayoutConstraint constraintWithItem:_rightTableView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0];
    NSArray *rightTableConstraints = @[rightTableToTop, rightTableToLeft, rightTableToRight, rightTableToBottom];
    [self addConstraints:rightTableConstraints];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return [_leftArray count];
    } else if (tableView == _rightTableView) {
        return [_rightArray count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 44;
    } else if (tableView == _rightTableView) {
        return 50;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"journals";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        if (tableView == _leftTableView) {
            cell.textLabel.text = _leftArray[indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        } else if (tableView == _rightTableView) {
            cell.textLabel.text = _rightArray[indexPath.row];
        }
    } else {
        if (tableView == _leftTableView) {
            cell.textLabel.text = _leftArray[indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        } else if (tableView == _rightTableView) {
            cell.textLabel.text = _rightArray[indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        NSString *key = _leftArray[indexPath.row];
        _rightArray = _infoDic[key];
        if (_rightArray) {
            [_rightTableView reloadData];
        }
    }
}

@end
