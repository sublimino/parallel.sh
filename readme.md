# parallel.sh
Execute scripts or commands in parallel, using BASH.

## Usage

Can be used stand-alone or butchered into another script.

100 iterations of `sleep 1` using 20 parallel workers:

    ./parallel.sh --iterations 100 --workers 20 sleep 1

To test with random intervals, create a script to `sleep` for between 2 and 10 seconds:

    echo -e '#!/bin/bash\nsleep $((2 + (RANDOM%9)))' > /tmp/testParallel.sh

Then use parallel.sh to invoke it 200 times with 50 workers:

    ./parallel.sh --iterations 200 --workers 50 /tmp/testParallel.sh

## Todo
- Only count children with correct parent PID instead of using ps

## Author
[@sublimino](http://twitter.com/sublimino)

[https://github.com/sublimino](https://github.com/sublimino)
