package lex;
import java_cup.runtime.*;

%%
%class Lexer

%cup
%line
%column
%ignorecase

L = [a-zA-Z_]
D = [0-9]
WHITE=[ \b\r\f\t\n]

%{
	public Symbol token(int simbolo){
		Lexema lexema = new Lexema( yytext() );
		compilador.setError("La cadena "+yytext()+" es invalida, se encontro en la linea "+(yyline+1)+", y en la columna "+(yycolumn+1));
		return new Symbol(simbolo,yyline,yycolumn,lexema);
	}
	public Symbol token(int simbolo,String componenteLexico){
		Cup.vars++;
		Lexema lexema = new Lexema( yytext() );
		return new Symbol(simbolo,yyline,yycolumn,lexema);
	}
%}
%%
<YYINITIAL>{ 
{WHITE} {/*Ignore*/}


("//".*)
{}

("ALTO")
{return token(sym.ALTO,"ALTO");}
("s"|"ms")
{return token(sym.TIEMPO,"TIEMPO");}
("contador")
{return token(sym.CONTADOR,"CONTADOR");}
("retardo")
{return token(sym.RETARDO,"RETARDO");}
("servo")
{return token(sym.SERVO,"SERVO");}
("detener")
{return token(sym.DETENER,"DETENER");}
("motorelect")
{return token(sym.MOTORELECT,"MOTORELECT");}
("sar")
{return token(sym.SAR,"SAR");}
("car")
{return token(sym.CAR,"CAR");}
("declara")
{return token(sym.DECLARA,"DECLARA");}
("#")
{return token(sym.GATO,"GATO");}

("verdadero")
{return token(sym.VERDADERO,"VERDADERO");}
("falso")
{return token(sym.FALSO,"FALSO");}

("pen0"|"pen1"|"pen2"|"pen3"|"pen4"|"pen5"|"pen6"|"pen7")
{return token(sym.PENTRADA,"PENTRADA");}
("entrada")
{return token (sym.ENTRADA, "ENTRADA");}
("psa0"|"psa1"|"psa2"|"psa3"|"psa4"|"psa5"|"psa6"|"psa7")
{return token(sym.PSALIDA,"PSALIDA");}




("salida")
{return token(sym.SALIDA,"SALIDA");}
("}")
{return token(sym.LLAVEDER,"LLAVEDER");}


("{")
{return token(sym.LLAVEIZQ,"LLAVEIZQ");}
("(")
{return token(sym.PAREIZQ,"PAREIZQ");}

(")")
{return token(sym.PAREDER,"PAREDER");}
("caracter")
{return token(sym.CARACTER,"CARACTER");}

("boleano")
{return token(sym.BOLEANO,"BOLEANO");}
("variable")
{return token(sym.VARIABLE,"VARIABLE");}

(";")
{return token(sym.PUNTOYCOMA,"PUNTOYCOMA");}
(".")
{return token(sym.PUNTO,"PUNTO");}


(">=")
{return token(sym.MAYORIGUALQUE,"MAYORIGUALQUE");}










("y")
{return token(sym.AND,"AND");}


("no")
{return token(sym.NOT,"NOT");}

("o")
{return token(sym.OR,"OR");}
("<=")
{return token(sym.MENORIGUALQUE,"MENORIGUALQUE");}

("<")
{return token(sym.MENORQUE,"MENORQUE");}
(">")
{return token(sym.MAYORQUE,"MAYORQUE");}
("==")
{return token(sym.COMPARA,"COMPARA");}
("=")
{return token(sym.IGUAL,"IGUAL");}

("<>")
{return token(sym.DISTINTODE,"DISTINTODE");}
(",")
{return token(sym.COMA,"COMA");}
("and")
{return token(sym.Y,"Y");}
("or")
{return token(sym.O,"O");}
("no")
{return token(sym.NEGACION,"NEGACION");}
("ed")
{return token(sym.ED,"ED");}
("ef")
{return token(sym.EF,"EF");}
("repetir")
{return token(sym.REPEAT,"REPEAT");}
("hasta")
{return token(sym.UNTIL,"UNTIL");}

("inicio")
{return token(sym.INICIO,"INICIO");}
("final")
{return token(sym.FINAL,"FINAL");}
("ciclo")
{return token(sym.CICLO,"CICLO");}
("programa")
{return token(sym.PROGRAMA,"PROGRAMA");}
("hacer")
{return token(sym.DO,"DO");}
("mientras")
{return token(sym.WHILE,"WHILE");}
("procedimiento")
{return token(sym.PROCEDURE,"PROCEDURE");}
("bucle")
{return token(sym.BUCLE,"BUCLE");}
("(")
{return token(sym.PARENTESISIZQ,"PARENTESISIZQ");}
(")")
{return token(sym.PARENTESISDER,"PARENTESISDER");}
(":")
{return token(sym.DOSPUNTOS,"DOSPUNTOS");}
("+")
{return token(sym.SUMA,"SUMA");}

("mod")
{return token(sym.MODULO,"MODULO");}


("*")
{return token(sym.MULTIPLICACION,"MULTIPLICACION");}
("&")
{return token(sym.RESTA,"RESTA");}
("/")
{return token(sym.DIVISION,"DIVISION");}
(("'") [^"'"]* ("'"))        //"'
{return token(sym.CADENA,"CADENA");}


(-?{D}+)
{return token(sym.INTEGERNUM,"INTEGERNUM");}

{L}({L}|{D})*
{return token(sym.ID,"ID");}
}
.
{return token(sym.ERROR);}











