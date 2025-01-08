/**
 * Extrator para GESPLAN
 * Fato: Extrator do cadastro de itens
 *
 * Autor: Anderson Hoepers - 11/02/2016
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/plan005tt.i}
{bi/esbi000.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define input  parameter table for tt-param.
define output parameter table for ttHierarquiaItem.
define output parameter table for tt-erro.

DEFINE VARIABLE da-data-ini       AS DATE       NO-UNDO.
DEFINE VARIABLE da-data-fim       AS DATE       NO-UNDO.
DEFINE VARIABLE da-tmp            AS DATE       NO-UNDO.
DEFINE VARIABLE c-mercado         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-segmento        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-unid-neg-item   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-familia-coml    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-desc-item       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ano-extracao    AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-mes-extracao    AS INTEGER    NO-UNDO.

DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.

/************************************************************************/

find first tt-param NO-ERROR.

ASSIGN da-data-ini        = tt-param.dt-inicial
       da-data-fim        = ADD-INTERVAL(tt-param.dt-final, 1, 'months') - 1
       I-Num-Ped-Exec-Rpw = 99999999. /* s¢ pra nÆo mostrar tela de acompanhamento */

EMPTY TEMP-TABLE ttHierarquiaItem.
EMPTY TEMP-TABLE tt-param-esftp061.
EMPTY TEMP-TABLE tt-raw-digita-esftp061.
EMPTY TEMP-TABLE tt-calcula.
EMPTY TEMP-TABLE tt-erro-esftp061.

CREATE tt-param-esftp061.
ASSIGN tt-param-esftp061.usuario            = c-seg-usuario
       tt-param-esftp061.destino            = 3
       tt-param-esftp061.data-exec          = TODAY 
       tt-param-esftp061.hora-exec          = TIME 
      /* tt-param-esftp061.arquivo            = SESSION:TEMP-DIRECTORY + "esftp061.tmp":U */
       tt-param-esftp061.arquivo            = c-dir-arquivo-session + "esftp061.tmp":U
       tt-param-esftp061.cod-estab-ini      = ""
       tt-param-esftp061.cod-estab-fim      = "ZZZ"
       tt-param-esftp061.da-data-ini        = da-data-ini
       tt-param-esftp061.da-data-fim        = da-data-fim
       tt-param-esftp061.it-codigo-ini      = ""
       tt-param-esftp061.it-codigo-fim      = "ZZZZZZZZ"
       tt-param-esftp061.cod-rep-ini        = 0
       tt-param-esftp061.cod-rep-fim        = 99999999
       tt-param-esftp061.cod-emitente-ini   = 0
       tt-param-esftp061.cod-emitente-fim   = 99999999
       tt-param-esftp061.cod-gr-cli-ini     = 0
       tt-param-esftp061.cod-gr-cli-fim     = 99999999
       tt-param-esftp061.fm-cod-com-ini     = ""
       tt-param-esftp061.fm-cod-com-fim     = "ZZZZZZZZ"
       tt-param-esftp061.l-vl-presente      = 0
       tt-param-esftp061.i-mes-med          = MONTH(da-data-fim)
       tt-param-esftp061.i-ano-med          = YEAR (da-data-fim)
       tt-param-esftp061.vl-icms-est        = 0
       tt-param-esftp061.l-imp-nota         = YES.

assign tt-param-esftp061.da-data-medio = (date((if tt-param-esftp061.i-mes-med = 12 
                                then 01
                                else tt-param-esftp061.i-mes-med + 1), 
                                01, 
                               (if tt-param-esftp061.i-mes-med = 12 
                                then tt-param-esftp061.i-ano-med + 1
                                else tt-param-esftp061.i-ano-med)) - 1).
  
run esp/ftp/esftp061rp1.p (INPUT  TABLE tt-param-esftp061,
                           INPUT  TABLE tt-raw-digita-esftp061,
                           OUTPUT TABLE tt-calcula,
                           OUTPUT TABLE tt-erro-esftp061).

