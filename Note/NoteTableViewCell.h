//
//  NoteTableViewCell.h
//  Note
//
//  Created by Admin on 11/11/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
