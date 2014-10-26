
Nonterminals dict def val_def att_def ven_def inc_def aopts name_fix digits.
Terminals include attribute value vendor vendor_begin vendor_end atype aopt format comma name.
Rootsymbol dict.

dict -> def dict : ['$1'|'$2'].
dict -> def : ['$1'].

def  -> att_def : '$1'.
def  -> val_def : '$1'.
def  -> ven_def : '$1'.
def  -> inc_def : '$1'.

att_def -> attribute name digits atype : make_adef('$2','$3','$4', []).
att_def -> attribute name digits atype aopts : make_adef('$2','$3','$4', '$5').

aopts -> aopt : ['$1'].
aopts -> aopt comma aopts : ['$1'|'$3'].

val_def -> value name_fix name_fix digits : make_vdef('$2','$3','$4').

ven_def -> vendor name_fix digits : make_vendor('$2','$3').
ven_def -> vendor name_fix digits format : make_vendor('$2','$3','$4').
ven_def -> vendor_begin name_fix : make_vbegin('$2').
ven_def -> vendor_end name_fix : make_vend('$2').

inc_def -> include : v('$1').

name_fix -> name : '$1'.
name_fix -> name comma name_fix: fix_comma('$1','$3').

digits -> name : make_digit('$1').

Erlang code.

fix_comma({A,B,X},{_,_,Y}) ->
    {A,B,X++[$,|Y]}.

make_adef(Name,Id,Type,Opts) ->
    {attribute,v(Name),v(Id),v(Type),lists:map(fun v/1,Opts)}.

make_vdef(Attr,Desc,Val) ->
    {value,v(Attr),v(Desc),v(Val)}.

make_vendor(Name,Id) ->
    {vendor,v(Name),v(Id),{1,1}}.

make_vendor(Name,Id,Format) ->
    {vendor,v(Name),v(Id),v(Format)}.

make_vbegin(Name) ->
    {vendor_begin,v(Name)}.

make_vend(Name) ->
    {vendor_end,v(Name)}.

make_digit({A,B,X})->
    {A,B,to_integer(X)}.

to_integer("0x"++L) -> list_to_integer(L,16);
to_integer(L) -> list_to_integer(L).

v({_,_,V}) -> V.
