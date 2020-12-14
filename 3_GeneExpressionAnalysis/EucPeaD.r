install.packages("gridExtra")
library(dplyr)
library(ggplot2)
library(gridExtra)
setwd("/Users/yiliao/Projects/2020TAD_revision")

df1 <- read.table("inside.outside.dat.out",sep="\t",header=TRUE)
df2 <- read.table("inside.conserved.nonconserved.dat.out",sep="\t",header=TRUE)
df3 <- read.table("inside.shared.specific.dat.out",sep="\t",header=TRUE)
df4 <- read.table("conserved.nonconserved.boundaries.dat.out",sep="\t",header=TRUE)
df5 <- read.table("boundaries.shared.specific.dat.out",sep="\t",header=TRUE)


df6 <-read.table("BG3.non_con_boundary.dat1.out",sep="\t",header=TRUE)

EucD1 <- df6 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 )) # %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD1)
ggplot(EucD1,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 1")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 






EucD1 <- df1 %>% rowwise() %>%
mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 )) # %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD1)
p1<-ggplot(EucD1,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 1")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD2 <- df2 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 )) # %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD2)
p2<-ggplot(EucD2,aes (y=corE,x=Types)) + ylim(0,500) +  xlab("Comparison 2")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD3 <- df3 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 ))# %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD3)
p3<-ggplot(EucD3,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 3")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD4 <- df4 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 )) #%>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD4)
p4<-ggplot(EucD4,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 4")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD5 <- df5 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-dpse_f_wb)^2 + (w1118_f_go-dpse_f_go)^2 + (w1118_f_tx-dpse_f_tx)^2 + (w1118_f_hd-dpse_f_hd)^2 + (w1118_f_ac-dpse_f_ac)^2 + (w1118_f_re-dpse_f_re)^2 + (w1118_f_dg-dpse_f_dg)^2 + (w1118_m_wb-dpse_m_wb)^2 + (w1118_m_go-dpse_m_go)^2 + (w1118_m_tx-dpse_m_tx)^2 + (w1118_m_hd-dpse_m_hd)^2 + (w1118_m_ac-dpse_m_ac)^2 + (w1118_m_re-dpse_m_re)^2 + (w1118_m_dg-dpse_m_dg)^2 )) %>% filter(corE>=0,corE<20000)
wilcox.test(corE~Types,data=EucD5)
p5<-ggplot(EucD5,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 5")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

grid.arrange(p1,p2,p3,p4,p5, nrow=1)

###### Pearson distance

PeaD1 <- df1 %>% rowwise() %>%
  mutate(corE=cor.test(c(w1118_f_wb,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(dpse_f_wb,dpse_f_go,dpse_f_tx,dpse_f_hd,dpse_f_ac,dpse_f_re,dpse_f_dg,dpse_m_wb,dpse_m_go,dpse_m_tx,dpse_m_hd,dpse_m_ac,dpse_m_re,dpse_m_dg),method ="pearson")$estimate)
wilcox.test(1-corE~Types,data=PeaD1)
p1<-ggplot(PeaD1,aes (y=1-corE,x=Types)) + xlab("Comparison 1")+ ylab ("Pearson Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 


PeaD2 <- df2 %>% rowwise() %>%
  mutate(corE=cor.test(c(w1118_f_wb,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(dpse_f_wb,dpse_f_go,dpse_f_tx,dpse_f_hd,dpse_f_ac,dpse_f_re,dpse_f_dg,dpse_m_wb,dpse_m_go,dpse_m_tx,dpse_m_hd,dpse_m_ac,dpse_m_re,dpse_m_dg),method ="pearson")$estimate)
wilcox.test(1-corE~Types,data=PeaD2)
p2<-ggplot(PeaD2,aes (y=1-corE,x=Types)) + xlab("Comparison 2")+ ylab ("Pearson Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

PeaD3 <- df3 %>% rowwise() %>%
  mutate(corE=cor.test(c(w1118_f_wb,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(dpse_f_wb,dpse_f_go,dpse_f_tx,dpse_f_hd,dpse_f_ac,dpse_f_re,dpse_f_dg,dpse_m_wb,dpse_m_go,dpse_m_tx,dpse_m_hd,dpse_m_ac,dpse_m_re,dpse_m_dg),method ="pearson")$estimate)
wilcox.test(1-corE~Types,data=PeaD3)
p3<-ggplot(PeaD3,aes (y=1-corE,x=Types)) + xlab("Comparison 3")+ ylab ("Pearson Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

PeaD4 <- df4 %>% rowwise() %>%
  mutate(corE=cor.test(c(w1118_f_wb,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(dpse_f_wb,dpse_f_go,dpse_f_tx,dpse_f_hd,dpse_f_ac,dpse_f_re,dpse_f_dg,dpse_m_wb,dpse_m_go,dpse_m_tx,dpse_m_hd,dpse_m_ac,dpse_m_re,dpse_m_dg),method ="pearson")$estimate)
wilcox.test(1-corE~Types,data=PeaD4)
p4<-ggplot(PeaD4,aes (y=1-corE,x=Types)) + xlab("Comparison 4")+ ylab ("Pearson Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

PeaD5 <- df5 %>% rowwise() %>%
  mutate(corE=cor.test(c(w1118_f_wb,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(dpse_f_wb,dpse_f_go,dpse_f_tx,dpse_f_hd,dpse_f_ac,dpse_f_re,dpse_f_dg,dpse_m_wb,dpse_m_go,dpse_m_tx,dpse_m_hd,dpse_m_ac,dpse_m_re,dpse_m_dg),method ="pearson")$estimate)
wilcox.test(1-corE~Types,data=PeaD5)
p5<-ggplot(PeaD5,aes (y=1-corE,x=Types)) + xlab("Comparison 5")+ ylab ("Pearson Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

grid.arrange(p1,p2,p3,p4,p5, nrow=1)


###################################w1118 and ORE


### E distance

EucD1 <- df1 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-oreR_f_wb)^2 + (w1118_f_ge-oreR_f_ge)^2+ (w1118_f_go-oreR_f_go)^2 + (w1118_f_tx-oreR_f_tx)^2 + (w1118_f_hd-oreR_f_hd)^2 + (w1118_f_ac-oreR_f_ac)^2 + (w1118_f_re-oreR_f_re)^2 + (w1118_f_dg-oreR_f_dg)^2 + (w1118_m_wb-oreR_m_wb)^2 + (w1118_m_go-oreR_m_go)^2 + (w1118_m_tx-oreR_m_tx)^2 + (w1118_m_hd-oreR_m_hd)^2 + (w1118_m_ac-oreR_m_ac)^2 + (w1118_m_ge-oreR_m_ge)^2 + (w1118_m_re-oreR_m_re)^2 + (w1118_m_dg-oreR_m_dg)^2 ))  %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD1)
p1<-ggplot(EucD1,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 1")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD2 <- df2 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-oreR_f_wb)^2 + (w1118_f_ge-oreR_f_ge)^2+ (w1118_f_go-oreR_f_go)^2 + (w1118_f_tx-oreR_f_tx)^2 + (w1118_f_hd-oreR_f_hd)^2 + (w1118_f_ac-oreR_f_ac)^2 + (w1118_f_re-oreR_f_re)^2 + (w1118_f_dg-oreR_f_dg)^2 + (w1118_m_wb-oreR_m_wb)^2 + (w1118_m_go-oreR_m_go)^2 + (w1118_m_tx-oreR_m_tx)^2 + (w1118_m_hd-oreR_m_hd)^2 + (w1118_m_ac-oreR_m_ac)^2 + (w1118_m_ge-oreR_m_ge)^2 + (w1118_m_re-oreR_m_re)^2 + (w1118_m_dg-oreR_m_dg)^2 ))  %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD2)
p2<-ggplot(EucD2,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 2")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD3 <- df3 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-oreR_f_wb)^2 + (w1118_f_ge-oreR_f_ge)^2+ (w1118_f_go-oreR_f_go)^2 + (w1118_f_tx-oreR_f_tx)^2 + (w1118_f_hd-oreR_f_hd)^2 + (w1118_f_ac-oreR_f_ac)^2 + (w1118_f_re-oreR_f_re)^2 + (w1118_f_dg-oreR_f_dg)^2 + (w1118_m_wb-oreR_m_wb)^2 + (w1118_m_go-oreR_m_go)^2 + (w1118_m_tx-oreR_m_tx)^2 + (w1118_m_hd-oreR_m_hd)^2 + (w1118_m_ac-oreR_m_ac)^2 + (w1118_m_ge-oreR_m_ge)^2 + (w1118_m_re-oreR_m_re)^2 + (w1118_m_dg-oreR_m_dg)^2 ))  %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD3)
p3<-ggplot(EucD3,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 3")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD4 <- df4 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-oreR_f_wb)^2 + (w1118_f_ge-oreR_f_ge)^2+ (w1118_f_go-oreR_f_go)^2 + (w1118_f_tx-oreR_f_tx)^2 + (w1118_f_hd-oreR_f_hd)^2 + (w1118_f_ac-oreR_f_ac)^2 + (w1118_f_re-oreR_f_re)^2 + (w1118_f_dg-oreR_f_dg)^2 + (w1118_m_wb-oreR_m_wb)^2 + (w1118_m_go-oreR_m_go)^2 + (w1118_m_tx-oreR_m_tx)^2 + (w1118_m_hd-oreR_m_hd)^2 + (w1118_m_ac-oreR_m_ac)^2 + (w1118_m_ge-oreR_m_ge)^2 + (w1118_m_re-oreR_m_re)^2 + (w1118_m_dg-oreR_m_dg)^2 ))  %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD4)
p4<-ggplot(EucD4,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 4")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

EucD5 <- df5 %>% rowwise() %>%
  mutate(corE=sqrt((w1118_f_wb-oreR_f_wb)^2 + (w1118_f_ge-oreR_f_ge)^2+ (w1118_f_go-oreR_f_go)^2 + (w1118_f_tx-oreR_f_tx)^2 + (w1118_f_hd-oreR_f_hd)^2 + (w1118_f_ac-oreR_f_ac)^2 + (w1118_f_re-oreR_f_re)^2 + (w1118_f_dg-oreR_f_dg)^2 + (w1118_m_wb-oreR_m_wb)^2 + (w1118_m_go-oreR_m_go)^2 + (w1118_m_tx-oreR_m_tx)^2 + (w1118_m_hd-oreR_m_hd)^2 + (w1118_m_ac-oreR_m_ac)^2 + (w1118_m_ge-oreR_m_ge)^2 + (w1118_m_re-oreR_m_re)^2 + (w1118_m_dg-oreR_m_dg)^2 )) #  %>% filter(corE>=0,corE<2500)
wilcox.test(corE~Types,data=EucD5)
p5<-ggplot(EucD5,aes (y=corE,x=Types)) + ylim(0,500) + xlab("Comparison 5")+ ylab ("Euclidean Distance")+ geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato") 

grid.arrange(p1,p2,p3,p4,p5, nrow=1)









### w118vsoreR
PeaD1 <- df1 %>% rowwise() %>%
  mutate(corE= cor.test(c(w1118_f_wb,w1118_f_ge,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_ge,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(oreR_f_wb,oreR_f_ge,oreR_f_go,oreR_f_tx,oreR_f_hd,oreR_f_ac,oreR_f_re,oreR_f_dg,oreR_m_wb,oreR_m_ge,oreR_m_go,oreR_m_tx,oreR_m_hd,oreR_m_ac,oreR_m_re,oreR_m_dg),method ="pearson")$estimate) %>% filter(corE>=0,corE<1)
wilcox.test(1-corE~ Types, data=PeaD1)
dim(PeaD1)
p1<-ggplot(PeaD1,aes (y=1-corE,x=Types)) + xlab("Comparison 1")+ ylab ("Pearson Distance")+ ylim (0,0.2) +geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato")

PeaD2 <- df2 %>% rowwise() %>%
  mutate(corE= cor.test(c(w1118_f_wb,w1118_f_ge,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_ge,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(oreR_f_wb,oreR_f_ge,oreR_f_go,oreR_f_tx,oreR_f_hd,oreR_f_ac,oreR_f_re,oreR_f_dg,oreR_m_wb,oreR_m_ge,oreR_m_go,oreR_m_tx,oreR_m_hd,oreR_m_ac,oreR_m_re,oreR_m_dg),method ="pearson")$estimate) %>% filter(corE>=0,corE<1)
wilcox.test(1-corE~ Types, data=PeaD2)
p2<-ggplot(PeaD2,aes (y=1-corE,x=Types)) + xlab("Comparison 2")+ ylab ("Pearson Distance")+ ylim (0,0.2) + geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato")

PeaD3 <- df3 %>% rowwise() %>%
  mutate(corE= cor.test(c(w1118_f_wb,w1118_f_ge,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_ge,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(oreR_f_wb,oreR_f_ge,oreR_f_go,oreR_f_tx,oreR_f_hd,oreR_f_ac,oreR_f_re,oreR_f_dg,oreR_m_wb,oreR_m_ge,oreR_m_go,oreR_m_tx,oreR_m_hd,oreR_m_ac,oreR_m_re,oreR_m_dg),method ="pearson")$estimate) %>% filter(corE>=0,corE<1)
wilcox.test(1-corE~ Types, data=PeaD3)
p3<-ggplot(PeaD3,aes (y=1-corE,x=Types)) + xlab("Comparison 3")+ ylab ("Pearson Distance")+ ylim (0,0.2) + geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato")

PeaD4 <- df4 %>% rowwise() %>%
  mutate(corE= cor.test(c(w1118_f_wb,w1118_f_ge,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_ge,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(oreR_f_wb,oreR_f_ge,oreR_f_go,oreR_f_tx,oreR_f_hd,oreR_f_ac,oreR_f_re,oreR_f_dg,oreR_m_wb,oreR_m_ge,oreR_m_go,oreR_m_tx,oreR_m_hd,oreR_m_ac,oreR_m_re,oreR_m_dg),method ="pearson")$estimate) %>% filter(corE>=0,corE<1)
wilcox.test(1-corE~ Types, data=PeaD4)
p4<-ggplot(PeaD4,aes (y=1-corE,x=Types)) + xlab("Comparison 4")+ ylab ("Pearson Distance")+ ylim (0,0.2) + geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato")

PeaD5 <- df5 %>% rowwise() %>%
  mutate(corE= cor.test(c(w1118_f_wb,w1118_f_ge,w1118_f_go,w1118_f_tx,w1118_f_hd,w1118_f_ac,w1118_f_re,w1118_f_dg,w1118_m_wb,w1118_m_ge,w1118_m_go,w1118_m_tx,w1118_m_hd,w1118_m_ac,w1118_m_re,w1118_m_dg),c(oreR_f_wb,oreR_f_ge,oreR_f_go,oreR_f_tx,oreR_f_hd,oreR_f_ac,oreR_f_re,oreR_f_dg,oreR_m_wb,oreR_m_ge,oreR_m_go,oreR_m_tx,oreR_m_hd,oreR_m_ac,oreR_m_re,oreR_m_dg),method ="pearson")$estimate) %>% filter(corE>=0,corE<1)
wilcox.test(1-corE~ Types, data=PeaD5)
p5<-ggplot(PeaD5,aes (y=1-corE,x=Types)) + xlab("Comparison 5")+ ylab ("Pearson Distance")+ ylim (0,0.2) + geom_violin(trim=FALSE) + geom_boxplot(position="dodge",width=0.12,color="tomato")

grid.arrange(p1,p2,p3,p4,p5, nrow=1)






