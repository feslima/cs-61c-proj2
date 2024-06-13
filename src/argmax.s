.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    li t0, 1
    blt a1, t0, error_empty_vector

    # Prologue
    addi sp sp -20
    sw ra 16(sp)
    sw s3 12(sp)
    sw s2 8(sp)
    sw s1 4(sp)
    sw s0 0(sp)

    mv s0, a0
    mv s1, a1

    li t0, 0        # int i = 0
    li t1, 1
    srli t1, t1, 31 # t1 = current max value
    mv s2, t0       # s2 = index of current max
    
    j loop_start

error_empty_vector:
    li a1 7
    jal exit2

loop_start:
    bge t0, s1, loop_end

    slli t2, t0, 2 # stride of 4 bytes
    add s3, s0, t2 # &(arr[i])
    lw t3, 0(s3)   # *(arr[i])
    
    sub t4, t3, t1 # t4 = current_max - *(arr[i])
    bgtz t4, update_max
    after_update_max:
    
    addi t0, t0, 1 # i++
    j loop_start

update_max:
    mv t1, t3
    mv s2, t0
    j after_update_max

loop_end:
    mv a0, s2

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw ra 16(sp)
    addi sp sp 20

    ret