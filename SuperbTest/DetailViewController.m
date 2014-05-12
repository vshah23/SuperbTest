//
//  DetailViewController.m
//  SuperbTest
//
//  Created by Vikas Shah on 3/15/14.
//  Copyright (c) 2014 Vikas Shah. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSArray *imageURLs = (NSArray *)[self.cellInfo valueForKey:@"screenshotUrls"];
    
    if (imageURLs.count > 1){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [imageURLs objectAtIndex:0]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        ((UIImageView *)[self.view viewWithTag:1]).image = image;
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [imageURLs objectAtIndex:1]]];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        ((UIImageView *)[self.view viewWithTag:2]).image = image;
    }
    UITextView *textView = ((UITextView *)[self.view viewWithTag:3]);
    UIScrollView *scrollView = ((UIScrollView *)[self.view viewWithTag:4]);
    textView.textContainerInset = UIEdgeInsetsMake(0.0, 10.0, 10.0, 5.0);
    textView.scrollEnabled = YES;
    textView.text = [self.cellInfo valueForKey:@"description"];
    [textView sizeToFit];
    textView.scrollEnabled = NO;
    [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, 10+((UIImageView *)[self.view viewWithTag:1]).frame.size.height+textView.frame.size.height)];
}

@end
