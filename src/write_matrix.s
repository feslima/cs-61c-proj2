.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 24(sp)
    sw s5, 20(sp)
    sw s4, 16(sp)
    sw s3, 12(sp)
    sw s2, 8(sp)
    sw s1, 4(sp)
    sw s0, 0(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # open the file
    mv a1, s0
    li a2, 1 # write only permission
    jal fopen
    li t0, -1
    beq, a0, t0, error_open
    mv s4, a0 # s4 =  file descriptor
    
    # write file contents
    mv a1, s4
    
    # write rows and columns
    addi sp, sp, -8
    sw s3, 4(sp)
    sw s2, 0(sp)
    mv a2, sp
    li a3, 2 # two elements

    li a4, 4 # 4 bytes per number
    jal fwrite
    bne a0, a3, error_write 
    addi sp, sp, 8 # deallocate used space

    # write the matrix elements
    mv a1, s4
    mv a2, s1
    mul s5, s2, s3 # s5 = number of elements to be written 
    mv a3, s5

    jal fwrite
    bne a0, s5, error_write 
    mv a1, s4
    jal fflush
    bnez a0, error_write

    # close file
    mv a1, s4
    jal fclose
    li t0, -1
    beq a0, t0, error_close

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, -28

    ret

error_open:
    li a1, 53
    jal exit2

error_write:
    li a1, 54
    jal exit2

error_close:
    li a1, 55
    jal exit2