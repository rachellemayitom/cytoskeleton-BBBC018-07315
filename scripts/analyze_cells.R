# Cytoskeleton and Cell Morphology
# Phenotype: Peripheral Actin
# Image ID: 07315

# 1. Use the measurements already imported in R
d <- read.csv("data/Fiji_results.csv")

# 2. Required columns
needed <- c("Area", "Mean", "Circ.", "AR")

if (!all(needed %in% names(d))) {
  stop("Missing Fiji columns. Recheck Set Measurements.")
}

# 3. Remove incomplete measurements
d <- d[complete.cases(d[, needed]), ]

if (nrow(d) < 5) {
  stop("Measure five clear cells.")
}

# 4. Add cell IDs
d$Cell <- paste0("Cell_", seq_len(nrow(d)))

# 5. Create output folders if needed
dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# 6. Save numerical summary
phenotype <- "Peripheral Actin"
image_id <- "07315"

s <- data.frame(
  phenotype = phenotype,
  image_id = image_id,
  cells_measured = nrow(d),
  mean_area = mean(d$Area),
  mean_circularity = mean(d$Circ.),
  mean_aspect_ratio = mean(d$AR),
  mean_actin_signal = mean(d$Mean)
)

write.csv(
  s,
  "results/cell_summary.csv",
  row.names = FALSE
)

print(s)

# 7. Figure 1: Cell area versus circularity
png("figures/area_vs_circularity.png",
    width = 900, height = 650)

plot(d$Area, d$Circ.,
     pch = 19,
     col = "steelblue",
     xlab = "Cell area (pixels squared)",
     ylab = "Circularity (0 to 1)",
     main = paste(phenotype, "-", image_id))

text(d$Area, d$Circ.,
     labels = d$Cell,
     pos = 3, cex = 0.75)

dev.off()

# 8. Figure 2: Relative actin signal
png("figures/actin_intensity.png",
    width = 900, height = 650)

barplot(d$Mean,
        names.arg = d$Cell,
        col = "steelblue",
        ylab = "Mean actin fluorescence (arbitrary units)",
        main = paste("Actin Signal -", image_id))

dev.off()