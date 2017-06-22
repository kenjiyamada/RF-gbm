
init.random = function() {
    set.seed(1009)
}

read.cal.house = function(fn) {
    cn = c('lat','lon','age','rm','brm','pop','hh','inc','hval')
    tx = read.csv(fn,header=F,col.names=cn)

    tb = data.frame(lat=tx$lat,lon=tx$lon,age=tx$age)
    tb$rm = tx$rm/tx$pop    # note this is per population
    tb$brm = tx$brm/tx$pop  # note this is per population
    tb$pop = tx$pop
    tb$oc = tx$pop/tx$hh
    tb$inc = tx$inc
    tb$hval = tx$hval / (100*1000)

    init.random()
    isTrn = (runif(nrow(tb)) < 0.8)

    trn=tb[isTrn,]
    tst=tb[!isTrn,]

    return(list(trn=trn,tst=tst))
}

train.rf = function(trn,...) {
    init.random()
    md = randomForest(hval ~ lat+lon+age+rm+brm+pop+oc+inc, data=trn, ...)
    return(md)
}

train.eval.rf = function(dat,n=100,inc=10,...) {
    trn=dat$trn
    tst=dat$tst

    ntr=(1:n)*inc    
    e2=rep(0,n)
    e6=rep(0,n)
    
    for (i in 1:n) {
        cat(sprintf('rf ntr=%d at %s\n', i*inc, date()))
        nt=ntr[i]
        r2=train.rf(trn,mtry=2,ntree=nt,...)
        r6=train.rf(trn,mtry=6,ntree=nt,...)
    
        p2=predict(r2,newdata=tst,type="response")
        p6=predict(r6,newdata=tst,type="response")

        e2[i]=mean(abs(p2-tst$hval))
        e6[i]=mean(abs(p6-tst$hval))
    }
    return(list(e2=e2,e6=e6))
}

train.gbm = function(trn,...) {
    init.random()
    md = gbm(hval ~ lat+lon+age+rm+brm+pop+oc+inc,
             distribution="gaussian", data=trn, shrinkage=0.05, ...)
    return(md)
}

train.eval.gbm = function(dat,n=100,inc=10,...) {
    trn=dat$trn
    tst=dat$tst

    ntr=(1:n)*inc    
    e4=rep(0,n)
    e6=rep(0,n)
    
    for (i in 1:n) {
        cat(sprintf('gbm ntr=%d at %s\n', i*inc, date()))
        nt=ntr[i]
	g4=train.gbm(trn,interaction.depth=4,n.trees=nt,...)
	g6=train.gbm(trn,interaction.depth=6,n.trees=nt,...)

        p2=predict(g4,newdata=tst,n.trees=nt,type="response")
        p6=predict(g6,newdata=tst,n.trees=nt,type="response")

        e4[i]=mean(abs(p2-tst$hval))
        e6[i]=mean(abs(p6-tst$hval))
    }
    return(list(e4=e4,e6=e6))
}

plot.rf.gbm = function(re,ge,inc=10) {
    n=length(re$e2)
    x=(1:n)*inc

    xlim=c(0,n*inc)
    ylim=c(0.30,0.42)
    plot(0,0,type='n',xlim=xlim,ylim=ylim,
	 xlab='ntrees', ylab='ave abs error',main='Cal House Data')

    lines(x,re$e2,type='b',col='orange')
    lines(x,re$e6,type='b',col='green')

    lines(x,ge$e4,type='b',col='blue')
    lines(x,ge$e6,type='b',col='red')

    lis=c('RF m=2','RF m=6','GBM d=4', 'GBM d=6')
    cols=c('orange','green','blue','red')
    pos='topright'
    legend(pos,legend=lis,lty=1,col=cols)
}

