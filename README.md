# Multiestabilidade em Populações de Pragas e Seus Predadores Naturais sob o Uso de Pesticidas

Este repositório contém os scripts em R utilizados para a modelagem matemática da dinâmica entre populações de pragas e seus predadores naturais sob o efeito de pesticidas. O estudo investiga como diferentes cenários de capacidade de suporte e intensidades de impacto dos pesticidas sobre os predadores afetam a multiestabilidade no sistema.

## Descrição do Projeto

A proposta deste projeto é analisar a interação entre pragas e seus predadores naturais em sistemas agrícolas, considerando os efeitos deletérios dos pesticidas sobre os predadores. A pesquisa utiliza simulações para observar o comportamento dinâmico do sistema, incluindo estados de equilíbrio alternativos e as implicações para o manejo integrado de pragas (MIP).

## Scripts

Os scripts contidos neste repositório foram desenvolvidos para:

1. Simular a dinâmica populacional de pragas e predadores naturais.
2. Analisar a multiestabilidade e os estados de equilíbrio do sistema.
3. Gerar gráficos, como a curva S e o gráfico de bifurcação cúspide, para visualizar as transições no sistema.

### Estrutura dos arquivos

- `sobreposicao_func_S_curve-V2`: Este script gera gráficos a partir do modelo matemático, com a sobreposição de curvas do crescimento de pragas e da resposta funcional dos predadores. Com isso é possível gerar uma curva S, permitindo a análise visual das diferentes respostas do sistema conforme o efeito dos pesticidas sobre os predadores naturais varia.
- `cuspBifurcation-V2`: Este script realiza a simulação e visualização do gráfico de bifurcação cúspide. A bifurcação cúspide revela como a variação da capacidade de suporte (K) e o efeito dos pesticidas sobre os predadores influenciam as transições abruptas entre estados de baixa e alta densidade de pragas. O gráfico gerado a partir deste script é essencial para entender como pequenas mudanças nos parâmetros podem levar a grandes diferenças no comportamento dinâmico do sistema.

## Como Utilizar

1. Clone este repositório para sua máquina local:
   ```bash
   git clone https://github.com/eduardosph/Multiestabilidade-em-popula-es-de-pragas-e-seus-predadores-naturais-sob-o-uso-de-pesticidas.git

2. Certifique-se de ter o R instalado no seu computador.

3. Abra os arquivos .R no RStudio (ou outra IDE de sua preferência) e execute as simulações.

## Referências

Se desejar mais informações sobre os conceitos e resultados abordados neste projeto, consulte o artigo completo ou entre em contato.

## Autor

Este projeto foi desenvolvido por Eduardo Cerqueira e Silva, sob a Orientação do Dr. Rafael Dettogni Guariento, como parte da dissertação de mestrado em Ecologia e Conservação pela Universidade Federal do Mato Grosso do Sul - UFMS.


