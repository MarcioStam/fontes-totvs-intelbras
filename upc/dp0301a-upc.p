/***********************************************************************
**
**  EPC dp0301a
**  
************************************************************************/
{utp\ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

def var c-char      as char                         no-undo.
def var wh-field    as widget-handle                no-undo.
def var texto       like dp-proces-item.narrativa   no-undo.
def var lg-ok       as logical                      no-undo.

def buffer b-dp-proces-item for dp-proces-item.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/***
MESSAGE p-ind-object    skip
        p-ind-event     skip
        p-cod-table     skip
        STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
***/    

if  p-ind-object = "viewer"
and p-ind-event  = "after-validate"
then do:
    find dp-proces-item where rowid(dp-proces-item) = p-row-table no-lock no-error.
    if avail dp-proces-item
    then do:

        run getHandler ( input "item-dp":U,  input p-wgh-frame, output wh-field).

        find first b-dp-proces-item
             where b-dp-proces-item.item-dp          = wh-field:screen-value
               and b-dp-proces-item.num-proces-item <> dp-proces-item.num-proces-item
               and b-dp-proces-item.ind-aprov        = 1
            no-lock no-error.
        if avail b-dp-proces-item
        then do:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Existe outro processo em aberto para o mesmo item.").
            return 'nok'.
        end.        

        /*--- retirada a valida‡Æo abaixo para evitar problema na operacao entre ENGENHARIA e DESENVOLVIMENTO
        
        find first b-dp-proces-item
             where b-dp-proces-item.item-dp          = wh-field:screen-value
               and b-dp-proces-item.num-proces-item <> dp-proces-item.num-proces-item
               and b-dp-proces-item.ind-aprov       >= 3
               and b-dp-proces-item.ind-aprov       <= 5
            no-lock no-error.
        if avail b-dp-proces-item
        then do:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Existe outro processo aprovado, e nÆo liberado para engenharia, para o mesmo item.").
            return 'nok'.
        end.        
        --------------------------------------------------*/
    end.
end.

if  p-ind-object = "viewer"
and p-ind-event  = "before-assign"
then do:
    find dp-proces-item where rowid(dp-proces-item) = p-row-table no-error.
    if avail dp-proces-item
    then do:
        assign dp-proces-item.user-criacao = c-seg-usuario.
    end.
end.



procedure getHandler.

   define  input parameter p-nome     as character no-undo.
   define  input parameter p-handle   as handle    no-undo.
   define output parameter p-retorno  as handle    no-undo.

   define variable h-frame    as handle   no-undo.

   assign h-frame = p-handle:first-child.

   do while ( h-frame <> ? ):

      if h-frame:type <> "FIELD-GROUP":U
      then do:
          if h-frame:name = p-nome
          then do:
              assign p-retorno = h-frame.
              return.
          end.

          else assign h-frame = h-frame:next-sibling.
      end.

      else assign h-frame = h-frame:first-child.
   end.

   return.

end procedure.   /* getHandler  */
