//
//  Calculation.m
//  Multiply
//
//  Created by Hendrik Schalekamp on 2015/08/21.
//  Copyright (c) 2015 Polymorph Systems. All rights reserved.
//

#import "Calculation.h"

@interface Calculation ()
@property (nonatomic)  BOOL hasAnswer;

@end

@implementation Calculation

- (Calculation*)init {
    self = [super init];
    if (self != nil) {
        _hasAnswer = NO;
    }
    return self;
}

- (BOOL)isCorrect {
    return ((_value1*_value2) == _answer);
}

- (BOOL) hasAnswer {
    return _hasAnswer;
}

- (void) setAnswer:(int)answer {
    _hasAnswer = YES;
    _answer = answer;
}

@end
