# parallel.sh: execute jobs in parallel
#
# Copyright (C) 2012 Andrew Martin.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author(s): Andrew Martin <sublimino@gmail.com>
#

ITERATIONS=20
WORKERS=10

USAGE="$0 [--iterations num] [--workers num] COMMAND"

while [ $# -gt 0 ]; do
    case "$1" in
    (--iterations) ITERATIONS=$2; shift;;
    (--workers) WORKERS=$2; shift;;
    (--help) echo $USAGE; exit 0;;
    (--) shift; break;;
    (*)  break;;
    esac
    shift
done

WORKER_COMMAND=${@-"sleep 2"}

MAX_WORKERS_FILE=$(mktemp -t parallel.workers.XXXXX) || exit 1
echo $WORKERS > $MAX_WORKERS_FILE

echo "Starting $ITERATIONS iterations of '$WORKER_COMMAND' with $WORKERS parallel workers."
echo "Workers can be altered at runtime by editing $MAX_WORKERS_FILE"
echo "Press any key to continue..."
read -n 1 c

for ((i=1; i<=$ITERATIONS; i++)); do
    while (true); do
        MAX_WORKERS=$(cat $MAX_WORKERS_FILE)
        WORKERS=$(jobs -r | wc -l)
        echo -e "\e[91mWorkers: $WORKERS / $MAX_WORKERS\e[39m"
        [[ $WORKERS -lt $MAX_WORKERS ]] && break || sleep 1
    done
    echo "$i: $WORKER_COMMAND"
    eval "$WORKER_COMMAND &"
done

unlink $MAX_WORKERS_FILE
echo -e "Completed $((i-1)) iterations of '$WORKER_COMMAND'"
exit 0