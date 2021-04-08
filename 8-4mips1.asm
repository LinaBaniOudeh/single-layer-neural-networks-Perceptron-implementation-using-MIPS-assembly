# Sa# Sample MIPS program that read a file.
#
.data
fout: .asciiz "test.csv" # filename for output
buffer: .space 100
arr: .word 0:200
NL:.asciiz "\n"



input: .word 0:100 
output: .word 0:100 
 
zero: .float 0.0
one: .float 1.0



inStor: .word 0:100 
wStor: .word 0:100 

msgOut:.asciiz " Output: "
msgin:.asciiz "input: "


msgOld:.asciiz " old wights: "
msgNew:.asciiz " new Wights: "

msgIteration:.asciiz "         iteration number : "


weights:.float 0.2 0.2 0.2 0.1 0.2 0.1 0.1 0.1 

threshold:.float 0.2
learningRate: .float 0.1
momentum:.float 1.0


space: .asciiz "\n"

W1Str: .asciiz "W1= "
W2Str: .asciiz " W2= "
   


.text
main:
	# Open (for reading) a file
	li $v0, 13 
	la $a0, fout 
	li $a1, 0 
	syscall # open a file (file descriptor returned in $v0)
	move $t0, $v0 # save file descriptor in $t0
	# Read to file just opened
	li $v0, 14 
	la $a1, buffer 
	li $a2, 1024
	move $a0, $t0 # put the file descriptor in $a0
	syscall # write to file
	# Get the value from certain address
	#la $a0, buffer 
	#li $v0, 4 
	#syscall
	# Close the file
	li $v0, 16 
	move $a0, $t0 # Restore fd
	syscall # close file
	
	
	
	li $t5,0
	li $t2, 0
	li $t1,0
	li $t4,44
        li $t6,10
        li $t7,13
        li $t5,32
	
	li $s2,0
	li $t1,0
	
	for: 	
	lb      $t0, buffer($t2)   #loading value
	add     $t2, $t2, 1
	
	
	

	beqz    $t0,con
	
	beq  $t0,$t4,print
	beq  $t0,$t5,for
	beq  $t0,$t6,for
	beq  $t0,$t7,print

	append:
	sub $t0,$t0,48
	mul $t1,$t1,10
	add $t1,$t1,$t0
	j for 
	
	print:
	
	move $a0,$t1
	li $v0 ,1
	syscall
	
	li $a0,32
	li $v0 ,11
	syscall
	
	sw $t1,arr($s2)
	addi $s2,$s2,4
	
	
	
	li $t1,0
	
	j for


con:
li $t1,35
sw $t1,arr($s2)	


        li $a0,10 #print
	li $v0,11
	syscall


#la $t1, arr
	li $t1,0
	li $t9,0
	li $s2,0
        li $s0,0
	

li $t0,0
li $t2,0
li $t4,0	

lwc1 $f0,zero	
li $s7,2	
li $t3,35
lwc1 $f0,zero
lwc1 $f2,one	

loop:
li $s1,0 

in:
	lw $t1,arr($t0)
	
	addi $t0,$t0,4
	beq $t1,$t3,con1
	
	
	sw $t1 ,input($t4)
	addi $v0, $zero, 4  # print_string syscall
	la $a0, msgin     # load address of the string
 	syscall
 	
 	move $a0,$t1
	li $v0 ,1
	syscall
	
	li $a0,32
	li $v0 ,11
	syscall
 	

	
	addi $t4,$t4,4


	addi $s1,$s1,1
	bge     $s1,$s7, out  #number of inputs
	j in

out:
lw $t1,arr($t0)
addi $t0,$t0,4
sw $t1 ,output($t2)
addi $t2,$t2,4

sw $t1 ,input($t4)
addi $v0, $zero, 4  # print_string syscall
la $a0, msgOut     # load address of the string
syscall



move $a0,$t1
li $v0 ,1
syscall
	
li $a0,10
li $v0 ,11
syscall


j loop 

con1: 
li $t1,35
sw $t1 ,input($t4)
sw $t1 ,output($t2)

li $a0,10
li $v0 ,11
syscall



	l.s $f0,zero
	l.s $f1,one
        lwc1 $f10,threshold
        lwc1 ,$f14,learningRate
        lwc1 $f20,momentum

