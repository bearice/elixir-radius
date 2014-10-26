Definitions.

ATTRIBUTE = ATTRIBUTE
VALUE     = VALUE
VENDOR    = VENDOR
B_VENDOR  = BEGIN-VENDOR
E_VENDOR  = END-VENDOR
INCLUDE   = \$INCLUDE[\s\t]+[^\r\n]+
ATYPE     = (string|octets|ipaddr|integer|signed|date|ifid|ipv6addr|ipv6prefix|ether|abinary|byte|short)
COMMA     = ,
HAS_TAG   = has_tag
ENCRYPT   = encrypt=[1-3]
FORMAT    = format=[124],[012]
NAME      = [a-zA-Z0-9\_\-\/\\\+\.]+
%DIGITS    = [0-9]+
%HEX       = 0x[0-9a-fA-F]+
SPACE     = [\s\t\v\f]
COMMENT   = #[^\r\n]*
EOL       = (\r\n?|\n)

Rules.

{INCLUDE}      : {token,{include,TokenLine,parse_include(TokenChars)}}.
{ATTRIBUTE}    : {token,{attribute,TokenLine}}.
{VALUE}        : {token,{value,TokenLine}}.
{VENDOR}       : {token,{vendor,TokenLine}}.
{B_VENDOR}     : {token,{vendor_begin,TokenLine}}.
{E_VENDOR}     : {token,{vendor_end,TokenLine}}.
{ATYPE}        : {token,{atype,TokenLine,list_to_atom(TokenChars)}}.
{COMMA}        : {token,{comma,TokenLine}}.
{HAS_TAG}      : {token,{aopt,TokenLine,has_tag}}.
{ENCRYPT}      : {token,{aopt,TokenLine,parse_encrypt(TokenChars)}}.
{FORMAT}       : {token,{format,TokenLine,parse_format(TokenChars)}}.
%{DIGITS}       : {token,{digits,TokenLine,to_integer(TokenChars)}}.
%{HEX}          : {token,{digits,TokenLine,to_integer(TokenChars)}}.
{NAME}         : {token,{name,TokenLine,TokenChars}}.
{EOL}          : skip_token.
{SPACE}+       : skip_token.
{COMMENT}      : skip_token.

Erlang code.



trim_ws(T) -> 
    {ok,R} = re:compile("(^\s*)|(\s*$)"),
    re:replace(T,R,"").

parse_include("$INCLUDE"++Name) ->
    {include,trim_ws(Name)}.

parse_encrypt("encrypt="++[X])->
    {encrypt,X-$1}.

parse_format("format="++[X,_,Y])->
    {X-$1,Y-$1}.
