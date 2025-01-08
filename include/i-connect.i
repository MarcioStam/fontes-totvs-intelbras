/**********************************
** Pr‚-Processadores
** 
** "{1}" 1- Conecta  2- Desconecta
** "{2}" Nome do Banco
**********************************/

/* Sempre desconecta o banco que ser  utilizado para evitar que seja utilizado um banco j  conectado de outra empresa */
if connected ("{2}")
   then run pi_conecta_persistent in v_hdl_btb_connect (input 1,
                                                        input 2,                  /* 1- Conecta  2- Desconecta */
                                                        input v_cod_empres_usuar, /* C¢digo da Empresa no EMS5 */
                                                        input "{2}",              /* Nome do Banco             */
                                                        output v_log_sucesso,
                                                        output table tt_erros_conexao).

/* Conecta o banco conforme a chamada */
if "{1}" = "1"
   then run pi_conecta_persistent in v_hdl_btb_connect (input 1,
                                                        input 1,                  /* 1- Conecta  2- Desconecta */
                                                        input v_cod_empres_usuar, /* C¢digo da Empresa no EMS5 */
                                                        input "{2}",              /* Nome do Banco             */
                                                        output v_log_sucesso,
                                                        output table tt_erros_conexao).
