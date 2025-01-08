/***   Include para os Pr‚-Processadores do Aplicativo de Distribui‡Æo    ***/
/*** Serve para o desenvolvimento tratar o conceito de miniflexibiliza‡Æo ***/ 

/*** Funcoes de Uso Geral ***/
&glob bf_dis_versao_ems        2.08  /* Utilizado para Teste de Release */

/*** Funcoes Liberadas na 2.02 ***/
&glob bf_dis_usu_moeda_cred    yes   /* Usuario e Moeda de Credito */
&glob bf_dis_fat_moeda         yes   /* Faturamento Outra Moeda */
&glob bf_dis_devol_forn        yes   /* Controle Devolucao a Fornecedor */
&glob bf_dis_siscomex_char     yes   /* Formato do campo nr-siscomex "caracter" */
&glob bf_dis_fatur_rem_emb     yes   /* Faturamento de Remito por Embarque */
&glob bf_dis_contr_fornec      yes   /* Contrato de Fornecimento para Pedido */
&glob bf_dis_nota_credito      yes   /* Nota Credito no Internacional */
&glob bf_dis_proc_ent          yes   /* Existe nr-proc-exp na Entrega do Pedido */
&glob bf_dis_mp_prog_ent       yes   /* MP para Programacao de Entrega */


/*** Funcoes Liberadas na 2.03 ***/
/*&glob bf_dis_ciap              yes   /* Ciap */*/
&glob bf_dis_desc_bonif        yes   /* Descontos e Bonificacoes */   
&glob bf_dis_adm_preco         yes   /* Administracao Precos Vendas */
&glob bf_dis_controle_fretes   yes   /* Controle de Fretes */
&glob bf_dis_adm_cotas         yes   /* Modulo de Administracao de Cotas */
&glob bf_dis_geracao_ref       yes   /* Geracao de Referencia por Nota Fiscal */
&glob bf_dis_consiste_conta    yes   /* Consistir Conta Contabil */
&glob bf_dis_default_un        yes   /* Consiste Unidade de Medida */
&glob bf_dis_unid_neg          yes   /* Unidade de Negocio */
&glob bf_dis_mp_prog_ent       yes   /* MP para Programacao de Entrega */
&glob bf_dis_aloc_neg_pre      yes   /* Novo Campo p/ Alocacao Negativa Pre-Faturamento */


/*** Funcoes Liberadas na 2.04 ***/
&glob bf_dis_usuario_estab     yes   /* Relacionamento Usu rios X Estabelecimento */
&glob bf_dis_param_estab       yes   /* Relacionamento Parƒmetros Faturamento X Estabelecimento */   
&glob bf_dis_serie_estab       yes   /* Relacionamento S‚rie X Estabelecimento */
&glob bf_dis_natur_uf          yes   /* Relacionamento Natureza Opera‡Æo X UF */
&glob bf_dis_nfe               yes   /* Nota Fiscal Eletr“nica */

/*** Fun‡äes liberadas na 2.04b, futuramente 2.05 ***/
&glob bf_dis_sales_tax               yes   /* Impostos do Produto Internacional */
&glob bf_dis_preco_un_med_mult       yes   /* Controle de Pre‡os para M£ltiplas Unidades de Medida dos Itens */
&glob bf_dis_drop_shipment           yes   /* Drop Shipment USA */
&glob bf_dis_allocate_blanket_orders yes   /* Aloca‡Æo F¡sica Pedidos Contrato de Fornecimento */


/*** Fun‡äes liberadas na 2.05 ***/
&glob bf_dis_desc_valor                  yes   /* Desconto por Valor                */
&glob bf_dis_formato_cfop                yes   /* Novo Formato Natureza de Opera‡Æo */
&glob bf_dis_vcp_pdp                     yes   /* Int Ped X Adm Val Config */

/*** Fun‡äes liberadas na 2.06 ***/
&glob bf_dis_gradiente                   yes   /* Funcoes da Gradiente que serÆo repassadas para a 2.05 */

/*** Fun‡äes liberadas na 2.06B ***/
&glob bf_dis_al                          yes   /* AL Î DIS-1 Î Numera‡Æo de Faturas */

/*** Fun‡äes liberadas na 2.07 ***/
&glob bf_dis_imp_AL                     yes   /* AL - DIS-3 - IVA por regiÆo - Vendas */
&glob bf_dis_nfe                        yes   /* Nota Fiscal Eletr“nica */ 
&glob bf_dis_sgt                        yes   /* Integra‡Æo EMS X SGT - OPERACIONAL TEXTIL */

/*** Fun‡äes liberadas na 2.08 ***/
&glob bf_libera_15_posicoes             yes   /* Libera o tamanho da nota fiscal para os documentos que entram no EMS2 para 15 posi‡äes */ 
&glob bf_lote_avancado_liberado         yes   /* Funcionalidade de Lote Avan‡ado */ 
&glob bf_unidade_negocio_deposito       yes   /* Controle de unidade de neg¢cio por dep¢sito nos processos de distribui‡Æo */ 
