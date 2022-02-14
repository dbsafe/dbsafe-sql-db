FROM mcr.microsoft.com/mssql/server:2019-latest

HEALTHCHECK --interval=1s --timeout=3s --retries=60 CMD sqlcmd -S localhost -U ${DBSAFE_USER} -P ${DBSAFE_PASSWORD} -Q "select @@VERSION"