library(ggplot2)

NH <-500 #numero maximo de valores de densidade de pragas possiveis
data<-array(0,dim = c(NH,5))  # para guardar os resultados

for (z in 1:NH){
  
  N <- seq(0, 8, by = 0.01)
  
  D <- 2
  P <- 1
  
  r <- 0.3          # Taxa intrínseca de crescimento da população de pragas
  d_N <- 0.1        # Efeito do pesticida na população de pragas
  K <- 8            # Capacidade suporte do sistema
  a <- 1.0          # Taxa de ataque do predador
  d_P_max <- 0.49     # Efeito do pesticida no forrageamento dos predadores
  h <-2        # Taxa de manuseio do predador (handling time)
  
  
  
  d_P_real<-z * d_P_max / NH  # Calcula o valor incremental de d_P_real ao longo do intervalo de 0 a d_P_max
  d_P<-d_P_real  # 2, 4 e 6   # Define d_P como o valor incremental de d_P_real para a iteração atual

  f_ND <- function(N, D) (r * (1 - d_N * D) * (1 - N/K) * N)
  g_ND <- function(N, D, P) ((a * (1 - d_P * D) * N^2) / (1 + a* h * (1 - d_P * D) * N^2))
  
  my_data <- data.frame(argx = N, f_ND = f_ND(N, D),
                        g_ND = g_ND(N, D, P))
  

  
  diferenca<-1:nrow(my_data)
  for (i in 1:nrow(my_data)){
    
    diferenca[i]<-my_data[i,2]- my_data[i,3]
    
  }
  
  
  df_total <- data.frame()
  
  df_total<-data.frame()
  
  for (i in 1:(nrow(my_data)-1)){
    
    if (diferenca[i+1]==0 ){
      df<-my_data[(i+1),1]
      df_total<-rbind(df_total,df) } 
    else if (diferenca[i+1]*diferenca[i]<0 ){
      df<-(my_data[(i+1),1]+my_data[(i),1])/2
      df_total<-rbind(df_total,df)
      df_total<-as.matrix(df_total)
    }
  }
  
  if (length(df_total) ==1){
    
    data[z,1]<-d_P
    data[z,2]<-df_total[1,1]
  }
  
  if (length(df_total) ==3){
    
    data[z,1]<-d_P
    data[z,3]<-df_total[1,1]
    data[z,4]<-df_total[2,1]
    data[z,5]<-df_total[3,1]
    
  }
}

# Carregar os dados
data
md <- data
md[md == 0] <- NA

# Plotagem da curva S
plot(md[, 1], md[, 2], ylim = c(0, 6), type = "l", col = "blue",
     xlab = "Efeito do pesticida no forrageamento dos predadores (d_P)",
     ylab = "Densidade de pragas (N)",
     main = "Curva S: Densidade de Pragas vs Efeito do Pesticida",
     lwd = 2)

# Linhas adicionais da curva S com multiestabilidade
par(new = TRUE)
plot(md[, 1], md[, 3], ylim = c(0, 6), type = "l", col = "green",
     xlab = "", ylab = "", axes = FALSE, lwd = 2)
par(new = TRUE)
plot(md[, 1], md[, 4], ylim = c(0, 6), type = "l", col = "red",
     xlab = "", ylab = "", axes = FALSE, lwd = 2)
par(new = TRUE)
plot(md[, 1], md[, 5], ylim = c(0, 6), type = "l", col = "green",
     xlab = "", ylab = "", axes = FALSE, lwd = 2)

# Legenda
legend("bottomright", 
       legend = c("Um ponto de equilíbrio", 
                  "Multiestabilidade", 
                  "Multiestabilidade instável"),
       col = c("blue", "green", "red"), lty = 1, lwd = 2, cex = 0.8,
       cex = 1.5,  # Aumenta o tamanho da fonte da legenda
       text.font = 4,  # Para deixar o texto mais em negrito (opcional)
       title = "Estados de Equilíbrio")


write.csv(data, file = "dados-S-curve.csv")




ggplot(my_data) +
  geom_point(aes(argx, f_ND, color = 'crescimento de pragas'), size = 0.5) +  # Tamanho menor para os pontos
  geom_line(aes(argx, f_ND, color = 'crescimento de pragas'), size = 0.2) +  # Tamanho da linha reduzido
  geom_point(aes(argx, g_ND, color = 'resposta funcional da predação'), size = 0.5) +  # Tamanho menor para os pontos
  geom_line(aes(argx, g_ND, color = 'resposta funcional da predação'), size = 0.2) +  # Tamanho da linha reduzido
  theme_bw() + 
  labs(x = 'Densidade de pragas', y = 'Taxas de crescimento de pragas ou resposta funcional da predação') +
  scale_color_manual(values = c('crescimento de pragas' = 'blue', 'resposta funcional da predação' = 'red'),
                     labels = c(expression(f(N,D)~"crescimento de pragas"), 
                                expression(g(N,D)~"resposta funcional da predação")),
                     name = 'Função') +
  theme(
    legend.text = element_text(size = 14),  # Aumenta o tamanho da fonte do texto da legenda
    legend.title = element_text(size = 16),  # Aumenta o tamanho da fonte do título da legenda
    legend.position = "bottom",  # Posiciona a legenda abaixo do gráfico
    axis.title = element_text(size = 16),  # Aumenta o tamanho da fonte dos nomes dos eixos
    axis.title.x = element_text(margin = margin(t = 20)),  # Aumenta o espaçamento do eixo X em relação ao gráfico
    axis.title.y = element_text(margin = margin(r = 20))   # Aumenta o espaçamento do eixo Y em relação ao gráfico
  ) +
  guides(color = guide_legend(override.aes = list(size = 3)))  # Aumenta a grossura das linhas na legenda

