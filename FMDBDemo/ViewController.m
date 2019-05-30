//
//  ViewController.m
//  FMDBDemo
//
//  Created by zw on 2019/5/16.
//  Copyright © 2019 zw. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
@interface ViewController ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导入sqlite框架，导入FMDB文件夹
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileName = %@",fileName);
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        NSLog(@"ok");
        
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    }
    self.db=db;
    
    //插入数据
    [self insertStu];
    [self deleteStu:6];
    [self updateStu:@"1apple6_name" :@"7777"];
    
    [self queryStu];
    [self dropStu];
    [self insertStu];
    [self queryStu];
    
    //6.关闭数据库
    [self.db close];
    
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark 插入数据
-(void)insertStu
{
    for (int i=0; i<10; i++)
    {
        NSString *name = [NSString stringWithFormat:@"1apple%i_name",i];
        int age = arc4random()%3+20;
        
        //1.  executeUpdate : 不确定的参数用?来占位 (后面参数必须都是oc对象)
        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?,?);",name,@(age)];
        
        //2.  executeUpdateWithFormat : 不确定的参数用%@、%d等来占位 （参数为原始数据类型）
//                [self.db executeUpdateWithFormat:@"insert into t_student (name, age) values (%@, %i);",name,age];
        
        //3. 数组
        //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?,?);" withArgumentsInArray:@[name,@(age)]];
    }
    
}
#pragma mark 删除数据
-(void)deleteStu:(int)idNum
{
    //a.  executeUpdate : 不确定的参数用?来占位 (后面参数必须都是oc对象)
        [self.db executeUpdate:@"delete from t_student where id=?;",@(idNum)];
    
    //b.  executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
    //    [self.db executeUpdateWithFormat:@"delete from t_student where name=%@;",@"apple9_name"];
}

#pragma mark 销毁表格
-(void)dropStu
{
    [self.db executeUpdate:@"drop table if exists t_student;"];
    
    //4.创表
    BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
    if (result) {
        NSLog(@"再次创表成功");
    }else{
        NSLog(@"再次创表失败");
    }
}

#pragma mark 修改数据
-(void)updateStu:(NSString *)oldName :(NSString*)newName
{
    //    [self.db executeUpdateWithFormat:@"update t_student set name=%@ where name=%@;",newName,oldName];
    [self.db executeUpdate:@"update t_student set name=? where name=?",newName,oldName];
}

#pragma mark 查询数据
-(void)queryStu
{
    //1.执行查询语句
    //    FMResultSet *resultSet = [self.db executeQuery:@"select * from t_student;"];
    FMResultSet *resultSet = [self.db executeQuery:@"select * from t_student where id<?;",@(14)];
    
    //2.遍历结果集合
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet objectForColumnName:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"id=%i ,name=%@, age=%i",idNum,name,age);
    }
    
}










@end
