#!/bin/bash
#SBATCH --job-name SS30
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=longjobs
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jrivera6@eafit.edu.co
#SBATCH -o SS30_%a_%j_%N.out
#SBATCH -e SS30_%a_%j_%N.err
#SBATCH --constraint=AVX512

module load gurobi/8.1.0

gurobi_cl TimeLimit=10800 Threads=1 ResultFile=backtoback30.sol LogFile=backtoback30.log backtoback30.mps
gurobi_cl TimeLimit=10800 Threads=1 ResultFile=classic30.sol LogFile=classic30.log classic30.mps
gurobi_cl TimeLimit=10800 Threads=1 ResultFile=english30.sol LogFile=english30.log english30.mps
gurobi_cl TimeLimit=10800 Threads=1 ResultFile=french30.sol LogFile=french30.log french30.mps
gurobi_cl TimeLimit=10800 Threads=1 ResultFile=inverted30.sol LogFile=inverted30.log inverted30.mps
gurobi_cl TimeLimit=10800 Threads=1 ResultFile=mirrored30.sol LogFile=mirrored30.log mirrored30.mps
