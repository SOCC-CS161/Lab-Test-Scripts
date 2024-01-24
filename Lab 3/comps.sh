#include <iostream>
#include <cstdlib>
using namespace std;

int getCardValue(int cardNum) {
    if (cardNum >= 10) return 10; // Face cards and 10s
    if (cardNum == 1) return 11;  // Ace
    return cardNum;               // Other cards
}

int main() {
    int seed = 0;

    while (true) {
        srand(seed);

        int card1Num = rand() % 13 + 1;
        int card2Num = rand() % 13 + 1;
        int card3Num = rand() % 13 + 1;
        int card4Num = rand() % 13 + 1;
        int card5Num = rand() % 13 + 1;

        int card1Value = getCardValue(card1Num);
        int card2Value = getCardValue(card2Num);
        int card3Value = getCardValue(card3Num);
        int card4Value = getCardValue(card4Num);
        int card5Value = getCardValue(card5Num);

        int handValue1Hit = card1Value + card2Value + card3Value;
        int handValue2Hits = handValue1Hit + card4Value;
        int handValue3Hits = handValue2Hits + card5Value;

        if (card1Value + card2Value < 21) {
            if (handValue1Hit > 21 && card1Num != 1 && card2Num != 1 && card3Num != 1) {
                cout << "Seed for one hit: " << seed << endl;
                cout << "Cards: " << card1Num << ", " << card2Num << ", " << card3Num << endl;
            }
            if (handValue2Hits > 21 && handValue1Hit <= 21) {
                cout << "Seed for two hits: " << seed << endl;
                cout << "Cards: " << card1Num << ", " << card2Num << ", " << card3Num << ", " << card4Num << endl;
            }
            if (handValue3Hits > 21 && handValue2Hits <= 21) {
                cout << "Seed for three hits: " << seed << endl;
                cout << "Cards: " << card1Num << ", " << card2Num << ", " << card3Num << ", " << card4Num << ", " << card5Num << endl;
                break;
            }
        }
        seed++;
    }

    return 0;
}
