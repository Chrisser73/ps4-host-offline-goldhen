@echo off
pushd "%~dp0" || exit /b 1

docker compose -f docker-compose.yml -f docker-compose.local.yml build || goto :fail
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d --no-build || goto :fail
echo Open http://localhost:8135/
popd
exit /b 0

:fail
echo Setup failed; existing files were not replaced. 1>&2
popd
exit /b 1
