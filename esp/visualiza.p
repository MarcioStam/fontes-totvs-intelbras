/*****************************************************************************
** Objetivo: Abrir arquivos de qualquer extensÆo a partir de um path+arquivo
*****************************************************************************/
{include/i_dbinst.i}
{include/i_dbtype.i}

assign this-procedure:private-data = "HLP=16":U.

def Input param p_nom_filename
    as character
    format "x(80)"
    no-undo.

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)"
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(12)"
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)"
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)"
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)"
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)"
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)"
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)"
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)"
    no-undo.
def var v_log_ok
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.
def var v_nom_exec
    as character
    format "x(30)"
    label "Aplicativo"
    no-undo.
def var v_nom_extension
    as character
    format "x(3)"
    no-undo.
def var v_nom_filename
    as character
    format "x(80)"
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    no-undo.
def var v_nom_path
    as character
    format "x(50)"
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9"
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9"
    no-undo.

assign v_nom_filename = p_nom_filename
       v_nom_extension = (entry(NUM-ENTRIES(v_nom_filename,"."),v_nom_filename, ".")).
       
run OpenDocument (v_nom_filename).

procedure OpenDocument:
    def input param c-doc as char.
    def var c-exec as char.
    def var h-Inst as int.
    
    run ConverteparaNomeDos ( input-output c-doc).
    
    assign c-exec = fill('x',255).
    run FindExecutableA in this-procedure (input c-doc,
                                           input "",
                                           input-output c-exec,
                                           output h-inst).
    
    if h-inst >= 0 and h-inst <=32 
    then do:
        run ShellExecuteA in this-procedure (input 0,
                                             input 'open',
                                             input 'rundll32.exe',
                                             input 'shell32.dll,OpenAs_RunDLL ' + c-doc,
                                             input "",
                                             input 1,
                                             output h-inst).
    end.
    
    run ShellExecuteA in this-procedure (input 0,
                                        input 'open',
                                        input c-doc,
                                        input "",
                                        input "",
                                        input 1,
                                        output h-inst).

    if h-inst < 0 or h-inst > 32 
    then do:
        return 'OK'.
    end.
    else do:
        return 'NOK'.
    end.
end procedure.

PROCEDURE ConverteparaNomeDos:
    def input-output param c-Nome as char no-undo.
    
    def var iLen   as int  init 255 no-undo.
    def var pShort as memptr.
    repeat:
        set-size(pShort) = iLen.
        run GetShortPathNameA 
            (c-Nome,
             get-pointer-value(pShort),
             get-size(pShort),
             output iLen).
        if get-size(pShort) >= iLen then
            leave. 
            
        set-size(pShort) = 0.
    end.
    c-Nome = get-string(pShort,1).
END PROCEDURE.    

PROCEDURE FindExecutableA EXTERNAL "SHELL32" :
  define input parameter lpFile as char.
  define input parameter lpDirectory as char.
  define input-output parameter lpResult as char.
  define return parameter hInstance as long.
END.

PROCEDURE ShellExecuteA EXTERNAL "SHELL32" :
  define input parameter hwnd as LONG.
  define input parameter lpOperation as char.
  define input parameter lpFile as char.
  define input parameter lpParameters as char.
  define input parameter lpDirectory as char.
  define input parameter nShowCmd as LONG.
  define return parameter hInstance as LONG.
END PROCEDURE.

PROCEDURE GetShortPathNameA EXTERNAL "KERNEL32":
    DEF INPUT  PARAM lpszLongPath  AS CHAR NO-UNDO.
    DEF INPUT  PARAM lpszShortPath AS LONG NO-UNDO.
    DEF INPUT  PARAM cchBuffer     AS LONG NO-UNDO.
    DEF RETURN PARAM lenBuffer     AS LONG NO-UNDO.
END PROCEDURE.

