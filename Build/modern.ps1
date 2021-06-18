# bundles a modern PC release using Zarf's IFsitegen.py utility and Parchment. You must have Inform 7 (on Windows) installed
Copy-Item "hibernated1.z5" "Releases\Modern"
Set-Location "Releases\Modern"
Remove-Item "Release" -Recurse -ErrorAction Ignore
python3.9 .\ifsitegen.py --cover .\Cover.png --author 'Stefan Vogt' --title 'Hibernated 1' .\hibernated1.z5
Set-Location "Release"