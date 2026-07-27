$png = "example-asset-pack\Villager_1\PNG"
$dst = "staging\villager"

# frame sequences: PNG Sequences\<Anim>\0_Villager_<Anim>_<n>.png → frames\<anim-kebab>\<n>.png
Get-ChildItem "$png\PNG Sequences" -Directory | ForEach-Object {
    $anim = $_.Name.ToLower() -replace ' ', '-'
    $out = Join-Path $dst "frames\$anim"
    New-Item -ItemType Directory -Force $out | Out-Null
    Get-ChildItem $_.FullName -Filter *.png | ForEach-Object {
        if ($_.BaseName -match '_(\d+)$') {
            Copy-Item $_.FullName (Join-Path $out "$($Matches[1]).png")
        }
    }
}

# vector parts: Vector Parts\<Part>.png → parts\<kebab-name>.png
$partMap = @{
    'Body.png'='body.png'; 'Head.png'='head.png'
    'Face 01.png'='face-01.png'; 'Face 02.png'='face-02.png'; 'Face 03.png'='face-03.png'
    'Left Arm.png'='arm-l.png'; 'Right Arm.png'='arm-r.png'
    'Left Hand.png'='hand-l.png'; 'Right Hand.png'='hand-r.png'
    'Left Leg.png'='leg-l.png'; 'Right Leg.png'='leg-r.png'
    'Sword.png'='sword.png'; 'SlashFX.png'='slash-fx.png'
}
New-Item -ItemType Directory -Force "$dst\parts" | Out-Null
$partMap.GetEnumerator() | ForEach-Object {
    Copy-Item (Join-Path "$png\Vector Parts" $_.Key) (Join-Path "$dst\parts" $_.Value)
}