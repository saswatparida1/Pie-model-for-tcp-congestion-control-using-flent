#!/bin/bash

if [ -z ${1} ]
then
	echo "${0}: A .flent.gz file is expected as an argument"

	exit 1
fi

if [ ${1: -9} != ".flent.gz" ]
then
	echo "${0}: ${1} is not a valid .flent.gz file"

	exit 1
fi

if ! [ -e ${1} ]
then
	echo "${0}: ${1}: No such file"

	exit 1
fi

filename=${1:0: -9}

if [ -e ${filename}.flent ]
then
	rm ${filename}.flent
fi

gunzip -k ${filename}.flent.gz

parse_command="grep -Pzo \"\\\".*::delay\\\"([^\\]]|\\n)*\\]\" ${filename}.flent | grep -Pzo \" [0-9]+\\.[0-9]+\""

n=0

for value in $(eval ${parse_command} | tr '\0' '\n' )
do
	delay[n]=${value}

	((n++))
done

sed -i 's/upload sum": \[$/upload_sum": \[/g' ${filename}.flent
sed -i 's/null/0.0/g' ${filename}.flent

parse_command="grep -Pzo \"\\\".*::avg_dq_rate\\\"([^\\]]|\\n)*\\]\" ${filename}.flent | grep -Pzo \" [0-9]+\\.[0-9]+\""

n=0

for value in $(eval ${parse_command} | tr '\0' '\n' )
do
	tcp_upload_sum[n]=${value}

	((n++))
done

rm ${filename}.flent

if [ -e ${2} ]
then
	rm ${2}
fi

for ((begin = 0; begin < n; begin++))
do
	if [ ${tcp_upload_sum[${begin}]} != "0.0" ]
	then
		break
	fi
done

for ((end = n - 1; end >= 0; end--))
do
	if [ ${tcp_upload_sum[${end}]} != "0.0" ]
	then
		break
	fi
done

for ((i = begin; i <= end; i++))
do
	#printf "%.5f %.5f\n" ${delay[i]} ${tcp_upload_sum[i]} >> ${2}
	printf "%.5f\n" ${delay[i]} >> ${2}
	printf "%.5f\n" ${tcp_upload_sum[i]} >> ${3}
done
