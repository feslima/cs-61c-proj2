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


outer_loop_start:




inner_loop_start:












inner_loop_end:




outer_loop_end:


    # Epilogue
    
    
    ret
    
error_matrix:
    add a1, t0, zero 
    jal exit2