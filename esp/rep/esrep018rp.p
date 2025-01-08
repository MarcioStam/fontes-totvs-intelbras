&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP018RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESREP018RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.

{esp/rep/esrep018tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-num-entr-param AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-cfop       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-log-tem-desp   AS LOGICAL     NO-UNDO.

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.nat-oper-ini format "x(06)" label "Nat Opera‡Æo" colon 40
    " <| |> " at 60
    tt-param.nat-oper-fim format "x(06)" no-label skip
    tt-param.cod-emitente-ini format ">>>>>>>>9" label "Fornecedor" colon 40
    " <| |> " at 60
    tt-param.cod-emitente-fim format ">>>>>>>>9" no-label skip
    tt-param.data-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.data-fim format "99/99/9999" no-label skip
    tt-param.uf-ini format "xxxx" label "Estado" colon 40
    " <| |> " at 60
    tt-param.uf-fim format "xxxx" no-label
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
/*     tt-param.cod-estabel label "Estabelecimento" colon 40 */
/*     skip(1)                                               */
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PAR¶METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELE€ÇO * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESSÇO * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i EmissÆo_de_Notas_de_Entrada * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

{include/tt-edit.i}
{include/pi-edit.i}

def temp-table tt-desp like despesa-aces.

DEF TEMP-TABLE tt-cfop-descartar NO-UNDO
    FIELD cod-cfop AS CHAR
    INDEX id-cfop
            cod-cfop.

DEF TEMP-TABLE tt-cfop-com-desp-aces NO-UNDO
    FIELD cod-cfop AS CHAR
    INDEX id-cfop
            cod-cfop.

DEF TEMP-TABLE tt-cfop-desp-aces NO-UNDO
    FIELD cod-cfop AS CHAR
    INDEX id-cfop
            cod-cfop.

DEF TEMP-TABLE tt-cfop-devol NO-UNDO
    FIELD cod-cfop AS CHAR
    INDEX id-cfop
            cod-cfop.

DEF TEMP-TABLE tt-msg-devol NO-UNDO
    FIELD num-msg AS INT
    INDEX id-msg
            num-msg.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.58
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run pi-relat in this-procedure.
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp c-liter-sel
         tt-param.nat-oper-ini 
         tt-param.nat-oper-fim 
         tt-param.cod-emitente-ini 
         tt-param.cod-emitente-fim 
         tt-param.data-ini 
         tt-param.data-fim 
         tt-param.uf-ini 
         tt-param.uf-fim 
         c-liter-par         
         c-liter-imp
         c-destino
         tt-param.arquivo   
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-relat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-relat Procedure 
PROCEDURE pi-relat PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-ali-icm like  it-nota-fisc.aliquota-icm no-undo.
    def var c-aliquotas  as character format "x(06)" no-undo.
    def var de-tot-icm   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
    def var de-tot-ipi   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
    def var de-tot-des   as decimal  format ">>>>>>>>9.99" init 0 no-undo.
    
    def var de-tot-merc  as decimal format ">>>>>>>>>9.99" init 0 no-undo.
    def var total-icm    as decimal format ">>>>>>>>>9.99" init 0 no-undo.
    def var total-ipi    as decimal format ">>>>>>>>>9.99" init 0 no-undo.
    def var de-tot-ger   as decimal format ">>>>>>>>>9.99" init 0 no-undo.
    def var nota-deb as dec no-undo.
    def var nota-cre as dec no-undo.
    def var nota-deb-1 as dec initial 0 no-undo.
    def var v-aliq like docum-est.aliquota-icm init 0 no-undo.
    def var de-tot-1  as dec no-undo.
    def var de-tot-2  as dec no-undo.
    def var de-tot-3  as dec no-undo.
    def var de-tot-4  as dec no-undo.

    EMPTY TEMP-TABLE tt-cfop-descartar.
    EMPTY TEMP-TABLE tt-cfop-com-desp-aces.
    EMPTY TEMP-TABLE tt-cfop-desp-aces.
    EMPTY TEMP-TABLE tt-cfop-devol.
    EMPTY TEMP-TABLE tt-msg-devol.

    /* Identificar parƒmetros para filtro de notas */
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "esrep018"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF  conteudo-programa.conteudo                  <> "" AND
            NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_DESCARTAR"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-cfop-descartar.
                    ASSIGN tt-cfop-descartar.cod-cfop = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
                END.
            END.

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_COM_DESP_ACES"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-cfop-com-desp-aces.
                    ASSIGN tt-cfop-com-desp-aces.cod-cfop = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
                END.
            END.

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_DESP_ACES"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-cfop-desp-aces.
                    ASSIGN tt-cfop-desp-aces.cod-cfop = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
                END.
            END.

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_DEVOL"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-cfop-devol.
                    ASSIGN tt-cfop-devol.cod-cfop = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
                END.
            END.

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "MSG_DEVOL"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-msg-devol.
                    ASSIGN tt-msg-devol.num-msg = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
                END.
            END.
        END. /* IF  conteudo-programa.conteudo                  <> "" AND */
    END. /* FOR FIRST ponto-programa */


    bloco-docum-est:
    for each docum-est no-lock
        where docum-est.nat-operacao >= tt-param.nat-oper-ini
          and docum-est.nat-operacao <= tt-param.nat-oper-fim
          and docum-est.cod-emitente >= tt-param.cod-emitente-ini
          and docum-est.cod-emitente <= tt-param.cod-emitente-fim
          and docum-est.dt-trans     >= tt-param.data-ini
          and docum-est.dt-trans     <= tt-param.data-fim
          and docum-est.uf           >= tt-param.uf-ini
          and docum-est.uf           <= tt-param.uf-fim
          AND docum-est.cod-estabel  >= tt-param.estab-ini
          AND docum-est.cod-estabel  <= tt-param.estab-fim:

        ASSIGN v-cod-cfop     = SUBSTR(docum-est.nat-operacao,1,4)
               v-log-tem-desp = NO.

        FIND FIRST tt-cfop-descartar NO-LOCK
            WHERE  tt-cfop-descartar.cod-cfop = v-cod-cfop NO-ERROR.

        IF  AVAIL tt-cfop-descartar
        THEN
            NEXT bloco-docum-est.


        FIND FIRST tt-cfop-com-desp-aces NO-LOCK
            WHERE  tt-cfop-com-desp-aces.cod-cfop = v-cod-cfop NO-ERROR.

        IF  NOT AVAIL tt-cfop-com-desp-aces
        THEN DO:
            bloco-desp:
            FOR EACH tt-cfop-desp-aces NO-LOCK:
                FOR EACH  despesa-aces NO-LOCK
                    WHERE despesa-aces.serie-docto   = docum-est.serie-docto 
                      AND despesa-aces.nro-docto     = docum-est.nro-docto 
                      AND despesa-aces.cod-emitente  = docum-est.cod-emitente 
                      AND despesa-aces.nat-operacao  = docum-est.nat-operacao 
                      AND despesa-aces.nat-oper-ac   BEGINS tt-cfop-desp-aces.cod-cfop:

                    ASSIGN v-log-tem-desp = YES.
                    LEAVE bloco-desp.
                END.
            END. /* FOR EACH tt-cfop-desp-aces NO-LOCK: */
            IF  v-log-tem-desp = NO
            THEN
                NEXT bloco-docum-est.
        END. /* IF  NOT AVAIL tt-cfop-com-desp-aces */


        FIND FIRST tt-cfop-devol NO-LOCK
            WHERE  tt-cfop-devol.cod-cfop = v-cod-cfop NO-ERROR.

        IF  AVAIL tt-cfop-devol
        THEN DO:
             FIND int-docum-est OF docum-est NO-LOCK NO-ERROR.
             IF  AVAIL int-docum-est
             THEN DO:
                 FIND FIRST tt-msg-devol NO-LOCK
                     WHERE  tt-msg-devol.num-msg = int-docum-est.cod-msg-devolucao NO-ERROR.

                 IF  AVAIL tt-msg-devol
                 THEN
                    NEXT bloco-docum-est.
             END.
             ELSE
                NEXT bloco-docum-est.
        END. /* IF  AVAIL tt-cfop-devol */
          
          run pi-acompanhar in h-acomp (input "Documento: " + docum-est.nro-docto).

          
          find emitente where 
               emitente.cod-emitente = docum-est.cod-emitente
               no-lock.

         if docum-est.tipo-docto = 2 then
            assign de-tot-icm = docum-est.icm-deb-cre.
         else      
            assign  de-tot-icm = docum-est.icm-deb-cre.

         assign de-tot-icm = de-tot-icm +
                 docum-est.icm-complem.
         assign v-aliq = docum-est.aliquota-icm. 

         for each despesa-aces use-index documento where
              despesa-aces.serie-docto   = docum-est.serie-docto and
              despesa-aces.nro-docto     = docum-est.nro-docto and
              despesa-aces.cod-emitente  = docum-est.cod-emitente and
              despesa-aces.nat-operacao  = docum-est.nat-operacao no-lock:
              create tt-desp.
              buffer-copy despesa-aces to tt-desp.
         end. 

         for each item-doc-est of docum-est no-lock:
            if item-doc-est.cd-trib-ipi = 1 or 
               item-doc-est.cd-trib-ipi = 4  then do: 
                                                      
            if docum-est.tipo-docto = 2 then
                 assign nota-cre = nota-cre + item-doc-est.valor-ipi[1]
                        v-aliq = item-doc-est.aliquota-icm. 
             else      
                assign nota-deb = nota-deb + item-doc-est.valor-ipi[1].
                assign v-aliq = item-doc-est.aliquota-icm.
            end.
            
            if item-doc-est.it-codigo = " " then do:
              assign v-aliq = item-doc-est.aliquota-icm.
              find natur-oper of docum-est no-lock no-error.
                   assign v-aliq = natur-oper.aliquota-icm.
            end.
            if item-doc-est.cd-trib-icm = 2 then do:
                  assign v-aliq = 0
                     de-tot-ipi = 0.
            end.
            else do:
              assign v-aliq = item-doc-est.aliquota-icm.
            end.           
         end.     
           if docum-est.nat-operacao begins "1556" or
              docum-est.nat-operacao begins "2556" or
              docum-est.nat-operacao begins "1551" or
              docum-est.nat-operacao begins "2551" 
              then do:
                assign de-tot-icm = 0
                           v-aliq = 0.
           end.
         
           disp docum-est.nro-docto                  label "Nr."  
               docum-est.serie-docto                 label "Ser"  
               docum-est.dt-trans  format "99/99/9999"  label "Data"
               docum-est.cod-emitente                  label "Emitente"
               emitente.nome-abrev                     label "Nome"
               docum-est.nat-operacao format "999xxx"  label "Nat."
               docum-est.valor-mercad format ">>>,>>>,>>>,>>9.99" label "Valor"
               v-aliq /*docum-est.aliquota-icm*/              label "% ICMS"
               de-tot-icm    format ">>>,>>>,>>>,>>9.99"  label "Val.ICMS"
               nota-deb      format ">>>,>>>,>>>,>>9.99"     label "Val.IPI"
               docum-est.tot-valor format ">>>,>>>,>>>,>>9.99"  label "Valor Total"
               docum-est.uf label "UF" with width 255 no-labels stream-io.

           assign de-tot-merc = de-tot-merc + docum-est.valor-mercad
                  total-icm  = total-icm  + de-tot-icm
                  total-ipi  = total-ipi  + nota-deb                                             
                  de-tot-ger = de-tot-ger  + docum-est.tot-valor.

           assign de-tot-icm = 0
                  nota-deb   = 0
                  de-tot-ipi = 0
                  de-tot-des = 0.
      end.

      assign de-tot-merc = de-tot-merc + de-tot-1
             total-icm   = total-icm   + de-tot-2
             de-tot-ger  = de-tot-ger  + de-tot-3.

       put de-tot-merc at 65  format ">>>,>>>,>>>,>>9.99" 
           total-icm   at 91   format ">>>,>>>,>>>,>>9.99" 
           total-ipi   at 110   format ">>>,>>>,>>>,>>9.99" 
           de-tot-ger  at 129  format ">>>,>>>,>>>,>>9.99" .
                             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

