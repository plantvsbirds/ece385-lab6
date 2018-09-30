# lab6

toplevel is main.sv

## wat im reading

- PC, MAR, MDR == reg
- INSTSEQDEC == control
- mem subsys == comb switch case

# mem subsys design

## Input signals
- MAR
- MDR
- READ
`MDR = M(MAR)`

- WRITE
`M(MAR) = MDR`

## Output signals
- NEW_MDR