/* Totaliza */
for each tt-calcula:
    /***** ACRESCIMO DE 1/12 SOBRE COMISSAO REFERENTE RESCISAO ******/
    assign tt-calcula.comissao-distrato = tt-calcula.comissao + (tt-calcula.comissao * 0.0833333).
END.

EMPTY TEMP-TABLE ttHierarquiaItem.

FOR EACH  tt-calcula
    WHERE tt-calcula.ajustes    = NO
      AND tt-calcula.it-codigo <> ""
    BREAK BY tt-calcula.it-codigo:

    ASSIGN c-mercado = TRIM(fn-free-accent("interno")).

    IF tt-calcula.atendente = "50" 
    THEN
        ASSIGN c-mercado = TRIM(fn-free-accent("externo")).
    ELSE 
        ASSIGN c-mercado = TRIM(fn-free-accent(tt-calcula.c-mercado)).

    IF  c-mercado = "interno"
    THEN
        ASSIGN c-mercado = "MI".
    ELSE
        ASSIGN c-mercado = "ME".

    ASSIGN c-segmento = TRIM(fn-free-accent(tt-calcula.cod-segmento)).

    FOR FIRST  fam-com-item NO-LOCK
         WHERE fam-com-item.fm-cod-com = tt-calcula.cod-segmento:
        ASSIGN c-segmento = TRIM(fn-free-accent(fam-com-item.descricao)).
    END.

    ASSIGN c-unid-neg-item = CAPS(TRIM(fn-free-accent(tt-calcula.descricao-un-nota)))
           c-desc-item     = TRIM(fn-free-accent(tt-calcula.it-codigo)).
    
    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-calcula.it-codigo:

        ASSIGN c-desc-item = TRIM(ITEM.it-codigo) + " - " + TRIM(fn-free-accent(ITEM.desc-item)).

        IF  c-unid-neg-item = ""
        THEN DO:
            FOR FIRST  unid_negoc NO-LOCK
                 WHERE unid_negoc.cod_unid_negoc = ITEM.cod-unid-negoc:
                ASSIGN c-unid-neg-item = CAPS(TRIM(fn-free-accent(unid_negoc.des_unid_negoc))).
            END.
        END.
    END.

    ASSIGN da-tmp         = tt-calcula.dt-emis-nota
           i-ano-extracao = YEAR (tt-calcula.dt-emis-nota)
           i-mes-extracao = MONTH(tt-calcula.dt-emis-nota).

    IF  tt-calcula.tipo = 2
    THEN DO:
        FOR LAST  nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel  = tt-calcula.cod-estabel
              AND nota-fiscal.nr-nota-fis  = tt-calcula.nr-nota-fis
              AND nota-fiscal.dt-emis-nota = tt-calcula.dt-emis-nota:

            FOR LAST  devol-cli NO-LOCK
                WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                  AND devol-cli.serie       = nota-fiscal.serie
                  AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND devol-cli.it-codigo   = tt-calcula.it-codigo
                  AND devol-cli.dt-devol   <= da-data-fim:

                ASSIGN da-tmp         = tt-calcula.dt-emis-nota
                       i-ano-extracao = YEAR (devol-cli.dt-devol)
                       i-mes-extracao = MONTH(devol-cli.dt-devol).
            END.
        END.
    END.

    IF  da-tmp < da-data-ini
    THEN
        ASSIGN i-ano-extracao = YEAR (da-data-ini)
               i-mes-extracao = MONTH(da-data-ini).

    IF  tt-calcula.ncm  = "" OR 
        ITEM.tipo-contr < 4 /* Fisico, Total, Consignado */
    THEN
        ASSIGN tt-calcula.ncm = STRING(ITEM.class-fiscal,"9999.99.99").
    ELSE
        ASSIGN tt-calcula.ncm = STRING(tt-calcula.ncm,"9999.99.99").

    ASSIGN c-segmento = CAPS(SUBSTR(tt-calcula.c-vertical,1,4)) + "_" + c-segmento.

    FIND FIRST ttHierarquiaItem
        WHERE  ttHierarquiaItem.CD_MasterExterno    = "1"
          AND  ttHierarquiaItem.NM_AnoExtracao      = i-ano-extracao
          AND  ttHierarquiaItem.CD_Empresa          = i-ep-codigo-usuario
          AND  ttHierarquiaItem.CD_Estabelecimeto   = tt-calcula.cod-estabel  
          AND  ttHierarquiaItem.CD_Mercado          = TRIM(SUBSTR(c-mercado,1,50))    
          AND  ttHierarquiaItem.CD_Origem           = TRIM(fn-free-accent(tt-calcula.c-origem))     
          AND  ttHierarquiaItem.CD_Vertical         = tt-calcula.c-vertical   
          AND  ttHierarquiaItem.CD_UnidNegoc        = c-unid-neg-item
          AND  ttHierarquiaItem.CD_Segmento         = TRIM(SUBSTR(c-segmento,1,50)) 
          AND  ttHierarquiaItem.CD_FamiliaComercial = TRIM(fn-free-accent(tt-calcula.fm-cod-com))   
          AND  ttHierarquiaItem.CD_ClassifFiscal    = tt-calcula.ncm          
          AND  ttHierarquiaItem.CD_Item             = tt-calcula.it-codigo NO-ERROR.  

    IF  NOT AVAIL(ttHierarquiaItem)
    THEN DO:
        ASSIGN c-familia-coml = tt-calcula.fm-cod-com.
        FOR FIRST fam-comerc NO-LOCK
            WHERE fam-comerc.fm-cod-com = tt-calcula.fm-cod-com:
            ASSIGN c-familia-coml = TRIM(fn-free-accent(tt-calcula.fm-cod-com)) + " - " + TRIM(fn-free-accent(fam-comerc.descricao)).
        END.

        CREATE ttHierarquiaItem.
        ASSIGN ttHierarquiaItem.CD_MasterExterno    = "1"                         
               ttHierarquiaItem.NM_AnoExtracao      = i-ano-extracao          
               ttHierarquiaItem.CD_Empresa          = i-ep-codigo-usuario         
               ttHierarquiaItem.CD_Estabelecimeto   = tt-calcula.cod-estabel      
               ttHierarquiaItem.CD_Mercado          = TRIM(SUBSTR(c-mercado,1,50))                   
               ttHierarquiaItem.CD_Origem           = TRIM(fn-free-accent(tt-calcula.c-origem))         
               ttHierarquiaItem.CD_Vertical         = tt-calcula.c-vertical                    
               ttHierarquiaItem.CD_UnidNegoc        = c-unid-neg-item
               ttHierarquiaItem.CD_Segmento         = TRIM(SUBSTR(c-segmento,1,50))                  
               ttHierarquiaItem.CD_FamiliaComercial = TRIM(fn-free-accent(tt-calcula.fm-cod-com))       
               ttHierarquiaItem.CD_ClassifFiscal    = tt-calcula.ncm              
               ttHierarquiaItem.CD_Item             = tt-calcula.it-codigo
               ttHierarquiaItem.CD_UnidMedida       = CAPS(TRIM(fn-free-accent(ITEM.un)))
               ttHierarquiaItem.TX_DescItem         = TRIM(SUBSTR(c-desc-item,1,100))
               ttHierarquiaItem.TX_UnidMedida       = CAPS(TRIM(fn-free-accent(ITEM.un)))
               ttHierarquiaItem.TX_Moeda            = "R$"
               ttHierarquiaItem.TX_FamiliaComercial = TRIM(SUBSTR(c-familia-coml,1,100))
               ttHierarquiaItem.TX_Mercado          = IF c-mercado = "ME" THEN "Externo" ELSE "Interno"
               ttHierarquiaItem.TX_Empresa          = "Intelbras".
    END.
END. /* FOR EACH tt-calcula */

RETURN "ok".
