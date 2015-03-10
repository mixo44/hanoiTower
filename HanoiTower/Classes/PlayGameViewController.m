//
//  PlayGameViewController.m
//  HanoiTower
//
//  Created by Misha Torosyan on 3/8/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import "PlayGameViewController.h"
#import "Defines.h"

@interface PlayGameViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UIView *mFirstColumn;
@property (strong, nonatomic) UIView *mSecondColumn;
@property (strong, nonatomic) UIView *mThirdColumn;

@property (strong, nonatomic) IBOutlet UIButton *mMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *mAutoButton;

@property (strong, nonatomic) NSMutableArray *mFirstColumnStack;
@property (strong, nonatomic) NSMutableArray *mSecondColumnStack;
@property (strong, nonatomic) NSMutableArray *mThirdColumnStack;

@property (strong, nonatomic) UIView *mDraggingView;
@property (assign, nonatomic) CGPoint mTouchOffset;
@property (assign, nonatomic) CGPoint mLastPoint;

@property (strong, nonatomic) NSMutableSet *mFiexedViewsSet;

@property (assign, nonatomic) BOOL isGameFinished;

@property (assign, nonatomic) NSUInteger mCountOfRings;

@property (assign, nonatomic) NSInteger mMovesCount;

@property (strong, nonatomic) UIAlertView *mGameResultAlertView;

@end

@implementation PlayGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _mCountOfRings = [[[NSUserDefaults standardUserDefaults]
                       valueForKey:kCountOfRings] integerValue];
    
    _mFirstColumnStack = [[NSMutableArray alloc] init];
    _mSecondColumnStack = [[NSMutableArray alloc] init];
    _mThirdColumnStack = [[NSMutableArray alloc] init];
    
    _isGameFinished = NO;
    
    
    _mMovesCount = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self drawColumns];
    
    [_mMenuButton.layer setCornerRadius:_mMenuButton.frame.size.height/2];
    _mMenuButton.alpha = 0;
    [UIView animateWithDuration:1.2 animations:^{
        _mMenuButton.alpha = 1;
    }];
    
}

#pragma mark - Draw Columns

- (void) drawColumns {
    
    UIView *firstColumnBottomView = [[UIView alloc] init];
    firstColumnBottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *secondColumnBottomView = [[UIView alloc] init];
    secondColumnBottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *thirdColumnBottomView = [[UIView alloc] init];
    thirdColumnBottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _mFirstColumn = [[UIView alloc] init];
    _mFirstColumn.translatesAutoresizingMaskIntoConstraints = NO;
    
    _mSecondColumn = [[UIView alloc] init];
    _mSecondColumn.translatesAutoresizingMaskIntoConstraints = NO;
    
    _mThirdColumn = [[UIView alloc] init];
    _mThirdColumn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    [_mFirstColumn setBackgroundColor:[UIColor cyanColor]];
    [_mSecondColumn setBackgroundColor:[UIColor cyanColor]];
    [_mThirdColumn setBackgroundColor:[UIColor cyanColor]];
    
    [_mFirstColumn.layer setBorderWidth:1.f];
    [_mSecondColumn.layer setBorderWidth:1.f];
    [_mThirdColumn.layer setBorderWidth:1.f];
    
    [_mFirstColumn.layer setBorderColor:[UIColor grayColor].CGColor];
    [_mSecondColumn.layer setBorderColor:[UIColor grayColor].CGColor];
    [_mThirdColumn.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [_mFirstColumn.layer setCornerRadius:3.f];
    [_mSecondColumn.layer setCornerRadius:3.f];
    [_mThirdColumn.layer setCornerRadius:3.f];
    
    
    
    [firstColumnBottomView setBackgroundColor:[UIColor grayColor]];
    [secondColumnBottomView setBackgroundColor:[UIColor grayColor]];
    [thirdColumnBottomView setBackgroundColor:[UIColor grayColor]];
    
    [firstColumnBottomView.layer setBorderWidth:1.f];
    [secondColumnBottomView.layer setBorderWidth:1.f];
    [thirdColumnBottomView.layer setBorderWidth:1.f];
    
    [firstColumnBottomView.layer setBorderColor:[UIColor blackColor].CGColor];
    [secondColumnBottomView.layer setBorderColor:[UIColor blackColor].CGColor];
    [thirdColumnBottomView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    [firstColumnBottomView.layer setCornerRadius:3.f];
    [secondColumnBottomView.layer setCornerRadius:3.f];
    [thirdColumnBottomView.layer setCornerRadius:3.f];
    
    
    
    [self.view addSubview:_mFirstColumn];
    [self.view addSubview:_mSecondColumn];
    [self.view addSubview:_mThirdColumn];
    
    [self.view addSubview:firstColumnBottomView];
    [self.view addSubview:secondColumnBottomView];
    [self.view addSubview:thirdColumnBottomView];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_mSecondColumn
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    
    
    [self addConstraintsToColumn:_mFirstColumn];
    [self addConstraintsToColumn:_mSecondColumn];
    [self addConstraintsToColumn:_mThirdColumn];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:
                               @"H:[_mFirstColumn(==columnWidth)]-(cottomColumnSpace)-"
                               "[_mSecondColumn(==columnWidth)]-(cottomColumnSpace)-"
                               "[_mThirdColumn(==columnWidth)]"
                               options:0
                               metrics:@{@"columnWidth" : @columnsWidth,
                                         @"cottomColumnSpace" : @columnsSpace}
                               views:NSDictionaryOfVariableBindings(_mFirstColumn,
                                                                    _mSecondColumn,
                                                                    _mThirdColumn)]];
    
    
    [self addContstraintsWhith:_mFirstColumn bottomView:firstColumnBottomView];
    [self addContstraintsWhith:_mSecondColumn bottomView:secondColumnBottomView];
    [self addContstraintsWhith:_mThirdColumn bottomView:thirdColumnBottomView];
    
    [_mFirstColumnStack addObject:firstColumnBottomView];
    [_mSecondColumnStack addObject:secondColumnBottomView];
    [_mThirdColumnStack addObject:thirdColumnBottomView];
    
    
    [self createRings];
    
    
}


