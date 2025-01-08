/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************
**  Programa: esp/crm/escrm005.p
**  Objetivo: Programa com fun‡äes de XML, para ser chamado externamente
**  Autor...: 
**  Data....: 
*******************************************************************************/

{esp/crm/escrm001.i}

DEFINE VARIABLE c-valor-dec  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-valor-dec  AS DECIMAL     NO-UNDO. 


PROCEDURE createXML:
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE      NO-UNDO.
    DEFINE INPUT  PARAMETER pEntidade  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-atributo.
    DEFINE OUTPUT PARAMETER pXML       AS LONGCHAR    NO-UNDO.

    DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hField AS HANDLE      NO-UNDO.

    DEFINE VARIABLE cBufferValue AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i            AS INTEGER     NO-UNDO.

    DEFINE VARIABLE hXml     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRoot    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE xmlParam AS HANDLE      NO-UNDO.
    DEFINE VARIABLE xmlText  AS HANDLE      NO-UNDO.

    CREATE X-DOCUMENT hXml.
    CREATE X-NODEREF  hRoot.
    CREATE X-NODEREF  xmlParam.
    CREATE X-NODEREF  xmlText.

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(pTempTable).
    hQuery:QUERY-PREPARE("FOR EACH ":U + pTempTable:NAME + " EXCLUSIVE-LOCK":U).
    hQuery:QUERY-OPEN.

    DO TRANSACTION ON ERROR UNDO, LEAVE:
        hQuery:GET-FIRST.

        hXml:CREATE-NODE(hRoot, pEntidade, "ELEMENT":U).
        hXml:APPEND-CHILD(hRoot).

        /** Percorre a temp-table **/
        DO WHILE NOT hQuery:QUERY-OFF-END:

            DO i = 1 TO pTempTable:NUM-FIELDS:
                ASSIGN hField       = pTempTable:BUFFER-FIELD(i)
                       cBufferValue = "":U.

                /** Ignora esse campo **/
                IF hField:DATA-TYPE = "rowid":U THEN NEXT.

                IF hField:DATA-TYPE = "character":U THEN DO:
                    IF hField:BUFFER-VALUE <> ? THEN
                        ASSIGN cBufferValue = TRIM(STRING(REPLACE(hField:BUFFER-VALUE, CHR(13), CHR(32))))
                               cBufferValue = TRIM(STRING(REPLACE(cBufferValue, CHR(10), CHR(32))))
                               cBufferValue = TRIM(STRING(REPLACE(cBufferValue, "'":U, "''":U))).
                END.
                ELSE DO:
                    IF hField:DATA-TYPE = "decimal" THEN DO:
                        IF hField:BUFFER-VALUE <> ? THEN
                            ASSIGN cBufferValue = TRIM(STRING(hField:BUFFER-VALUE, hField:FORMAT)).
                    END.
                    ELSE DO:
                        ASSIGN cBufferValue = TRIM(STRING(hField:BUFFER-VALUE)).
    
                        IF hField:DATA-TYPE = "date":U THEN DO:
                            IF hField:BUFFER-VALUE <> ? THEN DO:
                                IF hField:BUFFER-VALUE <= 01/01/1900 THEN
                                    ASSIGN cBufferValue = "1900-01-01":U.
                                ELSE DO:
                                    IF hField:BUFFER-VALUE >= 12/31/2999 THEN
                                        ASSIGN cBufferValue = "2999-12-31":U.
                                    ELSE
                                        ASSIGN cBufferValue = STRING(YEAR(hField:BUFFER-VALUE), "9999":U) + "-":U + STRING(MONTH(hField:BUFFER-VALUE), "99":U) + "-":U + STRING(DAY(hField:BUFFER-VALUE), "99":U).
                                END.
                            END.
                        END.
    
                        IF hField:DATA-TYPE = "logical":U THEN DO:
                            IF hField:BUFFER-VALUE = ?  OR
                               hField:BUFFER-VALUE = NO THEN
                                ASSIGN cBufferValue = "0":U.
                            ELSE
                                ASSIGN cBufferValue = "1":U.
                        END.
                    END.

                    IF hField:DATA-TYPE = "decimal":U OR
                       hField:DATA-TYPE = "integer":U THEN
                        ASSIGN cBufferValue = REPLACE(cBufferValue, ".":U, "":U)
                               cBufferValue = REPLACE(cBufferValue, ",":U, ".":U).
                END.

                hXml:CREATE-NODE(xmlParam, hField:NAME, "ELEMENT":U).

                IF hField:DATA-TYPE = "character":U OR
                   hField:DATA-TYPE = "date":U      THEN
                    hXml:CREATE-NODE(xmlText, ?, "CDATA-SECTION":U).
                ELSE
                    hXml:CREATE-NODE(xmlText, ?, "TEXT":U).

                xmlText:NODE-VALUE = cBufferValue NO-ERROR.
                xmlParam:APPEND-CHILD(xmlText).

                FOR EACH tt-atributo
                    WHERE tt-atributo.r-temp-table = pTempTable:ROWID
                      AND tt-atributo.nome-campo   = hField:NAME:
                    xmlParam:SET-ATTRIBUTE(tt-atributo.nome-atrib, tt-atributo.vl-atrib).
                END.

                hRoot:APPEND-CHILD(xmlParam).
            END.

            hQuery:GET-NEXT.

        END.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.

    hXml:SAVE("LONGCHAR":U, pXML).

    DELETE OBJECT xmlText.
    DELETE OBJECT xmlParam.
    DELETE OBJECT hRoot.
    DELETE OBJECT hXml.

    EMPTY TEMP-TABLE tt-atributo.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE readXML:
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE      NO-UNDO.
    DEFINE INPUT  PARAMETER pXML       AS LONGCHAR    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-atributo-entrada.

    DEFINE VARIABLE l-ok    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE hXML    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRoot   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hTags   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hValor  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hField  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE k       AS INTEGER     NO-UNDO.


    /*ASSIGN pXML = REPLACE(pXML, "&", "&amp;"). */

    EMPTY TEMP-TABLE tt-atributo-entrada.

    CREATE X-DOCUMENT hXML.
    CREATE X-NODEREF  hRoot.

    hXML:LOAD("LONGCHAR":U, pXML, FALSE).
    hXML:GET-DOCUMENT-ELEMENT(hRoot).

    CREATE X-NODEREF hTags.
    CREATE X-NODEREF hValor.

