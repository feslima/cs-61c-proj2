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
    
    li t0, 4
    bgt a3, t0, error_stride_too_long
    bgt a4, t0, error_stride_too_long

    li t0, 3 # no instruction to load 24 bits from memory
    bgt a3, t0, error_stride_unsupported
    bgt a4, t0, error_stride_unsupported

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
    li t5, 'a' 
    j loop_start

error_empty_vector:
    li a1 5
    jal exit2

error_no_stride:
    li a1 6
    jal exit2

error_stride_too_long:
    # at the moment I don't know how to deal with 
    # arrays of numbers greater than 32 bits, since 
    # the specification said the stride was variable
    # but didn't mention anything about strides 
    # greater than the Venus's word size of 32 bits.
    # Therefore, the error.
    li a1 9
    jal exit2

error_stride_unsupported:
    li a1 10
    jal exit2

loop_start:
    bge t0, s2, loop_end

    mv t1, s0
    mv t2, s3
    li t3, 'a'
    li t6, 4
    beq t2, t6, load_value_by_word
    li t6, 2
    beq t2, t6, load_value_by_halfword
    li t6, 1
    beq t2, t6, load_value_by_byte
    after_load_a:
    mv t4, t1 # store a for now
    
    mv t1, s1
    mv t2, s4
    li t3, 'b'
    li t6, 4
    beq t2, t6, load_value_by_word
    li t6, 2
    beq t2, t6, load_value_by_halfword
    li t6, 1
    beq t2, t6, load_value_by_byte
    after_load_b:
    mv t2, t1  # t2 = b
    mv t1, t4  # t1 = a
    
    mul t3, t1, t2 # a * b
    add s5, s5, t3 # sum += a * b
    
    addi t0, t0, 1 # i++
    j loop_start

loop_end:
    mv a0, s5

    # Epilogue
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw ra 24(sp)
    addi sp sp 28
    
    ret
    
load_value_by_word:
    # inputs
    # t1 -> address or vector
    # t2 -> stride
    # t3 -> loading a or b
    #
    # outputs
    # t1 -> *(a[i])
    mul t2, t0, t2
    add t1, t1, t2 # &(a[i])
    lw t1, 0(t1)   # t1 = *(a[i])

    beq t3, t5, after_load_a
    j after_load_b
    

load_value_by_halfword:
    # inputs
    # t1 -> address or vector
    # t2 -> stride
    # t3 -> loading a or b
    #
    # outputs
    # t1 -> *(a[i])
    mul t2, t0, t2
    add t1, t1, t2 # &(a[i])
    lh t1, 0(t1)   # t1 = *(a[i])

    beq t3, t5, after_load_a
    j after_load_b
    
load_value_by_byte:
    # inputs
    # t1 -> address or vector
    # t2 -> stride
    # t3 -> loading a or b
    #
    # outputs
    # t1 -> *(a[i])
    mul t2, t0, t2
    add t1, t1, t2 # &(a[i])
    lb t1, 0(t1)   # t1 = *(a[i])

    beq t3, t5, after_load_a
    j after_load_b