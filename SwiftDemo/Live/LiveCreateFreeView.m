//
//  LiveCreateFreeView.m
//  youxibang
//
//  Created by jiazhuo1 on 2018/4/27.
//

#import "LiveCreateFreeView.h"
#import "LiveCreateFreeTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>

static NSString *const FREETABLEVIEW_ID = @"freetableview_id";
@implementation LiveCreateFreeView

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
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)tapBlackView {
    [self dismiss];
}

- (void)configUI {
    CGFloat screen_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat screen_height = UIScreen.mainScreen.bounds.size.height;
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlackView)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    
    UIImageView *bkgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 261, 375)];
    bkgImgView.image = [UIImage imageNamed:@"live_create_bkg"];
    [self addSubview:bkgImgView];
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(261-20, -10, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"live_create_close"] forState:0];
    [closeBtn addTarget:self action:@selector(closeSelector) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 30)];
    titleLabel.text = @"是否收费照片?";
    titleLabel.textColor = [UIColor colorFromHexString:@"457fea"];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:titleLabel];
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.backgroundColor = UIColor.clearColor;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    tableview.rowHeight = 55;
    [tableview registerNib:[UINib nibWithNibName:@"LiveCreateFreeTableViewCell" bundle:nil] forCellReuseIdentifier:FREETABLEVIEW_ID];
    [self addSubview:tableview];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:@"上传照片" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(closeSelector) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor colorFromHexString:@"4481e9"];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    btn.layer.borderColor = [UIColor colorFromHexString:@"2d56a2"].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 19;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(uploadSelector) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(186, 38));
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
    }];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.mas_top).offset(85);
        make.bottom.mas_equalTo(btn.mas_bottom).offset(-30);
    }];
}

- (void)show {
    self.selectedIndex = 0;
    [self configUI];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.blackView.alpha = 0.5;
            self.alpha = 1;
        }completion:^(BOOL finished) {
            self.blackView.hidden = NO;
        }];
    });
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.blackView.alpha = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.blackView.hidden = YES;
            [self removeFromSuperview];
            [self.blackView removeFromSuperview];
        }];
    });
}


- (void)closeSelector {
    [self dismiss];
}

- (void)uploadSelector {
    [self dismiss];
    if (self.confirmSelecrBlock) {
        self.confirmSelecrBlock([NSString stringWithFormat:@"%ld元",(long)_selectedIndex]);
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArray = @[@"免费",@"收费1元",@"收费2元",@"收费3元"];
    LiveCreateFreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FREETABLEVIEW_ID];
    cell.freeLabel.text = titleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.descLabel.text = @"他人无需支付即可查看照片";
    }
    else {
        cell.descLabel.text = @"他人必须向你支付才能查看照片";
    }
    if (self.selectedIndex == indexPath.row) {
        cell.leftImgView.image = [UIImage imageNamed:@"ico_gx"];
    }
    else {
        cell.leftImgView.image = [UIImage imageNamed:@"ico_mx"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}

@end
