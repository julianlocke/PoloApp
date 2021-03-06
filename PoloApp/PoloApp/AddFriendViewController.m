//
//  AddFriendViewController.m
//  PoloApp
//
//  Created by Matt Brenman on 2/2/14.
//  Copyright (c) 2014 mbrenman. All rights reserved.
//

#import "AddFriendViewController.h"
#import <Parse/Parse.h>

@interface AddFriendViewController ()
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation AddFriendViewController

//this lets hide keyboard when a touch is outside the text area
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_friendNameField isFirstResponder])// && [touch view] != (_friendNameField))
    {
        [_friendNameField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//- (IBAction)AddFriendClick:(id)sender {
//    NSLog(@"So friends. Much wow");
//}
- (IBAction)AddButtonClick:(id)sender {

    
    NSString *newFriend = [_friendNameField text];
    [self AddFriendIfExistsinDB:newFriend];
}

- (void)AddFriendIfExistsinDB: (NSString *)newFriend
{
    //TODO: can we make this faster?
    
    PFQuery *query= [PFUser query];
    [query whereKey:@"username" equalTo: newFriend];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil){
            [self addFriendToFriends:newFriend];
        } else {
            NSLog(@"NOPE New Frand");
            [_alert show];
        }
    }];
}
     
- (void)addFriendToFriends: (NSString *)newFriend
{
    PFUser *me = [PFUser currentUser];
    _friends = me[@"friends"];
    if (_friends == nil){
        NSLog(@"ha ha. no friends for you. geek.");
        me[@"friends"] = [[NSMutableArray alloc] initWithObjects:newFriend, nil];
    } else {
        //TODO: Check if friend exists as a user in the app
        
        //Only add new friend if user does not already have the friend
        if (![_friends containsObject:newFriend]){
            [_friends addObject:newFriend];
            //NSLog(@"New Frand");
        }
    }
    
    [me saveInBackground];
    [self performSegueWithIdentifier:@"FriendAdded" sender:nil];
}
        
- (void)viewDidLoad
{
    [super viewDidLoad];
        //now we will populate an alert for use if the user tries to add a nonexistent friend
        _alert = [[UIAlertView alloc]
        initWithTitle:@"Error"
        message:@"No such user exists"
        delegate:self
        cancelButtonTitle:@"Dismiss"
        otherButtonTitles:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
