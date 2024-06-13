.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    li t0, 1
    blt a1, t0, error_too_small

    # Prologue
    addi sp sp -20
    sw ra 16(sp)
    sw s3 12(sp)
    sw s2 8(sp)
    sw s1 4(sp)
    sw s0 0(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    li t0, 0 # i = 0
    li a2, 0
    j loop_start

error_too_small:
    li a1 8
    jal exit2

loop_start:
    bge t0, s1, loop_end

    slli t2, t0, 2 # stride of 4 bytes
    add s3, s0, t2 # &(arr[i])
    lw t3, 0(s3)   # *(arr[i])
    
    mv a1, t3
    call max # max(*(arr[i]), 0)
    
    sw a0, 0(s3) # *(arr[i]) = max(*(arr[i]), 0)
    
    addi t0, t0, 1 # i++
    j loop_start

loop_end:
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw ra 16(sp)
    addi sp sp 20
    
	ret
