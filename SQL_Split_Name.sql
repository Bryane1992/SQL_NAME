/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PHX_NAME_ID]
      ,[PHX_NAME_FULL]
      ,[PHX_NAME_FIRST]
      ,[PHX_NAME_MID]
      ,[PHX_NAME_LAST]
  FROM [test].[dbo].[PHX_NAME]

  --SQL Query to get the number of words in the string (To be used to figure out if there is a middle name or not.
  Select len([PHX_NAME_FULL]) - len(replace([PHX_NAME_FULL], ' ', '')) + 1 NumbofWords
from PHX_NAME

--SQL Query to get the last name. This creates a substring of everything that is to the left of a comma
SELECT  SUBSTRING([PHX_NAME_FULL],1,CHARINDEX(',', [PHX_NAME_FULL])-1) FROM PHX_NAME

--SQL Query to get the first and middle name. For this to work correctly it must have a space after the comma. Other formats will not be accepted
SELECT  SUBSTRING([PHX_NAME_FULL], CHARINDEX(' ', [PHX_NAME_FULL]) + 1, LEN([PHX_NAME_FULL])) AS [FirstMiddle]
FROM PHX_NAME

/*
Now Let's seperate the names into three parts. (test)
Set variables to get the full name in order to seperate them
*/
DECLARE @FirstMiddle VARCHAR(MAX);
DECLARE @FullName VARCHAR(MAX);
DECLARE @First VARCHAR(MAX);
DECLARE @Middle VARCHAR(MAX);
--Getting the first name from the list to test
SET @FullName = (SELECT top 1 PHX_NAME_FULL FROM PHX_NAME)
--using the previous query to get the first and middle name 
SET @FirstMiddle = SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName))
--Outputting the first record by getting just the first name first
SELECT LEFT(@FirstMiddle, CHARINDEX(' ', @FirstMiddle) - 1) AS [First],
--now getting everything to the right of ' ' by going from the end of the string first in order to 
--seperate the middle name
RIGHT(@FirstMiddle, CHARINDEX(' ', REVERSE(@FirstMiddle)) - 1) AS [Middle],
--getting the last name by getting everything to the left of a comma 
SUBSTRING(@FullName ,1,CHARINDEX(',', @FullName )-1) AS [Last]

