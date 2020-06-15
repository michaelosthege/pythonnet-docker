#!/bin/sh

TEST_CMD="/tmp/tests/hello_mono.sh && python /tmp/tests/import_clr.py"

find _dockerfiles -type f -execdir docker run -it -v ${PWD}/tests:/tmp/tests --rm jonemo/pythonnet:{} /bin/bash -c "${TEST_CMD}" \;
