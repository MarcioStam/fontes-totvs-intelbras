&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172Q01 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName item
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item
&GLOBAL-DEFINE TableLabel item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{cdp/cdcfgdis.i}
{inbo/boin172.i RowObject}
{inbo/boin172.i tt-item}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-parametros-ini AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR c-parametros-fim AS CHAR FORMAT "x(60)" NO-UNDO.

DEF VAR c-it-codigo-ini AS CHAR NO-UNDO.
DEF VAR c-it-codigo-fim AS CHAR NO-UNDO.
DEF VAR c-desc-item-ini AS CHAR NO-UNDO.
DEF VAR c-desc-item-fim AS CHAR NO-UNDO.


/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n’o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgdis.i}
{cdp/cdcfgman.i}


def temp-table tt-raw-transfere NO-UNDO
   field raw-registro as RAW.
   
define temp-table RowErrorsFrotas no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 10.79
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters: ipar:c-it-codigo: Item
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findKeyRowid DBOProgram 
PROCEDURE findKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:   Localiza registro pela chave e retorna o rowid.
  Parameters:ipar:p-it-codigo:Item
             opar:p-rowid:Rowid que será retornado
  -----------------------------------------------------------------------------*/  
    &if defined(bf-mat-comex) &then    
    &else  
        def input  parameter p-it-codigo like item.it-codigo.
        def output parameter p-rowid as rowid no-undo.
    
        find {&TABLENAME} where
            {&tablename}.it-codigo = p-it-codigo
            no-lock no-error.
        if available {&TABLENAME} then
            assign p-rowid = rowid({&TABLENAME}).
            assign p-rowid = rowid({&TABLENAME}).
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRowidItem DBOProgram 
PROCEDURE findRowidItem :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada pelo produto TMS da Logistica.
               Qualquer d£vida entrar em contato com o suporte.
  Parameters:  Recebe rowid do Item
               Retorna o c¢digo do Item
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pRowidItem AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER pItCodigo  AS CHARACTER  NO-UNDO.

    FIND FIRST bf{&TableName} NO-LOCK
        WHERE ROWID(bf{&TableName}) = pRowidItem NO-ERROR.
    IF AVAIL bf{&TableName} THEN
        ASSIGN pItCodigo = bf{&tablename}.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-folh-item":U THEN ASSIGN pFieldValue = RowObject.cd-folh-item.            
        WHEN "cd-folh-lote":U THEN ASSIGN pFieldValue = RowObject.cd-folh-lote.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-auxiliar":U THEN ASSIGN pFieldValue = RowObject.cod-auxiliar.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "codigo-refer":U THEN ASSIGN pFieldValue = RowObject.codigo-refer.
        WHEN "de-codigo-prin":U THEN ASSIGN pFieldValue = RowObject.de-codigo-prin.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "desc-inter":U THEN ASSIGN pFieldValue = RowObject.desc-inter.        
        WHEN "desc-nacional":U THEN ASSIGN pFieldValue = RowObject.desc-nacional.        
        WHEN "descricao-1":U THEN ASSIGN pFieldValue = RowObject.descricao-1.
        WHEN "descricao-2":U THEN ASSIGN pFieldValue = RowObject.descricao-2.        
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.        
        WHEN "inform-compl":U THEN ASSIGN pFieldValue = RowObject.inform-compl.        
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.        
        WHEN "it-demanda":U THEN ASSIGN pFieldValue = RowObject.it-demanda.        
        WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
        WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.        
        WHEN "path":U THEN ASSIGN pFieldValue = RowObject.path.        
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.        
        &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
            &IF {&BF_DIS_VERSAO_EMS} < 2.05 &THEN
               WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
               WHEN "rv-codigo":U THEN ASSIGN pFieldValue = RowObject.rv-codigo.         
            &endif
        &endif
        
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.        
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.                    
        &if defined(bf-mat-comex) &then            
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.        
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.        
            WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.        
            WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.        
            WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.    
            WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.            
            WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.        
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.        
            WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
            WHEN "localizacao":U THEN ASSIGN pFieldValue = RowObject.localizacao.                    
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.        
            WHEN "u-char-2":U THEN ASSIGN pFieldValue = RowObject.u-char-2.                
        &else
            WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
            WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
            WHEN "cd-tag":U THEN ASSIGN pFieldValue = RowObject.cd-tag.            
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
            WHEN "prefixo-lote":U THEN ASSIGN pFieldValue = RowObject.prefixo-lote.
            WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
            WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
            WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.            
            WHEN "conta-aplicacao":U THEN ASSIGN pFieldValue = RowObject.conta-aplicacao.
            WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.            
            WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.            
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-liberac":U THEN ASSIGN pFieldValue = RowObject.data-liberac.
        WHEN "data-obsol":U THEN ASSIGN pFieldValue = RowObject.data-obsol.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
        WHEN "dt-ult-ben":U THEN ASSIGN pFieldValue = RowObject.dt-ult-ben.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-ISS":U THEN ASSIGN pFieldValue = RowObject.aliquota-ISS.    
        WHEN "altura":U THEN ASSIGN pFieldValue = RowObject.altura.    
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.                        
        WHEN "comprim":U THEN ASSIGN pFieldValue = RowObject.comprim.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.        
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ft-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.ft-conv-fmcoml.
        WHEN "ft-conversao":U THEN ASSIGN pFieldValue = RowObject.ft-conversao.
        WHEN "largura":U THEN ASSIGN pFieldValue = RowObject.largura.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
        WHEN "per-min-luc":U THEN ASSIGN pFieldValue = RowObject.per-min-luc.
        WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
        WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
        WHEN "perc-demanda":U THEN ASSIGN pFieldValue = RowObject.perc-demanda.
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
        WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-sem-tx":U THEN ASSIGN pFieldValue = RowObject.pr-sem-tx.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.                    
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.                    
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
        WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
        WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.        
        WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.                                
        &if defined(bf-mat-comex) &then       
            when "val-unit-mat[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat[1].
            when "val-unit-mat[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat[2].
            when "val-unit-mat[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat[3].        
            when "val-unit-mob[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob[1].        
            when "val-unit-mob[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob[2].
            when "val-unit-mob[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob[3].
            when "u-dec-1":U THEN ASSIGN pFieldValue = RowObject.u-dec-1.
            when "u-dec-2":U THEN ASSIGN pFieldValue = RowObject.u-dec-2.             
        &else
            WHEN "fator-reaj-icms":U THEN ASSIGN pFieldValue = RowObject.fator-reaj-icms.        
            WHEN "qt-var-max":U THEN ASSIGN pFieldValue = RowObject.qt-var-max.
            WHEN "qt-var-min":U THEN ASSIGN pFieldValue = RowObject.qt-var-min.            
            WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
            WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
            WHEN "quant-pacote":U THEN ASSIGN pFieldValue = RowObject.quant-pacote.
            WHEN "valor-ipi-beb":U THEN ASSIGN pFieldValue = RowObject.valor-ipi-beb.            
            WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
            WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
            WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.    
        WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.     
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.        
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.           
        WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.        
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.        
        WHEN "dec-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.dec-conv-fmcoml.
        WHEN "dec-ftcon":U THEN ASSIGN pFieldValue = RowObject.dec-ftcon.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
        WHEN "INT-1":U THEN ASSIGN pFieldValue = RowObject.INT-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "isencao-import":U THEN ASSIGN pFieldValue = RowObject.isencao-import.
        WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
        WHEN "niv-mps":U THEN ASSIGN pFieldValue = RowObject.niv-mps.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "nr-item-dcr":U THEN ASSIGN pFieldValue = RowObject.nr-item-dcr.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.        
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.   
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.             
        WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.        
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.        
        &if defined(bf-mat-comex) &then       
            when "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.        
            when "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.                
        &else
            WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
            WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
            WHEN "enquad-beb":U THEN ASSIGN pFieldValue = RowObject.enquad-beb.
            WHEN "esp-beb":U THEN ASSIGN pFieldValue = RowObject.esp-beb.
            WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
            WHEN "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.
            WHEN "capac-recip-beb":U THEN ASSIGN pFieldValue = RowObject.capac-recip-beb.
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
            WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
            WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
            WHEN "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.
            WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
            WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
            WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
            WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
            WHEN "nr-pontos-quotas":U THEN ASSIGN pFieldValue = RowObject.nr-pontos-quotas.
            WHEN "Nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.Nr-ult-peca.
            WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
            WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
            WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
            WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
            WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
            WHEN "tipo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-atp.
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
            WHEN "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.
            WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
            WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
            WHEN "tipo-recip-beb":U THEN ASSIGN pFieldValue = RowObject.tipo-recip-beb.
            WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
            WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
            WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
            WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
            WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
            WHEN "cod-tax-serv":U THEN ASSIGN pFieldValue = RowObject.cod-tax-serv.
            WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
            WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.        
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then      
    &else     
        DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.
    
        /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.
    
        ASSIGN pit-codigo = RowObject.it-codigo.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.    
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.                
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
        WHEN "id-grade":U THEN ASSIGN pFieldValue = RowObject.id-grade.
        WHEN "ind-backorder":U THEN ASSIGN pFieldValue = RowObject.ind-backorder.
        WHEN "ind-especifico":U THEN ASSIGN pFieldValue = RowObject.ind-especifico.
        WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
        WHEN "ind-ipi-dife":U THEN ASSIGN pFieldValue = RowObject.ind-ipi-dife.
        WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        &if defined (bf_dis_versao_ems)  &then
            &if {&bf_dis_versao_ems} >= 2.04 &then
                WHEN "log-necessita-li":U THEN ASSIGN pFieldValue = RowObject.log-necessita-li.
            &endif
        &endif
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "pm-ja-calc":U THEN ASSIGN pFieldValue = RowObject.pm-ja-calc.            
        &if defined(bf-mat-comex) &then      
            when "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.        
            when "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.        
            when "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.        
            when "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.        
            when "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.        
            when "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.        
            when "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.        
            when "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.        
            when "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.        
            when "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.        
            when "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.        
            when "u-log-1":U THEN ASSIGN pFieldValue = RowObject.u-log-1.                        
        &else     
            WHEN "alt-refer":U THEN ASSIGN pFieldValue = RowObject.alt-refer.
            WHEN "incentivado":U THEN ASSIGN pFieldValue = RowObject.incentivado.
            WHEN "ind-confprodcom":U THEN ASSIGN pFieldValue = RowObject.ind-confprodcom.
            WHEN "ind-quotas":U THEN ASSIGN pFieldValue = RowObject.ind-quotas.
            WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
            WHEN "log-carac-tec":U THEN ASSIGN pFieldValue = RowObject.log-carac-tec.
            WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
            WHEN "rot-quant":U THEN ASSIGN pFieldValue = RowObject.rot-quant.
            WHEN "rot-refer":U THEN ASSIGN pFieldValue = RowObject.rot-refer.
            WHEN "rot-revis":U THEN ASSIGN pFieldValue = RowObject.rot-revis.
            WHEN "tp-lote-econom":U THEN ASSIGN pFieldValue = RowObject.tp-lote-econom.
            WHEN "tp-lote-minimo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-minimo.
            WHEN "tp-lote-multiplo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-multiplo.
            WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.        
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then      
    &else
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.
    
        /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.
    
        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then      
    &else
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.
    
        /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.
    
        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowid DBOProgram 
