
@echo off

echo Creating sample skill...

IF NOT EXIST "env.bat" (
  echo No env.bat file found. Please create one. See README.md for details.
  EXIT /B
)

echo Setting necessary environment variables.
call env.bat

echo Logging into to the docker registry.
docker login -u %registry_username% -p %registry_password% %registry%

echo Calling docker buildx.
docker buildx build --platform linux/arm64 -t %registry%/%skill_name%:%skill_tag% --push .

