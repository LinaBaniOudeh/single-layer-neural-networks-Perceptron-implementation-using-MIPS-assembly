# Sa# Sample MIPS program that read a file.
#
.data
#fout: .asciiz "test.csv" # filename for output
buffer: .space 100
arr: .word 0:200
NL:.asciiz "\n"

fin: .ascii

input: .word 0:100 
output: .word 0:100 
 
zero: .float 0.0
one: .float 1.0

msg1:.asciiz "Enter File name : \n"
msg2:.asciiz "Enter number of features : \n"
msg3:.asciiz "Enter wights : \n"
msg4:.asciiz "Enter Momentum  : \n"
msg5:.asciiz "Enter learningRate  : \n"
msg6:.asciiz "Enter Threshold  : \n"
msg7:.asciiz "Enter Number of epochs  : \n"
msg8:.asciiz "training file data  : \n"

msg9:.asciiz "\nerror	weights\n"

inStor: .word 0:100 
wStor: .word 0:100 

msgOut:.asciiz " Output: "
msgin:.asciiz " input: "


msgOld:.asciiz " old wights: "
msgNew:.asciiz " new Wights: "

msgLr:.asciiz "learning Rate: "
msgThreshold:.asciiz "Threshold: "
msgIteration:.asciiz "############# end of epoches number : "


#weights:.float 0.3 -0.1 
weights:.float 0:100    

#threshold:.float 0.2
 

lrDec: .float 0.7
lrInc: .float 1.05
space: .asciiz "\n"

W1Str: .asciiz "W1= "
W2Str: .asciiz " W2= "
   
#numOfFeature:.word

.text
main:
	
	addi $v0, $zero, 4  # Enter File name
	la $a0,msg1    
	syscall
	
 	li $v0, 8
    	la $a0, fin 
    	li $a1, 21
    	syscall

      
        jal fileClean
        
	
	addi $v0, $zero, 4 
	la $a0,msg2    #Enter number of feature
	syscall
	
	li $v0, 5        
         syscall          
        
        move $s7,$v0      #store number Of Features      
        

        jal fileRead    

   	addi $v0, $zero, 4 
	la $a0,msg3   #Enter wights
	syscall
        
        li $t0,0
        jal readWights
	
	addi $v0, $zero, 4 
	la $a0,msg4   #Enter Momentum 
	syscall
        
	li $v0, 6        
        syscall 

	mov.s $f20,$f0  #store  momentum
	
	
	addi $v0, $zero, 4 
	la $a0,msg5   #Enter learningRate
	syscall
        
	li $v0, 6        
        syscall 
     
	mov.s $f14,$f0      #store  learningRate
	
	
	addi $v0, $zero, 4 
	la $a0,msg6  #Enter Threshold
	syscall
        
	li $v0, 6        
        syscall 
        
        mov.s $f10,$f0      #store Threshold
	
	addi $v0, $zero, 4 
	la $a0,msg7  #Enter epoches
	syscall
        
	li $v0,5        
        syscall 
        
 
	move $t6,$v0      #store number of epoches
	
	
	
	
	
	li $t5,0
	li $t2, 0
	li $t1,0
	li $t4,44 #comma 
        li $s6,10
        li $t7,13
        li $t5,32 #space 
	
	li $s2,0
	li $t1,0
	
	for: 	
	lb      $t0, buffer($t2)   #loading value
	add     $t2, $t2, 1
	beqz    $t0,con
	
	beq  $t0,$t4,store
	beq  $t0,$t5,for
	beq  $t0,$s6,for
	beq  $t0,$t7,store

	append:
	sub $t0,$t0,48
	mul $t1,$t1,10
	add $t1,$t1,$t0
	j for 
	
	store:
	sw $t1,arr($s2)
	addi $s2,$s2,4
	li $t1,0
	j for


con:
li $t1,35
sw $t1,arr($s2)	


        li $a0,10 #print new line
	li $v0,11
	syscall


	li $t1,0
	li $t9,0
	li $s2,0
        li $s0,0
	

li $t0,0
li $t2,0
li $t4,0	


li $t3,35 # #


	
addi $v0, $zero, 4  # Enter File name
la $a0,msg8    
syscall			
#split file data to input array and output array

loop:
li $s1,0 

in:
	lw $t1,arr($t0)
	
	addi $t0,$t0,4
	beq $t1,$t3,con1
	
	
	sw $t1 ,input($t4) #store in input array 
	addi $v0, $zero, 4  
	la $a0, msgin    # print -> input:   
 	syscall
 	
 	
	move $a0,$t1
	li $v0 ,1
	syscall
	
	li $a0,10
	li $v0 ,32
	syscall
 	

	
	addi $t4,$t4,4


	addi $s1,$s1,1
	bge     $s1,$s7, out  #number of inputs
	j in

out:
lw $t1,arr($t0)
addi $t0,$t0,4

sw $t1 ,output($t2)##store in output array 
addi $t2,$t2,4


addi $v0, $zero, 4 
la $a0, msgOut     
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
       
       
       

li $t7,0

epochs:	

	addi $v0, $zero, 4 
	la $a0,msg9    #error wights
	syscall
	
			
li $s1,0      
li $s2,0
li $s3,0
	
li $s4,0
li $s5,0
		
				
li $t3,35

#li $s7,2 #number of feature	

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
li $a0,9 #rab
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


#li $v0, 2        ####previous  squre error Print
#mov.s $f12,$f23
#syscall

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

#li $v0, 2       ###erorr squre  print 
#mov.s $f12,$f22
#syscall

#li $v0,11 
#li $a0,10
#syscall

mov.s $f23,$f22 #previous  squre error
mov.s $f22,$f0




addi $v0, $zero, 4  
la $a0,msgLr   
syscall

li $v0, 2       ### print learning rate 
mov.s $f12,$f14
syscall

li $v0,11 
li $a0,10
syscall



addi $v0, $zero, 4  
la $a0,msgThreshold   
syscall

li $v0, 2       ### print Threshold
mov.s $f12,$f10
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




###################################  procedures ################################### 

fileClean:
    li $t0, 0       #loop counter
    li $t1, 21      #loop end
clean:
    beq $t0, $t1, L5
    lb $t3, fin($t0)
    bne $t3, 0x0a, L6
    sb $zero, fin($t0)
    L6:
    addi $t0, $t0, 1
j clean
L5:
jr $ra



fileRead :
# Open (for reading) a file
	li $v0, 13 
	la $a0, fin 
	li $a1, 0 
	syscall # open a file (file descriptor returned in $v0)
	move $t0, $v0 # save file descriptor in $t0
	# Read to file just opened
	li $v0, 14 
	la $a1, buffer 
	li $a2, 1024
	move $a0, $t0 # put the file descriptor in $a0
	syscall # write to file
	
	li $v0, 16 
	move $a0, $t0 # Restore fd
	syscall # close file
jr $ra


printNewLine:
 
        li $a0,10 #printNewLine
	li $v0,11
	syscall

jr $ra

printSpace:
	li $a0,10
	li $v0 ,32
	syscall
jr $ra 	


readWights:
li $a1, 4
mul $t9,$a1,$s7      
                                   
 
    
    beq $t0,$t9,exx
     
     li $v0, 6
     syscall
    
    swc1 $f0,weights($t0)
    
    add $t0,$t0,4
   
     j readWights

exx:
    jr $ra


