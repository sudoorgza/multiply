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
@property NSMutableArray *data;

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
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0)];
    [titleLabel setText:@"Welcome to Multiply"];
    _data = [[NSMutableArray alloc] init];
    for (int i=1; i <= NUMBER_OF_ROWS; i++) {
        Calculation *calc = [[Calculation alloc] init];
        calc.value1 = 12;
        calc.value2 = i;
        [_data addObject:calc];
    }
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UILabel *label=[[UILabel alloc] initWithFrame:cell.contentView.frame];
    Calculation *calc = (Calculation*)_data[(long)indexPath.row];
    NSString *myString =[NSString stringWithFormat:@"%i x %i", calc.value1, calc.value2];
    [label setText:myString];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setFrame:CGRectMake(20,10,50.0,15.0)];
    UITextField *answer = [[UITextField alloc] initWithFrame:CGRectMake(70.0,5.0,40.0,25.0)];
    [answer setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    if ([calc hasAnswer]) {
        [answer setText:[NSString stringWithFormat:@"%i", calc.answer]];
    }
    answer.delegate = self;
    //[answer reloadInputViews];
    [answer setBackgroundColor:[UIColor lightGrayColor]];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:answer];
    cell.tag = indexPath.row;
    answer.tag = indexPath.row;
    //[cell addSubview:label];
    //[label setFrame:CGRectMake(10.0, 10.0, 10.0, 10.0)];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < (NUMBER_OF_ROWS-1)) {
        long index = (long)[NSIndexPath indexPathForRow:(textField.tag) inSection:0];
        Calculation *calc = (Calculation*)_data[index];
        calc.answer = [textField.text intValue];
        _data[index] = calc;
        NSIndexPath *path = [NSIndexPath indexPathForRow:(textField.tag+1) inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
        UITextField *answer = (UITextField*)cell.contentView.subviews[1];
        [answer becomeFirstResponder];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag < (NUMBER_OF_ROWS-1)) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:(textField.tag+1) inSection:0];
        
    }
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

@end
