# Written by: Robert Lopez
# ASM 6 UofA 
# Description:
#	This program simulates an Enigma Machine.
#
.data
prompt:
	.asciiz "Enter your 4 letter word: "
prompt2: 
	.asciiz "Enter your 4 letter word to decrypt: "
promptForEncryption:
	.asciiz "Encrypted: "
promptForDecryption: 
	.asciiz "Decrypted: "
user: 
	.space 5	# including /0	# TODO, increase this later
optionPrompt:
	.asciiz "Press 0 to encrypt or press 1 to decrypt your word:\n"
option:
	.space 4
optionError:
	.asciiz "Error: Please type 0 or 1 only.\n"
rotor1:
	.space 4
rotor2:
	.space 4
rotor3:
	.space 4
rotorSum:
	.word 0
rotorPrompt1:
	.asciiz "Enter rotor 1 num (0-9):\n"
rotorPrompt2:
	.asciiz "Enter rotor 2 num (0-9):\n"
rotorPrompt3:
	.asciiz "Enter rotor 3 num (0-9):\n"
printAgain:
	.asciiz "Run again? (y/n)\n"
againAnswer:
	.space 4
againError:
	.asciiz "Error: Please type Y or N only.\n"
.text
.globl enigmaMachine
enigmaMachine:
	# The following function follows this C code:
	#	string enigmaMachine( ) {
	#		string prompt = "Enter your 4 letter word to encode: ";
	#		string user;
	# 		scanf("%d", &user);
	#		
	#		for (int i=0; i < len(user); i++){
	#			user[i] += user[i] + rotor1 + rotor2 + rotor3
	#			}
	#		return user
	#	Registers:
	#		s0 = userWord
	#
main:
	#print welcome screen
.data
welcome1:	.asciiz "Welcome to Engima Machine 1.0"	
.text
	addi	$v0, $zero, 4
	la 	$a0, welcome1
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# This function will ask the user to type in a word,
	# then it will ask the user if they wish to encrypt
	# or decrypt that word.
	#
	# add to the stack frame, enough to hold 4 extra bits
	addi	$sp, $sp, 4
	# print prompt asking user for type in their word
	addi	$v0, $zero, 4
	la 	$a0, prompt
	syscall
	# get input from user
	la	$a0, user		# store input in this register
	li	$a1, 5			# max chars into a1 user can type is 5 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# print prompt asking user for rotor 1 num
	addi	$v0, $zero, 4
	la 	$a0, rotorPrompt1
	syscall
	# get input from user
	la	$a0, rotor1		# store input in this register
	li	$a1, 2			# max chars into a1 user can type is 5 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# print prompt asking user for rotor 1 num
	addi	$v0, $zero, 4
	la 	$a0, rotorPrompt2
	syscall
	# get input from user
	la	$a0, rotor2		# store input in this register
	li	$a1, 2			# max chars into a1 user can type is 5 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# print prompt asking user for rotor 1 num
	addi	$v0, $zero, 4
	la 	$a0, rotorPrompt3
	syscall
	# get input from user
	la	$a0, rotor3		# store input in this register
	li	$a1, 2			# max chars into a1 user can type is 5 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# set s0 = user
	la	$s0, user
getOption:
	# This function will ask the user to type in 0 or 1 to 
	# either encrypt or decrypt their word respectively. If 
	# the user types in anything other than 0 or 1 the function
	# will repeat until they do.
	# 
	# print option prompt to check if user wants to encrpyt or decrypt a word
	addi	$v0, $zero, 4
	la 	$a0, optionPrompt
	syscall
	# get input from user
	la	$a0, option		# store input in this register
	li	$a1, 2			# max chars into a1 user can type is 2 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	# if option == 1, go to encrypt function, else go to decrypt function
	la	$t1, option			# t1 = &option
	lb	$t2, 0($t1)			# t1 = option
	subi	$t2, $t2, 48
	addi	$t3, $zero, 1			# t2 = 1 for checking branch
	beq	$t2, $zero, encrypt		# if t1 = zero, encrypt
	beq	$t2, $t3, decrypt		# if t2 = one, decrypt
	# print error is 0 or 1 was not typed by user
	addi	$v0, $zero, 4
	la 	$a0, optionError
	syscall
	j 	getOption
addRotors:
	
encrypt:
	# This function ecrypts the users word by 
	# running a for loop which checks each letter
	# then switches them and places them in the stack.
	#	
	# create 'i' for the for-loop to check users letters 
	li	$t0, 0
