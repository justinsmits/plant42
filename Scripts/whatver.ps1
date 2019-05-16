

<#

$thatNewShit = "C:\\newShit.txt"
$sr = New-Object System.IO.StreamReader C:\\WeeklyOld.txt

If([System.IO.File]::Exists($thatNewShit)){
	[System.IO.File]::Delete($thatNewShit)
}

$sw = [System.IO.File]::AppendText($thatNewShit)

While ($sr.Peek() -gt -1){
	$line = $sr.ReadLine()
	While($line.IndexOf("<") -gt -1){
		$line = $line.Replace("<li>", "     - ")
		$line = $line.Replace("</li>", [System.Environment]::NewLine)
		
		
		$firstIndex = $line.IndexOf('<')
		if($firstIndex -gt -1){
			$firstClose = $line.IndexOf('>')
			$naughtyString = $line.SubString($firstIndex, $firstClose - $firstIndex + 1)
			$line = $line.Replace($naughtyString, "")
		}
	}
	
	$sw.WriteLine($line)
}

$sr.Dispose()

$sw.Flush()
$sw.Dispose()

Start-Process "C:\Program Files (x86)\Notepad++\notepad++.exe" $thatNewShit
#Exit





[Int32[]] $randomChars = @()
$randomChars = $randomChars + 1
$randomChars = $randomChars + 2
$randomChars = $randomChars + 3
$retVal = [System.Array]::IndexOf($randomChars, 3)
Write-Host $retVal
#>


$rnd  = New-Object System.Random	

$nL  = [System.Environment]::NewLine


$i = 0
$chars = "123456ABCDEFGH  "
[String[]]$colors = "Red", "Cyan", "Blue", "Green"
Write-Host $colors
$template = "                                                                                                                                                                                                       "


<#$lineLength = 118


for($lines=0;$lines -le 100;$lines++)
{
$randoms = $rnd.Next(0, $lineLength)

[Int32[]] $randomChars = @()
for ($rc=0;$rc -le $randoms; $rc++){
	$randomChars = $randomChars + $rnd.Next(0, $lineLength)
}

	for($i=0;$i -le 120; $i++)
	{
		$char = $chars.SubString($rnd.Next(0,13),1)
		if ([System.Array]::IndexOf($randomChars, $i) -gt 0){
			$f = $colors[$rnd.Next(0,$colors.Count)]
			Write-Host -fore $f -nonewline $char
		}else{
			Write-Host $char -nonewline
		}
	}
}

Exit
#>

for($i=0;$i -le 1000; $i++){

$ii = 0
$inserts = $rnd.Next(1,40);
$tempLine = $template
for($ii = 0;$ii -le $inserts;$ii++){
	
	$char = $chars.SubString($rnd.Next(0,13),1)
	$rando = $rnd.Next(0,199)
	$tempLine = $tempLine.Insert($rando, $char)
}

$f = $colors[$rnd.Next(0,$colors.Count)]
Write-Host -fore $f $tempLine

}