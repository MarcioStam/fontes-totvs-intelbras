/***********************************************************************
**  Programa..: upc\cd0111-upc.p
**  Autor.....: Graziely Lima - iDBA
**  Data......: MAR€O/2022 - Desenvolvimento
**  Descricao.: UPC para cria‡Æo da flag "Desativado - NÆo considera APS"
**  VersÆo....: 001
**  VersÆo....: 002 - 22/07/2022 - iDBA - Cargos UEP
**  VersÆo....: 003 - 06/10/2022 - iDBA - Valida‡Æo
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE i-aux            as integer no-undo.
DEFINE VARIABLE h-frame          AS HANDLE  NO-UNDO.
DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.
DEFINE VARIABLE ProgramHandle    as handle  no-undo.
DEFINE VARIABLE ProgramHandle2   as handle  no-undo.
DEFINE VARIABLE h-objeto         as handle  no-undo.
DEFINE VARIABLE h-folder         as handle  no-undo.
DEFINE VARIABLE c-folder         as char    no-undo.
DEFINE VARIABLE c-obj-aux        as char    no-undo.

def new global shared var h-cd0111-upc-b01  as handle        no-undo.
def new global shared var adm-broker-hdl    as handle        no-undo.
DEF NEW GLOBAL SHARED VAR wh-tg-consid-aps  AS WIDGET-HANDLE NO-UNDO.
def new global shared var lg-aux-cd0111-upc as logi          no-undo.

def new global shared var lg-cd0111-upc-inc as logi no-undo.
def new global shared var lg-cd0111-upc-mod as logi no-undo.
DEF NEW GLOBAL SHARED VAR lg-cd0111-upc-del as logi NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

/* message "Evento    " p-ind-event  skip         */
/*         "Objeto    " p-ind-object skip         */
/*         "nome obj  " c-objeto     skip         */
/*         "Frame     " p-wgh-frame  skip         */
/*         "Tabela    " p-cod-table  skip         */
/*         "ROWID     " string(p-row-table) SKIP  */
/*         view-as alert-box information.         */

if  p-ind-event  = "before-initialize"
and p-ind-object = "container"
and c-objeto     = "cd0111.w"
then do:
     assign ProgramHandle     = session:first-procedure
            lg-aux-cd0111-upc = no.

     /* Verifica quantas instƒncias do programa h  na mem¢ria */
     do while valid-handle(ProgramHandle):
         if ProgramHandle:file-name = "cdp/cd0111.w"
         or ProgramHandle:file-name = "cdp\cd0111.w"
         then assign i-aux          = i-aux + 1
                     ProgramHandle2 = ProgramHandle.

         assign ProgramHandle = ProgramHandle:next-sibling.
     end.

     if i-aux > 1
     then do:
          run utp\ut-msgs.p(input "show", input 19085, input "CD0111 j  est  aberto!").
          delete procedure ProgramHandle2.
          return "NOK".
     end.

     assign lg-aux-cd0111-upc = yes.
end.

IF p-ind-event = "INITIALIZE" AND p-ind-object = "CONTAINER" THEN DO:

    CREATE TOGGLE-BOX wh-tg-consid-aps
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 30
           HEIGHT       = 0.88
           ROW          = 3.2
           LABEL        = "Desativado - NÆo considera APS"
           COLUMN       = 40.5
           SENSITIVE    = NO
           VISIBLE      = YES.

    if lg-aux-cd0111-upc
    then run pi-folder.
END.

IF p-ind-event = "ASSIGN" THEN DO:

    FIND FIRST grup-maquina WHERE ROWID(grup-maquina) = p-row-table NO-LOCK NO-ERROR.
    
    IF  AVAIL grup-maquina
    and valid-handle(wh-tg-consid-aps)
    THEN DO:
         if wh-tg-consid-aps:checked
         then do:
              if can-find(first operacao use-index grup-maquina where
                                operacao.gm-codigo     = grup-maquina.gm-codigo
                            and operacao.data-termino >= today
                                no-lock)
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Grupo de M quina possui Opera‡Æo ativa Î favor verificar").
                   return "NOK":U.
              end.

              if can-find(first int_bem_pat_gm use-index ch-gm where
                                int_bem_pat_gm.gm-codigo = grup-maquina.gm-codigo
                                no-lock)
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Grupo de M quina possui BEM no ESCDP118 Î favor verificar").
                   return "NOK":U.
              end.
         end. /* if wh-tg-consid-aps:checked */

         ASSIGN grup-maquina.log-1 = wh-tg-consid-aps:CHECKED.
    END.

    if  p-ind-object = "VIEWER"
    and c-objeto     = "v16in144.w"
    then do:
         run get-attribute in p-wgh-object ('adm-new-record').
    
         IF RETURN-VALUE = 'YES'
         THEN assign lg-cd0111-upc-inc = yes
                     lg-cd0111-upc-mod = no
                     lg-cd0111-upc-del = no.
    end.