#pragma mark - Constraints
- (void) addContstraintsWhith:(UIView *)theView bottomView:(UIView *)bottomView {
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[bottomView(==columnWidth)]"
                               options:0
                               metrics:@{@"columnWidth" : @bottomColumnsWidth}
                               views:NSDictionaryOfVariableBindings(bottomView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[bottomView(==columnHeight)]"
                               options:0
                               metrics:@{@"columnHeight" : @bottomColumnsHeight}
                               views:NSDictionaryOfVariableBindings(bottomView)]];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:bottomView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:theView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:bottomView
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:theView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
}


- (void) addConstraintsToColumn:(UIView *)columnView {
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:
                               @"V:|-(columnTopSpace)-"
                               "[columnView(==columnHeight)]"
                               options:0
                               metrics:@{@"columnHeight" : @columnsHeight,
                                         @"columnTopSpace" : @columnsTopSpace}
                               views:NSDictionaryOfVariableBindings(columnView)]];
}


#pragma mark - Buttons

- (IBAction)menuButtonHandler:(UIButton *)sender {
    
    /*[self removeConstraintsFromDraggingView];
    
    [self.view removeConstraints: [_mDraggingView constraints]];
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:[_mDraggingView(==height)]-(0)-[last]" options: 0 metrics: @{@"height":@(ringsHeight)} views: @{@"last":[_mSecondColumnStack objectAtIndex: 0],@"_mDraggingView":_mDraggingView}]];

    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem: [_mSecondColumnStack objectAtIndex: 0]
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:_mDraggingView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0f
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem: [_mSecondColumnStack lastObject]
                              attribute: NSLayoutAttributeCenterX
                              relatedBy: NSLayoutRelationEqual
                              toItem:_mDraggingView
                              attribute: NSLayoutAttributeCenterX
                              multiplier: 1.0f
                              constant: 0.0f]];*/
    
    [UIView animateWithDuration:0.3 animations:^{
        _mMenuButton.alpha = 0;
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)autoButtonHandler:(UIButton *)sender {
    
    NSLog(@"%lu", (unsigned long)_mCountOfRings);
    
    [self automaticChangingSteps:_mCountOfRings
                     firstColumn:0
                    secondColumn:2
                     thirdColumn:1];
}


#pragma mark - Rings Logic

- (void) createRings {
    
    NSUInteger countOfRings = _mCountOfRings;
    
    NSUInteger ringWidth = minRingsWidth + (countOfRings - 1) * 10;
    
    for (int i = 0; i < countOfRings; ++i) {
        
        UIView *ringView = [[UIView alloc] init];
        [ringView setBackgroundColor:[UIColor colorWithRed:0.98 green:0.643 blue:0.353 alpha:1]];
        [ringView.layer setBorderWidth:1.f];
        [ringView.layer setCornerRadius:10.f];
        [ringView.layer setBorderColor:[UIColor blackColor].CGColor];
        ringView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:ringView];
        
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:[ringView(==ringHeight)]"
                                   options:0
                                   metrics:@{@"ringHeight" : @ringsHeight}
                                   views:NSDictionaryOfVariableBindings(ringView)]];
        
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:[ringView(==ringWidth)]"
                                   options:0
                                   metrics:@{@"ringWidth" : @(ringWidth -= 10)}
                                   views:NSDictionaryOfVariableBindings(ringView)]];
        
        
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:_mFirstColumn
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:ringView
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1
                                  constant:0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:_mFirstColumnStack[i]
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:ringView
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.f
                                  constant:0]];
        
        
        
        [_mFirstColumnStack addObject:ringView];
        
    }
}


