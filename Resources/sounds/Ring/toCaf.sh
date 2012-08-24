
#把各种格式的音乐转成caf
#使用系统工具：
#afconvert /System/Library/Sounds/Submarine.aiff ~/Desktop/sub.caf -d ima4 -f caff -v

#使用说明：
#把toCaf.sh放到音乐的目录中。并在，音乐目录中创建converted目录


for fullFileName in $( ls ); do 

shortFileName=${fullFileName%.*}

echo "converting ${fullFileName} ->  ${shortFileName}.caf"

afconvert $fullFileName converted/${shortFileName}.caf -d ima4 -f caff

echo "converted ${fullFileName} ->  ${shortFileName}.caf"

done 
