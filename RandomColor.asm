TITLE RandomColor.asm
; Best viewed in Notepad++
; Formating (comments, etc.) looks sloppy in Visual Studio and Notepad

INCLUDE Irvine32.inc	; Needed for the following procedures:
						;	- Randomize 
						;	- RandomRange
						; 	- WriteDec
						; 	- Crlf
						;	- SetTextColor
						; 	- WriteString
						; 	- ReadInt
						;   - ReadDec
						;   - WaitMsg

.data
	; Strings for various prompts displayed throughout the program
	numTimes	BYTE "Instance #: ", 0
	menuPrompt  BYTE "Enter your choice: ", 0
	menu1	    BYTE "1) Print Randomly Generated Arrays", 0
	menu2	    BYTE "2) Run again", 0
	menu3	    BYTE "3) Quit", 0
	menu4		BYTE "4) Help", 0
	menuSelect  BYTE "Choice: ", 0
	menuErr		BYTE "Sorry, that is not a valid selection. Please try again...", 0
	help1		BYTE "Option 1 prints different string of numbers every time in different colors", 0
	help2		BYTE "Option 2 prints the same string of numbers previously generated in Option 1, but the colors of each string will be different. ", 0
	help3		BYTE 'In order to select Option 2, you must have selected Option 1 at least once, or else there is nothing to "Run again"', 0
	prompt1     BYTE "Please input the following values...", 0
	prompt2     BYTE "Enter N (0 < N < 50): ", 0 
	prompt3     BYTE "Enter j (lower-bound): ", 0
	prompt4     BYTE "Enter k (upper-bound): ", 0
	promptErr1  BYTE "Sorry, you must enter a number between 0 and 50 (exclusive)", 0
	promptErr2  BYTE "Sorry, k must be a value greater than j", 0
	spacePrint  BYTE " ", 0
	
	; Constant defined for the limit of the size of N
	NLimit = 50
	
	; Array that holds the random integers and a pointer to the array
	array	    DWORD NLimit DUP(0)
	arrayPtr  	DWORD OFFSET array
	
	; Variables for storing user input, color value, and instance number
	Nvar		DWORD 0
	jvar		DWORD 0
	kvar 		DWORD 0
	stringColor DWORD 0
	count		DWORD 1
	

