@echo off
setlocal EnableDelayedExpansion
pushd "%~dp0" || exit /b 1

set "UPSTREAM=https://github.com/psx8/psx8.github.io.git"
set "ORIGIN="
set "BRANCH="
if exist "www" (
    if not exist "www\.git" (
        echo www already exists but is not a Git clone. Leaving it untouched. 1>&2
        goto :fail
    )
    git -C www remote get-url origin >nul || goto :fail
    for /f "delims=" %%R in ('git -C www remote get-url origin') do set "ORIGIN=%%R"
    if not "!ORIGIN!"=="%UPSTREAM%" (
        echo www has a different origin. Leaving it untouched. 1>&2
        goto :fail
    )
    git -C www symbolic-ref --quiet --short HEAD >nul || goto :fail
    for /f "delims=" %%B in ('git -C www symbolic-ref --quiet --short HEAD') do set "BRANCH=%%B"
    if not "!BRANCH!"=="main" (
        echo www is not on main. Leaving it untouched. 1>&2
        goto :fail
    )
    git -C www status --porcelain >nul || goto :fail
    for /f "delims=" %%S in ('git -C www status --porcelain') do (
        echo www has local changes. Leaving it untouched. 1>&2
        goto :fail
    )
    git -C www pull --ff-only origin main || goto :fail
) else (
    git clone "%UPSTREAM%" www || goto :fail
)

docker compose -f docker-compose.yml -f docker-compose.local.yml build || goto :fail
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d --no-build || goto :fail
echo Open http://localhost:8135/1352/index.html
popd
exit /b 0

:fail
echo Setup failed; existing files were not replaced. 1>&2
popd
exit /b 1