END.

IF p-ind-event = "DISPLAY" THEN DO:

    FIND FIRST grup-maquina
        WHERE ROWID(grup-maquina) = p-row-table NO-LOCK NO-ERROR.

    IF AVAIL grup-maquina THEN DO:
        IF  VALID-HANDLE(wh-tg-consid-aps) THEN
            ASSIGN wh-tg-consid-aps:SENSITIVE = NO
                   wh-tg-consid-aps:CHECKED = grup-maquina.log-1.
    END.
END.

IF p-ind-event = "AFTER-ENABLE" THEN DO:

    FIND FIRST grup-maquina
        WHERE ROWID(grup-maquina) = p-row-table NO-LOCK NO-ERROR.

    IF AVAIL grup-maquina THEN DO:
        IF  VALID-HANDLE(wh-tg-consid-aps) THEN
            ASSIGN wh-tg-consid-aps:SENSITIVE = YES.
    END.

    if p-ind-object = "viewer"
    and c-objeto    = "v16in144.w"
    and valid-handle(h-cd0111-upc-b01)
    then do:
         run pi-get-status in h-cd0111-upc-b01 (output lg-cd0111-upc-inc,
                                                output lg-cd0111-upc-mod,
                                                output lg-cd0111-upc-del).

         run pi-set-status in h-cd0111-upc-b01 (input no,
                                                input no,
                                                input no).

         run get-attribute in p-wgh-object ('adm-new-record').

         if RETURN-VALUE = 'YES'
         then run pi-close in h-cd0111-upc-b01.
    end.
END.

if  p-ind-event  = "AFTER-DISABLE"
and p-ind-object = "VIEWER"
and c-objeto     = "v16in144.w"
and valid-handle(h-cd0111-upc-b01)
then do:
     run pi-open in h-cd0111-upc-b01.          

     run pi-set-status in h-cd0111-upc-b01 (input lg-cd0111-upc-inc, 
                                            input lg-cd0111-upc-mod, 
                                            input lg-cd0111-upc-del).
end.

procedure pi-folder:
    if not valid-handle(adm-broker-hdl)
    then return.

    run get-link-handle in adm-broker-hdl(input  p-wgh-object,
                                          input  "PAGE-SOURCE":U,
                                          output c-folder).

    assign h-folder = handle(c-folder) no-error.

    if not valid-handle(h-folder)
    then return.

    run get-attribute in h-folder(input "Folder-labels":U).

    assign i-aux = num-entries(return-value,"|") + 1.

    run create-folder-page  in h-folder(input i-aux,
                                        input "CargosUEP":U).
    run create-folder-label in h-folder(input i-aux,
                                        input "Cargos UEP":U).

    run select-page in p-wgh-object(input i-aux).

    run init-object in p-wgh-object(input  "upc/cd0111-upc-b01.w":U,
                                    input  p-wgh-frame,
                                    input  'Initial-Lock = NO-LOCK,
                                            Hide-on-Init = no,
                                            Disable-on-Init = no,
                                            Layout = ,
                                            Create-On-Add = ?,
                                            ProgAtributo = ,
                                            ProgIncMod = upc/cd0111-upca.w,
                                            MessageNum = 0,
                                            MessageParam = ':U ,
                                    output h-cd0111-upc-b01).

    run set-position in h-cd0111-upc-b01 (6.5,3.5).

    run get-link-handle in adm-broker-hdl (input  p-wgh-object,
                                           input  "CONTAINER-TARGET":U,
                                           output c-obj-aux).

    do i-aux = 1 to num-entries(c-obj-aux):
        assign h-objeto = widget-handle(entry(i-aux, c-obj-aux)).

        if index(h-objeto:private-data, "q01in144") <> 0
        then do:
             run add-link in adm-broker-hdl (input h-objeto,
                                             input "Record":U,
                                             input h-cd0111-upc-b01).

             leave.
        end.
    end. 

    run dispatch in h-cd0111-upc-b01 ("initialize":U).
    
    run select-page in p-wgh-object (input 1).
end procedure. /* procedure pi-folder */

