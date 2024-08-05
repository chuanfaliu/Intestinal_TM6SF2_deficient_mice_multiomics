########
01.QC
########
mkdir -p ./1.cleandata/$1
kneaddata -i1 ./0.rawdata/$1_R1.fastq.gz -i2 ./0.rawdata/$1_R2.fastq.gz -db /expt/cfliu/database/kneaddata_db/mouse 
--trimmomatic /home/users/chuanfaliu_hope/micromamba/envs/metaphlan3/share/trimmomatic-0.36-3/ 
--run-fastqc-start --run-fastqc-end 
--remove-intermediate-output 
--output-prefix $1 -t 20 -p 20 -q phred33 -o ./1.cleandata/$1/ --cat-final-output

pigz -p 60 ./1.cleandata/$1/$1.fastq
#pigz -p 60 ./1.cleandata/$1/$1_unmatched_2.fastq
#mkdir -p /storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/ /storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/fastqc/
#cp -rf ./1.cleandata/$1/*.fastq.gz /storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/
#cp -rf ./1.cleandata/$1/fastqc/ /storage1/chuanfaliu_hope/project/4TM6SF2/1.cleandata/$1/fastqc/
#cp -rf ./1.cleandata/$1/*.log /storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/
#rm -r ./1.cleandata/$1/
#mkdir -p ./1.cleandata/$1

########
02.kk2
########

kraken2 --db /expt/Database/Kraken2_modification/GenBank/CurrentSCC --threads 80 --gzip-compressed --paired /storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/$1_unmatched_1.fastq.gz 
/storage1/chuanfaliu_hope/project/TM6SF2/1.cleandata/$1/$1_unmatched_2.fastq.gz 
--report ./4.kraken2/report2/$1.report 
--output /storage1/chuanfaliu_hope/project/TM6SF2/4.kraken2/result2/$1.result 
--minimum-hit-groups 3 2&>1 > ./4.kraken2/log/$1.log

########
03.bracken
#######

KRAKEN_DB=/expt/Database/Kraken2_modification/GenBank/CurrentSCC
bracken -d ${KRAKEN_DB} -i ./4.kraken2/report/$1.report -o 4.kraken2/bracken/$1.bracken -t 10

########
04.tranfer and merge
########

mkdir -p ./4.kraken2/mpa
/expt/cfliu/software/KrakenTools/kreport2mpa.py --display-header -r ./4.kraken2/report/$1_bracken_species.report -o ./4.kraken2/mpa/$1_readcount.mpa

mkdir 5.result
/expt/cfliu/software/KrakenTools/combine_mpa.py -i 2.kraken/mpa/* -o 5.result/merge_metaphlan_tables.profile
