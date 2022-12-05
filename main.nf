#!/usr/bin/env nextflow

import java.security.MessageDigest

nextflow.enable.dsl = 2


process summy {
    input:
      tuple val(filetype), val(patient), file(f), val(md5)

    output:
      stdout

    """
    md5 -q $f
    """
}

workflow {
    def fastqChannel = Channel
                   .fromPath(params.input)
                   .splitCsv(header: true, sep: '\t')

    summy(fastqChannel) | view
}