li $t6,4 #number of iteration
li $t7,0

epochs:	
			
li $s1,0      
li $s2,0
li $s3,0
	
li $s4,0
li $s5,0
		
				
li $t3,35

li $s7,2	

perceptron:
li $s0,0 
add.s $f5,$f0,$f0

wx:
	lwc1 $f2,weights($s1)#w    
	lwc1 $f3,input($s2)#x
	cvt.s.w $f3, $f3
	lw $t1,input($s2)

	

	
	#swc1 $f1,wStor($s1)#w    
	#swc1 $f3,inStor($s2)#x
	
	#cvt.s.w $f1, $f1
	beq $t1,$t3,print1 
	

	
	mul.s $f4, $f2, $f3 #w.x	
	
	add.s $f5, $f4, $f5 #summtion
	
	addi $s0,$s0,1
	addi $s1,$s1,4
	addi $s2,$s2,4
	
	bge     $s0,$s7,errorOut  #number of inputs
	j wx



errorOut:

add.s $f6,$f0,$f0
sub.s $f6,$f5,$f10 # -threshold

###Step Functoin 
#actual output $f7
 c.lt.s $f6, $f0   # CC = $f0 < $f2 Step Functiom
        bc1t TARG          # Branch if $f6 < $f0
        mov.s $f7,$f1
 TARG : cvt.s.w $f0, $f7

#cvt.s.w $f0, $f7

lwc1 $f8,output($s3)
cvt.s.w $f8, $f8
sub.s $f11,$f8,$f7 # erorr
mul.s $f15,$f11,$f14 # e*LR


addi $s3,$s3,4
li $s0,0 


wn:

lwc1 $f16,weights($s4)#w    
lwc1 $f17,input($s5)#x

cvt.s.w $f17, $f17

mul.s $f18,$f17,$f15 # e*LR*x
mul.s $f16,$f16,$f20 #momentun*w

add.s $f19,$f16,$f18 # Wn=w+e*LR*x



swc1 $f19,wStor($s4)#w 

#li $v0, 2 
#mov.s $f12,$f19
#syscall

#li $v0,11 
#li $a0,32
#syscall



addi $s0,$s0,1
addi $s4,$s4,4
addi $s5,$s5,4

blt   $s0,$s7,wn

j perceptron

print1:


addi $t7,$t7,1

addi $v0, $zero, 4  # print_string syscall
la $a0,msgIteration      # load address of the string
syscall


move $a0,$t7 
li $v0,1
syscall





li $a0,10 #print new line 
li $v0,11
syscall


addi $v0, $zero, 4  # print_string syscall
la $a0, msgOld       # load address of the string
syscall


li $s7,8# get size of list
li $s1, 0 # set counter for # of elems printed
li $s2, 0 # set offset from Array

print_loop:
bge $s1, $s7, print_loop_end # stop after last elem is printed



lwc1 $f3,weights($s2)
li $v0, 2 
mov.s $f12,$f3
syscall

li $a0, 32 # print a newline
li $v0, 11
syscall
addi $s1, $s1, 1 # increment the loop counter
addi $s2, $s2, 4 # step to the next array elem
j print_loop # repeat the loop


print_loop_end: 




li $a0,10 #print new line 
li $v0,11
syscall


addi $v0, $zero, 4  # print_string syscall
la $a0, msgNew      # load address of the string
syscall


li $s7,8# get size of list
li $s1, 0 # set counter for # of elems printed
li $s2, 0 # set offset from Array

print_loop1:
bge $s1, $s7, print_loop_end1 # stop after last elem is printed


#lw $a0,weights($s2) # print next value from the list
#li $v0, 1
#syscall
lwc1 $f3,wStor($s2)
li $v0, 2 
mov.s $f12,$f3
syscall

li $a0, 32 # print a newline
li $v0, 11
syscall
addi $s1, $s1, 1 # increment the loop counter
addi $s2, $s2, 4 # step to the next array elem
j print_loop1 # repeat the loop


print_loop_end1: 

li $a0,10 #print new line 
li $v0,11
syscall



blt   $t7,$t6,epochs



exit:

 
   
li $v0,10
syscall
