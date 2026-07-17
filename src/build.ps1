# 1. Automatically locate the native MSBuild.exe on your C: drive
$msbuild = (Get-ChildItem -Path "C:\Program Files", "C:\Program Files (x86)" -Filter "MSBuild.exe" -Recurse -ErrorAction SilentlyContinue | 
            Where-Object { $_.FullName -like "*Current\Bin\MSBuild.exe" } | 
            Select-Object -First 1).FullName

if ($msbuild) {
    Write-Host "Success! Found MSBuild at: $msbuild" -ForegroundColor Green
    Write-Host "Starting compilation (excluding MicIcon)..." -ForegroundColor Cyan
    
    # 2. Compile each individual tray icon project EXCEPT MicIcon
    Get-ChildItem -Filter *Icon.csproj -Recurse | 
        Where-Object { $_.Name -ne "MicIcon.csproj" } | 
        ForEach-Object { 
            Write-Host "`n--- Building: $($_.Name) ---" -ForegroundColor Yellow
            & $msbuild $_.FullName /p:Configuration=Release
        }
    
    Write-Host "`nCompilation Finished!" -ForegroundColor Green
} else {
    Write-Error "Could not find MSBuild.exe! Please ensure you have Visual Studio or Visual Studio Build Tools installed."
}