/*     /* MOSTRAR O XML */                                                                                       */
/*                                                                                                               */
/*                                                                                                               */
/*         define variable hDoc    as handle   no-undo.                                                          */
/*         create x-document hDoc.                                                                               */
/*                                                                                                               */
/*         hDoc:LOAD("longchar", pXML, NO).                                                                      */
/*         hDoc:SAVE("file","/opt/totvs/spool/an046325/" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
/*                                                                                                               */
/*         IF  VALID-HANDLE(hDoc) THEN                                                                           */
/*             DELETE OBJECT hDoc.                                                                               */
/*                                                                                                               */
/*                                                                                                               */
/*     /* FIM MOSTRAR O XML */                                                                                   */

    REPEAT i = 1 TO hRoot:NUM-CHILDREN:
        l-ok = hRoot:GET-CHILD(hTags, i).

        IF NOT l-ok THEN LEAVE.

        IF hTags:SUBTYPE <> "element":U THEN NEXT.

        DO j = 1 TO pTempTable:NUM-FIELDS:
            IF pTempTable:BUFFER-FIELD(j):NAME = hTags:NAME AND
               hTags:NUM-CHILDREN > 0                       AND
               hTags:GET-CHILD(hValor, 1)                   THEN DO:
                CASE pTempTable:BUFFER-FIELD(j):DATA-TYPE:
                    WHEN "date":U THEN DO:
                        CASE SESSION:DATE-FORMAT:
                            WHEN "dmy":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                            WHEN "mdy":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                            WHEN "ymd":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(1, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                        END CASE.
                    END.
                    WHEN "integer" THEN DO:
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN INTEGER(hValor:NODE-VALUE) ELSE ?.
                    END.
                    WHEN "decimal" THEN DO:
                                
                        if index(hValor:NODE-VALUE,".") > 0
                        then do:                                                      
                           assign d-valor-dec = int(substring(hValor:NODE-VALUE, 1, r-index(hValor:NODE-VALUE,".") - 1)).

                           IF  PROGRAM-NAME(2) MATCHES "*esmssp012*" 
                           THEN assign c-valor-dec = "0," + string((substring(hValor:NODE-VALUE, r-index(hValor:NODE-VALUE,".") + 1, 8))). 
                           ELSE assign c-valor-dec = "0," + string((substring(hValor:NODE-VALUE, r-index(hValor:NODE-VALUE,".") + 1, 5))). 
                                
                           ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN decimal(d-valor-dec + dec(c-valor-dec)) ELSE ?.
                        end.
                        else if hValor:NODE-VALUE <> "":U then
                            ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = decimal(hValor:NODE-VALUE).
                        else 
                          ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = ?.                        

                    END.
                    WHEN "logical" THEN DO:
                        CASE hValor:NODE-VALUE:
                            WHEN "1":U    OR
                            WHEN "TRUE":U OR
                            WHEN "T":U    OR
                            WHEN "YES":U  OR
                            WHEN "Y":U    OR
                            WHEN "Sim":U  OR
                            WHEN "S":U    THEN
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = YES.
                            WHEN "0":U     OR
                            WHEN "FALSE":U OR
                            WHEN "F":U     OR
                            WHEN "NO":U    OR
                            WHEN "N":U     OR
                            WHEN "NÆo":U   OR
                            WHEN "Nao":U   THEN
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = NO.
                            OTHERWISE DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = LOGICAL(TRIM(pTempTable:BUFFER-FIELD(j):INITIAL)).
                            END.
                        END CASE.
                    END.
                    WHEN "character" THEN DO:                       
                        
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = STRING(hValor:NODE-VALUE).                     
                         
                    END.
                    OTHERWISE DO:
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN hValor:NODE-VALUE ELSE ?.
                    END.
                END CASE.                
            END.
        END.

        REPEAT j = 1 TO NUM-ENTRIES(hTags:ATTRIBUTE-NAMES):
            CREATE tt-atributo-entrada.
            ASSIGN tt-atributo-entrada.tipo     = "atributo":U
                   tt-atributo-entrada.nome     = ENTRY(j, hTags:ATTRIBUTE-NAMES)
                   tt-atributo-entrada.nome-pai = hTags:NAME
                   tt-atributo-entrada.valor    = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
        END.
    END.

    DELETE OBJECT hXML.
    DELETE OBJECT hRoot.
    DELETE OBJECT hTags.
    DELETE OBJECT hValor.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE readXMLSon:
    /*****************************************************************************
    ** Fun‡Æo....: readXMLSon
    ** Parƒmetros: pTempTable  -  Entrada  -  Handle da Temp-Table
    **             pXML        -  Entrada  -  XML de Informa‡äes
    **
    ** Descri‡Æo.: Processar e criar as informa‡äes, na Temp-Table (handle) 
    **             de parƒmetro, que foram recebidas atrav‚s do XML de parƒmetro
    ******************************************************************************/
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE      NO-UNDO.
    DEFINE INPUT  PARAMETER pXML       AS LONGCHAR    NO-UNDO.
    

    DEFINE VARIABLE hXML       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRoot      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hLevel     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hTags      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hValor     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hField     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hTempTable AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE k          AS INTEGER     NO-UNDO.

    CREATE X-DOCUMENT hXML.
    CREATE X-NODEREF  hRoot.

    hXML:LOAD("LONGCHAR":U, pXML, FALSE).
    hXML:GET-DOCUMENT-ELEMENT(hRoot).

    CREATE X-NODEREF hLevel.
    CREATE X-NODEREF hTags.
    CREATE X-NODEREF hValor.

/*     /* MOSTRAR O XML */                                                                                          */
/*                                                                                                                  */
/*                                                                                                                  */
/*         define variable hDoc    as handle   no-undo.                                                             */
/*         create x-document hDoc.                                                                                  */
/*                                                                                                                  */
/*         hDoc:LOAD("longchar", pXML, NO).                                                                         */
/*         hDoc:SAVE("file","/opt/totvs/spool/an046325/Son" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
/*                                                                                                                  */
/*         IF  VALID-HANDLE(hDoc) THEN                                                                              */
/*             DELETE OBJECT hDoc.                                                                                  */
/*                                                                                                                  */
/*                                                                                                                  */
/*     /* FIM MOSTRAR O XML */                                                                                      */

    REPEAT i = 1 TO hRoot:NUM-CHILDREN:
        hRoot:GET-CHILD(hLevel, i).

        /* Cria um registro para cada "Filho" */
        pTempTable:BUFFER-CREATE().

        REPEAT k = 1 TO hLevel:NUM-CHILDREN:
            hLevel:GET-CHILD(hTags, k).
            
            REPEAT j = 1 TO pTempTable:NUM-FIELDS:
                hTags:GET-CHILD(hValor, 1).

                IF  pTempTable:BUFFER-FIELD(j):NAME = hTags:NAME AND
                    hTags:NUM-CHILDREN > 0                       THEN DO:
                    CASE pTempTable:BUFFER-FIELD(j):DATA-TYPE:
                        WHEN "date":U THEN DO:
                            CASE SESSION:DATE-FORMAT:
                                WHEN "dmy":U THEN DO:
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                                END.
                                WHEN "mdy":U THEN DO:
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                                END.
                                WHEN "ymd":U THEN DO:
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(1, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U)) ELSE ?.
                                END.
                            END CASE.
                        END.
                        WHEN "integer" THEN DO:
                            ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN INTEGER(hValor:NODE-VALUE) ELSE ?.
                        END.
                        WHEN "decimal" THEN DO:
                            IF  INDEX(hValor:NODE-VALUE,".") > 0 THEN DO:
                                ASSIGN d-valor-dec = INT(SUBSTRING(hValor:NODE-VALUE, 1, R-INDEX(hValor:NODE-VALUE,".") - 1))
                                       c-valor-dec = "0," + STRING((SUBSTRING(hValor:NODE-VALUE, R-INDEX(hValor:NODE-VALUE,".") + 1, 5))).

                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DECIMAL(d-valor-dec + DEC(c-valor-dec)) ELSE ?.
                            END.
                            ELSE
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = hValor:NODE-VALUE.
                        END.
                        WHEN "logical" THEN DO:
                            CASE hValor:NODE-VALUE:
                                WHEN "1":U    OR
                                WHEN "TRUE":U OR
                                WHEN "T":U    OR
                                WHEN "YES":U  OR
                                WHEN "Y":U    OR
                                WHEN "Sim":U  OR
                                WHEN "S":U    THEN
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = YES.
                                WHEN "0":U     OR
                                WHEN "FALSE":U OR
                                WHEN "F":U     OR
                                WHEN "NO":U    OR
                                WHEN "N":U     OR
                                WHEN "NÆo":U   OR
                                WHEN "Nao":U   THEN
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = NO.
                                OTHERWISE DO:
                                    ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = LOGICAL(TRIM(pTempTable:BUFFER-FIELD(j):INITIAL)).
                                END.
                            END CASE.
                        END.
                        WHEN "character" THEN DO:
                            ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = STRING(hValor:NODE-VALUE).
                        END.
                        OTHERWISE DO:
                            ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN hValor:NODE-VALUE ELSE ?.
                        END.
                    END CASE.                
                END.
            END.
        END.
    END.

    DELETE OBJECT hXML.
    DELETE OBJECT hRoot.
    DELETE OBJECT hLevel.
    DELETE OBJECT hTags.
    DELETE OBJECT hValor.

    RETURN "OK":U.

END PROCEDURE.

