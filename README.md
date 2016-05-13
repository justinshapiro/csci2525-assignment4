##Assignment 5##
1. a. Create a procedure (usrInput) that asks the user for N, j and k. All will be
unsigned and will have to be passed back to the calling procedure (main for
example, but not necessarily). NO GLOBAL LABELS.
b. Create a procedure (ArrayFill) that fills an array of doublewords with N (N <
50) random integers, making sure the values fall within the range j…k inclusive.
When calling the procedure, pass a pointer to the array that will hold the data,
pass N, and pass the values of j and k. Preserve all register values between calls
to the procedure.
2. Write a procedure (RandomColor) that randomly generates an integer
between 0 and 9. Use this integer along with the hint below to pick what color
will be used when displaying text. Use a loop to display the elements of a
randomly generated array (see part 1) (each on its own line) 20 times, each line
with a randomly chosen color.
The probabilities for each color are:
White = 30%
Blue = 10%
Green = 60%
HINT: If the integer is between 0-2 (inclusive), choose white
If the integer = 3, choose blue
If the integer is in the range 4-9 (inclusive), choose green.
3. Write a program RandomColor.asm that uses the above procedures. Your
program should also have some sort of menu that provides the following options.
1) Print Randomly Generated Arrays
2) Run again
3) Quit
Ask the user to enter their choice.
Run your program 10 times, do the probabilities hold? I don’t need to see the
results. Just tell me if the probabilities hold. You can do this in a text file and
upload to canvas.

1. Any output will be shown in the console window.
2. You may use any command Chapter 6 and below.
3. Your procedure(s) must be called from the main procedure.
4. Part of the program will be graded on the basis of program style. I reserve the
right to judge style as I deem fit for the assignment. The use of comments is
required and not optional.
5. Upload to Canvas prior to the due date.