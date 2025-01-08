{utp/ut-glob.i}
{esp/esb/esesb000fn.i}
    
define temp-table cabecalho no-undo xml-node-name 'CABECALHO'
   field IdentidadeEmissor as character initial '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
   field NumeroOperacao    as character
   field CodigoMensagem    as character
   field LoginUsuario      as character.

define temp-table conteudo no-undo xml-node-name 'CONTEUDO'
   field idm as integer xml-node-type 'hidden'.

define temp-table cabecalhor no-undo xml-node-name 'CABECALHO' like cabecalho.

define temp-table conteudor no-undo xml-node-name 'CONTEUDO'
   field idm as integer xml-node-type 'hidden'.

define temp-table resultado no-undo xml-node-name 'Resultado'
   field idm as int xml-node-type 'hidden'
   field Sucesso as log initial yes
   field CodigoErro as int
   field Mensagem as CHAR INITIAL "Integra‡Æo ocorrida com sucesso!".
/*                                                                             */
/* DEFINE VARIABLE c-usuario         AS CHARACTER   NO-UNDO.                   */
/* DEFINE VARIABLE c-senha           AS CHARACTER   NO-UNDO.                   */
/*                                                                             */
/* FIND FIRST ponto-programa NO-LOCK                                           */
/*     WHERE  ponto-programa.nome-programa = "escrm004":U                      */
/*     AND    ponto-programa.ponto         = 1 NO-ERROR.                       */
/* IF  AVAIL  ponto-programa THEN DO:                                          */
/*     FOR EACH  conteudo-programa NO-LOCK                                     */
/*         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa: */
/*         IF conteudo-programa.sequencia = 1 THEN DO:                         */
/*             ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")      */
/*                    c-senha   = ENTRY(2,conteudo-programa.conteudo,",").     */
/*         END.                                                                */
/*     END.                                                                    */
/* END.                                                                        */
/*                                                                             */
/* if v_cod_usuar_corren = "" or                                               */
/*    v_cod_usuar_corren = c-usuario then do:                                  */
/*                                                                             */
/*    /* Login no EMS */                                                       */
/*    run bi/esbi002.p (input c-usuario,                                       */
/*                      input c-senha).                                        */
/* end.                                                                        */
/*                                                                             */



