#!/bin/bash
## unpack all the fastq.gz, 
## perform bowtie analysis,
## transfer *.sam to *.bed
## mail myself that the mission accomplished
## <12-28-2012 Xiaoqin Yang>


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Uncompress all the .gz files in the folder
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#gzip -d *.gz


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# bowtie and then change the file format 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#mkdir ../run
for fastq in *.fastq; do
        sam=$(echo $fastq | sed -e 's/.fastq/.sam/g')
        bam=$(echo $fastq | sed -e 's/.fastq/.bam/g')
        sorted=$(echo $fastq | sed -e 's/.fastq/_sorted/g')
        sortedf=$(echo $fastq | sed -e 's/.fastq/_sorted.bam/g')
        bed=$(echo $fastq | sed -e 's/.fastq/.bed/g')

        bowtie -S -q -m 1 /mnt/Storage/data/Bowtie/hg19 $fastq $sam -p 8
        samtools view -bS $sam > $bam
        samtools sort $bam $sorted
        bamToBed -i $sortedf > $bed
        #mv $bed ../run

        #bowtie -S  -q /mnt/Storage/data/Bowtie/hg19 $fastq $sam -p 8
        #bowtie -S  -q -I 0 -X 300  hg18_combined.fa.bowtie -1 Pair1.fastq -2 Pair2.fastq bowpeout.sam -p 8
        #samtools view -bS -f 0x2 GSM945580.sam | bamToBed -bedpe -i stdin | sortBed -i stdin
        #samtools view -uSb -f 0x2 reads.sam | samtools sort -n - reads_sorted | 
        #samtools view <GSM945580.sam> -Sb | bamToBed -i stdin > GSM945580.bed
        #sam2bed $sam $bed

done


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Inform myself that mission accomplished
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/usr/sbin/sendmail -t <<EOF
From: Mail testing <xiaoqinyang@yeah.net>                                                                                      
To: sirxqyang@gmail.com
Subject: Misson accomplished!                                                  
----------------------------------
Sweet heart,

Nucleosome bowtie finished!
Further analysis could be perform.

me
---------------------------------
EOF
man sendmail