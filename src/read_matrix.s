.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

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

    # open the file
    mv a1, s0
    li a2, 0 # read only permission
    jal fopen
    li t0, -1
    beq, a0, t0, error_open
    mv s3, a0 # s3 =  file descriptor

    # read number of rows and columns (first 8 bytes)
    mv a1, s3
    mv a2, s1 # ready the buffer to receive the number of rows
    li a3, 4
    jal fread
    li t0, -1
    beq a0, t0, error_read
    mv a2, s2 # ready the buffer to receive the number of columns
    jal fread
    beq a0, t0, error_read
    
    # calculate the amount of memory to allocate
    lw t1, 0(s1)
    lw t2, 0(s2)
    li t0, 4 # 4 bytes per number
    mul s4, t1, t2
    mul s4, s4, t0 # s4 = size of memory to be allocated 

    mv a0, s4
    jal malloc
    li t0, -1
    beq a0, t0, error_memory_alloc
    mv s5, a0 # s5 = memory address of matrix
    
    # read the matrix
    mv a1, s3
    mv a2, s5
    mv a3, s4
    jal fread
    li t0, -1
    beq a0, t0, error_read
    
    # close file
    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, error_close

    mv a0, s5 # set result pointer
    
    # restore pointers of args
    mv a1, s1
    mv a2, s2
    
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
    
error_memory_alloc:
    li a1, 48
    jal exit2

error_open:
    li a1, 50
    jal exit2

error_read:
    li a1, 51
    jal exit2

error_close:
    li a1, 52
    jal exit2