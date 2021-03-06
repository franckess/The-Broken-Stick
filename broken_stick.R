# Clean up
cat("\014")
rm(list = ls())
gc()

# Set up working environment
setwd("E:/Data Science/Animation")

# Loading relevant packages
suppressPackageStartupMessages(library(animation))
set.seed(2016)
prob <- function(){
  
  x <- runif(n = 2, min = 0, max = 1) # Picking 2 points randomly on the stick at the same time
  a <- min(x) # first point
  b <- max(x) # second pojnt
  pieces <- c(a, b-a, 1-b) # pieces of the stick with their respective length
  cond1 <- sum(pieces[c(1,2)]) > pieces[3] # condition # 1
  cond2 <- sum(pieces[c(1,3)]) > pieces[2] # condition # 2
  cond3 <- sum(pieces[c(3,2)]) > pieces[1] # condition # 3
  combine_conds <- ifelse(cond1 & cond2 & cond3, 1, 0) # if all 3 conditions are satisfied
  return(combine_conds)
  
}

## Visualization (option 1)
cnt <- c()
total <- 1000
for(k in 1:total) cnt = c(cnt, prob())

df <- data.frame(incrmt = 1:total, prob = rep(0, total))

for (i in 1:total)  df$prob[i] <- sum(cnt[1:i])/i

saveHTML({
  for(i in 1:total) {
    
    plot(1:i, df$prob[1:i], type = "l", ylim = c(0, 1), main = "Monte Carlo Simulation", ylab = "Probabilities",
         xlab = "iterations")
    abline(h = 0.25, col = 2, lty = 2)
    ani.pause(interval = 0.1)
  }
},img.name = "brokenstick", htmlfile = "broken_stick.html")


## Visualization (option 2)
cnt <- c()

total <- 1000

for(k in 1:total) cnt = c(cnt, index_Score())

df <- setNames(data.frame(1:total, rep(0, total)), c("Incrmt","Probs"))

for (i in 1:total)  df$Probs[i] <- sum(cnt[1:i])/i

for(i in 1:total) {
  
  sub_df <- subset(df, df$Incrmt <= i)
  simul_plot <- qplot(Incrmt, Probs, data = sub_df, geom = "path") + 
    labs(x = "iterations", y = "Probabilities", title = "Monte Carlo Simulation") + ylim(c(0,0.4)) + 
    geom_hline(yintercept = 0.25, colour = "red", linetype = "longdash")
  ggsave(plot = simul_plot, filename = paste(sprintf("images/brokenstick_%02d",i),".png", sep = ""), limitsize = FALSE)
  dev.off()
}
