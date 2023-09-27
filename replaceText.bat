@echo off
setlocal enabledelayedexpansion

:: Set your find and replace strings here
set FIND=FF1D2B
set REPLACE=FF1D2B

:: Initialize counters
set TOTALFOUND=0
set TOTALREPLACED=0

for %%G in (*.html, *.css) do (
    :: Get count of occurrences (case-insensitive)
    for /f %%C in ('powershell -NoProfile -Command "(Get-Content '%%G') -join \"`n\" | Select-String '(?i)%FIND%' -AllMatches | %{$_.Matches.Count}"') do set COUNT=%%C
    if !COUNT! gtr 0 (
        :: Do the replacement if occurrences found (case-insensitive)
        powershell -NoProfile -Command "(Get-Content '%%G') -replace '(?i)%FIND%', '%REPLACE%' | Set-Content '%%G'"
        set /a TOTALFOUND+=COUNT
        set /a TOTALREPLACED+=COUNT
        echo Found !COUNT! occurrences in %%G and replaced them.
    ) else (
        echo No occurrences found in %%G.
    )
)

:: Recursively perform operation on subdirectories
for /D %%D in (*) do (
    cd "%%D"
    call %0
    cd ..
)

:: Display total counts if at the root level (you can customize this check if your root directory will have other .bat files)
if exist *.bat (
    echo.
    echo Total occurrences found: !TOTALFOUND!
    echo Total replacements made: !TOTALREPLACED!
    if !TOTALFOUND! equ 0 (
        echo No occurrences found in any files.
    )
)

endlocal
exit
