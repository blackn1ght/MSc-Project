#include <iostream>
#include <stdio.h>
#include <vector>
#include <llvm/Value.h>

class CodeGenContext;
class NStatement;
class NExpression;
class NVariableDeclaration;
class NRule;
class NQuestion;

typedef std::vector<NStatement*> StatementList;
typedef std::vector<NExpression*> ExpressionList;
typedef std::vector<NVariableDeclaration*> VariableList;
typedef std::vector<NRule*> RuleList;
typedef std::vector<NQuestion*> QuestionList;

class Node {
public:
	virtual ~Node() {}
	virtual llvm::Value* codeGen(CodeGenContext& context) { }
};

class NExpression : public Node {
};

class NStatement : public Node {
};

class NInteger : public NExpression {
public:
	long long value;
	NInteger(long long value) : value(value) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NDouble : public NExpression {
public:
	double value;
	NDouble(double value) : value(value) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NIdentifier : public NExpression {
public:
	std::string name;
	NIdentifier(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NMethodCall : public NExpression {	// Was public NExpression
public:
	const NIdentifier& id;
	ExpressionList arguments;
	NMethodCall(const NIdentifier& id, ExpressionList& arguments) : id(id), arguments(arguments) { }
	NMethodCall(const NIdentifier& id) : id(id) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NBinaryOperator : public NExpression {
public:
	int op;
	NExpression& lhs;
	NExpression& rhs;
	NBinaryOperator(NExpression &lhs, int op, NExpression& rhs) : lhs(lhs), rhs(rhs), op(op) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NAssignment : public NExpression {
public:
	NIdentifier& lhs;
	NIdentifier& rhs;
	
	NAssignment(NIdentifier& lhs, NIdentifier& rhs) : lhs(lhs), rhs(rhs) { }
	//NAssignment(Nidentifier& lhs, NExpression& e_rhs) : lhs(lhs), e_rhs(e_rhs) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NBlock: public NExpression {
public:
	StatementList statements;
	NBlock() { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NExpressionStatement : public NStatement {
public:
	NExpression& expression;
	NExpressionStatement(NExpression& expression) : expression(expression) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NVariableDeclaration : public NStatement {
public:
	const NIdentifier& type;
	NIdentifier& id;
	NExpression *assignmentExpr;
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id) : type(type), id(id) { }
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id, NExpression *assignmentExpr) :
		type(type), id(id), assignmentExpr(assignmentExpr) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NMethodDeclaration : public NStatement {
public:
	int& type;		// Rule, Question, Action
	const NIdentifier& id;
	NBlock& qstmt;
	
	NMethodDeclaration(int& type, const NIdentifier& id, NBlock& qstmt) : type(type), id(id), qstmt(qstmt) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NQuestionBlock : public NBlock {
public:
	NExpression& question;
	const NIdentifier& ident;
	NExpression& why;
	
	NQuestionBlock(NExpression& question, const NIdentifier& ident, NExpression& why) : question(question), ident(ident), why(why) { }
	
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NDecisionStatement : public NStatement {
public:
	NExpression& ifExpression;
	NExpression& thenExpression;
	NDecisionStatement(NExpression& ifExpression, NExpression& thenExpression) : ifExpression(ifExpression), thenExpression(thenExpression) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NSentence : public NExpression {
public:
	std::string text;
	NSentence(std::string& text) : text(text) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};
