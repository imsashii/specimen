library(data.table)

## initializing...

totalsales=aggregate(SALE~MEMBERID+BRAND+REGN,originaldata,FUN=sum) 
reg_len=unique(totalsales$REGN)
listofdataframes<-list()
listofproportions<-list()
listofhighestbrands<-list()
TopRegionBrands<-list()

## first 

for(i in reg_len){
  listofdataframes[[i]]<-assign(paste("regiondata",i,sep=""),subset(totalsales,REGN==i))
}

## second

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  assign(paste("brandtotal",i,sep=""),aggregate(SALE~BRAND,regiondata,FUN = sum))
}

## third

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  assign(paste("highestbrand",i,sep=""), brandtotal[order(-brandtotal$SALE),])
}

## fourth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  assign(paste("regiontotal",i,sep=""), aggregate(SALE~REGN,regiondata,FUN = sum))
}

##fifth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand=brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  listofproportions[[i]]<-assign(paste("proportion",i,sep=""), as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2))))
}

##sixth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand=brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  proportion = as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2)))
  listofhighestbrands[[i]]<-assign(paste("highestbrand",i,sep=""),cbind(highestbrand,proportion))
}

##seventh

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  regiondata=regiondata[order(regiondata$MEMBERID),]
  assign(paste("totalbymemid",i,sep=""),aggregate(SALE~MEMBERID,regiondata,FUN = sum))
}

##eighth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  regiondata=regiondata[order(regiondata$MEMBERID),]
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  assign(paste("finaldata",i,sep=""),merge(regiondata,totalbymemid,by="MEMBERID",all.x=T))
}

##nineth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  regiondata=regiondata[order(regiondata$MEMBERID),]
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  assign(paste("brandpropbymemid",i,sep=""),as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2))))
}

##tenth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  regiondata=regiondata[order(regiondata$MEMBERID),]
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  assign(paste("uberdata",i,sep=""),cbind(finaldata,brandpropbymemid))
}

## eleventh

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand = brandtotal[order(-brandtotal$SALE),]
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  uberdata=cbind(finaldata,brandpropbymemid)
  assign(paste("uberbrand_data",i,sep=""),subset(uberdata,BRAND==highestbrand[1,1]))
}

## twelvth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand = brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  proportion = as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2)))
  highestbrand = cbind(highestbrand,proportion)
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  uberdata=cbind(finaldata,brandpropbymemid)
  uberbrand_data=subset(uberdata,BRAND==highestbrand[1,1])
  assign(paste("membertype",i,sep=""),as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak"))))
}

## thirteenth

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand = brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  proportion = as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2)))
  highestbrand = cbind(highestbrand,proportion)
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  uberdata=cbind(finaldata,brandpropbymemid)
  uberbrand_data=subset(uberdata,BRAND==highestbrand[1,1])
  membertype = as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak")))
  assign(paste("uberbrand_data",i,sep=""),cbind(uberbrand_data,membertype))
}

## Step 1: Getting the difference in members who are part of the East but dont sell Himani Navratna

## Step 2: Creating a new dataframe to include those missing members from above

## Step 3: Then adding this new dataframe to the existing one to create the complete list of strong and weak members


for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand = brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  proportion = as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2)))
  highestbrand = cbind(highestbrand,proportion)
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  uberdata=cbind(finaldata,brandpropbymemid)
  uberbrand_data=subset(uberdata,BRAND==highestbrand[1,1])
  membertype = as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak")))
  uberbrand_data =  cbind(uberbrand_data,membertype)
  membertype = as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak")))
  v<-totalbymemid$MEMBERID
  w<-uberbrand_data$MEMBERID
  differenceinmembers = setdiff(v,w)
  if(is.null(differenceinmembers)== T){
    assign(paste("FINALSTWK_uberbrand",i,sep=""), cbind(uberbrand_data,membertype))
  } else{
    uberbrand_extra = data.table(MEMBERID=differenceinmembers,BRAND=highestbrand[1,1],REGN=i,SALE.x=0,SALE.y=0,brandprop=0.00,membertype="Weak")
    assign(paste("FINALSTWK_uberbrand",i,sep=""), rbind(uberbrand_data,uberbrand_extra))
  }
}


## Creating a table of the Highest Selling Brand in each Region

for(i in 1:length(listofhighestbrands)){
  for(j in 1){
    REGN = reg_len[i]
    BRAND = listofhighestbrands[[i]][j,1]
    SALE = round((listofhighestbrands[[i]][j,2]/10000000),2)
    brandprop = listofhighestbrands[[i]][j,3]
    TopRegionBrands[[(i-1)+j]] = cbind.data.frame(REGN,BRAND,SALE,brandprop)
  }
}

Highestsellingbrands<-do.call(rbind, lapply(TopRegionBrands, data.frame, stringsAsFactors=FALSE))
colnames(Highestsellingbrands)[3] <- "SALE_Cr"

## Creating a subset of 'Weak Members' in each Region

for(i in reg_len){
  regiondata=subset(totalsales,REGN==i)
  brandtotal=aggregate(SALE~BRAND,regiondata,FUN = sum)
  highestbrand = brandtotal[order(-brandtotal$SALE),]
  regiontotal = aggregate(SALE~REGN,regiondata,FUN = sum)
  proportion = as.data.frame(cbind(brandprop=round((highestbrand$SALE/regiontotal$SALE)*100,2)))
  highestbrand = cbind(highestbrand,proportion)
  totalbymemid=aggregate(SALE~MEMBERID,regiondata,FUN = sum)
  finaldata=merge(regiondata,totalbymemid,by="MEMBERID",all.x=T)
  brandpropbymemid=as.data.frame(cbind(brandprop=round((finaldata$SALE.x/finaldata$SALE.y)*100,2)))
  uberdata=cbind(finaldata,brandpropbymemid)
  uberbrand_data=subset(uberdata,BRAND==highestbrand[1,1])
  membertype = as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak")))
  uberbrand_data =  cbind(uberbrand_data,membertype)
  membertype = as.data.frame(cbind(membertype=ifelse(uberbrand_data$brandprop>=highestbrand[1,3],"Strong","Weak")))
  v<-totalbymemid$MEMBERID
  w<-uberbrand_data$MEMBERID
  differenceinmembers = setdiff(v,w)
  if(is.null(differenceinmembers)== T){
    assign(paste("FINALSTWK_uberbrand",i,sep=""), cbind(uberbrand_data,membertype))
  } else{
    uberbrand_extra = data.table(MEMBERID=differenceinmembers,BRAND=highestbrand[1,1],REGN=i,SALE.x=0,SALE.y=0,brandprop=0.00,membertype="Weak")
    assign(paste("FINALSTWK_uberbrand",i,sep=""), rbind(uberbrand_data,uberbrand_extra))
  }
  FINALSTWK_uberbrand = rbind(uberbrand_data,uberbrand_extra)
  assign(paste("WeakMembersinRegion",i,sep=""), subset(FINALSTWK_uberbrand, membertype=="Weak"))
} 
















