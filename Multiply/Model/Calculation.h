//
//  Calculation.h
//  Multiply
//
//  Created by Hendrik Schalekamp on 2015/08/21.
//  Copyright (c) 2015 Polymorph Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculation : NSObject 

@property int value1;
@property int value2;
@property (nonatomic, setter=setAnswer:) int answer;

- (BOOL)isCorrect;
- (BOOL)hasAnswer;

@end
