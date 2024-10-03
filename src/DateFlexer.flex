import java.util.ArrayList;
import java.util.List;

%%
%public
%class DateLexer
%unicode
%function yylex
%type String

%{

private List<String> fechasValidas = new ArrayList<>();

public List<String> getFechasValidas() {
    return fechasValidas;
}

private boolean esFechaValida(int dia, int mes, int anio) {
    if (mes < 1 || mes > 12) return false;
    if (dia < 1) return false;

    int[] diasEnMes = {31, (esAnioBisiesto(anio) ? 29 : 28), 31, 30, 31, 30,
                       31, 31, 30, 31, 30, 31};

    if (dia > diasEnMes[mes - 1]) return false;

    return true;
}

private boolean esAnioBisiesto(int anio) {
    return (anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0);
}

private int obtenerMesDesdeAbreviatura(String mesTexto) {
    switch(mesTexto.toLowerCase()) {
        case "jan": return 1;
        case "feb": return 2;
        case "mar": return 3;
        case "apr": return 4;
        case "may": return 5;
        case "jun": return 6;
        case "jul": return 7;
        case "aug": return 8;
        case "sep": return 9;
        case "oct": return 10;
        case "nov": return 11;
        case "dec": return 12;
        default: return -1;
    }
}
%}

DAY        = (0?[1-9]|[12][0-9]|3[01])
MONTH_NUM  = (0[1-9]|1[012])
YEAR       = [0-9]{2,4}

MONTH_ABBR = ([Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc])

DATE_SLASH             = {DAY}\/{MONTH_NUM}\/{YEAR}
DATE_DASH              = {DAY}-{MONTH_NUM}-{YEAR}
DATE_DOT               = {YEAR}\.{MONTH_NUM}\.{DAY}
DATE_SLASH_LETTER_MONTH= {DAY}\/{MONTH_ABBR}\/{YEAR}
DATE_DASH_LETTER_MONTH = {DAY}-{MONTH_ABBR}-{YEAR} // NEW PATTERN

%%

{DATE_SLASH} {
    String texto = yytext();
    String[] partes = texto.split("/");
    int dia = Integer.parseInt(partes[0]);
    int mes = Integer.parseInt(partes[1]);
    int anio = Integer.parseInt(partes[2]);
    if (esFechaValida(dia, mes, anio)) {
        texto = texto + " – FECHA_CORTA_NUMEROS";
        fechasValidas.add(texto);
        return texto; // Return the matched date string with appended text
    }
    // Do nothing for invalid dates
}

{DATE_DASH} {
    String texto = yytext();
    String[] partes = texto.split("-");
    int dia = Integer.parseInt(partes[0]);
    int mes = Integer.parseInt(partes[1]);
    int anio = Integer.parseInt(partes[2]);
    if (esFechaValida(dia, mes, anio)) {
        texto = texto + " – FECHA_CORTA_NUMEROS";
        fechasValidas.add(texto);
        return texto; // Return the matched date string with appended text
    }
    // Do nothing for invalid dates
}

{DATE_DOT} {
    String texto = yytext();
    String[] partes = texto.split("\\.");
    int anio = Integer.parseInt(partes[0]);
    int mes = Integer.parseInt(partes[1]);
    int dia = Integer.parseInt(partes[2]);
    if (esFechaValida(dia, mes, anio)) {
        texto = texto + " – FECHA_CORTA_NUMEROS";
        fechasValidas.add(texto);
        return texto; // Return the matched date string with appended text
    }
    // Do nothing for invalid dates
}

{DATE_SLASH_LETTER_MONTH} {
    String texto = yytext();
    String[] partes = texto.split("/");
    int dia = Integer.parseInt(partes[0]);
    String mesTexto = partes[1];
    int anio = Integer.parseInt(partes[2]);
    int mes = obtenerMesDesdeAbreviatura(mesTexto);
    if (mes != -1 && esFechaValida(dia, mes, anio)) {
        texto = texto + " - FECHA_MES_LETRAS";
        fechasValidas.add(texto);
        return texto; // Return the matched date string with appended text
    }
    // Do nothing for invalid dates
}

{DATE_DASH_LETTER_MONTH} { // NEW RULE FOR DASH FORMAT WITH LETTER MONTH
    String texto = yytext();
    String[] partes = texto.split("-");
    int dia = Integer.parseInt(partes[0]);
    String mesTexto = partes[1];
    int anio = Integer.parseInt(partes[2]);
    int mes = obtenerMesDesdeAbreviatura(mesTexto);
    if (mes != -1 && esFechaValida(dia, mes, anio)) {
        texto = texto + " - FECHA_MES_LETRAS";
        fechasValidas.add(texto);
        return texto; // Return the matched date string with appended text
    }
    // Do nothing for invalid dates
}

[^\\] { /* Ignore any character, including newlines */ }

<<EOF>> { return null; } // Signal end of file
