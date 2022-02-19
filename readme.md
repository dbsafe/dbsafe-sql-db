# MS-SQL Server database used for testing.

## Using localdb
### Deploy the database to localdb
Open the solution `demo-db.sln` in Visual Studio and run the database project `ProductDatabase`

### Connecting to the database in localdb
Use connection string

`data source=(localdb)\ProjectModels;initial catalog=ProductDatabase;integrated security=True;MultipleActiveResultSets=True`

## Using MS-SQL Server in a Docker container

### Start database in a container
`docker-compose up --build -d`

### Generating deployment script
The script is already in the repository. Steps 1, 2, and 3 are needed only if the database project is modified.

1. Open and build the solution `demo-db.sln` in Visual Studio

2. Get sqlpackage from

    https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15

3. Execute the next command in a CMD terminal to generate the sql script. The database and the login should not exist to ensure that the script includes all the objects.

    `"C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe" /Action:script /SourceFile:.\ProductDatabase\bin\Debug\ProductDatabase.dacpac /OutputPath:ProductDatabase.sql /TargetServerName:localhost /TargetUser:sa /TargetPassword:"yourStrong(!)Password" /TargetDatabaseName:ProductDatabase`

### Deploy database using script
 
`sqlcmd -S localhost -U sa -P "yourStrong(!)Password" -i ProductDatabase.sql`

