#A address 00000000h

L0:add $1,$0,$0		#a=$1
   add $2,$0,$0		#i=$2
   addi $3,$0,5		#j=$3

L1:slti $4,$2,5		#if i<5 $4=1, else $4=0
   beq $4,$0,L8

   addi $3,$0,5

L4:slt $5,$2,$3	#if i<j $5=1, else $5=0
   beq $5,$0,L3

   add $6,$1,$3		#Compute the address of a[j]
   lw $7,0($6)		#$7=a[j]
   lw $8,-1($6)		#$8=a[j-1]
   slt $9,$7,$8		#if(a[j]<a[j-1]) $9=1
   beq $9,$0,L5
   add $10,$0,$7
   sw $8,0($6)
   sw $10,-1($6)


L5:addi $3,$3,-1
   j L4
L3:addi $2,$2,1
   j L1

L8:add $1,$0,$0
L6:lw $2,0($1)
   sw $2,0($1)
   lw $2,1($1)
   sw $2,1($1)
   lw $2,2($1)
   sw $2,2($1)
   lw $2,3($1)
   sw $2,3($1)
   lw $2,4($1)
   sw $2,4($1)
   lw $2,5($1)
   sw $2,5($1)
L7:j L6