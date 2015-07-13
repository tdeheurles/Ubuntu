#! /bin/bash
. config/installations.sh

for script in ${installations[*]}
do
  wget -O scripts/$script.sh $remoteAddress/$script.sh
done

packer build \
  -force \
  -var-file=config/packer_variables.json \
  vivid.json
