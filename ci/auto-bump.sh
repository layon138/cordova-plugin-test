if ! $RELEASING_FROM_MAIN ; then
    echo 'Skipping auto bump because the pipeline is not executed from master branch!'
    return
fi

python3 ci/auto_bump.py $RELEASE_VERSION $GITHUB_API_ACCESS_PSW
