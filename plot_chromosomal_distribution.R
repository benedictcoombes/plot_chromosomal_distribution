library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

input_file=args[1]
output_file_name=args[2]

dat <- read.table(input_file, header = FALSE)

colnames(dat) <- c("chr", "position", "cov")
dat$position <- dat$position / 1000000

dat <- dat[dat$chr != "chrUn",]

plot <- ggplot(data = dat, aes(x=position, y=cov)) +
  geom_col() +
  facet_wrap(~chr, ncol = 3) +
  theme_bw() +
  scale_x_continuous(breaks = c(0,100,200,300,400,500,600,700,800,900,1000)) +
  labs(x="Chromosomal Position (Mbp)", y="Number of features")

ggsave(output_file_name, plot, height=8, width=16, device="png")
