#!/usr/bin/env nextflow

process summy {
    debug true

    container 'public.ecr.aws/docker/library/python:3.10.8-bullseye'

    input:
      path s3url

    output:
      stdout

    script:
        """
        #!/usr/bin/env python3
        import hashlib
        from pathlib import Path

        md5hash = hashlib.md5(usedforsecurity=False)
        sha1hash = hashlib.sha1(usedforsecurity=False)
        sha256hash = hashlib.sha256(usedforsecurity=False)

        with open('$s3url','rb') as f:
            while chunk := f.read(128 * md5hash.block_size):
                md5hash.update(chunk)
                sha1hash.update(chunk)
                sha256hash.update(chunk)

        print (f"md5 = {md5hash.hexdigest()}")
        print (f"sha1 = {sha1hash.hexdigest()}")
        print (f"sha256 = {sha256hash.hexdigest()}")
        """
}

workflow {
    tsvInputChannel = Channel
                   .fromPath(params.input)
                   .splitCsv(header: true, sep: '\t')
                   .map { it.S3URL  }

    summy(tsvInputChannel)
}
