//
//  ViewController.m
//  Multiply
//
//  Created by Hendrik Schalekamp on 2015/08/18.
//  Copyright (c) 2015 Polymorph Systems. All rights reserved.
//

#import "ViewController.h"
#import "Calculation.h"

#define NUMBER_OF_ROWS 12

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property UITableView* tableView;
@property UITableViewController* tableVC;
@property CGSize kbSize;
@property NSMutableDictionary *history;
@property NSMutableArray *data;
@property UIButton *button;

@end

@implementation ViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 30.0, self.view.frame.size.width, self.view.frame.size.height - 30.0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableVC setTableView:_tableView];
    
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    [titleLabel setText:@"Welcome to Multiply"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [headerView addSubview:titleLabel];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f
                                                            constant:0]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0]];
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_button setTitle:@" Start " forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor colorWithRed:1.0f green:0.34f blue:0.13f alpha:1.0f]];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    _button.tag = 0;
    [headerView addSubview:_button];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_button
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:-12.0]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_button
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    _data = [[NSMutableArray alloc] init];
    _history = [[NSMutableDictionary alloc] init];
    
    [self.view addSubview:headerView];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CalculationCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UILabel *label=[[UILabel alloc] initWithFrame:cell.contentView.frame];
    long index = (long)indexPath.row;
    Calculation *calc = (Calculation*)_data[index];
    NSString *myString =[NSString stringWithFormat:@"%i x %i = ", calc.value1, calc.value2];
    [label setText:myString];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setFrame:CGRectMake(20,10,80.0,15.0)];
    CGRect rect = CGRectMake(100.0,5.0,40.0,25.0);
    UITextField *answerTextField = [[UITextField alloc] initWithFrame:rect];
    answerTextField.delegate = self;
    if ([calc hasAnswer]) {
        [answerTextField setText:[NSString stringWithFormat:@"%i", calc.answer]];
        [answerTextField setEnabled:NO];
        if ((calc.value1*calc.value2) == calc.answer) {
            [answerTextField.layer setBorderColor:[[UIColor clearColor] CGColor]];
            [answerTextField setBorderStyle:UITextBorderStyleNone];
        } else {
            [answerTextField setBorderStyle:UITextBorderStyleLine];
            [answerTextField.layer setBorderColor:[[UIColor redColor] CGColor]];
            [answerTextField.layer setCornerRadius:0.0f];
            [answerTextField.layer setMasksToBounds:YES];
            [answerTextField.layer setBorderWidth:1.0f];
        }
    } else {
        [answerTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [answerTextField setBorderStyle:UITextBorderStyleLine];
        [answerTextField.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [answerTextField.layer setCornerRadius:0.0f];
        [answerTextField.layer setMasksToBounds:YES];
        [answerTextField.layer setBorderWidth:1.0f];
    }
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:answerTextField];
    answerTextField.tag = indexPath.row;
    
    cell.tag = indexPath.row;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    long index = textField.tag;
    Calculation *calc = (Calculation*)_data[index];
    calc.answer = [textField.text intValue];
    _data[index] = calc;
    NSIndexPath *path = [NSIndexPath indexPathForRow:(textField.tag) inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    if (textField.tag < (NUMBER_OF_ROWS-1)) {
        path = [NSIndexPath indexPathForRow:(textField.tag+1) inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
        UITextField *nextAnswer = (UITextField*)cell.contentView.subviews[1];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [nextAnswer becomeFirstResponder];
    } else {
        [_button setTitle:@" Go again " forState:UIControlStateNormal];
        [_button setEnabled:YES];
    }
    return YES;
}

- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
}

- (BOOL)inHistory:(int)multiplier {
    id obj = [_history objectForKey:@(multiplier).stringValue];
    if (obj!= NULL) {
        return true;
    }
    return false;
    
}

- (NSArray*) getRandomTable {
    NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc] init];
    for (int i=1; i <= NUMBER_OF_ROWS; i++) {
        int randomValue = (int)arc4random();
        NSString *key = @(randomValue).stringValue;
        [tempDictionary setValue:@(i) forKey:key];
    }
    
    NSArray *sortedKeys = [[tempDictionary allKeys]
                           sortedArrayWithOptions:NSSortStable
                           usingComparator:^NSComparisonResult(id obj1, id obj2) {
        int v1 = [(NSString*)obj1 intValue];
        int v2 = [(NSString*)obj2 intValue];
        if (v1 < v2) {
            return NSOrderedAscending;
        } else if (v2 < v1) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    NSMutableArray *table=[[NSMutableArray alloc] init];
    for (int i=1; i <= NUMBER_OF_ROWS; i++) {
        NSString *num = sortedKeys[i-1];
        [table addObject:[tempDictionary valueForKey:num]];
    }
    return table;
}

- (NSArray *)sortKeysByIntValue:(NSDictionary *)dictionary {
    
    NSArray *sortedKeys = [dictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int v1 = [obj1 intValue];
        int v2 = [obj2 intValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    return sortedKeys;
}

- (void)buttonTouchUpInside:(UIControl*)sender {
    [_button setEnabled:NO];
    [_data removeAllObjects];
    if ([_history count] >= 12) {
        _history = [[NSMutableDictionary alloc] init];
    }
    int multiplier = arc4random_uniform(12) + 1;
    while ([self inHistory:multiplier]) {
        multiplier = arc4random_uniform(12) + 1;
    }
    [_history setValue:@(true) forKey:@(multiplier).stringValue];
    for (id item in [self getRandomTable]) {
        NSNumber *i = item;
        Calculation *calc = [[Calculation alloc] init];
        calc.value1 = multiplier;
        calc.value2 = i.intValue;
        [_data addObject:calc];
        
    }
    [_tableView reloadData];
    

}
@end
