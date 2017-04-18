-- 创建微博数据表 --
-- 如果在程序中，没有通过 SQL 制定字段的值，就使用 default 的值替代 --

CREATE TABLE IF NOT EXISTS "T_Status" (
"statusId" INTEGER NOT NULL,
"userId" INTEGER NOT NULL,
"status" TEXT,
"createTime" TEXT DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("statusId","userId")
);
