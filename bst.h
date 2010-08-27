/* 	bst.h

	Provides a BST to store the variables in the program
	
*/
#define MAX_NODES			9999
#define NULL_POINTER		-1
#define NULL_ENTRY			"__NULL__"

int free_node;
int key;

struct Node {
	int id;
	char *variable_name;
	char *value;
	int left;
	int right;
};

struct Node nodes[MAX_NODES];

void BST();
int Insert(char *variable_name, char *data);
char *GetVariableValue(char *variable_name);
