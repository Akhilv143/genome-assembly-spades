# Bacterial Genome Assembly using SPAdes

[![Nextflow](https://img.shields.io/badge/Workflow-Nextflow-17a2b8.svg)](https://www.nextflow.io/)
[![SPAdes](https://img.shields.io/badge/Assembly-SPAdes-28a745.svg)](https://cab.spbu.ru/software/spades/)
[![FastQC](https://img.shields.io/badge/QC-FastQC-e83e8c.svg)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
[![Trimmomatic](https://img.shields.io/badge/Trimming-Trimmomatic-ffc107.svg)](http://www.usadellab.org/cms/?page=trimmomatic)
[![QUAST](https://img.shields.io/badge/Evaluation-QUAST-fd7e14.svg)](http://quast.sourceforge.net/)
[![MultiQC](https://img.shields.io/badge/Report-MultiQC-6f42c1.svg)](https://multiqc.info/)
[![Conda](https://img.shields.io/badge/Env-Conda-44A833.svg)](https://docs.conda.io/)

## Overview

This project provides an automated Nextflow pipeline for **bacterial genome assembly**. The workflow performs quality control, read trimming, genome assembly, and assembly quality assessment. It streamlines the entire process from raw sequencing reads to assembled contigs, culminating in unified quality reports.

---

## Features

* **Quality Control (FastQC):** Analyze raw and trimmed read quality.
* **Read Trimming (Trimmomatic):** Remove low-quality bases and adapters.
* **Quality Verification:** Secondary FastQC check after trimming.
* **Genome Assembly (SPAdes):** Error-corrected assembly running in `--careful` mode.
* **Assembly Assessment (QUAST):** Evaluate critical assembly metrics (N50, L50, etc.).
* **Comprehensive Reporting (MultiQC):** Unified HTML summary of all steps.
* **Automated Workflow:** Fully orchestrated through Nextflow for maximum reproducibility.

---

## Pipeline Workflow

```text
FastQC (Raw Reads)
       ↓
  Trimmomatic
       ↓
FastQC (Trimmed Reads)
       ↓
 SPAdes Assembly
       ↓
 QUAST Evaluation
       ↓
  MultiQC Report
```

---

## Installation

### 1. Install Nextflow

```bash
curl -s [https://get.nextflow.io](https://get.nextflow.io) | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/
```

### 2. Install Tools Using Conda/Mamba

It is recommended to use the provided `environment.yml` to ensure all dependencies are met.

**Using Mamba (Recommended):**
```bash
mamba env create -f environment.yml
```

**Using Conda:**
```bash
conda env create -f environment.yml
```

---

## Usage

### Basic Command

```bash
nextflow run pipeline.nf --reads "data/*_{1,2}.fastq.gz" --outdir results
```

### Parameters

* `--reads` : Path to paired-end FASTQ files (must be enclosed in quotes to prevent shell expansion).
* `--outdir` : Output directory path for all results.

### Example Run

```bash
nextflow run pipeline.nf \
  --reads "data/sample_*_{1,2}.fastq.gz" \
  --outdir assembly_results
```

---

## Project Directory Structure

Once the pipeline completes, your project directory will look like this:

```text
.
├── README.md
├── data
│   ├── ERR3335404_1.fastq.gz
│   └── ERR3335404_2.fastq.gz
├── environment.yml
├── fastqc_output
│   ├── raw
│   │   ├── ERR3335404_1_fastqc.html
│   │   └── ERR3335404_2_fastqc.html
│   └── trimmed
│       ├── ERR3335404_1_trimmed_fastqc.html
│       └── ERR3335404_2_trimmed_fastqc.html
├── multiqc_report
│   └── multiqc_report
│       ├── multiqc_data
│       └── multiqc_report.html
├── pipeline.nf
├── quast_output
│   ├── report.html
│   ├── report.txt
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
```

---

## Key Output Files

| Output | Location |
| :--- | :--- |
| **Trimmed reads** | `trimmomatic_output/` |
| **Raw & trimmed QC reports** | `fastqc_output/` |
| **SPAdes assembly** | `spades_output/contigs.fasta` |
| **QUAST assembly report** | `quast_output/report.html` |
| **MultiQC summary** | `multiqc_report/multiqc_report.html` |

---

## Interpreting Results

### MultiQC Report
Open `multiqc_report/multiqc_report.html` in your browser to view:
* Read quality summaries.
* Adapter and quality trimming statistics.
* Assembly performance metrics.

### QUAST Metrics to Check
When reviewing the QUAST report, pay attention to the following:
* **N50:** Higher is better.
* **L50:** Lower is better.
* **Total assembly size:** Should closely match the expected genome size of the target organism.
* **Contig count:** Lower indicates a more contiguous, better assembly.
* **GC content:** Verify against expected GC content for the species.

### Typical Bacterial Genome Expectations
* **Genome size:** 2–8 Mb
* **N50:** > 50 kb (Good), > 200 kb (Excellent)
* **Contigs:** < 100 (Good), < 20 (Excellent)

---

## Troubleshooting

* **Out of Memory:**
  * Increase RAM availability.
  * Use the SPAdes `--memory` parameter to specify an upper limit.
* **Assembly Failures:**
  * Check the initial read quality in the MultiQC report.
  * Ensure FASTQ files are properly paired.
  * Confirm sufficient disk space is available.

---

## Citation

If you use this pipeline in your research, please cite the following tools:

* **Nextflow:** Di Tommaso et al., 2017
* **SPAdes:** Bankevich et al., 2012
* **FastQC:** Andrews, 2010
* **Trimmomatic:** Bolger et al., 2014
* **QUAST:** Gurevich et al., 2013
* **MultiQC:** Ewels et al., 2016
