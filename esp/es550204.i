/*****************************************************************************

    Programa    : sdin001i04.i
    
    Objetivo    : Formata as Linhas x Colunas da Planilha
    
    Autor       : DatasulWA - Minas Gerais - Eduardo Leite
    
    Data        : 12/03/2009
    
    Revis∆o     :
    
*****************************************************************************/    

case "{1}":

    when "Formataá∆o" then do:

        chbook:PageSetup:PrintTitleRows = "$1:$" + string(iLinha).
    
        if {2} <= iLinha - 2 then
            assign iNumLinha = iLinha.
        else
            assign iNumLinha = {2}.
    
        run utp/ut-acomp.p persistent set h-acomp.  
        {utp/ut-liter.i "Aguarde..."}
        run pi-inicializar in h-acomp (input "Aguarde..."). 
    
        do iColunas = 1 to iNumCol:
    
            assign cRange = caps(entry(iColunas,cColunas) + "9").
    
            run pi-acompanhar  in h-acomp (input "Formatando Pasta " + chbook:name + " - " + caps(entry(iColunas,cColunas))). 
    
            chexcel:Range(cRange):select.
            chexcel:Range(cRange):copy.
    
            if ChExcel:version = "11.0" and
               iNumLinha + iLinha   >= 65536  then
                assign cRange = entry(iColunas,cColunas) + "10:" + entry(iColunas,cColunas) + string(65535).
            else
                assign cRange = entry(iColunas,cColunas) + "10:" + entry(iColunas,cColunas) + string(iNumLinha + iLinha).
    
            chexcel:Range(cRange):select.
            chbook:Paste.
    
        end.
    
        /***** Borda Inferior ****/
        assign cRange = "A" + string(iNumLinha + iLinha) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha).
        ChSheet:Range(cRange):Borders(9):LineStyle  = 1.
        ChSheet:Range(cRange):Borders(9):Weight     = -4138.
        ChSheet:Range(cRange):Borders(9):ColorIndex = -4105.
    
        /***** Linha de SubTotais *****/
        assign cRange = "A" + string(iNumLinha + iLinha) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha).
        ChSheet:Range(cRange):select.
        ChSheet:Range(cRange):copy.
    
        assign cRange = "A" + string(iNumLinha + iLinha + 1) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha + 1).
        ChSheet:Range(cRange):select.
        ChSheet:paste.
    
        ChExcel:Range("A" + string(iNumLinha + iLinha + 1) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha + 1)):Interior:ColorIndex = 15.
        ChExcel:Range("A" + string(iNumLinha + iLinha + 1) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha + 1)):font:BOLD = yes.
        ChExcel:Range("A" + string(iNumLinha + iLinha + 1) + ":" + entry(iNumCol,cColunas) + string(iNumLinha + iLinha + 1)):FormatConditions:delete.
    
        assign cRange = "A" + string(iLinha + 1).
    
        ChSheet:Range(cRange):select.
    
        run pi-finalizar in h-acomp. 

    end.

    when "Converter" then do:

        run utp/ut-acomp.p persistent set h-acomp.  
        {utp/ut-liter.i "Aguarde..."}
        run pi-inicializar in h-acomp (input "Aguarde..."). 
        run pi-acompanhar  in h-acomp (input "Convertendo Texto x Coluna..."). 

        ChExcel:Range("A" + string(iLinha - {2} + 1) + ":A" + string(iLinha)):select.

        ChExcel:selection:TextToColumns (,         /* Destination          */
                                         1,        /* DataType             */
                                         ,         /* TextQualifier        */
                                         ,         /* ConsecutiveDelimiter */
                                         ,         /* Tab                  */
                                         ,         /* Semicolon            */
                                         ,         /* Comma                */
                                         ,         /* Space                */
                                         true,     /* Other                */
                                         chr(161), /* OtherChar            */
                                         ,         /* FieldInfo            */
                                         ) no-error.

        assign cRange = "A6".
        ChSheet:Range(cRange):select.

        run pi-finalizar in h-acomp.

    end.

end case.
