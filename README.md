# Genome Assembly Pipeline using SPAdes

[![Nextflow](https://img.shields.io/badge/Workflow-Nextflow-17a2b8.svg)](https://www.nextflow.io/)
[![SPAdes](https://img.shields.io/badge/Assembly-SPAdes-28a745.svg)](https://cab.spbu.ru/software/spades/)
[![FastQC](https://img.shields.io/badge/QC-FastQC-e83e8c.svg)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
[![Trimmomatic](https://img.shields.io/badge/Trimming-Trimmomatic-ffc107.svg)](http://www.usadellab.org/cms/?page=trimmomatic)
[![QUAST](https://img.shields.io/badge/Evaluation-QUAST-fd7e14.svg)](http://quast.sourceforge.net/)
[![MultiQC](https://img.shields.io/badge/Report-MultiQC-6f42c1.svg)](https://multiqc.info/)
[![Conda](https://img.shields.io/badge/Env-Conda-44A833.svg)](https://docs.conda.io/)

## Overview

This project provides an automated Nextflow pipeline for bacterial genome assembly. The workflow performs quality control, read trimming, genome assembly, and assembly quality assessment. It streamlines the entire process from raw sequencing reads to assembled contigs with unified quality reports.

---

## Features

* **Quality Control (FastQC):** Analyze raw and trimmed read quality
* **Read Trimming (Trimmomatic):** Remove low-quality bases and adapters
* **Quality Verification:** FastQC check after trimming
* **Genome Assembly (SPAdes – careful mode):** Error-corrected assembly
* **Assembly Assessment (QUAST):** Evaluate assembly metrics
* **Comprehensive Reporting (MultiQC):** Unified HTML summary
* **Automated Workflow:** Fully orchestrated through Nextflow for reproducibility

---

## Installation

### Install Nextflow

```bash
curl -s [https://get.nextflow.io](https://get.nextflow.io) | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/
Install Tools Using Conda/MambaBashmamba env create -f environment.yml
Bashconda env create -f environment.yml
Basic CommandBashnextflow run pipeline.nf --reads "data/*_{1,2}.fastq.gz" --outdir results
Parameters--reads : Path to paired-end FASTQ files--outdir : Output directory pathExample:Bashnextflow run pipeline.nf \
  --reads "data/sample_*_{1,2}.fastq.gz" \
  --outdir assembly_results
Pipeline WorkflowFastQC (Raw)
   ↓
Trimmomatic
   ↓
FastQC (Trimmed)
   ↓
SPAdes Assembly
   ↓
QUAST Evaluation
   ↓
MultiQC Report
Updated Project Directory StructureThe project now follows this structure:.
├── README.md
├── data
│   ├── ERR3335404_1.fastq.gz
│   └── ERR3335404_2.fastq.gz
├── environment.yml
├── fastqc_output
│   ├── raw
│   │   ├── ERR3335404_1_fastqc.html
│   │   ├── ERR3335404_1_fastqc.zip
│   │   ├── ERR3335404_2_fastqc.html
│   │   └── ERR3335404_2_fastqc.zip
│   └── trimmed
│       ├── ERR3335404_1_trimmed_fastqc.html
│       ├── ERR3335404_1_trimmed_fastqc.zip
│       ├── ERR3335404_2_trimmed_fastqc.html
│       └── ERR3335404_2_trimmed_fastqc.zip
├── multiqc_report
│   └── multiqc_report
│       ├── multiqc_data
│       └── multiqc_report.html
├── pipeline.nf
├── quast_output
│   ├── report.html
│   ├── report.txt
│   ├── report.pdf
│   └── basic_stats
├── spades_output
│   ├── contigs.fasta
│   ├── scaffolds.fasta
│   ├── assembly_graph.fastg
│   └── final_contigs.fasta
└── trimmomatic_output
    ├── ERR3335404_1_trimmed.fastq.gz
    ├── ERR3335404_1_unpaired.fastq.gz
    ├── ERR3335404_2_trimmed.fastq.gz
    └── ERR3335404_2_unpaired.fastq.gz
Key Output FilesOutputLocationTrimmed readstrimmomatic_output/Raw & trimmed QC reportsfastqc_output/SPAdes assemblyspades_output/contigs.fastaQUAST assembly reportquast_output/report.htmlMultiQC summarymultiqc_report/multiqc_report.htmlInterpreting ResultsMultiQC ReportOpen multiqc_report/multiqc_report.html to view:Read quality summariesAdapter/quality trimming statsAssembly performance metricsQUAST Metrics to CheckN50 (higher is better)L50 (lower is better)Total assembly size (match expected genome size)Contig count (lower indicates better assembly)GC contentTypical bacterial genome expectations:Genome size: 2–8 MbN50: >50 kb (good), >200 kb (excellent)Contigs: <100 (good), <20 (excellent)TroubleshootingOut of MemoryIncrease RAMUse SPAdes --memory parameterAssembly FailuresCheck read qualityEnsure files are paired properlyConfirm disk space availabilityCitationPlease cite the following tools if you use this pipeline:Nextflow: Di Tommaso et al., 2017SPAdes: Bankevich et al., 2012FastQC: Andrews, 2010Trimmomatic: Bolger et al., 2014QUAST: Gurevich et al., 2013MultiQC: Ewels et al., 2016
