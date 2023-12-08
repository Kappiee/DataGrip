--查询当前用户时否有db_owner权限
SELECT IS_ROLEMEMBER('db_owner');

--给予最小权限原则
-- 创建新用户
CREATE Login ApiUser WITH PASSWORD = 'blogDB.0@';
--映射到MyBlogDB数据库
CREATE USER ApiUser FOR LOGIN ApiUser;
--设置默认数据库--不是必要
--alter login ApiUser with default_database = MyBlogDB

-- 授予读取权限
--GRANT SELECT TO ApiUser;
GRANT SELECT ON DATABASE::MyBlogDB TO ApiUser;
-- 如果需要，授予写入权限
GRANT INSERT, UPDATE ON DATABASE::MyBlogDB TO ApiUser;
-- 授予删除权限
GRANT DELETE ON DATABASE::MyBlogDB TO ApiUser;
