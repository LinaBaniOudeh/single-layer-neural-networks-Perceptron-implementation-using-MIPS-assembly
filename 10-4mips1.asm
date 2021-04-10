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

msgLr:.asciiz "learning Rate: "

msgIteration:.asciiz "          end of iteration number : "


weights:.float 0.3 -0.1 

threshold:.float 0.2
learningRate: .float 0.1
momentum:.float 0.95

lrDec: .float 0.7
lrInc: .float 1.05
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
        lwc1 $f20,momentum
        lwc1 ,$f14,learningRate
li $t6,5 #number of iteration
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
li $s1,0
li $s4,0
wx:
	lwc1 $f2,weights($s1)#w    
	lwc1 $f3,input($s2)#x
	cvt.s.w $f3, $f3
	lw $t1,input($s2)

	
	#swc1 $f1,wStor($s1)#w    
	#swc1 $f3,inStor($s2)#x
	
	#cvt.s.w $f1, $f1
	beq $t1,$t3,print1 # end of cuurent epochs 
	

	
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
        j c
 TARG : mov.s $f7,$f0

c:

lwc1 $f8,output($s3)
cvt.s.w $f8, $f8

sub.s $f11,$f8,$f7 # erorr

mul.s $f15,$f11,$f14 # e*LR





mul.s $f21,$f11,$f11    #squre error 



add.s $f22,$f21,$f22

li $v0, 2       ###erorr print 
mov.s $f12,$f11
syscall

li $v0,11 
li $a0,32
syscall



addi $s3,$s3,4
li $s0,0 


wn:

lwc1 $f16,weights($s4)#w    
lwc1 $f17,input($s5)#x

cvt.s.w $f17, $f17

mul.s $f18,$f17,$f15 # e*LR*x
mul.s $f16,$f16,$f20 #momentun*w

add.s $f19,$f16,$f18 # Wn=momentun*w+e*LR*x


li $v0, 2 
mov.s $f12,$f19
syscall

li $v0,11 
li $a0,32
syscall


swc1 $f19,weights($s4)#w new wights  




addi $s0,$s0,1
addi $s4,$s4,4
addi $s5,$s5,4

blt   $s0,$s7,wn



li $v0,11 
li $a0,10
syscall


j perceptron

print1:



li $t9,1
blt $t7,$t9,continue


li $v0, 2        ####previous  squre error Print
mov.s $f12,$f23
syscall

li $v0,11 
li $a0,10
syscall



#$ f23=previous  squre error
#$ f22=Current squre error

  
lwc1 $f24,lrDec #0.7
lwc1 $f25,lrInc #1.05
 
c.lt.s $f22, $f23  # CC = $f23 < $f22 
       bc1t TARG1          # Branch if $f6 < $f0
       mul.s $f14,$f14,$f24
      j cc
TARG1 :mul.s $f14,$f14,$f25

cc:


continue:


addi $t7,$t7,1

li $v0, 2       ###erorr squre  print 
mov.s $f12,$f22
syscall

li $v0,11 
li $a0,10
syscall

mov.s $f23,$f22 #previous  squre error
mov.s $f22,$f0




addi $v0, $zero, 4  # print_string syscall
la $a0,msgLr    # load address of the string
syscall

li $v0, 2       ###erorr squre  print 
mov.s $f12,$f14
syscall

li $v0,11 
li $a0,10
syscall





addi $v0, $zero, 4  # print_string syscall
la $a0,msgIteration      # load address of the string
syscall


move $a0,$t7 
li $v0,1
syscall


li $v0,11 
li $a0,10
syscall



blt   $t7,$t6,epochs



exit:

 
   
li $v0,10
syscall
