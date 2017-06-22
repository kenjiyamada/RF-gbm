#!/bin/sh

N=$1
INC=$2
PDF=$3

DAT=data/CaliforniaHousing/cal_housing.data

echo starting $0 at `date`
echo DAT=$DAT N=$N INC=$INC PDF=$PDF

R --no-save --quiet <<EOF
source("scp/cal-house2.R")
library(randomForest)
library(gbm)

dat=read.cal.house("$DAT")
re=train.eval.rf(dat,n=$N,inc=$INC)
ge=train.eval.gbm(dat,n=$N,inc=$INC)

pdf("$PDF")
plot.rf.gbm(re,ge,inc=$INC)
dev.off()

warnings()
quit(save="no")
EOF

echo finished $0 at `date`

exit

