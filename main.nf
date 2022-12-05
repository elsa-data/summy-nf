#!/usr/bin/env nextflow

process summy {
    debug true

  container 'public.ecr.aws/docker/library/python:3.8-alpine'



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
