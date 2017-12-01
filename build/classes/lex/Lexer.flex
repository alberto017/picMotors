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
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.ALTO,"ALTO");}
("s"|"ms")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.TIEMPO,"TIEMPO");}
("contador")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.CONTADOR,"CONTADOR");}
("retardo")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.RETARDO,"RETARDO");}
("servo")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.SERVO,"SERVO");}
("detener")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DETENER,"DETENER");}
("motorelect")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MOTORELECT,"MOTORELECT");}
("sar")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.SAR,"SAR");}
("car")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.CAR,"CAR");}
("declara")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DECLARA,"DECLARA");}
("#")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.GATO,"GATO");}

("verdadero")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.VERDADERO,"VERDADERO");}
("falso")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.FALSO,"FALSO");}

("pen0"|"pen1"|"pen2"|"pen3"|"pen4"|"pen5"|"pen6"|"pen7")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PENTRADA,"PENTRADA");}
("entrada")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token (sym.ENTRADA, "ENTRADA");}
("psa0"|"psa1"|"psa2"|"psa3"|"psa4"|"psa5"|"psa6"|"psa7")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PSALIDA,"PSALIDA");}




("salida")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.SALIDA,"SALIDA");}
("}")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.LLAVEDER,"LLAVEDER");}

("{")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.LLAVEIZQ,"LLAVEIZQ");}
("(")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PAREIZQ,"PAREIZQ");}

(")")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PAREDER,"PAREDER");}
("caracter")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.CARACTER,"CARACTER");}

("boleano")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.BOLEANO,"BOLEANO");}
("variable")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.VARIABLE,"VARIABLE");}

(";")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PUNTOYCOMA,"PUNTOYCOMA");}
(".")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PUNTO,"PUNTO");}

(">=")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MAYORIGUALQUE,"MAYORIGUALQUE");}










("y")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.AND,"AND");}


("no")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.NOT,"NOT");}

("o")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.OR,"OR");}
("<=")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MENORIGUALQUE,"MENORIGUALQUE");}

("<")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MENORQUE,"MENORQUE");}
(">")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MAYORQUE,"MAYORQUE");}
("==")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.COMPARA,"COMPARA");}
("=")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.IGUAL,"IGUAL");}

("<>")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DISTINTODE,"DISTINTODE");}
(",")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.COMA,"COMA");}
("and")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.Y,"Y");}
("or")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.O,"O");}
("no")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.NEGACION,"NEGACION");}
("ed")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.ED,"ED");}
("ef")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.EF,"EF");}
("repetir")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.REPEAT,"REPEAT");}
("hasta")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.UNTIL,"UNTIL");}

("inicio")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.INICIO,"INICIO");}
("final")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.FINAL,"FINAL");}
("ciclo")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.CICLO,"CICLO");}
("programa")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PROGRAMA,"PROGRAMA");}
("hacer")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DO,"DO");}
("mientras")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.WHILE,"WHILE");}
("procedimiento")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PROCEDURE,"PROCEDURE");}
("bucle")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.BUCLE,"BUCLE");}
("(")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PARENTESISIZQ,"PARENTESISIZQ");}
(")")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.PARENTESISDER,"PARENTESISDER");}
(":")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DOSPUNTOS,"DOSPUNTOS");}
("+")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.SUMA,"SUMA");}

("mod")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MODULO,"MODULO");}


("*")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.MULTIPLICACION,"MULTIPLICACION");}
("&")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.RESTA,"RESTA");}
("/")
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.DIVISION,"DIVISION");}
(("'") [^"'"]* ("'"))        //"'
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.CADENA,"CADENA");}


(-?{D}+)
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.INTEGERNUM,"INTEGERNUM");}

{L}({L}|{D})*
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.ID,"ID");}
}
.
{compilador.setTablaLexema("<Palabra reservada, "+yytext()+" >"+"\n");return token(sym.ERROR);}











