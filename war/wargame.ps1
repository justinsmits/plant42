function Write-Message{
    param(
        [Parameter(Mandatory=$true)]
        [String]$Message,
        [System.ConsoleColor]$ForegroundColor=[System.ConsoleColor]::White
    )
    Write-Host ""
    #foreach($char in $Message.Split(" ")) {
    foreach($char in $Message.ToCharArray()) {
        Write-Host -ForegroundColor $ForegroundColor "$char" -NoNewLine
        sleep -Milliseconds 1
    }
}

class Card {
    [Int32]$number
}

function ShuffleDeck([System.Collections.ArrayList]$Deck) {
    return $Deck | Sort-Object {Get-Random}
}

class player {
    [String]$Name
    [System.Collections.Stack]$Cards
    [System.Collections.ArrayList]$CardsWon

    [System.Boolean]HasCards(){
        $currentCards = $this.CardCount();
        
        return ($currentCards -gt 0)
    }
    [System.Int32]CardCount() {
        return ($this.Cards.Count + $this.CardsWon.Count)
    }
    [Card]GetCard(){
        [Card]$retVal = $null;
        if ($this.Cards.Count -gt 0) {
            $retVal = $this.Cards.Pop()
        } else {
            Write-Message -ForegroundColor Magenta "$($this.Name) is shuffling their deck"
            $tempDeck = ShuffleDeck($this.CardsWon);
            foreach($card in $tempDeck) {
                $this.Cards.Push($card);
            }
            $this.CardsWon = New-Object System.Collections.ArrayList
            $retVal = $this.Cards.Pop();
        }
        return $retVal
    }


    player([String]$name){
        $this.Name = $name
        $this.Cards = New-Object System.Collections.Stack
        $this.CardsWon = New-Object System.Collections.ArrayList
    }
}

class Deck {
    [System.Collections.ArrayList]$Cards

    Deck([Int32]$size) {
    $this.Cards = New-Object System.Collections.ArrayList
        for($i=1;$i -le $size;$i++) {
            for ($suiteNum = 1; $suiteNum -le 4; $suiteNum++) {
                $card = New-Object Card
                $card.number = $i
                $this.Cards.Add($card)
            }
        }

    }
    
}

function WinWar([PSCustomObject]$winner, [System.Collections.ArrayList]$matchDeck){
    Write-Message -ForegroundColor Green "$($winner.Name) won the war!!"
    foreach($card in $matchDeck) {
        [void]$winner.CardsWon.add($card)
    }
}


function playgame {
    $a = New-Object player("Bob")
    $b = New-Object player("Jill")

    [Int32]$numCards = 10;
    $gameDeck = New-Object Deck($numCards)

    $gameDeck.Cards = ShuffleDeck($gameDeck.Cards)

    $shuffledDeck = New-Object System.Collections.Stack
    foreach($card in $gameDeck.Cards) {
        $shuffledDeck.Push($card)

    }
    Write-Message "$($shuffledDeck.Count)"

    $i = 0
    while($shuffledDeck.Count -gt 0) {
        $card = $shuffledDeck.Pop()
        if ($i % 2 -eq 0) {
            $a.Cards.Push($card)
        } else {
            $b.Cards.Push($card)
        }
        $i++
    }

    $i=1
    $matchWinner = $null
    [System.Collections.ArrayList]$matchDeck
    while(($a.HasCards() -eq $true) -and ($b.HasCards() -eq $true)) {
        Write-Message "Match $i"
        Write-Message "$($a.Name) has $($a.CardCount()) cards left"
        Write-Message "$($b.Name) has $($b.CardCount()) cards left"
        $matchDeck = New-Object System.Collections.ArrayList

        while(-not $matchWinner) {
            if (-not ($a.HasCards() -eq $true)){
                $matchWinner = $b
                break
            }
            if (-not ($b.HasCards() -eq $true)){
                $matchWinner = $a
                break
            }

            $aCard = $a.GetCard()
            $bCard = $b.GetCard()

            Write-Message "$($a.Name) has a $($aCard.number)"
            Write-Message "$($b.Name) has a $($bCard.number)"
            [void]$matchDeck.Add($aCard)
            [void]$matchDeck.Add($bCard)
        
            if ($aCard.number -gt $bCard.number) {
                $matchWinner = $a

            } elseif ($bCard.number -gt $aCard.number) {
                $matchWinner = $b
            } else {
                Write-Message -ForegroundColor Red "WWWWWAAAAAAAAARRRRRRRRR!!!!!!!!!!!!!!!!!!!!!"
                if (-not ($a.CardCount() -ge 2)) {
                    $matchWinner = $b
                    break
                }
                if (-not ($b.CardCount() -ge 2)) {
                    $matchWinner = $a
                    break
                }
                $aBurn1 = $a.GetCard()
                $aBurn2 = $a.GetCard()
                $bBurn1 = $b.GetCard()
                $bBurn2 = $b.GetCard()
                $matchDeck.AddRange(($aBurn1, $aBurn2, $bBurn1, $aBurn2))
            
            }
        }

        WinWar -winner $matchWinner -matchDeck $matchDeck 
        $matchWinner = $null
       
        $i++
        if ($i % 5 -eq 0) {
            $aCount = $a.CardCount()
            $bCount = $b.CardCount()
            if ($aCount -gt $bCount) {
                Write-Message -ForegroundColor Cyan "$($a.Name) is winning with $($aCount) cards"
            } elseif ($bCount -gt $aCount) {
                Write-Message -ForegroundColor Cyan "$($b.Name) is winning with $($bCount) cards"
            } else {
                Write-Message -ForegroundColor Cyan "The game is currently a tie"
            }
        }
        sleep -Milliseconds 200
    }

    Write-Message "THE GAME iS OVER!!"


}

playgame