.data
	array: .word 1,4,7,10,25,3,5,13,17,21
	prompt: .asciiz "\nYour merged array is:"
	startingbracket: .asciiz "a["
	endingbracket: .asciiz "]: "
	newLine: .asciiz "\n"
	else1: .asciiz "else\n"
	while: .asciiz "while1\n"
	result: .word 0:10

.text

main:
	la 	$s0, array
	la	$a0, array
	la      $s7, result
	
	addi $s1, $zero, 0 #low == 0 
	addi $s2, $zero, 9 #high == 9
	addi $s3, $zero, 4 #mid == 4

merge:
	add $t0, $t0, $s1 # $t0 = i (low), i for a[]
	add $t1, $t1, $s1 # $t1 = k (low), k for c[]
	addi $t2, $s3, 1  # $t2 = j (mid + 1)
	addi $t3, $s2, 1  # $t3 = high + 1 (this is so we can just do mid+1 < t3)
	addi $s4, $s3, 1  # $s4 = mid + 1 (this is we can do i < mid )

while1:
	slt $t4, $t0, $s4     # if i < mid + 1, $t4 == 1
	slt $t5, $t2, $t3      # if j < high + 1 (don’t have to do j <= high)
	and $t6, $t4, $t5     #if both $t4 and $t5 returned true, $t6 will be 1
	beq $t6, $zero, while2 #if not both are true, we can skip to the next loop
	

	# $t0 = i, getting a[i]

	sll $t7, $t0, 2   # multiplies i by 4, places that into $t7
	add $t7, $s0, $t7 # $t0 has the address of the a[i] position in mips form
	lw $t8, 0($t7)    # $t8 has the value of a[i] now

	# $t2 = j, getting a[j]
	sll $t7, $t2, 2    # multiplies j by 4, places that into $t7
	add $t7, $s0, $t7  # $t2 has the address of the a[j] position in mips form
	lw $t9, 0($t7)     # $t9 has the value of a[j] now


	# $t1 = k, setting up for c[k] (will use next based off the conditional statement)
	sll $t4, $t1, 2	   # multiplies k by 4, places that into $t4
	add $t4, $s7, $t4  # $t4 should have the position of c[k] in mips form ($s7 because c[])
	# I placed this above the if conditional, so i can use this c[k] in else

	#if a[i] < a[j]
	slt $t6, $t8, $t9
	beq $t6, $zero, else

	
	sw $t8, 0($t4)     # saving $t8 (value of a[i]) into address of $t4, which is c[k]

	addi $t1, $t1, 1   # k++
	addi $t0, $t0, 1   # i++
	j while1

else:

	#t1 = k, getting c[k]
	sll $t4, $t1, 2
	add $t4, $s7, $t4
	
	# $t2 = j, getting a[j]
	sll $t6, $t2, 2
	add $t6, $s0, $t6
	lw $t7, 0($t6)


	sw $t7, 0($t4)     # saving $t7 (value of a[j]) into address of $t5, which is c[k]

	addi $t1, $t1, 1   # k++
	addi $t2, $t2, 1   # j++
	j while1

while2:
	slt $t4, $t0, $s4      # if i < mid, $t3 == 1
	beq $t4, $zero, while3 # it means i < mid is false, so we will check the other conditional
	
	# Will overwrite registers used in while1
	sll $t5, $t1, 2   # finding c[k] again, like in the first while loop, different registers#
	add $t5, $s7, $t5

	sll $t6, $t0, 2
	add $t6, $s0, $t6
	lw $t7, 0($t6)
	
	sw $t7, 0($t5) # saving $t7 (value of a[i]) into address of $t5, which is c[k]
	
	addi $t1, $t1, 1   # k++
	addi $t0, $t0, 1   # i++
	j while2

while3:
	slt $t4, $t2, $t3      # if j < high + 1 
	beq $t4, $zero, for    # will jump to the for loop if false
	

	# Will overwrite registers used in while1 and while2
	sll $t5, $t1, 2	   # multiplies k by 4, places that into $t5
	add $t5, $s7, $t5  # $t5 should have the position of c[k] in mips form ($s7 because c[])

	sll $t6, $t2, 2    # multiplies j by 4, places that into $t6
	add $t6, $s0, $t6  # $t2 has the address of the a[j] position in mips form
	lw $t7, 0($t6)     # $t7 has the value of a[j] now

	sw $t7, 0($t5)     # saves value of $t7 into address of $t5, which is c[k] (c[k] = a[j])
	
	addi $t1, $t1, 1   # k++
	addi $t2, $t2, 1   # j++

	j while3

for:
	slt $t4, $s1, $t1  # for (i < k, because i already starts at low, no need to make a condition)
	beq $t4, $zero, initializeprint
	
	sll $t5, $s1, 2   #value of c[i]
	add $t5, $s7, $t5
	lw  $t6, 0($t5)
	
	sll $t7, $s1, 2  #address of a[i]
	add $t7, $s0, $t7
	
	sw $t6, 0($t7)   #save value of c[i] into a[i]
	
	addi $s1, $s1, 1

	j for 

	
initializeprint:
        addi $t0, $zero, -1 # our i is now -1, so we can use it as a count for 0-9
        addi $t9, $zero, 9  # $t9 will be for when we stop
        
        la $a0, prompt
        addi $v0, $zero, 4
        syscall
        
        la $a0, newLine
	addi $v0, $zero, 4
	syscall
	
        
printif:
	addi $t0, $t0, 1 # i++
	sub $t1, $t0, $t9 # this is i-9, where if $t1 is now greater than 0, it means i > 9
	bgtz $t1, exit
printarray:
	la $a0, startingbracket
	addi $v0, $zero 4
	syscall
	
	add $a0, $t0, $zero
	addi $v0, $zero, 1
	syscall
	
	la $a0, endingbracket
	addi $v0, $zero 4
	syscall
	
	sll $t2, $t0, 2
	add $t2, $t2, $s0
	lw $a0, 0($t2)
	addi $v0, $zero, 1
	syscall
	
	la $a0, newLine
	addi $v0, $zero, 4
	syscall
	
	j printif
	
	
exit:
        addi $v0, $zero, 10 
        syscall
