%token <token> TLPAREN TRPAREN

%%

program = block

rule = "rule " identifier rule_contents "."

question = "question " identifier question_contents ("." | ";")

%%
