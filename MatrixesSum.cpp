#include <iostream>

const short int ROWS{ 3 };
const short int COLS{ 3 };

void printMatrix(int matrix[ROWS][COLS]);

int main() {

	int matrixOne[ROWS][COLS] = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
	int matrixTwo[ROWS][COLS] = { {9, 8, 7}, {6, 5, 4}, {3, 2, 1} };

	int matrixSum[ROWS][COLS] = { {0, 0, 0}, {0, 0, 0}, {0, 0, 0} };

	for (short int row = 0; row < ROWS; row++) {
		for (short int col = 0; col < COLS; col++) {
			matrixSum[row][col] = matrixOne[row][col] + matrixTwo[row][col];
		}
	}

	printMatrix(matrixOne);
	printMatrix(matrixTwo);
	printMatrix(matrixSum);

	return 0;
}

void printMatrix(int matrix[ROWS][COLS]) {
	std::cout << std::endl;
	for (short int row = 0; row < ROWS; row++) {
		for (short int col = 0; col < COLS; col++) {
			std::cout << matrix[row][col] << " ";
		}
		std::cout << std::endl;
	}
}