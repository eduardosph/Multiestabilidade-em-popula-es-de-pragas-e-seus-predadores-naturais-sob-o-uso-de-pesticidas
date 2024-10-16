# Criado por Eduardo Cerqueira e Silva e Rafael Dettogni Guariento.
# Todos os direitos reservados
# E-mail: duducerqueira.br@gmail.com
# GitHub: https://github.com/eduardosph/Multiestabilidade-em-popula-es-de-pragas-e-seus-predadores-naturais-sob-o-uso-de-pesticidas

library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)

NH <- 300 # número máximo de valores de densidade de pragas possíveis
NK <- 150  # número de variações de K
data <- array(0, dim = c(NH*NK, 6))  # para guardar os resultados, incluindo K

for (w in 1:NK) {
  for (z in 1:NH) {
    N <- seq(0, 10, by = 0.01)
    
    D <- 2
    P <- 1
    
    r <- 0.3          # Taxa intrínseca de crescimento da população de pragas
    d_N <- 0.1        # Efeito do pesticida na população de pragas
    Kmax <- 10        # Capacidade máxima de suporte do sistema
    K <- w * Kmax / NK           
    a <- 1.0          # Taxa de ataque do predador
    d_P_max <- 0.49   # Efeito do pesticida no forrageamento dos predadores
    h <- 2            # Taxa de manuseio do predador (handling time)
    
    d_P_real <- z * d_P_max / NH
    d_P <- d_P_real
    
    f_ND <- function(N, D) (r * (1 - d_N * D) * (1 - N / K) * N)
    g_ND <- function(N, D, P) ((a * (1 - d_P * D) * N^2) / (1 + a * h * (1 - d_P * D) * N^2))
    
    my_data <- data.frame(argx = N, f_ND = f_ND(N, D), g_ND = g_ND(N, D, P))
    
    diferenca <- numeric(nrow(my_data))
    for (i in 1:nrow(my_data)) {
      diferenca[i] <- my_data[i, 2] - my_data[i, 3]
    }
    
    df_total <- data.frame()
    
    for (i in 1:(nrow(my_data) - 1)) {
      if (diferenca[i + 1] == 0) {
        df <- my_data[(i + 1), 1]
        df_total <- rbind(df_total, df) 
      } else if (diferenca[i + 1] * diferenca[i] < 0) {
        df <- (my_data[(i + 1), 1] + my_data[(i), 1]) / 2
        df_total <- rbind(df_total, df)
        df_total <- as.matrix(df_total)
      }
    }
    
    if (length(df_total) == 1) {
      data[z + (NH * w - NH), 1] <- d_P
      data[z + (NH * w - NH), 2] <- df_total[1, 1]
      data[z + (NH * w - NH), 6] <- K
    }
    
    if (length(df_total) == 3) {
      data[z + (NH * w - NH), 1] <- d_P
      data[z + (NH * w - NH), 3] <- df_total[1, 1]
      data[z + (NH * w - NH), 4] <- df_total[2, 1]
      data[z + (NH * w - NH), 5] <- df_total[3, 1]
      data[z + (NH * w - NH), 6] <- K
    }
  }
}

# Criar uma coluna de objeto data indicando os valores de K para cada fatia da curva S

data <- as.data.frame(data)
data <- data %>%
  mutate(across(where(is.numeric), ~ ifelse(. == 0.000 | . == 0, NA, .)))
colnames(data) <- c("d_P", "N1", "N2", "N3", "N4", "K")
data_long <- data %>%
  pivot_longer(cols = starts_with("N"), names_to = "N_type", values_to = "N") %>%
  filter(!is.na(N))

write.csv(data, file = "cusp-K.csv")


# Criar gráfico de bifurcação cusp usando plotly com tamanho dos pontos em 0.8

plot_ly(data_long, x = ~d_P, y = ~K, z = ~N, color = ~N_type, colors = c('blue', '#CFB53B', 'red', '#CFB53B')) %>%
  add_markers(size = I(0.8)) %>% 
  layout(scene = list(xaxis = list(title = 'Efeito do pesticida nos predadores (d_P)'),
                      yaxis = list(title = 'Capacidade de suporte (K)'),
                      zaxis = list(title = 'Densidade de pragas (N)')))



