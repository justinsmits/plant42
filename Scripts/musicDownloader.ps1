
$i = 401

 for($i=437; $i -le 444; $i++){
 
	$source = "http://www.insatiablerecords.com/pod/SOLARIS$i(128K).mp3"
	$destination = "C:\Users\Tron\Music\Solarstone\$i.mp3"
 
	Invoke-WebRequest $source -OutFile $destination
 
 }

