#!/bin/sh
unset MATLAB_JAVA
matlab_exec=/home/joel.chacon/MATLAB_2016_Portable/bin/matlab
path=/home/joel.chacon/ISCSO_2019/2019/Final
#sleep $((RANDOM % 20))
X="${1}(${3})"
echo ${X} > ${path}/matlab_command_${2}.m
cat ${path}/matlab_command_${2}.m
cd ${path};
${matlab_exec} -nojvm < ${path}/matlab_command_${2}.m > kk &
wait
#${matlab_exec} -nojvm -nodisplay -nosplash < ${path}/matlab_command_${2}.m 
rm ${path}/matlab_command_${2}.m
