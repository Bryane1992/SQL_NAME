﻿/****** Script for SelectTopNRows command from SSMS  ******/
-- Delcaring variables 
DECLARE @FirstMiddle VARCHAR(MAX);
DECLARE @FullName VARCHAR(MAX);
DECLARE @First VARCHAR(MAX);
DECLARE @Middle VARCHAR(MAX);
DECLARE @Last VARCHAR(MAX);
DECLARE @words VARCHAR(MAX);
DECLARE @ID int;
DECLARE @iter int = 0;
--Using a cursor to iterate through the rows and get each name
DECLARE @Name_Cursor CURSOR;

BEGIN
	--getting the full name from the table and fetching the NEXT result 
	--then inputting that result into variable @FullName
	SET @Name_Cursor = CURSOR FOR
		SELECT UPPER(PHX_NAME_FULL) FROM PHX_NAME

	OPEN @Name_Cursor
	FETCH NEXT FROM @Name_Cursor
		INTO @FullName
	--looping while the next fetch is successful. 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Here is where I am getting the variables from previously tested queries
		SET @FirstMiddle = SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName))
		--Set an iterator in order to get the top ID that is greater than the previous iteration. (Must be sequential)
		SET @ID = (SELECT TOP 1 PHX_NAME_ID FROM PHX_NAME WHERE PHX_NAME_ID > @iter)
		SET @Last = SUBSTRING(@FullName,1,CHARINDEX(',', @FullName)-1)
		--Get the # of words in the FirstMiddle and if its 1 then theres no middle name
		--If theres 2 then there must be a middle name
		SET @words = len(@FirstMiddle) - len(replace(@FirstMiddle, ' ', '')) + 1
		IF @words = 2
			BEGIN
				SET @First = LEFT(@FirstMiddle, CHARINDEX(' ', @FirstMiddle) - 1)
				SET @Middle = RIGHT(@FirstMiddle, CHARINDEX(' ', REVERSE(@FirstMiddle)) - 1)
				IF @First like '%.' 
					SET @First = left(@First, len(@First) - 1) 
			END
			

		IF @words = 1
			BEGIN
				--SELECT @FirstMiddle AS FirstName
				IF @First like '%.' 
					SET @First = left(@First, len(@First) - 1) 					 
				SET @First = @FirstMiddle
				SET @Middle = NULL
			END
			--This would be an invalid format exception so just set to NULL
		IF @words < 1 OR @words > 2
			BEGIN
				SET @First = NULL
				SET @Middle = NULL
			END
		--We have everything we need so update the table
		UPDATE [dbo].[PHX_NAME] SET

	    [PHX_NAME_FIRST] = @First,

		[PHX_NAME_MID] = @Middle,

		[PHX_NAME_LAST] = @Last

		WHERE [PHX_NAME_ID] = @ID

		--bump up the iterate to make sure we get the next ID to correctly update
		SET @iter = @iter + 1
		FETCH NEXT FROM @Name_Cursor
		INTO @FullName
	END
	--Release the cursor 
	CLOSE @Name_Cursor	;
	DEALLOCATE @Name_Cursor

END;

