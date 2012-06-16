using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Lexer
{
	class Calc
	{
		static protected Lexer _lexer;
		static protected Lexer lexer
		{
			get
			{
				if (_lexer == null)
				{
					_lexer = new Lexer();
					_lexer.SkipWhitespace = true;
					_lexer.AddDefinition("double", "(\\+|-|)[0-9]+\\.[0-9]+");
					_lexer.AddDefinition("int", "(\\+|-|)[0-9]+");
					_lexer.AddDefinition("op", "(\\+|-|\\*|/)");
					_lexer.AddDefinition("open", "\\(");
					_lexer.AddDefinition("close", "\\)");
					_lexer.FinalizeDefinitions();
				}

				return _lexer;
			}
		}

		static public double Eval(string eq)
		{
			string token, value;
			int p = 0;
			Stack<List<object>> contexts = new Stack<List<object>>();
			contexts.Push(new List<object>());

			while (lexer.Next(eq, ref p, out token, out value))
			{
				switch (token)
				{
					case "int":
						contexts.Peek().Add(int.Parse(value));
						break;
					case "double":
						contexts.Peek().Add(double.Parse(value));
						break;
					case "op":
						contexts.Peek().Add(value);
						break;
					case "open":
						contexts.Push(new List<object>());
						break;
					case "close":
						double r = EvalLastContext(ref contexts);
						contexts.Peek().Add(r);
						break;
				}
			}

			return EvalLastContext(ref contexts);
		}

		static protected double EvalLastContext(ref Stack<List<object>> contexts)
		{
			List<object> last = contexts.Pop();
			double r = 0;

			for (int a = 0, b = last.Count; a < b; ++a)
			{
				if (last[a] is int || last[a] is double)
					r = Convert.ToDouble(last[a]);
				else if (last[a] is string)
				{
					string op = (string)last[a];
					++a;
					if (a < b)
					{
						if (last[a] is int || last[a] is double)
						{
							switch (op)
							{
								case "+":
									r += Convert.ToDouble(last[a]);
									break;
								case "-":
									r -= Convert.ToDouble(last[a]);
									break;
								case "*":
									r *= Convert.ToDouble(last[a]);
									break;
								case "/":
									r /= Convert.ToDouble(last[a]);
									break;
							}
						}
					}
				}
			}

			return r;
		}
	}
}
