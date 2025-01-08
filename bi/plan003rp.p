/**
 * Extrator para GESPLAN
 * Fato: Extrator do volume realizado de vendas
 *
 * Autor: Anderson Hoepers - 10/02/2016
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/plan003tt.i}
{bi/esbi000.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define input  parameter table for tt-param.
define output parameter table for ttVolumeRealizado.
define output parameter table for tt-erro.

DEFINE VARIABLE da-data-ini       AS DATE        NO-UNDO.
DEFINE VARIABLE da-data-fim       AS DATE        NO-UNDO.
DEFINE VARIABLE da-tmp            AS DATE        NO-UNDO.
DEFINE VARIABLE c-mercado         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-segmento        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-familia-coml    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ano-extracao    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mes-extracao    AS INTEGER     NO-UNDO.

DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.

/************************************************************************/

find first tt-param NO-ERROR.

ASSIGN da-data-ini        = tt-param.dt-inicial
       da-data-fim        = ADD-INTERVAL(tt-param.dt-final, 1, 'months') - 1
       I-Num-Ped-Exec-Rpw = 99999999. /* s¢ pra nÆo mostrar tela de acompanhamento */

EMPTY TEMP-TABLE ttVolumeRealizado.
EMPTY TEMP-TABLE tt-param-esftp061.
EMPTY TEMP-TABLE tt-raw-digita-esftp061.
EMPTY TEMP-TABLE tt-calcula.
EMPTY TEMP-TABLE tt-erro-esftp061.

CREATE tt-param-esftp061.
ASSIGN tt-param-esftp061.usuario            = c-seg-usuario
       tt-param-esftp061.destino            = 3
       tt-param-esftp061.data-exec          = TODAY 
       tt-param-esftp061.hora-exec          = TIME 
    /*   tt-param-esftp061.arquivo            = SESSION:TEMP-DIRECTORY + "esftp061.tmp":U */
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

EMPTY TEMP-TABLE ttVolumeRealizado.

FOR EACH  tt-calcula
    WHERE tt-calcula.ajustes    = NO
      AND tt-calcula.it-codigo <> "":

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

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-calcula.it-codigo:
    END.

    IF  tt-calcula.ncm  = "" OR 
        ITEM.tipo-contr < 4 /* Fisico, Total, Consignado */
    THEN
        ASSIGN tt-calcula.ncm = STRING(ITEM.class-fiscal,"9999.99.99").
    ELSE
        ASSIGN tt-calcula.ncm = STRING(tt-calcula.ncm,"9999.99.99").

    ASSIGN c-segmento = CAPS(SUBSTR(tt-calcula.c-vertical,1,4)) + "_" + c-segmento.

    ASSIGN c-familia-coml = CAPS(TRIM(fn-free-accent(tt-calcula.fm-cod-com))).
/*     FOR FIRST fam-comerc NO-LOCK                                                                                                        */
/*         WHERE fam-comerc.fm-cod-com = tt-calcula.fm-cod-com:                                                                            */
/*         ASSIGN c-familia-coml = CAPS(TRIM(fn-free-accent(tt-calcula.fm-cod-com)) + " - " + TRIM(fn-free-accent(fam-comerc.descricao))). */
/*     END.                                                                                                                                */

    FIND FIRST ttVolumeRealizado
        WHERE  ttVolumeRealizado.CD_MasterExterno    = "1"
          AND  ttVolumeRealizado.NM_AnoExtracao      = i-ano-extracao
          AND  ttVolumeRealizado.NM_MesExtracao      = i-mes-extracao
          AND  ttVolumeRealizado.CD_Empresa          = i-ep-codigo-usuario
          AND  ttVolumeRealizado.CD_Estabelecimeto   = tt-calcula.cod-estabel  
          AND  ttVolumeRealizado.CD_Mercado          = SUBSTR(c-mercado,1,50)    
          AND  ttVolumeRealizado.CD_Origem           = TRIM(fn-free-accent(tt-calcula.c-origem))     
          AND  ttVolumeRealizado.CD_Vertical         = tt-calcula.c-vertical   
          AND  ttVolumeRealizado.CD_UnidNegoc        = TRIM(fn-free-accent(tt-calcula.descricao-un-nota))
          AND  ttVolumeRealizado.CD_Segmento         = SUBSTR(c-segmento,1,50) 
          AND  ttVolumeRealizado.CD_FamiliaComercial = c-familia-coml   
          AND  ttVolumeRealizado.CD_ClassifFiscal    = tt-calcula.ncm          
          AND  ttVolumeRealizado.CD_Item             = tt-calcula.it-codigo NO-ERROR.  


    IF  NOT AVAIL(ttVolumeRealizado)
    THEN DO:  
        CREATE ttVolumeRealizado.
        ASSIGN ttVolumeRealizado.CD_MasterExterno    = "1"                         
               ttVolumeRealizado.NM_AnoExtracao      = i-ano-extracao          
               ttVolumeRealizado.NM_MesExtracao      = i-mes-extracao          
               ttVolumeRealizado.CD_Empresa          = i-ep-codigo-usuario         
               ttVolumeRealizado.CD_Estabelecimeto   = tt-calcula.cod-estabel      
               ttVolumeRealizado.CD_Mercado          = SUBSTR(c-mercado,1,50)                   
               ttVolumeRealizado.CD_Origem           = TRIM(fn-free-accent(tt-calcula.c-origem))         
               ttVolumeRealizado.CD_Vertical         = tt-calcula.c-vertical                    
               ttVolumeRealizado.CD_UnidNegoc        = TRIM(fn-free-accent(tt-calcula.descricao-un-nota))
               ttVolumeRealizado.CD_Segmento         = SUBSTR(c-segmento,1,50)                  
               ttVolumeRealizado.CD_FamiliaComercial = c-familia-coml       
               ttVolumeRealizado.CD_ClassifFiscal    = tt-calcula.ncm              
               ttVolumeRealizado.CD_Item             = tt-calcula.it-codigo.
    END.

    IF  tt-calcula.tipo = 1 
    THEN
        ASSIGN ttVolumeRealizado.NM_VolumeVendido = ttVolumeRealizado.NM_VolumeVendido + tt-calcula.qtd.
    ELSE
        ASSIGN ttVolumeRealizado.NM_VolumeVendido = ttVolumeRealizado.NM_VolumeVendido - tt-calcula.qtd.

END. /* FOR EACH tt-calcula */

RETURN "ok".
