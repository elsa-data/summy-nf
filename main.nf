#!/usr/bin/env nextflow


nextflow.enable.dsl = 2


process summy {
    input:
      path s3url

    output:
      stdout

    script:
        """
        #!/usr/bin/env python3
        import hashlib
        from pathlib import Path

        hash = hashlib.md5()
        hash.update(Path('$s3url').read_bytes())
        print (hash.digest())
        """
}

workflow {
    tsvInputChannel = Channel
                   .fromPath(params.input)
                   .splitCsv(header: true, sep: '\t')
                   .map { it.S3URL  }

    summy(tsvInputChannel) | view
}
