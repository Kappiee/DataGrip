-- 创建 Posts 表
CREATE TABLE Posts (
    PostID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME NOT NULL,
    ModifiedDate DATETIME,
    CategoryID INT,
    IsPublished BIT NOT NULL
);

-- 创建 Categories 表
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(1000)
);

-- 创建 Tags 表
CREATE TABLE Tags (
    TagID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) UNIQUE NOT NULL
);

-- 创建 PostTags 关联表
CREATE TABLE PostTags (
    PostID INT NOT NULL,
    TagID INT NOT NULL,
    CONSTRAINT PK_PostTags PRIMARY KEY (PostID, TagID),
    CONSTRAINT FK_PostTags_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    CONSTRAINT FK_PostTags_Tags FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

-- 创建 Files 表
CREATE TABLE Files (
    FileID INT PRIMARY KEY IDENTITY,
    PostID INT,
    FilePath NVARCHAR(500) NOT NULL,
    FileType NVARCHAR(50),
    UploadDate DATETIME NOT NULL,
    CONSTRAINT FK_Files_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);

-- 创建 PostViews 表
CREATE TABLE PostViews (
    ViewID INT PRIMARY KEY IDENTITY,
    PostID INT NOT NULL,
    ViewDate DATETIME NOT NULL,
    IPAddress NVARCHAR(50),
    CONSTRAINT FK_PostViews_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);
