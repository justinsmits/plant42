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
        return ($this.Cards.Count -gt 0 -or $this.CarsWon.Count -gt 0);
    }
    [System.Int32]CardCount() {
        return ($this.Cards.Count + $this.CardsWon.Count)
    }
    [Card]GetCard(){
        [Card]$retVal = $null;
        if ($this.Cards.Count -gt 0) {
            $retVal = $this.Cards.Pop()
        } else {
            Write-Host -ForegroundColor Magenta "$($this.Name) is shuffeling their deck"
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

function WinWar([PSCustomObject]$winner, [System.Collections.ArrayList]$warMatch){
    Write-Host -ForegroundColor Green "$($winner.Name) won the war!!"
    foreach($card in $warMatch) {
        $winner.CardsWon.add($card)
    }
}

function PlayMatch([Card]$aCard,[Card]$bCard) {
    if ($aCard.number -gt $bCard.number) {
            return "a"

        } elseif ($bCard.number -gt $aCard.number) {
            return "b"

        } else {
            return "w"
        }
}

function playgame {
    $a = New-Object player("Bob")
    $b = New-Object player("Jill")

    [Int32]$numCards = 5;
    $gameDeck = New-Object Deck($numCards)

    $gameDeck.Cards = ShuffleDeck($gameDeck.Cards)

    $shuffledDeck = New-Object System.Collections.Stack
    foreach($card in $gameDeck.Cards) {
        $shuffledDeck.Push($card)

    }
    Write-Host $shuffledDeck.Count

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
    while($a.HasCards -and $b.HasCards) {
        Write-Host "Match $i"
        $aCard = $a.GetCard()
        $bCard = $b.GetCard()

        Write-Host "$($a.Name) has a $($aCard.number)"
        Write-Host "$($b.Name) has a $($bCard.number)"
        #$matchResult = PlayMatch($aCard, $bCard)
        if ($aCard.number -gt $bCard.number) {
            Write-Host -ForegroundColor Green "$($a.Name) Wins"
            [void]$a.CardsWon.Add($aCard)
            [void]$a.CardsWon.Add($bCard)

        } elseif ($bCard.number -gt $aCard.number) {
            Write-Host -ForegroundColor Green "$($b.Name) Wins"
            [void]$b.CardsWon.Add($aCard)
            [void]$b.CardsWon.Add($bCard)

        } else {
            Write-Host -ForegroundColor Red "WWWWWAAAAAAAAARRRRRRRRR!!!!!!!!!!!!!!!!!!!!!"
            $warDeck = New-Object System.Collections.ArrayList
            $warDeck.Add($aCard)
            $warDeck.Add($bCard)
            $warDeck.Add($a.GetCard())
            $warDeck.Add($b.GetCard())
            $aCard = $a.GetCard()
            $bCard = $b.GetCard()
            $warDeck.Add($aCard)
            $warDeck.Add($bCard)
            if ($aCard.number -gt $bCard.number) {
                WinWar($a, $warDeck)

            } elseif ($bCard.number -gt $aCard.number) {
                WinWar($b, $warDeck)

            } else {
                Write-Host -ForegroundColor White "DRAW"
                $e = 0
                for ($e=0;$e -lt $warDeck.Count;$e++) {
                    if ($e % 2 -eq 0) {
                        $a.CardsWon.Add($warDeck[$e])
                    } else {
                        $b.CardsWon.Add($warDeck[$e])
                    }
                }
            }
            
        }
        $i++
        if ($i % 5 -eq 0) {
            $aCount = $a.CardCount()
            $bCount = $b.CardCount()
            if ($aCount -gt $bCount) {
                Write-Host -ForegroundColor Cyan "$($a.Name) is winning with $($aCount) cards"
            } elseif ($bCount -gt $aCount) {
                Write-Host -ForegroundColor Cyan "$($b.Name) is winning with $($bCount) cards"
            } else {
                Write-Host -ForegroundColor Cyan "The game is currently a tie"
            }
        }
        sleep -Milliseconds 500
    }


}

playgame