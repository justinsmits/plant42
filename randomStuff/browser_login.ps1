# this script is a complete hack, but keeping in case i have a need to inject javascript into a window\frames via the URL and for some reason decided to use IE???WHAT?

function NavigateWait($ie) {
	
	$exitFlag = $false

	do {

		sleep -milliseconds 100

		if ( $ie.ReadyState -eq 4 ) {

		   $exitFlag = $true

		}

	} until ( $exitFlag )
	return $ie
}

function Login([System.String] $pass){
#maybe can be substituded with [System.Environment]::MachineName
$machineName = "<LOCAL MACHINE NAME>" 
$userName = "<USERNAME>"
if([System.String]::IsNullOrWhiteSpace($pass)){
	write-host "No pass provided"
}

$ie = New-Object -ComObject "InternetExplorer.Application"

$ie.Visible = $true
$ie.Navigate2("<HOST URL>")

$ie = NavigateWait($ie)

($ie.Document).getElementByID("username").value = $userName
($ie.Document).getElementByID("credential").value = $pass

($ie.Document).getElementByID("login_button").click()

#wait for the iframe to load
sleep -milliseconds  8000
	
$ie = NavigateWait($ie)

#inject javascript into the URL bar to click the connect button in one of the frames. Total hack, but it works
$ie.Navigate2("javascript:window.document.frames[0].document.getElementsByTagName(""input"")[3].click()")

sleep -milliseconds  8000

start-process "$env:windir\system32\mstsc.exe" -argumentlist "/v:$machineName"

}
