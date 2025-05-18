#include <iostream>

int isVowel(char character);

int main() {
	std::string text{ "My name is Ozymandias, king of kings 60" };
	int spacesCount{ 0 };
	int vowelsCount{ 0 };
	int consonantsCount{ 0 };
	int numbersCount{ 0 };
	char character;

	for (char i = 0; i < text.size(); i++)
	{
		character = text[i];

		if (character == 32) {
			spacesCount++;
		}
		else if (__builtin_isalpha(character)) {
			if (isVowel(character) == 1) {
				vowelsCount++;
			}
			else {
				consonantsCount++;
			}
		}
		else if (isdigit(character)) {
			numbersCount++;
		}
	}

	std::cout << "Spaces: " << spacesCount << std::endl;
	std::cout << "Consonants: " << consonantsCount << std::endl;
	std::cout << "Vowels: " << vowelsCount << std::endl;
	std::cout << "Numbers: " << numbersCount << std::endl;

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