checkWordsLoop:
	# For loop follows this code:
	#	for (int i = 0; i < 5; i++){
	#		encrypted[i] = word[i] + 2 + rotor1 + rotor2 + rotor3;
	#		i++
	slti	$t1, $t0, 4			# t1 = i < 5
	beq	$t1, $zero, printWordsLoop	# if 0 >= 1, end loop
	# check word[i] 
	add	$t2, $zero, $t0		# t2 = i
	add	$t2, $s0, $t2		# t2 = &word[i]
	lb	$t3, 0($t2)		# t3 = word[i]
	#addi	$t3, $t3, 2		# t3 = word[i] + 2
	# t4 = &rotor1
	la	$t4, rotor1
	# t4 = rotor1
	lw	$t4, 0($t4)
	# t3 = word[i] + rotor1 
	add	$t3, $t3, $t4
	# t4 = &rotor1
	la	$t4, rotor2
	# t4 = rotor1
	lw	$t4, 0($t4)
	# t3 = word[i] + rotor1 + rotor2 
	add	$t3, $t3, $t4
	# t4 = &rotor3
	la	$t4, rotor3
	# t4 = rotor1
	lw	$t4, 0($t4)
	# t3 = word[i] + rotor1 + rotor2 + rotor3
	add	$t3, $t3, $t4
	# calculating mod -> a-[n*(a/n)]
	li	$t4, 26
	divu	$t5, $t3, $t4	# a/n
	mult	$t5, $t4 
	mflo	$t6
	sub	$t3, $t3, $t6
	# add 90 so we print letters only from ascii table
	addi	$t3, $t3, 97
	# add it to stack
	add	$t2, $zero, $t0		# t2 = i
	add	$t2, $sp, $t2		# t2 = &sp[i]
	sb	$t3, 0($t2)		# sp[i] = word[i] + rotor1
	addi	$t0, $t0, 1		# i += 1
	j checkWordsLoop
printWordsLoop:
	# print out encrypted word prompt first, 
	addi	$v0, $zero, 4
	la	$a0, promptForEncryption
	syscall
	# set int i to t0
	li	$t0, 0
getEncryptedWords:
	#	for (int i = 0; i < 4; i++){
	#		printf('%d', encrypt[i]);
	#		i++;
	slti	$t1, $t0, 4			# t1 = i < 5
	beq	$t1, $zero, endLoop		# if 0 >= 1
	# get words from stack frame
	add	$t2, $zero, $t0
	add	$t2, $sp, $t2
	lb	$t3, 0($t2)
	addi	$v0, $zero, 11
	add	$a0, $zero, $t3
	syscall	
	addi	$t0, $t0, 1
	j getEncryptedWords
endLoop:
	# print newline
	addi	$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	j endEnigma
decrypt:
	li	$t0, 0
checkWordsLoopDecrypt:
	# For loop follows this code:
	#	for (int i = 0; i < 5; i++){
	#		decrypted[i] = word[i] - 2;
	#		i++
	slti	$t1, $t0, 4			# t1 = i < 5
	beq	$t1, $zero, printWordsLoop2	# if 0 >= 1, end loop
	# check word[i] 
	add	$t2, $zero, $t0		# t2 = i
	add	$t2, $s0, $t2		# t2 = &word[i]
	lb	$t3, 0($t2)		# t3 = word[i]
	#subi	$t3, $t3, 2		# t3 = word[i] - rotor1
	# load up rotor 1
	la	$t4, rotor1
	lw	$t4, 0($t4)
	# t3 = word[i] - rotor1
	sub	$t3, $t3, $t4
	# load up rotor 2
	la	$t4, rotor2
	lw	$t4, 0($t4)
	# t3 = word[i] - rotor1 - rotor2
	sub	$t3, $t3, $t4
	# load up rotor 1
	la	$t4, rotor3
	lw	$t4, 0($t4)
	# t3 = word[i] - rotor1 - rotor2 - rotor3
	sub	$t3, $t3, $t4
	subi	$t3, $t3, 8
	# calculating mod -> a-[n*(a/n)]
	li	$t4, 26
	divu	$t5, $t3, $t4	# a/n
	mult	$t5, $t4 
	mflo	$t6
	sub	$t3, $t3, $t6
	# add 90 so we print letters only from ascii table
	addi	$t3, $t3, 97
	#load up t3 % 26
	add	$t2, $zero, $t0		# t2 = i
	add	$t2, $sp, $t2		# t2 = &sp[i]
	sb	$t3, 0($t2)		# sp[i] = word[i] - 2
	addi	$t0, $t0, 1		# i += 1
	j checkWordsLoopDecrypt
printWordsLoop2:
	# print out encrypted word prompt first, 
	addi	$v0, $zero, 4
	la	$a0, promptForDecryption
	syscall
	# set int i to t0
	li	$t0, 0
getDecryptedWords:
	#	for (int i = 0; i < 4; i++){
	#		printf('%d', encrypt[i]);
	#		i++;
	slti	$t1, $t0, 4			# t1 = i < 5
	beq	$t1, $zero, endLoop		# if 0 >= 1
	# get words from stack frame
	add	$t2, $zero, $t0
	add	$t2, $sp, $t2
	lb	$t3, 0($t2)
	addi	$v0, $zero, 11
	add	$a0, $zero, $t3
	syscall	
	addi	$t0, $t0, 1
	j getDecryptedWords
endEnigma:
	addi $v0, $zero, 4
	la   $a0, printAgain
	syscall
	# get input from user
	la	$a0, againAnswer		# store input in this register
	li	$a1, 2			# max chars into a1 user can type is 5 (including /0) TODO: Increase this later
	li	$v0, 8			# syscall read string
	syscall
	la	$t0, againAnswer
	lw	$t0, 0($t0)
	subi	$t1, $t0, 121
	beq	$t1, $zero, enigmaMachine
	subi	$t1, $t0, 110
	beq	$t1, $zero, exit
	addi $v0, $zero, 4
	la   $a0, againError
	syscall
	j endEnigma
	
exit:
	addi $v0, $zero, 10
	syscall
