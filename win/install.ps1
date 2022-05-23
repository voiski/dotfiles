# Refer to: https://gist.github.com/dougwaldron/d510f2d67a922da169aca1aeff7e4c4d#file-installsoftware-ps1
# 1. Make sure the Microsoft App Installer is installed:
#    https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1
# 2. Edit the list of apps to install.
# 3. Run this script as administrator.

# Note:
# If running scripts is blocked (it should be), you can temporarily unblock them by running: 
# $ Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

Write-Output "Installing Apps"
$apps = @(
    @{name = "7zip.7zip" },
    @{name = "Adobe.Acrobat.Reader.64-bit" },
    @{name = "Axosoft.GitKraken" },
    # @{name = "Devolutions.RemoteDesktopManagerFree" }, # Maybe in future
    @{name = "Git.Git" },
    @{name = "GnuPG.Gpg4win" },
    @{name = "Google.Chrome" },
    @{name = "Greenshot.Greenshot" },
    @{name = "Inkscape.Inkscape" },
    @{name = "JanDeDobbeleer.OhMyPosh" },
    @{name = "JetBrains.Toolbox" },
    @{name = "JohnMacFarlane.Pandoc" },
    @{name = "KDE.KDiff3" },
    # @{name = "Microsoft.AzureDataStudio" }, # Included with SSMS
    # @{name = "Microsoft.dotnet" },
    @{name = "Microsoft.PowerShell" },
    # @{name = "Microsoft.PowerToys" }, # Enhance windows - maybe in future
    # @{name = "Microsoft.SQLServerManagementStudio" }, # Includes AzureDataStudio
    @{name = "Microsoft.VisualStudioCode" },
    @{name = "Microsoft.WindowsTerminal" },
    # @{name = "Mozilla.Firefox.DeveloperEdition" },
    # @{name = "Mozilla.Firefox" },
    @{name = "NickeManarin.ScreenToGif" },
    @{name = "Notepad++.Notepad++" },
    # @{name = "OpenJS.NodeJS.LTS" },
    # @{name = "TimKosse.FileZilla.Client" },
    @{name = "VideoLAN.VLC" },
    @{name = "WinDirStat.WinDirStat" },
    @{name = "SlackTechnologies.Slack" },
    @{name = "Zoom.Zoom" }
);
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}