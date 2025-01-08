def temp-table grupo-com
 FIELD cd-gr-com AS integer FORMAT ">>9"
 FIELD ds-gr-com AS character FORMAT "X(30)"
 FIELD b2b       AS logical FORMAT "Sim/Nao"
 INDEX codigo cd-gr-com ASCENDING.

def temp-table subgrupo-com
 FIELD cd-sub-com  AS integer FORMAT ">>9"
 FIELD ds-sub-com  AS character FORMAT "X(30)"
 FIELD cd-gr-com   AS integer FORMAT ">>9"
 FIELD quantidade  AS integer FORMAT ">>9"
 FIELD b2b         AS logical FORMAT "Sim/Nao"
 INDEX codigo cd-gr-com  ASCENDING 
              cd-sub-com ASCENDING.

def temp-table comp-item
 FIELD it-codigo AS character FORMAT "X(16)"
 FIELD cd-gr-com AS integer   FORMAT ">>9"
 FIELD cd-sub-com AS integer  FORMAT ">>9"
 FIELD cd-marca AS integer    FORMAT ">>9"
 FIELD cd-cor AS integer      FORMAT ">>9"
 FIELD nr-tronco AS integer   FORMAT ">>9"
 FIELD nr-ramais AS integer   FORMAT ">>9"
 FIELD nr-ram-dig AS integer  FORMAT ">>>"
 FIELD dec-1 AS decimal       FORMAT ">>>>>9.99"
 FIELD dec-2 AS decimal       FORMAT ">>>>>9.99"
 FIELD int-1 AS integer       FORMAT ">>>>>>>>9"
 FIELD int-2 AS integer       FORMAT ">>>>>>>>9"
 FIELD data-1 AS date         FORMAT "99/99/9999"
 FIELD data-2 AS date         FORMAT "99/99/9999"
 FIELD char-1 AS character    FORMAT "X(256)"
 FIELD log-1 AS logical       INDEX cod-item it-codigo ASCENDING 
 INDEX cod-cor  cd-cor  ASCENDING 
 INDEX cod-grup cd-gr-com  ASCENDING 
 INDEX cod-marca cd-marca ASCENDING 
 INDEX cod-ramal nr-ramais ASCENDING 
 INDEX cod-sub-com cd-sub-com ASCENDING 
 INDEX cod-tronco nr-tronco ASCENDING 
 INDEX ramal-tronco nr-ram-dig ASCENDING 
                    nr-ramais ASCENDING 
                    nr-tronco ASCENDING 
                    it-codigo ASCENDING .