- (void) removeConstraintsFromDraggingView {
    
    NSMutableArray *checkingViews = [[NSMutableArray alloc] init];
    
    if (_mFirstColumnStack.count > 1) {
        [checkingViews addObject:_mFirstColumnStack];
    }
    
    if (_mSecondColumnStack.count > 1) {
        [checkingViews addObject:_mSecondColumnStack];
    }
    
    if (_mThirdColumnStack.count > 1) {
        [checkingViews addObject:_mThirdColumnStack];
    }
    
    
    [self.view.constraints enumerateObjectsUsingBlock:^(id obj,
                                                        NSUInteger idx,
                                                        BOOL *stop) {
        
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        
        if (constraint.secondItem == _mDraggingView &&
            (constraint.firstItem == _mFirstColumn ||
             constraint.firstItem == _mSecondColumn ||
             constraint.firstItem == _mThirdColumn)) {
                [self.view removeConstraint:constraint];
            }
        
        
        [checkingViews enumerateObjectsUsingBlock:^(id obj,
                                                    NSUInteger idx,
                                                    BOOL *stop) {
            
            NSMutableArray *array = (NSMutableArray *)obj;
            
            if (constraint.secondItem == _mDraggingView &&
                constraint.firstItem  == array[array.count - 2]) {
                [self.view removeConstraint:constraint];
            }
        }];
        
        
    }];
}


- (void) moveRingToColumn:(UIView *)column toStack:(NSMutableArray *)movingArray {
    
    ++_mMovesCount;
    [self removeConstraintsFromDraggingView];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:[movingArray lastObject]
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:_mDraggingView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0f
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:column
                              attribute: NSLayoutAttributeCenterX
                              relatedBy: NSLayoutRelationEqual
                              toItem:_mDraggingView
                              attribute: NSLayoutAttributeCenterX
                              multiplier: 1.0f
                              constant: 0.0f]];
    
    
    if ([_mFirstColumnStack containsObject:_mDraggingView]) {
        
        [_mFirstColumnStack removeObject:_mDraggingView];
        
    } else if ([_mSecondColumnStack containsObject:_mDraggingView]) {
        
        [_mSecondColumnStack removeObject:_mDraggingView];
        
    } else if ([_mThirdColumnStack containsObject:_mDraggingView]) {
        
        [_mThirdColumnStack removeObject:_mDraggingView];
        
    }
    
    [movingArray addObject:_mDraggingView];
    
}


- (BOOL) checkMovingRings:(NSMutableArray *)moveToStack {
    
    if (((UIView *)(moveToStack.lastObject)).frame.size.width >
        _mDraggingView.frame.size.width ||
        moveToStack.count == 1) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}


- (void) rectIntersect:(CGRect) rect {
    
    if ([self checkMovingRings:_mFirstColumnStack] &&
        ((CGRectIntersectsRect(rect, _mFirstColumn.frame) &&
          ![_mFirstColumnStack containsObject:_mDraggingView]))) {
        
        [self moveRingToColumn:_mFirstColumn toStack:_mFirstColumnStack];
        
    } else if ([self checkMovingRings:_mSecondColumnStack] &&
               ((CGRectIntersectsRect(rect, _mSecondColumn.frame) &&
                 ![_mSecondColumnStack containsObject:_mDraggingView]))) {
        
        [self moveRingToColumn:_mSecondColumn toStack:_mSecondColumnStack];
        
    } else if ([self checkMovingRings:_mThirdColumnStack] &&
               ((CGRectIntersectsRect(rect, _mThirdColumn.frame) &&
                 ![_mThirdColumnStack containsObject:_mDraggingView]))) {
        
        [self moveRingToColumn:_mThirdColumn toStack:_mThirdColumnStack];
        
    } else {
        
        CGPoint correctionWithCenter = CGPointMake(_mLastPoint.x + _mTouchOffset.x,
                                                   _mLastPoint.y + _mTouchOffset.y);
        
        _mDraggingView.center = correctionWithCenter;
        
    }
}



