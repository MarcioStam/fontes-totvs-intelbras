/**************************************************************************************************
** PROGRAMA...: ft0904z01-upc.p - Chamada do zoom reposition da esp-ext-nota-fiscal
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 06/01/2011
**************************************************************************************************/

DEF VAR h-query-tmp  AS HANDLE  NO-UNDO.
DEF VAR h_q01di135   AS HANDLE  NO-UNDO.
DEF VAR hProgramZoom AS HANDLE  NO-UNDO.

ASSIGN h_q01di135 = SESSION:FIRST-PROCEDURE.
      
DO  WHILE h_q01di135 <> ?:
    ASSIGN h-query-tmp = h_q01di135:NEXT-SIBLING.

    IF (INDEX(h_q01di135:FILE-NAME, "diqry/q01di135.w") <> 0) THEN
        LEAVE.

    ASSIGN h_q01di135 = h-query-tmp.
END.

/*Chamada principal do zoom*/
{method/ZoomReposition.i &ProgramZoom="eszoom/z01es135.w"}

WAIT-FOR CLOSE OF hProgramZoom.


PROCEDURE repositionRecord:
/*****************************************************************************************
** Procedure chamada pelo zoom de reposition
*****************************************************************************************/

    DEF INPUT PARAM pr-rowid AS ROWID NO-UNDO.

    /*Encontra NOTA-FISCAL com base na ESP-EXT-NOTA-FISCAL*/
    FOR FIRST esp-ext-nota-fiscal NO-LOCK
        WHERE ROWID(esp-ext-nota-fiscal) = pr-rowid,
        FIRST nota-fiscal NO-LOCK OF esp-ext-nota-fiscal:

        RUN pi-reposiciona-query IN h_q01di135 (INPUT ROWID(nota-fiscal)).
    END.
    
    RETURN "OK".
END PROCEDURE.
