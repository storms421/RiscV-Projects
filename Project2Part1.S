# Project2Part1.S
# Noah Storms

.text
.globl main

main:
  # Load the address of matrix to registers
  la a2, matrix
  # Save the address for later callbacks
  mv t6, a2

  # Load the address of the avg array into a register
  la a3, avg

  # Call the avg_columns function
  call avg_columns

  # Exit program
  li a7, 10           # Exit system call code
  ecall

avg_columns:
    # Save return address on stack
    addi sp, sp, -4
    sw ra, 0(sp)

  li t0, 0           # Initialize outer loop counter i to 0
  li a0, 2          # Initialize row amount
  li a1, 3           # Initialize column amount
  li t3, 0           # Initialize address pointer to hit each element in every row for current column
  li a4, 4          # Setting base increment in address memory
  li a5, 0         # Column locator
 
  mul t3, a1, a4   # Set distance to move for next element

  avg_columns_outer_loop:
    bge t0, a1, end_avg_columns_outer_loop  # Exit the outer loop if i >= col

    li t1, 0           # Initialize sum to 0
    li t2, 0           # Initialize inner loop counter k to 0
    
    mul a6, a5, a4  # Determine the next column to point to in array (for matrix)
    add a2, t6, a6  # Set the new pointer to the next column

    avg_columns_inner_loop:
      bge t2, a0, end_avg_columns_inner_loop  # Exit the inner loop if k >= row

      lb t4, 0(a2)     # Load matrix[k][i] into t4
      add t1, t1, t4    # Add matrix[k][i] to sum
      
      add a2, a2, t3   # Move to the next element in the column
      addi t2, t2, 1   # Increment the inner loop counter k
      j avg_columns_inner_loop

    end_avg_columns_inner_loop:

   jal ra, do_divide    # Call do_divide
    sw t1, 0(a3)        # Store the result in avg[i]

    addi a3, a3, 4     # Move to the next element in the avg array
    addi t0, t0, 1     # Increment the outer loop counter i
    addi a5, a5, 1    # Increment for the next column
    j avg_columns_outer_loop

  end_avg_columns_outer_loop:
     # Reload return address to return to main
     lw ra, 0(sp)
     addi sp, sp, 4
     ret

do_divide:
    # Store anything that needs to be preserved to stack
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)

    li t5, 0  # Initialize quotient

# Divides the integers    
loop_divide:
    blt t1, a0, exit_divide # If remainder value is less than divisor, jump
    sub t1, t1, a0 # Subtract divisor from dividend (remainder for next iterations)
    addi t5, t5, 1 # Add to quotient the whole number 
    j loop_divide

exit_divide:
    mv t1, t5 # Store quotient in proper register

     # Reload old data back into respected registers
    lw ra, 0(sp)
    lw a0, 4(sp) 
    addi sp, sp, 8
    ret

.data
matrix: 
    .word 0, 1, 2, 1, 2, 3
avg:    
    .word 0, 0, 0
