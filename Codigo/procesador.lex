/*Seccion de declaraciones*/
%{
    #include <stdlib.h>

    void init_command();
    void procesar_palabra(char * palabra, int palabra_size);
    void procesar_palabra_fin(char * palabra, int palabra_size);
    void procesar_palabra_inicio(char * palabra, int palabra_size);
    void procesar_palabra_fin_documento(char * palabra, int palabra_size);

%}


caracter            [a-zA-Z\.,]
digito              [0-9]
especial            [\*;]
espacio             " "
salto               \n
barra               \/

palabra             ({caracter}|{digito}|{barra})+
entrecomillado      \"({palabra}|{espacio})*\"
separador           -+
prompt              {caracter}*sql{caracter}*>
comando             ^{prompt}({espacio}*({caracter}|{digito}|{especial}))*

%%

{comando}[^-]*({separador}|{espacio})*                      {;}
{comando}                                                   {;}
{separador}                                                 {;}
({palabra}|{entrecomillado})({espacio})*{salto}{prompt}     {procesar_palabra_fin_documento(yytext, yyleng);}
({palabra}|{entrecomillado}){espacio}*$                     {procesar_palabra_fin(yytext, yyleng);}
^(({palabra}|{entrecomillado}){espacio}*)                   {procesar_palabra_inicio(yytext, yyleng);}
(({palabra}|{entrecomillado}){espacio}*)                    {procesar_palabra(yytext, yyleng);}

%% 

int main(int argc, char ** argv){
    // Abrimos el fichero
    if(argc == 2){
        yyin = fopen(argv[1], "rt");
    }else{
        printf("El fichero %s no se puede abrir", argv[1]);
        return 1;
    }
    
    init_command();
    yylex();
    return 0;
}

void init_command(){
    printf("INSERT INTO table VALUES");
}

void procesar_palabra(char * palabra, int palabra_size){
    int acabado = 0;

    // Se procesa una palabra que no es entrecomillada
    if(palabra[0] != '\"'){
        for(int i = 0; i < palabra_size && acabado == 0; i++){
            if(palabra[i] != ' ' && palabra[i] != '\0'){
                printf("%c", palabra[i]);
            }else{
                acabado = 1;
            }
        }

    // Se procesa una palabra entrecomillada
    }else{
        printf("\"");
        for(int i = 1; i < palabra_size && acabado == 0; i++){
            if(palabra[i] != '\"' && palabra[i] != '\0'){
                printf("%c", palabra[i]);
            }else{
                acabado = 1;
            }
        }
        printf("\"");
    }
    printf(", ");
}

void procesar_palabra_fin(char * palabra, int palabra_size){
    int acabado = 0;

    // Se procesa una palabra que no esta entrecomillada
    if(palabra[0] != '\"'){
        for(int i = 0; i < palabra_size && acabado == 0; i++){
            if(palabra[i] != ' ' && palabra[i] != '\0' && palabra[i] != '\n'){
                printf("%c", palabra[i]);
            }else{
                acabado = 1;
            }
        }
        printf("),");

    // Se procesa una palabra comillada
    }else{
        printf("\"");
        for(int i = 1; i < palabra_size && acabado == 0; i++){
            if(palabra[i] == '\"'){
                acabado = 1;
            }else{
                printf("%c", palabra[i]);
            }
        }

        printf("\"),");
    }
}

void procesar_palabra_fin_documento(char * palabra, int palabra_size){
    int acabado = 0;

    // Se procesa una palabra que no esta entrecomillada
    if(palabra[0] != '\"'){
        for(int i = 0; i < palabra_size && acabado == 0; i++){
            if(palabra[i] != ' ' && palabra[i] != '\0' && palabra[i] != '\n'){
                printf("%c", palabra[i]);
            }else{
                acabado = 1;
            }
        }
        printf(");\n");

    // Se procesa una palabra comillada
    }else{
        printf("\"");
        for(int i = 1; i < palabra_size && acabado == 0; i++){
            if(palabra[i] == '\"'){
                acabado = 1;
            }else{
                printf("%c", palabra[i]);
            }
        }

        printf("\");\n");
    }
}

void procesar_palabra_inicio(char * palabra, int palabra_size){
    printf("\t(");
    int acabado = 0;
    for(int i = 0; i < palabra_size && acabado == 0; i++){
        if(palabra[i] != ' ' && palabra[i] != '\0'){
            printf("%c", palabra[i]);
        }else{
            acabado = 1;
        }
    }
    printf(", ");
}
