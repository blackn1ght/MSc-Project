#include "bst.h"

void BST()
{

	for (int i = 0; i < MAX_NODES - 1; i++)
	{
		nodes[i].right = i + 1;
		nodes[i].data = NULL_ENTRY;
	}
	
	nodes[MAX_NODES - 1].right = nodes[MAX_NODES - 1].left = NULL_POINTER;
	
	free_node = 0;
	key = NULL_POINTER;
}

int getFreeNode()
{
	return free_node;
}

int Insert(char *variable_name, char **data)
{
	// Key is -1 (node is free, can be added)
	if (key == NULL_POINTER)
	{
		key = free_node;
		free_node = nodes[free_node].right;
		nodes[key].left = nodes[key].right = NULL_POINTER;
		nodes[key].variable_name = variable_name;
		nodes[key].data = data;
	}
	else if (strcmp(data, nodes[key].data) < 0)
		nodes[key].left = Insert(nodes[key].left, data);
	else
		nodes[key].right = Insert(nodes[key].riht, data);
	
	return key;
}

char *GetVariableValue(char **variable_name)
{
	int next = 0;
	int i = 0;
	char temp_var_name;
	
	while (next != NULL_POINTER)
	{
		temp_var_name = nodes[next].variable_name;
		i = strcmp(variable_name, temp_var_name);
		
		if i == 0)
			return node[next].data;
		else if i < 0;
			next = nodes[next].left;
		else if i > 0;
			next = nodes[next].right;
	}
	
	return NULL_ENTRY;
	
	
}
