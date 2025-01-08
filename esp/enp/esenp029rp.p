/***********************************************************************
**  Programa..: esp/enp/esenp029rp
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Fevereiro/2015 - Desenvolvimento
**  Descricao.: Relat¢rio de itens
**  Versao....: 001 20/02/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esenp029rp 1.00.00.00}

/****************************  Definitions  ****************************/

{esp/enp/esenp029tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}
/****************************  Temp-Tables  ****************************/

/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
      
DEFINE VARIABLE h-acomp       AS HANDLE    NO-UNDO.
DEFINE VARIABLE tipo_1          AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE tipo_2          AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-excel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-nivel       AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE it-filho      LIKE estrutura.it-codigo.
DEFINE VARIABLE it-filho-desc LIKE ITEM.desc-item.
DEFINE VARIABLE chExcel       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE i-seq-saida   AS INT.

DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER b-estrutura FOR estrutura.


DEFINE TEMP-TABLE tt-saida
    FIELD it-pai         LIKE estrutura.it-codigo
    FIELD it-pai-desc    LIKE ITEM.desc-item 
    FIELD it-filho       LIKE estrutura.es-codigo
    FIELD it-filho-desc  LIKE b-item.desc-item
    FIELD nivel          AS INTEGER FORMAT "99"
    FIELD tipo           AS CHAR FORMAT "x(10)"
    FIELD quantidade     LIKE estrutura.quant-usada
    FIELD seq            AS INT
    FIELD fantasma       AS CHAR.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esenp029.csv".
        
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esenp029.csv".
    END.

END. 

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

PUT STREAM str-excel "Item-Pai;Descri‡Æo;Item-Filho;Descri‡Æo;Nivel;Tipo;Qtd;F" SKIP.


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    
    {include/i-rpcab.i}
    {include/i-rpout.i} 

    EMPTY TEMP-TABLE tt-saida.

    ASSIGN i-seq-saida = 0.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes..."). 
    
    RUN piMontaRelat.

END.

PROCEDURE piMontaRelat:
    
    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo >= tt-param.item-ini
          AND estrutura.it-codigo <= tt-param.item-fim
          AND estrutura.data-inicio  <= tt-param.data-ini
          AND estrutura.data-termino >  tt-param.data-ini:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.it-codigo NO-ERROR.
        
        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        FIND FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo NO-ERROR.

       
        ASSIGN i-nivel = 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = estrutura.it-codigo        
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = estrutura.es-codigo    
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = estrutura.quant-usada.

        IF estrutura.fantasma = YES THEN
            ASSIGN tt-saida.fantasma = "#".
        ELSE
            ASSIGN tt-saida.fantasma = "".

       IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

       ELSE
           ASSIGN tt-saida.tipo = "Comprado".
           
        RUN pi-estrutura(INPUT estrutura.es-codigo,
                         INPUT estrutura.it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
    
    END.

    RUN pi-finalizar in h-acomp.
END.

FOR EACH tt-saida NO-LOCK
    BY tt-saida.seq:

    IF tt-param.fabricado = NO AND tt-param.comprado = NO THEN

        PUT STREAM str-excel UNFORMATTED
        tt-saida.it-pai              ";"
        TRIM(tt-saida.it-pai-desc)   ";"
        tt-saida.it-filho            ";"
        TRIM(tt-saida.it-filho-desc) ";"
        tt-saida.nivel               ";"
        tt-saida.tipo                ";"                  
        tt-saida.quantidade          ";"
        TRIM(tt-saida.fantasma)      SKIP.
    
    IF tt-param.fabricado = YES AND tt-saida.tipo BEGINS "Fabricado" THEN

        PUT STREAM str-excel UNFORMATTED
        tt-saida.it-pai              ";"
        TRIM(tt-saida.it-pai-desc)   ";"
        tt-saida.it-filho            ";"
        TRIM(tt-saida.it-filho-desc) ";"
        tt-saida.nivel               ";"
        tt-saida.tipo                ";"                  
        tt-saida.quantidade          ";"
        TRIM(tt-saida.fantasma)      SKIP.

    IF tt-param.comprado = YES AND tt-saida.tipo BEGINS "Comprado" THEN

        PUT STREAM str-excel UNFORMATTED
        tt-saida.it-pai              ";"
        TRIM(tt-saida.it-pai-desc)   ";"
        tt-saida.it-filho            ";"
        TRIM(tt-saida.it-filho-desc) ";"
        tt-saida.nivel               ";"
        tt-saida.tipo                ";"                  
        tt-saida.quantidade          ";"
        TRIM(tt-saida.fantasma)      SKIP.
    
END. 

OUTPUT STREAM str-excel CLOSE.

CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.

IF ERROR-STATUS:ERROR THEN 
    CREATE "Excel.Application":U chExcel.
    
ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).

chPlanilhaMod:Activate().

ASSIGN chExcel:VISIBLE     = TRUE
       chExcel:WindowState = 3.

RELEASE OBJECT chExcel       NO-ERROR.
RELEASE OBJECT chArquivo     NO-ERROR.
RELEASE OBJECT chPlanilhaMod NO-ERROR.

PROCEDURE pi-estrutura:
    
    DEFINE INPUT PARAMETER p-es-codigo LIKE estrutura.es-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo LIKE estrutura.it-codigo NO-UNDO.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-es-codigo
          AND estrutura.data-inicio  <= tt-param.data-ini
          AND estrutura.data-termino >  tt-param.data-ini:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-nivel = i-nivel + 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = p-it-codigo        
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = estrutura.es-codigo    
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = estrutura.quant-usada.
        
        IF estrutura.fantasma = YES THEN
            ASSIGN tt-saida.fantasma = "#".
        ELSE
            ASSIGN tt-saida.fantasma = "".
        
        IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

        ELSE
           ASSIGN tt-saida.tipo = "Comprado".


        RUN pi-estrutura(INPUT estrutura.es-codigo,
                         INPUT p-it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
        

    END.

END.  

















