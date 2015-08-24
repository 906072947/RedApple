/**
 * Project Untitled
 */


#include "ExpressionNode.h"

/**
 * ExpressionNode implementation
 * 
 * 表达式节点
 * =========
 * 
 * 这个表达式节点，实际上是在抽象S-表达式  
 * 所有的内容都是函数调用，所有的部分都能够用函数嵌套来完成
 * 
 * 重要特性：
 * 
 * 1. 所有的节点都会维护一个链表结构，并在运行时放置到代码区中  
 * 2. 所有的值类型都是直接传值的  
 * 3. 所有的IDNode，都是引用类型  
 * 4. 所有的运算符，全是函数调用
 */