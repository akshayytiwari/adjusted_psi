# --- Code for MCMC simulations with evolving sensitivity and specificity as done by Mitchell et al. ---

# Model development
model_string <- "
model {
  x[1:4] ~ dmultinom(p[1:4], n)

  # Probabilities of observing counts in each category
  p1 <- sen * P_Z * (P_SZ + P_SB - gamma * P_SZ * P_SB) + (1 - spe) * (1 - P_Z) * P_SB
  p2 <- sen * P_Z * (1 - P_SZ - P_SB + gamma * P_SZ * P_SB) + (1 - spe) * (1 - P_Z) * (1 - P_SB)
  p3 <- spe * (1 - P_Z) * P_SB + (1 - sen) * P_Z * (P_SZ + P_SB - gamma * P_SZ * P_SB)
  p4 <- spe * (1 - P_Z) * (1 - P_SB) + (1 - sen) * P_Z * (1 - P_SZ - P_SB + gamma * P_SZ * P_SB)
  total <- p1 + p2 + p3 + p4
  
  p[1] <- p1 / total
  p[2] <- p2 / total
  p[3] <- p3 / total
  p[4] <- p4 / total

  P_Z ~ dbeta(1, 1)
  P_SZ ~ dbeta(1, 1)
  P_SB ~ dbeta(1, 1)
  sen ~ dbeta(sen_a, sen_b)
  spe ~ dbeta(spe_a, spe_b)
}
"

model_mitchell <- function(data_vector, gamma_val, sen_a, sen_b, spe_a, spe_b) {
  jags_data <- list(
    x = data_vector,
    n = sum(data_vector),
    gamma = gamma_val,
    sen_a = sen_a,
    sen_b = sen_b,
    spe_a = spe_a,
    spe_b = spe_b
  )
  
  inits <- function() {
    list(
      P_Z = runif(1),
      P_SZ = runif(1),
      P_SB = runif(1),
      sen = runif(1),
      spe = runif(1)
    )
  }
  model <- jags.model(textConnection(model_string), data = jags_data, inits = inits, n.chains = 3, quiet = TRUE)
  update(model, 10000)  # Burn-in
  samples <- coda.samples(model, c("P_Z", "P_SZ", "P_SB", "sen", "spe"), n.iter = 1000000, thin = 1000)
  summary_stats <- summary(samples)
  estimates <- summary_stats$quantiles[, c("50%", "2.5%", "97.5%")]
  colnames(estimates) <- c("Median", "CrI_Lower", "CrI_Upper")
  
  out <- c(estimates["P_Z", ], estimates["P_SZ", ], estimates["P_SB", ],
           estimates["sen", ], estimates["spe", ])
  names(out) <- c("P_Z_Median", "P_Z_CrI_Lower", "P_Z_CrI_Upper",
                  "P_SZ_Median", "P_SZ_CrI_Lower", "P_SZ_CrI_Upper",
                  "P_SB_Median", "P_SB_CrI_Lower", "P_SB_CrI_Upper",
                  "sen_Median", "sen_CrI_Lower", "sen_CrI_Upper",
                  "spe_Median", "spe_CrI_Lower", "spe_CrI_Upper")
  return(out)
}

# Calling model with a toy example (to ensure that model is running well)
# n_sym_pos <- 50; n_asym_pos <- 30; n_sym_neg <- 20; n_asym_neg <- 70
# x_simulated <- c(n_sym_pos, n_asym_pos, n_sym_neg, n_asym_neg)
# estimates <- model_mitchell(x_simulated, gamma_val = 1, 35, 2, 17, 1)
