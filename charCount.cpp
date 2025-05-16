#include <iostream>

int isVowel(char character);

int main() {
	std::string text{ "My name is Ozymandias, king of kings 60" };
	int spacesCount{ 0 };
	int vowelsCount{ 0 };
	int consonantsCount{ 0 };
	int numbersCount{ 0 };

	for (char i = 0; i < text.size(); i++)
	{
		char character = text[i];

		if (character == 32) {
			spacesCount++;
		}
		else if (__ascii_isalpha(character)) {
			if (isVowel(character) == 1) {
				vowelsCount++;
			}
			else {
				consonantsCount++;
			}
		}
		else {
			numbersCount++;
		}
	}

	std::cout << "\nspaces: " << spacesCount;
	std::cout << "\nconsonants: " << consonantsCount;
	std::cout << "\nvowels: " << vowelsCount;
	std::cout << "\nnumbers: " << numbersCount;

	return 0;
}

int isVowel(char character) {
	int vowels[]{ 65, 69, 73, 79, 85 };

	for (int j = 0; j < sizeof(vowels); j++)
	{
		if (toupper(character) == vowels[j]) {
			return 1;
		}
	}
	return 0;
}