#! /bin/bash

set -o xtrace

curl -F file=@"linux-distros.jpg" http://35.199.35.6:8091/api/images/

for ((i=1; i = i;)); do
    curl -F file=@"linux-distros.jpg" http://35.199.35.6:8091/api/images/ 
    #curl -F file=@"linux-distros.jpg" http://35.199.55.194:8091/api/images/
    #curl -F file=@"linux-distros.jpg" http://35.194.66.179:8091/api/images/     
done


