def var i-cont     as int no-undo.
def var c-aux      as char no-undo.

if  self:data-type     = "character" and
    self:screen-value <> '?' and
    index(self:format,'x(') = 0 then do:
 
  c-aux = self:screen-value.
 
  do  i-cont = 1 to length(self:format):
      if  substr(self:format,i-cont,1) = '9' then   
      if  not(substr(self:screen-value,i-cont,1) >= '0' and
              substr(self:screen-value,i-cont,1) <= '9') then do:

          overlay (c-aux, i-cont,1) = '0'.
/*
          run utp/ut-msgs.p (input "show", input 8816, input self:format).
          return no-apply.
*/
      end.        
  end.
  
  assign self:screen-value = c-aux.

end.
   