PROCEDURE goToKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then      
    &else
        DEFINE INPUT PARAMETER prowid AS rowid NO-UNDO.
    
        FIND FIRST bfitem WHERE
             rowid(bfitem) = prowid
             NO-LOCK NO-ERROR.
       
        /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfitem THEN
            RETURN "NOK":U.
    
        /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
              existam erros ser  retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 6 then
              RUN openQueryStatic (input "ByFiltroItCodigo":U).
       
           when 7 then
              RUN openQueryStatic (input "ByFiltroDescricao":U).
              
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescItem DBOProgram 
PROCEDURE openQueryByDescItem :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
    /*
    &if defined(bf-mat-comex) &then    
    &else
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.desc-item >= c-it-codigo-ini AND
                                         {&TABLENAME}.desc-item <= c-it-codigo-fim
                                         NO-LOCK by {&TABLENAME}.desc-item indexed-reposition.
        RETURN "OK":U.
    &endif
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescricao DBOProgram 
PROCEDURE openQueryByFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de código do item e descrição-1. Ordena por descrição-1.
  ------------------------------------------------------------------------------*/
    &IF DEFINED(bf-mat-comex) &THEN
        open query {&QUERYNAME} for each {&TABLENAME} USE-INDEX descricao where 
                                         {&TABLENAME}.descricao-1 >= c-desc-item-ini AND
                                         {&TABLENAME}.descricao-1 <= c-desc-item-fim NO-LOCK .
    
    &ELSE
        open query {&QUERYNAME} for each {&TABLENAME} USE-INDEX descricao where 
                                         {&TABLENAME}.desc-item >= c-desc-item-ini AND
                                         {&TABLENAME}.desc-item <= c-desc-item-fim NO-LOCK.
    &endif
                                             
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroItCodigo DBOProgram 
PROCEDURE openQueryByFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de código do item e descrição-1. Ordena por código do item.
  ------------------------------------------------------------------------------*/
    
    open query {&QUERYNAME} for each {&TABLENAME}  USE-INDEX codigo where 
                                     {&tablename}.it-codigo   >= c-it-codigo-ini AND
                                     {&tablename}.it-codigo   <= c-it-codigo-fim NO-LOCK.   
                                                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint1 DBOProgram 