.code

	;=======================================================================;
	;--------------------------- MAIN PROCEDURE ----------------------------;
	; Function: Displays a menu, calls usrInput to get the values of N,     ;
	;			j, and k from the user in order to pass to ArrayFill to     ;
	;			produce a random string. The string is then printed to the  ;
	;			terminal window.											;
	; Requires: nothing														;
	; Recieves: nothing														;
	; Returns:  nothing														;
	; Postcondition: terminal window is filled with a random string, which  ;
	;				 will vary depending on what the user selected in the   ;
	;				 menu at the beginning of the program.                  ;
	;=======================================================================;
	main PROC
		
		; DISPLAY MENU
		Menu:
			mov edx, OFFSET numTimes			; Display instance number
				call WriteString
			mov eax, count
				call WriteDec
			
			call Crlf							; Print line to terminal (more reliable than appending 0dh, 0ah to string )
			call Crlf
			
			mov edx, OFFSET menuPrompt			; Prompt user to choose a menu selection
				call WriteString
			
			call Crlf
			
			mov edx, OFFSET menu1				; 1) Print Randomly Generated Arrays
				call WriteString
			
			call Crlf
			
			mov edx, OFFSET menu2				; 2) Run again
				call WriteString
			
			call Crlf
			
			mov edx, OFFSET menu3				; 3) Quit
				call WriteString
				
				call Crlf
			
			mov edx, OFFSET menu4				; 4) Help
				call WriteString
			
			call Crlf
			call Crlf
			
			mov edx, OFFSET menuSelect			; Prompt user for selection
				call WriteString
			
			call ReadDec						; Use conditional jumps to direct the user to the desired part of the program
				cmp eax, 1
					je option1
				cmp eax, 2
					je option2
				cmp eax, 3
					je option3
				cmp eax, 4
					je option4
				jmp menuError					; If the user entered an invalid value, they are given an error message and menu is reprinted 
				menuError:
					mov edx, OFFSET menuErr
					call WriteString
					call Crlf
					call Crlf
					jmp Menu
					
		option4:								; Help describes how I interped the instructions. Run again should print the same randomly generated
												; string, but serves the purpose of testing if the color probabilities hold. 
			mov edx, OFFSET help1				; If a new string is desired, the user will have to choose option 1
				call WriteString
				
			call Crlf
			
			mov edx, OFFSET help2				; To test color probability, choose option two
				call WriteString
				
			mov edx, OFFSET help3				; To test color probability, choose option two
				call WriteString
			
			call Crlf
			call Crlf
			
			call WaitMsg						; Let user review screen before returning to menu
			call Clrscr							; Terminal screen will be cleared to start fresh
			jmp Menu	
			
		call Randomize
		
		option1:			; Option 1 differes only by calling usrInput and ArrayFill in order to generate a new string	
			call usrInput
			pushad
			call ArrayFill
			popad
			
		option2:								; Option 1 and Option 2 both run through the code under the label option2
			cmp Nvar, 0
				je Menu
			call RandomColor					
			mov eax, stringColor			
			call SetTextColor					; Color of the string printed will be either white, green, or blue	
			
			mov ecx, Nvar
			mov esi, arrayPtr			
			L2:							
				mov al, BYTE PTR [esi]	
				call WriteDec
				inc esi	
				mov edx, OFFSET spacePrint		; A space is printed in between numbers in order to be clear of what numbers are being printed
				call WriteString
			loop L2											
			
			call Crlf		
			call Crlf
			call Crlf
			
			mov eax, 7							; Since the color of the text on the terminal was set to change for the string, it should be changed 
												; back to default for the rest of the program as it repeats the menu until the user selects Option 3			
			call SetTextColor
			
			inc count
			jmp Menu
			
		option3:								; Option 3 simply directs the user to the end of the program so it can exit
			exit
			
	main ENDP

	
	
	;=======================================================================;
	;-------------------------- userInput PROCEDURE ------------------------;
	; Function: prompts the user to enter N, j, and k, provides basic error ;
	;			checking, and passes these values back to main				;
	; Requires: nothing														;
	; Recieves: nothing														;
	; Returns:  N, j, and k in the form of variables						;
	; Postcondition: terminal window is filled with a random string, which  ;
	;				 will vary depending on what the user selected in the   ;
	;				 menu at the beginning of the program.                  ;
	;=======================================================================;
	usrInput PROC
		
		call Crlf
		
		mov edx, OFFSET prompt1					; Prompt the user to enter the following values
			call WriteString
		
		call Crlf
		call Crlf		
		
		GetN:
			mov edx, OFFSET prompt2				; Prompt user to enter N
				call WriteString
			call ReadInt
				cmp eax, NLimit
					jge NError					; Go to label to display error if entry is not within (0,50)
				cmp eax, 0
					je NError
			mov Nvar, eax
		
		GetJ:
			mov edx, OFFSET prompt3				; Prompt user to enter j
				call WriteString
			call ReadInt
			mov jvar, eax						; No integer value is considered invalid in this case
			
		GetK:
			mov edx, OFFSET prompt4				; Prompt user to enter k
				call WriteString
			call ReadInt
				cmp eax, jvar
					jle KError					; Go to label to display error if entry is not greater than j
			mov kvar, eax
			jmp skipErrors
		
		NError:
			mov edx, OFFSET promptErr1
				call WriteString
			
			call Crlf
			call Crlf
			
			jmp GetN
		
		KError:	
			mov edx, OFFSET promptErr2
				call WriteString
			
			call Crlf
			call Crlf
			
			jmp GetK
		
		skipErrors:								; If no more errors need to be displayed user should be brought here so procedure can correctly exit
	ret
	usrInput ENDP
	
	
	
	;=======================================================================;
	;-------------------------- ArrayFill PROCEDURE ------------------------;
	; Function: fills array of random integers based on the values of N, j, ;
	;			and k passed in from main                                   ;
	; Requires: Nvar, jvar, and kvar										;
	; Recieves: Nvar, jvar, and kvar										;
	; Returns:  an array filled with random integers for string	     		;
	; Postcondition: an array filled with random integers based on N, j,	;
	;				 and kvar								                ;
	;=======================================================================;
	ArrayFill PROC

		mov esi, arrayPtr
		mov ecx, Nvar
		mov eax, kvar
		sub eax, jvar							; subtract jvar from kvar to bring range in terms the lower bound starting at 0
		inc eax
		mov ebx, eax
		L1:
			mov eax, ebx
			call RandomRange
			add eax, jvar						; add the lower bound to modified range in order return a random integer in the specified range
			mov [esi], eax
			inc esi
		loop L1

	ret
	ArrayFill ENDP

	
	
	;=======================================================================;
	;------------------------ RandomColor PROCEDURE ------------------------;
	; Function: creates a value corresponding to one of three colors that 	;
	;			can be generated based on a 30/60/10 probability            ;
	; Requires: nothing														;
	; Recieves: nothing														;
	; Returns:  a variable containing the color code for the string    		;
	; Postcondition: a variable will be available to approriately change	;
	;				 the color of a string									;
	;=======================================================================;
	RandomColor PROC

		mov eax, 10
		call RandomRange
		
		cmp eax, 2
			jle pickWhite
		cmp eax, 3
			je pickBlue
		cmp eax, 9
			jle pickGreen
			
		pickWhite:
			mov eax, 15
			jmp setStringColor
		pickBlue:
			mov eax, 1
			jmp setStringColor
		pickGreen:
			mov eax, 2
			jmp setStringColor
		
		setStringColor: 
			mov stringColor, eax
		
	ret
	RandomColor ENDP

END main