#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint pointOnMainVew = [touch locationInView:self.view];
    
    UIView *touchedPlaceView = [self.view hitTest:pointOnMainVew withEvent:event];
    
    
    
    _mFiexedViewsSet = [NSMutableSet setWithObjects:
                        self.view,
                        _mFirstColumn,
                        _mSecondColumn,
                        _mThirdColumn,
                        _mFirstColumnStack[0],
                        _mSecondColumnStack[0],
                        _mThirdColumnStack[0],
                        _mMenuButton,
                        nil];
    
    if (_mFirstColumnStack.count > 1) {
        for (int i = 0; i < _mFirstColumnStack.count - 1; ++i) {
            [_mFiexedViewsSet addObject:_mFirstColumnStack[i]];
        }
    }
    
    if (_mSecondColumnStack.count > 1) {
        for (int i = 0; i < _mSecondColumnStack.count - 1; ++i) {
            [_mFiexedViewsSet addObject:_mSecondColumnStack[i]];
        }
    }
    
    if (_mThirdColumnStack.count > 1) {
        for (int i = 0; i < _mThirdColumnStack.count - 1; ++i) {
            [_mFiexedViewsSet addObject:_mThirdColumnStack[i]];
        }
    }
    
    
    
    if (![_mFiexedViewsSet containsObject:touchedPlaceView]) {
        
        _mDraggingView = touchedPlaceView;
        
        [self.view bringSubviewToFront:_mDraggingView];
        
        CGPoint touchPoint = [touch locationInView:_mDraggingView];
        
        _mTouchOffset = CGPointMake(CGRectGetMidX(_mDraggingView.bounds) - touchPoint.x,
                                    CGRectGetMidY(_mDraggingView.bounds) - touchPoint.y);
        
        _mLastPoint = pointOnMainVew;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _mDraggingView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                             _mDraggingView.alpha = 0.5f;
                         }];
        
    } else {
        
        _mDraggingView = nil;
        
    }
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self ringsTouchEnded];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self ringsTouchEnded];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mDraggingView) {
        
        UITouch *touch = [touches anyObject];
        
        CGPoint draggedPointOnMainVew = [touch locationInView:self.view];
        
        CGPoint correctionWithCenter = CGPointMake(draggedPointOnMainVew.x + _mTouchOffset.x,
                                                   draggedPointOnMainVew.y + _mTouchOffset.y);
        
        _mDraggingView.center = correctionWithCenter;
        
    }
}


- (void) ringsTouchEnded {
    [self rectIntersect:_mDraggingView.frame];
    
    [UIView animateWithDuration:0.3f animations:^{
        _mDraggingView.transform = CGAffineTransformIdentity;
        _mDraggingView.alpha = 1.f;
    }];
    
    if (_mThirdColumnStack.count - 1 == _mCountOfRings) {
        
        _mGameResultAlertView = [[UIAlertView alloc]
                                 initWithTitle:@"The End"
                                 message:[NSString
                                          stringWithFormat:@"Congratulations!\n"
                                          "You just won the game by %lu moves.\n"
                                          "Minimum number of moves is: %d.",
                                          (long)_mMovesCount, (int)pow(2, _mCountOfRings) - 1]
                                 delegate:self.view
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        _mGameResultAlertView.delegate = self;
        
        [_mGameResultAlertView show];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Recursion

- (void) automaticChangingSteps:(NSUInteger)countOfRings
                    firstColumn:(NSUInteger)firstColumn
                   secondColumn:(NSUInteger)secondColumn
                    thirdColumn:(NSUInteger)thirdColumn {
    
    if (countOfRings > 0) {
        [self automaticChangingSteps:countOfRings - 1
                         firstColumn:firstColumn
                        secondColumn:thirdColumn
                         thirdColumn:secondColumn];
        
        NSLog(@"\n%lu -> %lu", (unsigned long)firstColumn, (unsigned long)secondColumn);
        
        
        [self automaticChangingSteps:countOfRings - 1
                         firstColumn:thirdColumn
                        secondColumn:secondColumn
                         thirdColumn:firstColumn];
    }
}

@end
