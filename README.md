# Genome Assembly Pipeline using SPAdes

## Overview

This project provides an automated **Nextflow pipeline** for bacterial genome assembly. The workflow performs quality control, read trimming, genome assembly, and assembly quality assessment. It streamlines the entire process from raw sequencing reads to assembled contigs with unified quality reports.

---

## Features

* **Quality Control (FastQC):** Analyze raw and trimmed read quality
* **Read Trimming (Trimmomatic):** Remove low-quality bases & adapters
* **Quality Verification:** FastQC check after trimming
* **Genome Assembly (SPAdes – careful mode):** Error-corrected assembly
* **Assembly Assessment (QUAST):** Evaluate assembly metrics
* **Comprehensive Reporting (MultiQC):** Unified HTML summary
* **Automated Workflow:** Fully orchestrated through Nextflow for reproducibility

---

## Installation

### Install Nextflow

```bash
curl -s https://get.nextflow.io | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/
```

### Install Tools Using Conda/Mamba

```bash
mamba env create -f environment.yml
```
```bash
conda env create -f environment.yml
```
---

### Basic Command

```bash
nextflow run pipeline.nf --reads "data/*_{1,2}.fastq.gz" --outdir results
```

### Parameters

* `--reads` : Path to paired-end FASTQ files
* `--outdir` : Output directory path

**Example:**

```bash
nextflow run pipeline.nf \
  --reads "data/sample_*_{1,2}.fastq.gz" \
  --outdir assembly_results
```

---

## Pipeline Workflow

```
FastQC (Raw)
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
```

---

# Updated Project Directory Structure

The project now follows this structure:

```
.
├── README.md
├── data
│   ├── ERR3335404_1.fastq.gz
│   └── ERR3335404_2.fastq.gz
├── environment.yml
├── fastqc_output
│   ├── raw
│   │   ├── ERR3335404_1_fastqc.html
│   │   ├── ERR3335404_1_fastqc.zip
│   │   ├── ERR3335404_2_fastqc.html
│   │   └── ERR3335404_2_fastqc.zip
│   └── trimmed
│       ├── ERR3335404_1_trimmed_fastqc.html
│       ├── ERR3335404_1_trimmed_fastqc.zip
│       ├── ERR3335404_2_trimmed_fastqc.html
│       └── ERR3335404_2_trimmed_fastqc.zip
├── multiqc_report
│   └── multiqc_report
│       ├── multiqc_data
│       └── multiqc_report.html
├── pipeline.nf
├── quast_output
│   ├── report.html
│   ├── report.txt
│   ├── report.pdf
│   └── basic_stats
├── spades_output
│   ├── contigs.fasta
│   ├── scaffolds.fasta
│   ├── assembly_graph.fastg
│   └── final_contigs.fasta
└── trimmomatic_output
    ├── ERR3335404_1_trimmed.fastq.gz
    ├── ERR3335404_1_unpaired.fastq.gz
    ├── ERR3335404_2_trimmed.fastq.gz
    └── ERR3335404_2_unpaired.fastq.gz
```
---

## Key Output Files

| Output                   | Location                             |
| ------------------------ | ------------------------------------ |
| Trimmed reads            | `trimmomatic_output/`                |
| Raw & trimmed QC reports | `fastqc_output/`                     |
| SPAdes assembly          | `spades_output/contigs.fasta`        |
| QUAST assembly report    | `quast_output/report.html`           |
| MultiQC summary          | `multiqc_report/multiqc_report.html` |

---

## Interpreting Results

### MultiQC Report

Open `multiqc_report/multiqc_report.html` to view:

* Read quality summaries
* Adapter/quality trimming stats
* Assembly performance metrics

### QUAST Metrics to Check

* **N50** (higher is better)
* **L50** (lower is better)
* **Total assembly size** (match expected genome size)
* **Contig count** (lower indicates better assembly)
* **GC content**

**Typical bacterial genome expectations:**

* Genome size: **2–8 Mb**
* N50: **>50 kb (good)**, **>200 kb (excellent)**
* Contigs: **<100 (good)**, **<20 (excellent)**

---

## Troubleshooting

### Out of Memory

* Increase RAM
* Use SPAdes `--memory` parameter

### Assembly Failures

* Check read quality
* Ensure files are paired properly
* Confirm disk space availability

---

## Citation

Please cite the following tools if you use this pipeline:

* **Nextflow:** Di Tommaso *et al.*, 2017
* **SPAdes:** Bankevich *et al.*, 2012
* **FastQC:** Andrews, 2010
* **Trimmomatic:** Bolger *et al.*, 2014
* **QUAST:** Gurevich *et al.*, 2013
* **MultiQC:** Ewels *et al.*, 2016

---

## Acknowledgments

Thanks to the developers of all integrated tools for enabling reproducible and accessible microbial genomics research.
