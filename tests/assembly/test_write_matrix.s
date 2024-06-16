.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
rows: .word 3
cols: .word 3
file_path: .asciiz "outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    # Write the matrix to a file
    la a0, file_path
    la a1, m0
    la a2, rows
    lw a2, 0(a2)
    la a3, rows
    lw a3, 0(a3)
    jal write_matrix

    # Exit the program
    jal exit