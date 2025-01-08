/*****************************************************************************
*
* This file contains sample code which may assist you in creating applications.
* You may use the code as you see fit. If you modify the code or include it in
* another software program, you will refrain from identifying Progress Software
* as the supplier of the code, or using any Progress Software trademarks in 
* connection with your use of the code. THE CODE IS NOT SUPPORTED BY PROGRESS
* SOFTWARE AND IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, INCLUDING,
* WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE OR NONINFRINGEMENT.
*
*******************************************************************************/

  /*------------------------------------------------------------------ 
    File: xmlutil.p
    Description: XML Helper Functions
    Created: 05/03/00 DEC
  -------------------------------------------------------------------*/

{soap/xmlutil.i}

/* Used for creating XPATH of a node */
DEFINE TEMP-TABLE tPath 
    FIELD Path       AS CHAR
    FIELD Num        AS INT
    INDEX path path.

/* Searchs an XML Document or Fragment for all elements of one or more
 * specified names and returns the results in a Temp-Table.
 */
PROCEDURE getElementsByTagName:    
    DEFINE INPUT  PARAMETER phElement AS HANDLE NO-UNDO.  
    DEFINE INPUT  PARAMETER pcName    AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttElements.
  
    DEFINE VARIABLE iUniqueId AS INTEGER NO-UNDO.
    DEFINE VARIABLE hRoot     AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDoc      AS HANDLE NO-UNDO.

    /* Empty our Temp Table */
    EMPTY TEMP-TABLE ttElements.
  
    /* We start at the root element to generate absolute XPaths */
    IF phElement:TYPE <> "Document":U THEN
    DO:
        CREATE X-DOCUMENT hdoc.
        hDoc = phElement:OWNER-DOCUMENT.
    END.
    ELSE 
        iUniqueId = phElement:UNIQUE-ID.

    CREATE X-NODEREF hRoot.
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).  
    RUN searchElementsByTagName(hRoot,pcName,iUniqueId,'').
END.

PROCEDURE searchElementsByTagName:    
    DEFINE INPUT  PARAMETER phElement AS HANDLE NO-UNDO.  
    /* DOM is case-sensitve */
    DEFINE INPUT  PARAMETER pcName    AS CHAR   NO-UNDO CASE-SENSITIVE.
    DEFINE INPUT  PARAMETER piId      AS INT    NO-UNDO. 
    DEFINE INPUT  PARAMETER pcPath    AS CHAR   NO-UNDO.
    
    DEFINE BUFFER tPath FOR tPath.
    
    DEFINE VARIABLE uniqueId AS INT    NO-UNDO.
    DEFINE VARIABLE i        AS INT    NO-UNDO.
    DEFINE VARIABLE hChild   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hText    AS HANDLE NO-UNDO.
    DEFINE VARIABLE iFound   AS INT    NO-UNDO.
    
    CREATE X-NODEREF hChild. 
    CREATE X-NODEREF hText. 
   
    /* piId is set to 0 to indicate that we have arrived at the node that was 
     * passed into getElementsByTagName 
     */
    IF phElement:UNIQUE-ID = piId THEN
        piId = 0.
   
    /* pcName is case-senstive so we use lookup insted of can-do */
    IF piId = 0 AND LOOKUP(phElement:NAME,pcName) > 0 THEN
    DO:
        phElement:NORMALIZE().
        phElement:GET-CHILD(hText,1).
        CREATE ttElements.
        CREATE X-NODEREF ttElements.nhandle.
        hText:GET-PARENT(ttElements.nhandle).
        ASSIGN ttElements.NAME      = phElement:Name
        ttElements.Path             = pcPath.
        ttElements.NodeValue        = IF hText:SUBTYPE = "text" THEN 
            hText:NODE-VALUE 
        ELSE 
            "".
    END. /* PiID = 0 */
   
    /* Add element and [number] to path */  
    pcPath = pcPath + "/" + phElement:NAME.
   
    FIND tPath WHERE tPath.Path = pcPath NO-ERROR.
    IF NOT AVAIL tPath THEN
    DO:
        CREATE tPath.
        ASSIGN tPath.Path = pcPath.
    END.
    tPath.Num = tPath.Num + 1.

    DO i = 1 TO phElement:NUM-CHILDREN :
        phElement:GET-CHILD(hChild,i).
        IF hChild:SUBTYPE = 'element' THEN
            RUN searchElementsByTagName (hChild,pcName,piId,
                pcPath + '[' + STRING(tPath.Num) + ']').
    
    END.
END.

/* Takes a MEMPTR for input, removes any external DTD
 * reference, and returns a parsed X-DOCUMENT.
 */
PROCEDURE parseNoDTD:

    DEF INPUT PARAM mem-in AS MEMPTR NO-UNDO.
    DEF INPUT PARAM mem-size AS INTEGER NO-UNDO.
    DEF OUTPUT PARAM xml-out AS HANDLE NO-UNDO.

    DEF VAR mem-xml         AS MEMPTR NO-UNDO.
    DEF VAR raw-data        AS CHAR NO-UNDO.
    DEF VAR sub1            AS CHAR NO-UNDO.
    DEF VAR sub2            AS CHAR NO-UNDO.
    DEF VAR chunk-size      AS INT NO-UNDO.
    DEF VAR start-idx       AS INT NO-UNDO.
    DEF VAR stop-idx        AS INT NO-UNDO.
    DEF VAR bytes           AS INT NO-UNDO.

    IF mem-size > 30000 THEN
        chunk-size = 30000.
    ELSE
        chunk-size = mem-size.

    raw-data = GET-STRING(mem-in, 1, chunk-size).
    start-idx = INDEX(raw-data, "<!DOCTYPE").
    IF start-idx > 0 THEN
    DO:
        stop-idx = INDEX(raw-data, ">", start-idx).
        sub1 = SUBSTRING(raw-data, 1, (start-idx - 1)).
        sub2 = SUBSTRING(raw-data, stop-idx + 1, -1).
        raw-data = sub1 + sub2.
    END.
    bytes = LENGTH(raw-data).

    IF chunk-size = mem-size THEN
    DO:
        SET-SIZE(mem-xml) = bytes + 1.
        PUT-STRING(mem-xml, 1) = raw-data.
    END.
    ELSE
    DO:
        SET-SIZE(mem-xml) = mem-size - (chunk-size - bytes) + 1.
        PUT-STRING(mem-xml, 1) = raw-data.
        start-idx = chunk-size + 1.
        stop-idx = bytes + 1.
        REPEAT:
            IF (mem-size - start-idx) < 30000 THEN
                chunk-size = mem-size - start-idx.
            raw-data = GET-STRING(mem-in, start-idx, chunk-size).
            PUT-STRING(mem-xml, stop-idx) = raw-data.
            start-idx = start-idx + chunk-size.
            stop-idx = stop-idx + chunk-size.
            IF start-idx >= mem-size THEN
                LEAVE.
        END.
    END.

    CREATE X-DOCUMENT xml-out.
    xml-out:LOAD("memptr", mem-xml, FALSE).
    SET-SIZE(mem-xml) = 0.
END.
