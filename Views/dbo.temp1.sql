SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[temp1]
AS
SELECT salegroup,sum([DINNER] * qty) [DINNER],sum([LUNCH] * qty )[LUNCH] 
FROM (SELECT * FROM
(

SELECT     SaleGroup, CONVERT(decimal(18, 2), SUM(NumTables)) AS NumTables, CONVERT(decimal(18, 2), SUM(NumGuest)) AS NumGuest, 
                      CONVERT(decimal(18, 2), SUM(NumChecks)) AS NumChecks, CONVERT(decimal(18, 2), SUM(ProfitTotal) / SUM(NumGuest)) AS PPA, 
                      CONVERT(decimal(18, 2), SUM(ProfitTotal) / SUM(NumChecks)) AS PCA,CONVERT(decimal(18, 2),SUM(ProfitTotal))  as total
 from (
		Select mp.Name as SaleGroup,count(o.ID) as NumTables,sum(o.GuestCount) as NumGuest,
		   NULL AS NumChecks, NULL AS ProfitTotal
		From [order] as o inner join MealPeriod as mp ON o.MealPeriod = mp.Name and o.StoreID=mp.StoreID
		Where BusinessDate BETWEEN '2012-06-13 00:00:00' AND '2012-06-13 00:00:00' AND o.StoreID=6 Group by mp.Name UNION 
		Select	mp.Name as SaleGroup, NULL AS NumTables, NULL AS NumGuest, 
			COUNT(p.CheckID) AS NumChecks, NULL as ProfitTotal
		From [Order] as O inner JOIN [Check] as c ON O.id = c.orderid and o.StoreID=c.StoreID
			JOIN Payment as p ON p.CheckID = c.ID and o.StoreID=p.StoreID
			inner join MealPeriod as mp ON o.MealPeriod = mp.Name and o.StoreID=mp.StoreID
		Where o.BusinessDate BETWEEN '2012-06-13 00:00:00' AND '2012-06-13 00:00:00' AND o.StoreID=6 Group by mp.Name UNION 
		Select mp.Name as SaleGroup, NULL AS NumTables, NULL AS NumGuest,
		  NULL AS NumChecks, SUM(qty *(price -AdjustedPrice)) as ProfitTotal
		From [Order] as O JOIN OrderLineItem OI ON O.ID = OI.orderid and o.StoreID= OI.StoreID
		inner join MealPeriod as mp ON o.MealPeriod = mp.Name and o.StoreID=mp.StoreID 
		where o.BusinessDate  BETWEEN '2012-06-13 00:00:00' AND '2012-06-13 00:00:00' AND o.StoreID=6 Group by mp.Name ) as table1
		Group by SaleGroup) as tabel4
		 PIVOT(count(salegroup) FOR salegroup IN([DINNER],[LUNCH])) AS P)a
        UNPIVOT(qty FOR salegroup IN([NumTables], [NumGuest], [PPA],[NumChecks],[Pca],[total])) AS U
  group by salegroup
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'temp1', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'temp1', NULL, NULL
GO
