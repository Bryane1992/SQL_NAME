/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PHX_NAME_ID]
      ,[PHX_NAME_FULL]
      ,[PHX_NAME_FIRST]
      ,[PHX_NAME_MID]
      ,[PHX_NAME_LAST]
  FROM [test].[dbo].[PHX_NAME]

  --SQL Query to get the number of words in the string
  Select len([PHX_NAME_FULL]) - len(replace([PHX_NAME_FULL], ' ', '')) + 1 NumbofWords
from PHX_NAME

--SQL Query to get the last name. This creates a substring of everything that is to the left of a comma
SELECT  SUBSTRING([PHX_NAME_FULL],1,CHARINDEX(',', [PHX_NAME_FULL])-1) FROM PHX_NAME

--SQL Query to get the first and middle name. For this to work correctly it must have a space after the comma. Other formats will not be accepted
SELECT  SUBSTRING([PHX_NAME_FULL], CHARINDEX(' ', [PHX_NAME_FULL]) + 1, LEN([PHX_NAME_FULL])) AS [FirstMiddle]
FROM PHX_NAME

