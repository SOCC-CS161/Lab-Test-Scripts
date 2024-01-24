#include <iostream>
#include <cstdlib>
using namespace std;

int getCardValue(int cardNum) {
    if (cardNum >= 10) return 10; // Face cards and 10s
    if (cardNum == 1) return 11;  // Ace
    return cardNum;               // Other cards
}

int getCardValue2(int cardNum, bool isAceEleven) {
    if (cardNum == 1) return isAceEleven ? 11 : 1; // Ace as 11 or 1
    if (cardNum >= 2 && cardNum <= 10) return cardNum; // Numbers 2-10
    return 10; // Face cards
}


int main1() {
    int seed = 0;
    const int desiredFirst = 1;  // Represents an Ace (1 when modded by 13)
    const int desiredSecond = 10; // Represents a 10-value card (10 when modded by 13)

    while (true) {
        srand(seed);

        int firstCard = rand() % 13 + 1;
        int secondCard = rand() % 13 + 1;

        if (firstCard == desiredFirst && secondCard == desiredSecond) {
            std::cout << "Blackjack initial deal: Found seed: " << seed << std::endl;
            std::cout << "First card: " << firstCard << ", Second card: " << secondCard << std::endl;
            break;
        }

        seed++;
        if (seed % 100000 == 0) {
            std::cout << "Checked " << seed << " seeds so far." << std::endl;
        }
    }

    return 0;
}

int main2() {
    int seed = 1;
    const int blackjack = 21;

    while (true) {
        srand(seed);

        int firstCardNum = rand() % 13 + 1;
        int secondCardNum = rand() % 13 + 1;
        int thirdCardNum = rand() % 13 + 1;

        int firstCardValue = getCardValue(firstCardNum);
        int secondCardValue = getCardValue(secondCardNum);
        int thirdCardValue = getCardValue(thirdCardNum);

        int handValue = firstCardValue + secondCardValue + thirdCardValue;

        if (handValue == blackjack) {
            std::cout << "Blackjack one hit: Found seed: " << seed << std::endl;
            std::cout << "Cards: " << firstCardNum << ", " << secondCardNum << ", " << thirdCardNum << std::endl;
            std::cout << "Values: " << firstCardValue << ", " << secondCardValue << ", " << thirdCardValue << std::endl;
            break;
        }

        seed++;
        if (seed % 100000 == 0) {
            std::cout << "Checked " << seed << " seeds so far." << std::endl;
        }
    }

    return 0;
}

int main3() {
    int seed = 2;

    while (true) {
        srand(seed);

        int cardNums[3];
        for (int i = 0; i < 3; i++) {
            cardNums[i] = rand() % 13 + 1;
        }

        int handValueAsEleven = getCardValue2(cardNums[0], true) +
            getCardValue2(cardNums[1], true) +
            getCardValue2(cardNums[2], true);

        int handValueAsOne = getCardValue2(cardNums[0], false) +
            getCardValue2(cardNums[1], false) +
            getCardValue2(cardNums[2], false);

        if (handValueAsEleven > 21 && handValueAsOne <= 21) {
            std::cout << "Ace revalued: Found seed: " << seed << std::endl;
            std::cout << "Cards: " << cardNums[0] << ", " << cardNums[1] << ", " << cardNums[2] << std::endl;
            std::cout << "Values with Ace as 11: " << handValueAsEleven << std::endl;
            std::cout << "Values with Ace as 1: " << handValueAsOne << std::endl;
            break;
        }

        seed++;
        if (seed % 100000 == 0) {
            std::cout << "Checked " << seed << " seeds so far." << std::endl;
        }
    }

    return 0;
}

int main4() {
    int seed = 1;


    for (int i = 0; i < 20; i++) {
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
            if (handValue2Hits > 21 && handValue1Hit <= 21 && card1Num != 1 && card2Num != 1 && card3Num != 1 && card4Num != 1) {
                cout << "Seed for two hits: " << seed << endl;
                cout << "Cards: " << card1Num << ", " << card2Num << ", " << card3Num << ", " << card4Num << endl;
            }
            if (handValue3Hits > 21 && handValue2Hits <= 21 && card1Num != 1 && card2Num != 1 && card3Num != 1 && card4Num != 1 && card5Num != 1) {
                cout << "Seed for three hits: " << seed << endl;
                cout << "Cards: " << card1Num << ", " << card2Num << ", " << card3Num << ", " << card4Num << ", " << card5Num << endl;
                
            }
        }
        seed++;
    }

    return 0;
}

int main() {
    main1();
    main2();
    main3();
    main4();

}
