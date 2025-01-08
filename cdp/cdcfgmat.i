/***   Include para os Pr‚-Processadores do Aplicativo de Distribui‡Æo    ***/
/*** Serve para o desenvolvimento tratar o conceito de miniflexibiliza‡Æo ***/ 

/*** Funcoes de Uso Geral ***/
&glob bf_mat_versao_ems        2.08 /* Corresponde a versÆo 2.06 */

/*** Funcoes Liberadas na 2.02 ***/
&glob bf_mat_receb_fisico            yes   /* Recebimento Fisico */
&glob bf_mat_unidade_negocio         yes   /* Unidade de Negocio */
&glob bf_mat_controle_verba          yes   /* Verifica Controle de Verba no Investimento */
&glob bf_mat_contratos               yes   /* Melhorias em Controle de Contratos */
&glob bf_mat_aprova_eletronica       yes   /* Melhorias da Aprovacao Eletronica */
&glob bf_mat_desatualiza_ap          yes   /* Desatualizacao AP */
&glob bf_mat_variacao_compras        yes   /* Conciliacao Transitoria Fornecedores */
&glob bf_mat_contrato_moedas         yes   /* Consulta Multi-Moeda em Controle Contratos */
&glob bf_mat_ext_ord_per             yes   /* Conversao da Tabela ext-ord-per da 2.01 p/ 2.02 */
&glob bf_mat_tipo_ressup             yes   /* Tipo de Ressuprimento de Estoque */
&glob bf_mat_consumo_estab           yes   /* Consumo e Estatistica por Estabelec */
&glob bf_mat_susp_ii_ipi             yes   /* Suspensao IPI Importacao */

/*** Funcoes Liberadas na 2.04 ***/
&glob bf_mat_conv_moedas             yes   /* Fator Multiplicativo/Divisivo Conversao Moedas */
&glob bf_mat_item_natureza           yes   /* Ident Imposto do Item Conforme a Natureza */
&glob bf_mat_iva_despesas            yes   /* Inclusao Impostos nas Despesas da Nota (MAT e DIS) */
&glob bf_mat_selecao_estab_re        yes   /* Selecao Estabelecimentos no Recebimento */
&glob bf_mat_conta_estab             yes   /* Contas Transitorias por Estabelecimento */
&glob bf_mat_fech_estab              yes   /* Fechamento por Estabelecimento */
&glob bf_mat_comp_uso_certific       yes   /* Componentes Usados em Certificado */
&glob bf_mat_natur_compra_re         yes   /* Tipo de Compra na Natureza de Operacao para Recebimento */
&glob bf_mat_ref_lote                yes   /* Tratamento de Multiplas Referencias por Lote */
&glob bf_mat_estorno_devol           yes   /* Estorno Devolucao AP/CR */
&glob bf_mat_cons_estat_estab        yes   /* Consumo e Estatistica por Estabelec - Fase II */
&glob bf_mat_esp_fiscal              yes   /* Especie Fiscal no Recebimento */
&glob bf_mat_oper_triangular         yes   /* Operacao Triangular - Materiais */
&glob bf_mat_rateio_despesas         yes   /* Rateio Despesas Recebimento Internacional */
&glob bf_mat_reporte_autom           yes   /* Reporte Automatico do Acabado */
&glob bf_mat_contrato_perm           yes   /* Melhorias em Contratos (Permissoes, Aprovacao, etc...) */
&glob bf_mat_uni_estab               yes   /* Parƒmetros Item/Fam¡lia por Estabelecimento */
&glob bf_mat_conta_contab_inp        yes   /* Conta Cont bil Investimentos */
&glob bf_mat_importacao_mrp          yes   /* Importacao x MRP */
&glob bf_mat_nf_simp_remes_desp_imp  yes   /* Nota Fiscal de Simples Remessa e Despesas da Nota Fiscal Complementar */

/*** Funcoes Liberadas na 2.04A ***/
&glob bf_mat_custeio_item            yes   /* Novos metodos de custeio on-line */

/*** Funcoes Pendentes ***/
/*&glob bf_mat_devol_cli_inter       yes   /* Devolucao de Cliente do Internacional */*/
/*&glob bf_mat_estorno_cr            yes   /* Estorno Contas a Receber */*/
/*&glob bf_mat_custo_on_line         yes   /* Custo On-line */*/

/*** Funcoes Liberadas na 2.04B ***/
&glob bf_mat_despesa_compra_inter    yes /* Duty Code em Compras e Recebimento */
&glob bf_mat_fornec_temporario       yes /* Fornecedor Tempor rio */
&glob bf_mat_gl_posting_details      yes /* Rastreabilidade */
&glob bf_mat_po_number               yes /* PO Number */
&glob bf_mat_despesa_fase_II         yes /* Duty Code em contratos */

/*** Funcoes Liberadas na 2.05 ***/
&glob bf_mat_bloqueio_fornec         yes /* Bloqueio Fornecedor */
&glob bf_mat_cc_invest               yes /* Altera‡Æo dos campos centro de custo */

/*** Funcoes Liberadas na 2.06 ***/
&glob bf_mat_gradiente               yes   /* Funcoes da Gradiente que serÆo repassadas para a 2.05 */
&glob bf_mat_portador_ap             yes   /* Portador AP */

/*** Funcoes Liberadas na 2.08 ***/
&glob bf_libera_15_posicoes          no    /* Libera o tamanho da nota fiscal para os documentos que entram no EMS2 para 15 posi‡äes */ 
&glob bf_lote_avancado_liberado      yes   /* Funcionalidade de Lote Avan‡ado */ 
