.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    ble a2, zero, error_empty_vector
    ble a3, zero, error_no_stride
    ble a4, zero, error_no_stride

    # Prologue
    addi sp sp -28
    sw ra 24(sp)
    sw s5 20(sp)
    sw s4 16(sp)
    sw s3 12(sp)
    sw s2 8(sp)
    sw s1 4(sp)
    sw s0 0(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    
    li s5, 0 # sum = 0
    li t0, 0 # i = 0
    j loop_start

error_empty_vector:
    li a1 5
    jal exit2

error_no_stride:
    li a1 6
    jal exit2

loop_start:
    bge t0, s2, loop_end

    mv t1, s0
    mv t2, s3
    jal load_value
    mv t3, t1 # store a for now
    
    mv t1, s1
    mv t2, s4
    jal load_value
    mv t2, t1  # t2 = b
    mv t1, t3  # t1 = a
    
    mul t3, t1, t2 # a * b
    add s5, s5, t3 # sum += a * b
    
    addi t0, t0, 1 # i++
    j loop_start

loop_end:
    mv a0, s5

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw ra 24(sp)
    addi sp sp 28
    
    ret
    
load_value:
    # inputs
    # t1 -> address or vector
    # t2 -> stride
    #
    # outputs
    # t1 -> *(a[i])
    mul t2, t0, t2
    slli t2, t2, 2 # each number is stored in 4 bytes
    add t1, t1, t2 # &(a[i])
    lw t1, 0(t1)   # t1 = *(a[i])

    ret