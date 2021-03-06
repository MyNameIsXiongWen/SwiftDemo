//
//  IntelligentView.m
//  youxibang
//
//  Created by jiazhuo1 on 2018/4/23.
//

#import "IntelligentView.h"
#import <Colours/Colours.h>

@implementation IntelligentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorFromHexString:@"dddddd"].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, 135, 0.5)];
    sepLabel.backgroundColor = [UIColor colorFromHexString:@"dddddd"];
    [self addSubview:sepLabel];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 125, 14.5)];
    self.nameLabel.textColor = [UIColor colorFromHexString:@"333333"];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.nameLabel];
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 65, 15)];
    self.priceLabel.textColor = [UIColor colorFromHexString:@"457fea"];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.priceLabel];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 160, 60, 15)];
    self.timeLabel.textColor = [UIColor colorFromHexString:@"aaaaaa"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:11.0];
    [self addSubview:self.timeLabel];
    
}

@end
