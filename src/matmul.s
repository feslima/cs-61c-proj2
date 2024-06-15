.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 2
    ble a1, zero, error_matrix
    ble a2, zero, error_matrix

    li t0, 3
    ble a4, zero, error_matrix
    ble a5, zero, error_matrix

    li t0, 4
    sub t1, a2, a4  # must be zero (cols_m0 == rows_m1)
    bnez t1, error_matrix

    # Prologue
    addi sp, sp, -40
    sw ra, 36(sp)
    sw s8, 32(sp)
    sw s7, 28(sp)
    sw s6, 24(sp)
    sw s5, 20(sp)
    sw s4, 16(sp)
    sw s3, 12(sp)
    sw s2, 8(sp)
    sw s1, 4(sp)
    sw s0, 0(sp)
    
    jal save_registers
    
    li s7, 0 # d_idx = 0
    mul s8, s1, s5 # number of elements of d (m0_rows * m1_cols)
    j loop_start


loop_start:
    bge s7, s8, loop_end
    
    mv a1, s7
    mv a2, s5
    jal ind2sub # [a0, a1] = ind2sub(d_idx, m1_cols)
    mv t0, a0 # t0 = i
    mv t1, a1 # t1 = j
    
    mul a0, t0, s2 # i * m0_cols
    slli a0, a0, 2 # multiply by 4 to align the array address
    add a0, a0, s0 # &m0[i * m0_cols]
    
    slli t1, t1, 2 # multiply by 4 to align the array address
    add a1, t1, s3 # &m1[j]
    
    mv a2, s2 # size of the vectors used in dot product (m0_cols)
    li a3, 1  # stride of v0 (1)
    mv a4, s5 # stride of v1 (m1_cols)
    
    jal dot
    
    slli t3, s7, 2 # multiply by 4 to align the array address
    add t3, s6, t3 # &d[d_idx]
    sw a0, 0(t3)   # *(d[d_idx]) = dot(v0, v1)
    
    addi s7, s7, 1 # d_idx++
    j loop_start

loop_end:
    mv a6, s6

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    ret

save_registers:
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    ret
    
error_matrix:
    add a1, t0, zero 
    jal exit2