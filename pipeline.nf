// Pipeline parameters - CORRECTED PATHS
params.fastqdir = "/home/akhil/nextflow/fastq"
params.read1 = "/home/akhil/nextflow/fastq/ERR3335404_1.fastq.gz"
params.read2 = "/home/akhil/nextflow/fastq/ERR3335404_2.fastq.gz"

// Output directories
params.FASTQC_OUTPUT = "/home/akhil/nextflow/FASTQC_OUTPUT"
params.TRIMMOMATIC_OUTPUT = "/home/akhil/nextflow/TRIMMOMATIC_OUTPUT"
params.SPADES_OUTPUT = "/home/akhil/nextflow/SPADES_OUTPUT"
params.QUAST_OUTPUT = "/home/akhil/nextflow/QUAST_OUTPUT"
params.MULTIQC_OUTPUT = "/home/akhil/nextflow/MULTIQC_OUTPUT"

// Trimmomatic adapter file - UPDATED PATH
params.adapter = "/home/akhil/nextflow/TruSeq3-PE.fa"

process fastqc_raw {
    publishDir("${params.FASTQC_OUTPUT}/raw", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path reads
    
    output:
        path "*_fastqc.{html,zip}", emit: fastqc_results
    
    script:
    """
    fastqc -t ${task.cpus} ${reads}
    """
}

process trimmomatic {
    publishDir("${params.TRIMMOMATIC_OUTPUT}", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path read1
        path read2
    
    output:
        path "${read1.simpleName}_trimmed.fastq.gz", emit: trimmed_read1
        path "${read2.simpleName}_trimmed.fastq.gz", emit: trimmed_read2
        path "*_unpaired.fastq.gz", emit: unpaired_reads
    
    script:
    """
    trimmomatic PE -threads ${task.cpus} \\
        ${read1} ${read2} \\
        ${read1.simpleName}_trimmed.fastq.gz ${read1.simpleName}_unpaired.fastq.gz \\
        ${read2.simpleName}_trimmed.fastq.gz ${read2.simpleName}_unpaired.fastq.gz \\
        ILLUMINACLIP:${params.adapter}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}

process fastqc_trimmed {
    publishDir("${params.FASTQC_OUTPUT}/trimmed", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path reads
    
    output:
        path "*_fastqc.{html,zip}", emit: fastqc_results
    
    script:
    """
    fastqc -t ${task.cpus} ${reads}
    """
}

process assemble {
    publishDir("${params.SPADES_OUTPUT}", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path read1
        path read2
    
    output:
        path "*/contigs.fasta", emit: contigs
        path "*/scaffolds.fasta", emit: scaffolds
        path "*", emit: spades_all
    
    script:
    def sample_name = read1.simpleName.split('_')[0]
    """
    spades.py --careful -t ${task.cpus} -m ${task.memory.toGiga()} -1 $read1 -2 $read2 -o ${sample_name}
    """
}

process quast {
    publishDir("${params.QUAST_OUTPUT}", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path contigs
    
    output:
        path "quast_output", emit: quast_results
    
    script:
    """
    quast.py -o quast_output ${contigs} -t ${task.cpus}
    """
}

process multiqc {
    publishDir("${params.MULTIQC_OUTPUT}", mode: 'copy')
    
    cpus 12
    memory '5 GB'
    
    input:
        path fastqc_reports
    
    output:
        path "multiqc_report", emit: multiqc_results
    
    script:
    """
    multiqc -o multiqc_report ${fastqc_reports}
    """
}

workflow {
    // Create channels
    read1_ch = Channel.fromPath(params.read1)
    read2_ch = Channel.fromPath(params.read2)
    raw_reads_ch = Channel.fromPath([params.read1, params.read2])
    
    // Run FastQC on raw reads
    fastqc_raw(raw_reads_ch)
    
    // Run Trimmomatic
    trimmomatic(read1_ch, read2_ch)
    
    // Combine trimmed reads for FastQC
    trimmed_reads_combined = trimmomatic.out.trimmed_read1.concat(trimmomatic.out.trimmed_read2)
    
    // Run FastQC on trimmed reads
    fastqc_trimmed(trimmed_reads_combined)
    
    // Run SPAdes assembly
    assemble(trimmomatic.out.trimmed_read1, trimmomatic.out.trimmed_read2)
    
    // Run QUAST on assembly contigs
    quast(assemble.out.contigs)
    
    // Combine all FastQC reports for MultiQC
    all_fastqc_reports = fastqc_raw.out.fastqc_results.mix(fastqc_trimmed.out.fastqc_results)
    
    // Run MultiQC on all FastQC reports
    multiqc(all_fastqc_reports.collect())
    
    // View outputs
    assemble.out.contigs.view()
    quast.out.quast_results.view()
    multiqc.out.multiqc_results.view()
}
