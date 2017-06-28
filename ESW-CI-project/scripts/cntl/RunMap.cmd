@echo off

echo Starting RunMAP script.

rem MAPpath passed from the command line. Contains the location of the MAP script.
set MAPpath=%1

rem echo Changing to PATH: %MAPpath%
cd  %MAPpath%

rem Call the MAP script now that we have the location
perl %MAPpath%

rem Check the return code from the script. ERRORLEVEL is how jenkins determines pass/fail
IF %ERRORLEVEL% NEQ 0 (
  ECHO +++ Script failed! +++
)
EXIT /B %ERRORLEVEL%

rem to go home:)
cd \users\jenkins

echo RunMAP ended.