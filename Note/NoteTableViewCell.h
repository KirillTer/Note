//
//  NoteTableViewCell.h
//  Note
//
//  Created by Admin on 1/26/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
