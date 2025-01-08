/***************************************************************************
** Programa: gtupc/upc-re1001h1.p
** VersÆo..: 1.00.00.000
** Obs.....: UPC usada para desabilitar função do TMS e permitir entrada de 
             CTE via atualização de documento. 
** Autor...: Oliver Fagionato / Martin E. Mebs
***************************************************************************/

{include/i-prgvrs.i UPC-RE1001 2.00.00.000}
					
DEFINE INPUT PARAMETER p-ind-event                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object                 AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object                 AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                  AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                  AS ROWID          NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-btConf-re1001 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btConf-new-re1001 AS WIDGET-HANDLE NO-UNDO.

DEF VAR l-cte AS LOG NO-UNDO INITIAL NO.

IF p-ind-event = "AFTER-INITIALIZE" THEN DO:

    {INCLUDE/VER-HDLS.I &ATIVA-GERACAO-LISTA=NO
                    &TELA-DISCO='D'
                    &NOME-ARQUIVO='C:/temp/zzz.LST'
                    &LISTA-FRAMES=''
                    &LISTA-TIPOS-OBJS=''}

    IF NOT VALID-HANDLE(wh-btConf-re1001) THEN
        ASSIGN wh-btConf-re1001 = fc-all-hdl("fPage0", "btConf", 000).

    IF NOT VALID-HANDLE(wh-btConf-new-re1001) THEN DO:
        CREATE BUTTON wh-btConf-new-re1001
        ASSIGN WIDTH     = wh-btConf-re1001:WIDTH
               ROW       = wh-btConf-re1001:ROW
               COL       = wh-btConf-re1001:COL
               LABEL     = wh-btConf-re1001:LABEL
               FRAME     = wh-btConf-re1001:FRAME
               HEIGHT    = wh-btConf-re1001:HEIGHT
               VISIBLE   = YES
               SENSITIVE = YES.

        wh-btConf-new-re1001:LOAD-IMAGE-UP(wh-btConf-re1001:IMAGE).

        ON 'choose':U OF wh-btConf-new-re1001 PERSISTENT RUN gtupc/upc-re1001.p(INPUT "choose-btconf",
                                                                                INPUT p-ind-object,
                                                                                INPUT p-wgh-object,
                                                                                INPUT p-wgh-frame, 
                                                                                INPUT p-cod-table, 
                                                                                INPUT p-row-table).

        ASSIGN wh-btConf-re1001:WIDTH     = 0.1
               wh-btConf-re1001:HEIGHT    = 0.1
               wh-btConf-re1001:VISIBLE   = NO
               wh-btConf-re1001:SENSITIVE = NO.
    END.
END.

IF p-ind-event = "choose-btconf" THEN DO:
    	
	/* Codigo gati - antes da atualizacao */
	RUN pi-habilita(OUTPUT l-cte,
					INPUT p-row-table).
	 
	APPLY 'CHOOSE' TO wh-btConf-re1001. /* botao de confirmacaao padrao do produto TOTVS */

	/* Codigo gati - depois da atualizacao*/
	RUN pi-desabilita(INPUT l-cte).
	
END.

IF p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    ASSIGN wh-btConf-re1001     = ?
           wh-btConf-new-re1001 = ?.
END.

{gtupc/i-hab-cte.i}

RETURN "OK".
