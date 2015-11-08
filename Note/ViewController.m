//
//  ViewController.m
//  Note
//
//  Created by Admin on 11/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DBManager.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Styles for textView
    [self.navigationItem setTitle:@"New Note"];
    self.noteTextView.layer.borderWidth = 2.0f;
    self.noteTextView.layer.borderColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor];
    self.noteTextView.layer.cornerRadius = 15;
    
    if (![self isNewNote]) {
        [self createNote];
    }

    self.noteTextView.text = self.note.text;
    
    //set date to label
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd MMM yyyy, hh:mm"];
    self.dateLabel.text = [DateFormatter stringFromDate:self.note.time];
    
    if ([self isPhotoExist]) {
        self.imageView.image = [UIImage imageWithData:self.note.photo.photoData];
    }
    
}

- (BOOL)isNewNote
{
    return self.note != nil;
}

- (BOOL)isPhotoExist
{
    return self.note.photo != nil;
}

//ave button
- (IBAction)save:(id)sender{
    if (![self.noteTextView.text length]) {       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please input some text" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        self.note.text = self.noteTextView.text;
        [[DBManager sharedInstance] saveContext];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
- (IBAction)cancel:(id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)createNote
{
    Note *newNote = (Note *)[[DBManager sharedInstance] createEntityName:@"Note"];
    newNote.time = [NSDate date];
    self.note = newNote;
}

//Methods for PickerController
- (IBAction)photoButton:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    if (![self isPhotoExist]) {
        Photo *newPhoto = (Photo *)[[DBManager sharedInstance] createEntityName:@"Photo"];
        self.note.photo = newPhoto;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    self.note.photo.photoData = imageData;
    NSString *imageURL = info[UIImagePickerControllerMediaURL];
    self.note.photo.photoName = [imageURL lastPathComponent];
    self.note.photo.photoNumber = @(arc4random() % 10);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
