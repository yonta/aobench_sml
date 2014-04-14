#!/bin/bash

function bench () {
	case "$1" in
	sml)
		sml @SMLload=aobench-image aobench-sml.ppm
		;;
	gcc | mlton | smlsharp-1.2.0 | smlsharp-2.0.0)
		./aobench-${1} aobench-${1}.ppm
		;;
	*)
		echo "unkown compiler [$1]"
		;;
	esac
}

function build () {
	case "$1" in
	sml)
		ml-build aobench.cm AObench.main aobench-image
		;;
	gcc)
		gcc -std=gnu99 -O2 -Wall --pedantic-errors -o aobench-gcc aobench.c -lm
		;;
	mlton)
		mlton -output aobench-mlton aobench.mlb
		;;
	smlsharp-1.2.0)
		make -f makefile-smlsharp-1.2.0 clean
		make -f makefile-smlsharp-1.2.0
		;;
	smlsharp-2.0.0)
		make -f makefile-smlsharp-2.0.0 clean
		make -f makefile-smlsharp-2.0.0
		;;
	*)
		echo "unkown compiler [$1]"
		;;
	esac
}


# number of iteration
N=1

compiler=(gcc sml mlton smlsharp-1.2.0 smlsharp-2.0.0)
for (( i=0; i<${#compiler[@]}; i++ ))
do
	# check existence
	which ${compiler[$i]} >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		build ${compiler[$i]}
		echo "${compiler[$i]} is running"
		time for (( j=0; j<$N; j++ ))
		do
			bench ${compiler[$i]}
		done
	else
		echo "${compiler[$i]} is not found :("
	fi
done
