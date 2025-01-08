/*****************************************************************************

    Programa    : sdin001i01.i
    
    Objetivo    : Include para Validar a Planilha Modelo
    
    Autor       : DatasulWA - Minas Gerais - Eduardo Leite
    
    Data        : 12/03/2009
    
    Revis∆o     :
    
*****************************************************************************/    

    file-info:file-name = "modelos\{1}.xls".
    if file-info:full-pathname <> ? then 
        assign cNomeArqOrigem  = file-info:full-pathname
               cNomeArqDestino = session:temp-directory + "\{1}_" + string(time) + ".xls".

    assign cNomeArqDestino = replace(cNomeArqDestino,"/","\")
           cNomeArqDestino = replace(cNomeArqDestino,"\\","\").

    if file-info:full-pathname = ? then do:

        run utp\ut-msgs.p (input "show",
                           input 17006,
                           input "Planilha Modelo " + caps("{1}") + ".XLS n∆o encontrada!" + 
                                 "~~" + 
                                 "N∆o foi poss°vel localizar a planilha modelo para a geraá∆o do arquivo. Favor comunicar " +
                                 "ao TI para verificar se a mesma existe no diret¢rio de ESPEC/MODELOS").
        return no-apply.

    end.

    os-command silent value("del " + session:temp-directory + "\{1}_*.xls").
    os-command silent value("del " + session:temp-directory + "\{1}_*.xlsx").
    os-copy value(cNomeArqOrigem) value(cNomeArqDestino).

    run pi-executar.

