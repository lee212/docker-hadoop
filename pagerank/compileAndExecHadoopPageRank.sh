#!/bin/bash

if [ $# -ne 3 ]; then
    echo 1>&2 Usage: [PageRank Inputs File Directory][Number of Urls][Number Of Iterations]
    echo "e.g. ./compileAndExecHadoopPageRank.sh PageRankDataGenerator/pagerank5000g50.input.0 5000 1"
    exit -1
fi

# clean existing compiled class
echo "Clean built java class and jar"
ant clean

# compile your code and shows errors if any
echo "Compiling source code with ant"
ant

if [ -f dist/HadoopPageRankMooc.jar ]
then
    echo "Source code compiled!"
else
    echo "There may be errors in your source code, please check the debug message."
    exit 255
fi

# run pageRank

$HADOOP_PREFIX/bin/hadoop dfs -mkdir input.pagerank
$HADOOP_PREFIX/bin/hadoop dfs -put $1 input.pagerank
$HADOOP_PREFIX/bin/hadoop jar dist/HadoopPageRankMooc.jar indiana.cgl.hadoop.pagerank.HadoopPageRank input.pagerank output.pagerank $2 $3

# capture the standard output
rm -rf output.pagerank
hadoop dfs -get output.pagerank .

echo "PageRank Finished execution, see results in output.pagerank/ directory."
