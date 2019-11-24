
/*
   Copyright 2011 tSQLt --gj

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
USE tempdb;
GO

IF(db_id('tSQLt_Example') IS NOT NULL)
EXEC('
ALTER DATABASE tSQLt_Example SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;
USE tSQLt_Example;
ALTER DATABASE tSQLt_Example SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
USE tempdb;
DROP DATABASE tSQLt_Example;
');
GO

CREATE DATABASE tSQLt_Example WITH TRUSTWORTHY ON;
GO

USE tSQLt_Example;
GO

IF OBJECT_ID('Accelerator.Particle') IS NOT NULL DROP TABLE Accelerator.Particle;
GO

IF OBJECT_ID('Accelerator.Color') IS NOT NULL DROP TABLE Practice.Color;
GO

IF TYPE_ID('tSQLt.Private') IS NOT NULL DROP TYPE tSQLt.Private;
GO

IF TYPE_ID('tSQLtPrivate') IS NOT NULL DROP TYPE tSQLtPrivate;
GO

IF OBJECT_ID('tSQLt.DropClass') IS NOT NULL
    EXEC tSQLt.DropClass tSQLt;
GO

IF EXISTS (SELECT 1 FROM sys.assemblies WHERE name = 'tSQLtCLR')
    DROP ASSEMBLY tSQLtCLR;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(MAX)) LIKE '9.%')
BEGIN
  EXEC('ALTER VIEW tSQLt.Private_SysTypes AS SELECT *,0 is_table_type FROM sys.types AS T;');
END;
GO

IF((SELECT SqlVersion FROM tSQLt.Info())>9)
BEGIN
  EXEC('CREATE VIEW tSQLt.Private_SysIndexes AS SELECT * FROM sys.indexes;');
END
ELSE
BEGIN
  EXEC('CREATE VIEW tSQLt.Private_SysIndexes AS SELECT *,0 AS has_filter,'''' AS filter_definition FROM sys.indexes;');
END;
GO

INSERT INTO tSQLt.Private_NullCellTable (I) VALUES (NULL);
GO

EXEC('
  SET NOCOUNT ON;
  SELECT TOP(0) * 
    INTO tSQLt.Private_AssertEqualsTableSchema_Expected
    FROM tSQLt.Private_AssertEqualsTableSchema_Actual AS AETSA;
');
GO

IF NOT(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(MAX)) LIKE '9.%')
BEGIN
  EXEC('CREATE TYPE tSQLt.AssertStringTable AS TABLE(value NVARCHAR(MAX));');
END;
GO

IF NOT(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(MAX)) LIKE '9.%')
BEGIN
EXEC('
CREATE PROCEDURE tSQLt.AssertStringIn
  @Expected tSQLt.AssertStringTable READONLY,
  @Actual NVARCHAR(MAX),
  @Message NVARCHAR(MAX) = ''''
AS
BEGIN
  IF(NOT EXISTS(SELECT 1 FROM @Expected WHERE value = @Actual))
  BEGIN
    DECLARE @ExpectedMessage NVARCHAR(MAX);
    SELECT value INTO #ExpectedSet FROM @Expected;
    EXEC tSQLt.TableToText @TableName = ''#ExpectedSet'', @OrderBy = ''value'',@txt = @ExpectedMessage OUTPUT;
    SET @ExpectedMessage = ISNULL(''<''+@Actual+''>'',''NULL'')+CHAR(13)+CHAR(10)+''is not in''+CHAR(13)+CHAR(10)+@ExpectedMessage;
    EXEC tSQLt.Fail @Message, @ExpectedMessage;
  END;
END;
');
END;
GO

/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
IF OBJECT_ID('Accelerator.IsExperimentReady') IS NOT NULL DROP FUNCTION Accelerator.IsExperimentReady;
GO

IF OBJECT_ID('Accelerator.GetParticlesInRectangle') IS NOT NULL DROP FUNCTION Accelerator.GetParticlesInRectangle;
GO

IF OBJECT_ID('Accelerator.SendHiggsBosonDiscoveryEmail') IS NOT NULL DROP PROCEDURE Accelerator.SendHiggsBosonDiscoveryEmail;
GO

IF OBJECT_ID('Accelerator.AlertParticleDiscovered') IS NOT NULL DROP PROCEDURE Accelerator.AlertParticleDiscovered;
GO

IF OBJECT_ID('Accelerator.GetStatusMessage') IS NOT NULL DROP FUNCTION Accelerator.GetStatusMessage;
GO

IF OBJECT_ID('Accelerator.FK_ParticleColor') IS NOT NULL ALTER TABLE Accelerator.Particle DROP CONSTRAINT FK_ParticleColor;
GO

/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
EXEC tSQLt.NewTestClass 'AcceleratorTests';
GO


/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
DECLARE @Msg NVARCHAR(MAX);SELECT @Msg = 'Installed at '+CONVERT(NVARCHAR,GETDATE(),121);RAISERROR(@Msg,0,1);

GO


--------------------------------------------------------------------------------


GO

--Build-



GO

SET NOCOUNT ON;
DECLARE @ver NVARCHAR(MAX); 
DECLARE @match INT; 
SELECT @ver = '| tSQLt Version: ' + I.Version,
       @match = CASE WHEN I.Version = I.ClrVersion THEN 1 ELSE 0 END
  FROM tSQLt.Info() AS I;
SET @ver = @ver+SPACE(42-LEN(@ver))+'|';
 
RAISERROR('',0,1)WITH NOWAIT;
RAISERROR('+-----------------------------------------+',0,1)WITH NOWAIT;
RAISERROR('|                                         |',0,1)WITH NOWAIT;
RAISERROR('| Thank you for using tSQLt.              |',0,1)WITH NOWAIT;
RAISERROR('|                                         |',0,1)WITH NOWAIT;
RAISERROR(@ver,0,1)WITH NOWAIT;
IF(@match = 0)
BEGIN
  RAISERROR('|                                         |',0,1)WITH NOWAIT;
  RAISERROR('| ERROR: mismatching CLR Version.         |',0,1)WITH NOWAIT;
  RAISERROR('| Please download a new version of tSQLt. |',0,1)WITH NOWAIT;
END
RAISERROR('|                                         |',0,1)WITH NOWAIT;
RAISERROR('+-----------------------------------------+',0,1)WITH NOWAIT;




GO
