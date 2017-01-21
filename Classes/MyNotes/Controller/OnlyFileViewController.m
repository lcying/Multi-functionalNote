//
//  OnlyFileViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/14.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "OnlyFileViewController.h"
#import "OnlyFileView.h"
#import "FileCell.h"

@interface OnlyFileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) OnlyFileView *fileView;
@property (nonatomic) NSMutableArray *allCategorysArray;

@end

@implementation OnlyFileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self findAllNoteObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.allCategorysArray = [NSMutableArray array];
    
    self.fileView = [[OnlyFileView alloc] init];
    [self.view addSubview:self.fileView];
    [self.fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    if (self.fileModel) {
        self.fileView.headView.titleLabel.text = self.fileModel.filename;
    }else{
        self.fileView.headView.titleLabel.text = @"全部文件";
    }
    
    if (!self.fileModel) {
        self.fileView.changeButton.userInteractionEnabled = NO;
        [self.fileView.changeButton setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];
    }else{
        self.fileView.changeButton.userInteractionEnabled = YES;
    }
    
    self.fileView.fileTableView.delegate = self;
    self.fileView.fileTableView.dataSource = self;
    
    [self.fileView.fileTableView registerClass:[FileCell class] forCellReuseIdentifier:@"FileCell"];
    
    __block __weak OnlyFileViewController *weakself = self;
    
    [self.fileView.headView setFileHeadCallBack:^(id obj) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:@"请输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *filename = ac.textFields.firstObject.text;
            if ([filename isEqualToString:@""]) {
                [Utils toastview:@"请输入文件名"];
                return ;
            }
            BmobObject *object = [BmobObject objectWithClassName:@"Category"];
            [object setObject:filename forKey:@"filename"];
            [object setObject:weakself.fileModel.currentObject forKey:@"Category"];//设置父分类
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:@"NO" forKey:@"readOpen"];
            
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Utils toastview:@"创建成功！"];
                    [weakself findAllNoteObjects];
                    
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
    
    [self.fileView.changeButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableView Delegate ----------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCategorysArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //文件夹
    FileCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
    if (fileCell == nil) {
        fileCell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FileCell"];
    }
    FileModel *model = self.allCategorysArray[indexPath.row];
    fileCell.fileModel = model;
    return fileCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //文件夹
    FileModel *model = self.allCategorysArray[indexPath.row];
    
    OnlyFileViewController *vc = [[OnlyFileViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.currentNoteModel = self.currentNoteModel;
    vc.fileModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Method ------------------------------

- (void)findAllNoteObjects{//一次性得到所有分类
    BmobQuery *fileQuery = [BmobQuery queryWithClassName:@"Category"];
    [fileQuery orderByDescending:@"createdAt"];
    [fileQuery whereKey:@"User" equalTo:[BmobUser currentUser]];
    if (self.fileModel) {
        [fileQuery whereKey:@"Category" equalTo:self.fileModel.currentObject];
    }else{
        [fileQuery whereKeyDoesNotExist:@"Category"];
    }
    [fileQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            self.allCategorysArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                FileModel *fileModel = [[FileModel alloc] init];
                fileModel.currentObject = obj;
                [self.allCategorysArray addObject:fileModel];
            }
            [self.fileView.fileTableView reloadData];
        }
    }];
}

- (void)changeAction{
    //确定移动
    
    BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.objectId];
    [object setObject:self.fileModel.currentObject forKey:@"Category"];
    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            [Utils toastview:@"移动成功！"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}

@end