PROCEDURE setconstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o item
              inicial e final e a descrição inicial e final.
  Parameters: ipar1:p-it-codigo-ini:Item Inicial
              ipar2:p-it-codigo-fim:Item Final
              ipar3:p-desc-item-ini:Descrição Inicial
              ipar4:p-desc-item-fim:Descrição Final
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
        
    def input param p-it-codigo-ini as char.
    def input param p-it-codigo-fim as char.
   
    assign c-it-codigo-ini = p-it-codigo-ini
           c-it-codigo-fim = p-it-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint7 DBOProgram 
PROCEDURE setConstraint7 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o item
              inicial e final e a descrição inicial e final.
  Parameters: ipar1:pit-codigo-ini:Item Inicial
              ipar2:pit-codigo-fim:Item Final
              ipar3:pdesc-item-ini:Descrição Inicial
              ipar4:pdesc-item-fim:Descrição Final
------------------------------------------------------------------------------*/
  def input param p-desc-item-ini as char.
  def input param p-desc-item-fim as char.

  assign c-desc-item-ini = p-desc-item-ini
         c-desc-item-fim = p-desc-item-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.

assign lValida = no.
do i-cont = 1 to 5:
    run cdp/cd9902.p (input i-cont).
    if return-value = "OK":U then do:
        assign lValida = yes.
        leave.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateItem in h-abapi008 (RowObject.it-codigo).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
        
        if pType = "CREATE" then do:
           IF CAN-FIND(item
              WHERE item.it-codigo = RowObject.it-codigo) THEN
              {method/svc/errors/inserr.i
               &ErrorNumber="7" 
               &ErrorType="EMS"
               &ErrorParameters="'Item'"}  
        end.
        
        /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
              executadas ---*/
        /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as valida‡äes ---*/

        if pType = "Delete":U then
            run validateDeleteFrotas in this-procedure.
    
        /*--- Verifica ocorrˆncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

