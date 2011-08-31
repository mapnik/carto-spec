grammar carto;
options { language=Java; }

/*

Grammar taken from
http://www.w3.org/TR/REC-CSS2/syndata.html#tokenization

ANTLR from
http://www.bensblog.com/2008/05/23/parsing-css-with-antlr

*/

//stylesheet  : [ CDO | CDC | S | statement ]*;
stylesheet
    :   (CDO|CDC|statement)*
    ;


//statement   : ruleset | at-rule;
statement
    :   ruleset
    ;



//block       : '{' S* [ any | block | ATKEYWORD S* | ';' ]* '}' S*;
block   :   LBRACE (any|block|VARIABLE|SEMICOLON)* RBRACE 
    ;

//ruleset     : selector? '{' S* declaration? [ ';' S* declaration? ]* '}' S*;

selector:   '*'
    |   '*'? (IDENT|'>'|'+'|CLASS|HASH)+
    ;
    
    
ruleset :   selector? LBRACE declaration? ( SEMICOLON declaration? )* RBRACE
    ;

//selector    : any+;

//declaration : property ':' S* value;
declaration
    :   property COLON value
    ;

//property    : IDENT S*;
property:   IDENT
     ;

//value       : [ any | block | ATKEYWORD S* ]+;
value   :   (any|block|VARIABLE)*
          ;

//any         : [ IDENT | NUMBER | PERCENTAGE | DIMENSION | STRING
//              | DELIM | URI | HASH | UNICODE-RANGE | INCLUDES
//              | FUNCTION | DASHMATCH | '(' any* ')' | '[' any* ']' ] S*;
any :   (   IDENT|NUMBER|PERCENTAGE|DIMENSION|STRING|
            HASH|INCLUDES|
            FUNCTION|DASHMATCH
            // TODO UNICODE_RANGE|DELIM|URI| '(' any* ')' | '[' any* ']' ] S*;
        )
    ;


/* Tokens */

//IDENT     {ident}
IDENT   :   F_IDENT
    ;

//ATKEYWORD     @{ident}
VARIABLE
    :   '@' F_IDENT
    ;

//STRING    {string}
STRING  :   F_STRING
    ;

//HASH  #{name}
HASH    :   '#' F_NAME
    ;

//NUMBER    {num}
NUMBER  :   F_NUM
    ;

//PERCENTAGE    {num}%
PERCENTAGE
    :   F_NUM '%'
    ;

//DIMENSION     {num}{ident}
DIMENSION
    :   F_NUM F_IDENT
    ;

//URI   url\({w}{string}{w}\)
//|url\({w}([!#$%&*-~]|{nonascii}|{escape})*{w}\)
//UNICODE-RANGE     U\+[0-9A-F?]{1,6}(-[0-9A-F]{1,6})?


//CDO   <!--
CDO :   '<!--'
    ;

//CDC   -->
CDC :   '-->'
    ;


//;     ;
SEMICOLON
    :   ';'
    ;   
    
COLON   :   ':'
    ;   


//{     \{
LBRACE  :   '{'
    ;

//}     \}
RBRACE  :   '}'
    ;

//(     \(
LPAREN  :   '('
    ;

//)     \)
RPAREN  :   ')'
    ;

//[     \[
LBRACKET:   '['
    ;

//]     \]
RBRACKET:   ']'
    ;

//S     [ \t\r\n\f]+
S   :   (' '|'\t'|'\r'|'\n'|'\f')+
        { $channel=HIDDEN; }
    ;

//COMMENT   \/\*[^*]*\*+([^/][^*]*\*+)*\/
COMMENT :   '/*' (options {greedy=false;} : .)*   '*/'
        { $channel=HIDDEN; }
    ;

//FUNCTION  {ident}\(
FUNCTION:   F_IDENT '('
    ;

//INCLUDES  ~=
INCLUDES:   '~='
    ;

//DASHMATCH     |=
DASHMATCH
    :   '|='
    ;

//DELIM     any other character not matched by the above rules

CLASS   :   '.' F_IDENT
    ;


//ident     {nmstart}{nmchar}*
fragment
F_IDENT :   F_NMSTART F_NMCHAR*
    ;

//name  {nmchar}+
fragment
F_NAME  :   F_NMCHAR+
    ;

//nmstart   [a-zA-Z]|{nonascii}|{escape}
fragment
F_NMSTART
    :   (F_LETTER)
// TODO add nonascii, escaped
    ;

//nonascii  [^\0-\177]
//unicode   \\[0-9a-f]{1,6}[ \n\r\t\f]?
//escape    {unicode}|\\[ -~\200-\4177777]

//nmchar    [a-z0-9-]|{nonascii}|{escape}
fragment
F_NMCHAR:   (F_LETTER|F_DIGIT|'-')
// TODO add nonascii, escaped
    ;

//num   [0-9]+|[0-9]*\.[0-9]+
fragment
F_NUM   :   ('0'..'9')+
    |   ('0'..'9')* '.' ('0'..'9')+
    ;


//string    {string1}|{string2}
fragment
F_STRING:   F_STRING1
    |   F_STRING2
    ;

//string1   \"([\t !#$%&(-~]|\\{nl}|\'|{nonascii}|{escape})*\"
fragment
F_STRING1
    :   '"' ('\t'|' '|'!'|'#'|'$'|'%'|'&'|'\''|'.'|F_LETTER|F_DIGIT)* '"' 
    ;
//string2   \'([\t !#$%&(-~]|\\{nl}|\"|{nonascii}|{escape})*\'
fragment
F_STRING2
    :   '\'' ('\t'|' '|'!'|'#'|'$'|'%'|'&'|'.'|F_LETTER|F_DIGIT)* '\'' 
    ;

//nl    \n|\r\n|\r|\f
fragment
F_NL    :   '\n'
    |   '\r\n'
    |   '\r'
    |   '\f'
    ;
    
fragment
F_LETTER:   'a'..'z'
    |   'A'..'Z'
    ;
    
fragment
F_DIGIT :   '0'..'9'
    ;

//w     [ \t\r\n\f]*
fragment
F_W :   (' '|'\t'|'\r'|'\n'|'\f')*
    ;