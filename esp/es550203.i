/*****************************************************************************

    Programa    : sdin001i01.i
    
    Objetivo    : Include para Abrir, Fechar a Planilha Excel ou Mudar de Pasta
    
    Autor       : DatasulWA - Minas Gerais - Eduardo Leite
    
    Data        : 12/03/2009
    
    Revis∆o     :
    
*****************************************************************************/    

case "{1}":

    /*** Abrir a Planilha Excel ***/
    when "Abrir" then do:

        create "excel.application" ChExcel.

        assign ChBook                 = ChExcel:WorkBooks:OPEN(c-filename)
               ChSheet                = ChExcel:ActiveSheet
               ChExcel:DisplayAlerts  = no /*** N∆o mostrar mensagens de error ***/
               ChExcel:visible        = no /*** N∆o mostrar a planilha na tela ***/
               chexcel:ScreenUpdating = no /*** N∆o efetuar display na tela    ***/.

    end.

    /*** Fechar a Planilha Excel ***/
    when "Fechar" then do:

        if valid-handle(ChExcel) then do:

            ASSIGN c-caminho = session:temp-dir + TRIM(c-seg-usuario) + "\".

            ChExcel:ActiveWorkBook:SaveAs(c-caminho + x-c-tabela + string(time) + ".xls",-4143,"","",false,false,3).
            
            chexcel:ScreenUpdating = yes.
            ChExcel:visible        = yes.

            release object ChExcel      no-error.

                    end.

                if valid-handle(ChSheet) then
            release object ChSheet      no-error.

        if valid-handle(ChBook) then
            release object ChBook       no-error.

    end.

    /***** Mudar de Pasta de Trabalho *****/
    when "MudarPasta" then do:
        assign chsheet  = chexcel:worksheets:item({2}) NO-ERROR.
        chexcel:Worksheets({2}):Activate NO-ERROR.
        assign chbook   = chexcel:Worksheets({2}) NO-ERROR.

    end.

    /***** Validar o N£mero de Registros Encontrados *****/
    when "NrRegEnc" then do:

        if ChExcel:version = "11.0" and
           {2} + iLinha   >= 65536  then do:
            
            run utp\ut-msgs.p (input "show",
                               input 27100,
                               input "Vers∆o Excel (Vs " + ChExcel:version + ") n∆o permite mais de 65536 Linha. Deseja Continuar?" +
                                     "~~" +
                                     "A Vers∆o do Excel Ç incompat°vel com o n£mero de linha para a pasta selecionada - ultrapassou o limite de 65536 linha (incluindo o cabeáalho). " +
                                     "Deseja continuar? Se SIM ser∆o impressas somente atÇ o limite, se N«O dever† ser reduzido a Seleá∆o/ParÉmetros para reduzir o n£mero de registros." + " Pasta Trabalho: " + chbook:name).
            if return-value = "no" then do:

                ChExcel:ActiveWorkbook:close.

                if valid-handle(ChExcel) then
                    release object ChExcel      no-error.

                if valid-handle(ChSheet) then
                    release object ChSheet      no-error.

                if valid-handle(ChBook) then
                    release object ChBook       no-error.

                return "adm-error":U.

            end.

        end.

    end.

end.

