USE [net.score_manage]
GO
/****** Object:  Table [dbo].[class]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class](
	[classid] [varchar](15) NOT NULL,
	[name] [varchar](10) NOT NULL,
	[createTime] [datetime] NULL,
 CONSTRAINT [PK_class] PRIMARY KEY CLUSTERED 
(
	[classid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_class_name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[student]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student](
	[sid] [varchar](15) NOT NULL,
	[password] [varchar](10) NOT NULL,
	[createTime] [datetime] NULL,
	[gender] [char](3) NOT NULL,
	[birth] [date] NULL,
	[name] [varchar](10) NOT NULL,
	[classid] [varchar](15) NOT NULL,
 CONSTRAINT [PK_student] PRIMARY KEY CLUSTERED 
(
	[sid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subject]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subject](
	[subid] [varchar](15) NOT NULL,
	[name] [varchar](10) NOT NULL,
	[createTime] [datetime] NULL,
	[total] [int] NOT NULL,
 CONSTRAINT [PK_subject] PRIMARY KEY CLUSTERED 
(
	[subid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_subject_name] UNIQUE NONCLUSTERED 
(
	[subid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[score]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[score](
	[scoreid] [varchar](15) NOT NULL,
	[sid] [varchar](15) NOT NULL,
	[subid] [varchar](15) NOT NULL,
	[grade] [decimal](3, 1) NOT NULL,
	[createTime] [datetime] NULL,
 CONSTRAINT [PK_score] PRIMARY KEY CLUSTERED 
(
	[scoreid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_score_sid_subid] UNIQUE NONCLUSTERED 
(
	[subid] ASC,
	[sid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[score_detail]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[score_detail]
AS
SELECT   dbo.score.grade, dbo.subject.total, dbo.student.name, dbo.student.gender, dbo.student.birth, dbo.class.name AS class, 
                dbo.subject.name AS subject, dbo.class.classid, dbo.score.subid, dbo.score.sid, dbo.score.scoreid
FROM      dbo.score INNER JOIN
                dbo.student ON dbo.score.sid = dbo.student.sid INNER JOIN
                dbo.subject ON dbo.score.subid = dbo.subject.subid INNER JOIN
                dbo.class ON dbo.student.classid = dbo.class.classid
GO
/****** Object:  View [dbo].[class_and_subject_statistics]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[class_and_subject_statistics]
AS
SELECT   AVG(dbo.score.grade) AS average, MAX(dbo.score.grade) AS max, MIN(dbo.score.grade) AS min,
                    (SELECT   COUNT(*) AS Expr1
                     FROM      dbo.student
                     WHERE   (classid = dbo.class.classid)) AS classCount, COUNT(*) AS testCount,
                    (SELECT   COUNT(*) AS Expr1
                     FROM      dbo.score_detail
                     WHERE   (grade >= total * 0.6) AND (classid = dbo.class.classid) AND (subid = dbo.score.subid)) AS passCount,
                    (SELECT   COUNT(*) AS Expr1
                     FROM      dbo.score_detail AS score_detail_1
                     WHERE   (grade >= total * 0.8) AND (classid = dbo.class.classid) AND (subid = dbo.score.subid)) AS goodCount, 
                dbo.score.subid, dbo.class.classid
FROM      dbo.score INNER JOIN
                dbo.student AS student_1 ON dbo.score.sid = student_1.sid INNER JOIN
                dbo.subject ON dbo.score.subid = dbo.subject.subid INNER JOIN
                dbo.class ON student_1.classid = dbo.class.classid
GROUP BY dbo.score.subid, dbo.class.classid
GO
/****** Object:  Table [dbo].[admin]    Script Date: 2022/6/12 16:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin](
	[mid] [varchar](15) NOT NULL,
	[password] [varchar](10) NOT NULL,
	[createTime] [datetime] NULL,
 CONSTRAINT [PK_admin] PRIMARY KEY CLUSTERED 
(
	[mid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[admin] ADD  CONSTRAINT [DF_admin_password]  DEFAULT ('root') FOR [password]
GO
ALTER TABLE [dbo].[student] ADD  CONSTRAINT [DF_student_password]  DEFAULT ('qwqe') FOR [password]
GO
ALTER TABLE [dbo].[student] ADD  CONSTRAINT [DF_student_gender]  DEFAULT ('男') FOR [gender]
GO
ALTER TABLE [dbo].[subject] ADD  CONSTRAINT [DF_subject_total]  DEFAULT ((100)) FOR [total]
GO
ALTER TABLE [dbo].[score]  WITH CHECK ADD  CONSTRAINT [FK_score_sid] FOREIGN KEY([sid])
REFERENCES [dbo].[student] ([sid])
GO
ALTER TABLE [dbo].[score] CHECK CONSTRAINT [FK_score_sid]
GO
ALTER TABLE [dbo].[score]  WITH CHECK ADD  CONSTRAINT [FK_score_subid] FOREIGN KEY([subid])
REFERENCES [dbo].[subject] ([subid])
GO
ALTER TABLE [dbo].[score] CHECK CONSTRAINT [FK_score_subid]
GO
ALTER TABLE [dbo].[student]  WITH CHECK ADD  CONSTRAINT [FK_student_classid] FOREIGN KEY([classid])
REFERENCES [dbo].[class] ([classid])
GO
ALTER TABLE [dbo].[student] CHECK CONSTRAINT [FK_student_classid]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'管理员id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'admin', @level2type=N'COLUMN',@level2name=N'mid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'admin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'admin', @level2type=N'COLUMN',@level2name=N'createTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'班级号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'class', @level2type=N'COLUMN',@level2name=N'classid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'班级名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'class', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'class', @level2type=N'COLUMN',@level2name=N'createTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'成绩记录编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'score', @level2type=N'COLUMN',@level2name=N'scoreid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学生编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'score', @level2type=N'COLUMN',@level2name=N'sid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学科编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'score', @level2type=N'COLUMN',@level2name=N'subid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学科成绩' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'score', @level2type=N'COLUMN',@level2name=N'grade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'score', @level2type=N'COLUMN',@level2name=N'createTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'sid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'createTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'性别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'出生年月' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'birth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'班级id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'student', @level2type=N'COLUMN',@level2name=N'classid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学科号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'subject', @level2type=N'COLUMN',@level2name=N'subid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'学科名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'subject', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'subject', @level2type=N'COLUMN',@level2name=N'createTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'总分' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'subject', @level2type=N'COLUMN',@level2name=N'total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[35] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "score"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "student_1"
            Begin Extent = 
               Top = 6
               Left = 245
               Bottom = 146
               Right = 414
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "subject"
            Begin Extent = 
               Top = 6
               Left = 452
               Bottom = 146
               Right = 621
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "class"
            Begin Extent = 
               Top = 6
               Left = 659
               Bottom = 127
               Right = 828
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'class_and_subject_statistics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'class_and_subject_statistics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "score"
            Begin Extent = 
               Top = 6
               Left = 364
               Bottom = 146
               Right = 517
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "student"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 237
               Right = 326
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "subject"
            Begin Extent = 
               Top = 6
               Left = 555
               Bottom = 146
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "class"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 127
               Right = 899
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'score_detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'score_detail'
GO
