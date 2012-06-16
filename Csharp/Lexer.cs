using System;
using System.Collections.Generic;
//using System.Text;
using System.Text.RegularExpressions;

namespace Lexer
{
	class Lexer
	{
		static protected Regex whitespace = new Regex("\\s*", RegexOptions.Compiled);

		protected Dictionary<string, string> definitions;

		protected Regex regex;

		protected String[] defs;

		public bool SkipWhitespace;

		public Lexer()
			: this(new Dictionary<string, string>())
		{
		}

		public Lexer(Dictionary<string, string> defs)
		{
			this.SkipWhitespace = false;
			this.definitions = new Dictionary<string, string>(defs);
		}

		public void AddDefinition(string name, string regex)
		{
			this.definitions[name] = regex;
		}

		public void RemoveDefinition(string name)
		{
			if (this.definitions.ContainsKey(name))
				this.definitions.Remove(name);
		}

		public void FinalizeDefinitions()
		{
			string[] pattern = new string[this.definitions.Count];
			this.defs = new string[this.definitions.Count];
			int a = 0;

			foreach (KeyValuePair<string, string> pair in this.definitions)
			{
				//pattern[a] = string.Format(this.SkipWhitespace ? "\\s*(?<{0}>{1})\\s*" : "(?<{0}>{1})", pair.Key, pair.Value);
				pattern[a] = string.Format("(?<{0}>{1})", pair.Key, pair.Value);

				this.defs[a++] = pair.Key;
			}

			try
			{
				this.regex = new Regex("(" + string.Join("|", pattern) + ")", RegexOptions.ExplicitCapture | RegexOptions.Compiled);
			}
			catch (ArgumentException e)
			{
				throw e;
			}

			
		}

		public bool Peek(string buffer, int position)
		{
			string def, val;
			return this.Peek(buffer, position, out def, out val);
		}

		public bool Peek(string buffer, int position, out string definition, out string value)
		{
			definition = value = "";

			if (this.regex == null)
				return false;

			Match match = this.regex.Match(buffer, position);
			if (!match.Success)
				return false;

			//foreach (string def in this.definitions.Keys)
			for (int a = 0, b = this.defs.Length; a < b; ++a)
			{
				string def = this.defs[a];
				string val = match.Groups[def].Value;
				if (val != "")
				{
					definition = def;
					value = val;
					return true;
				}
			}

			return false;
		}

		public bool Next(string buffer, ref int position)
		{
			string def, val;
			return this.Next(buffer, ref position, out def, out val);
		}

		public bool Next (string buffer, ref int position, out string definition, out string value)
		{
			definition = value = "";

			if (buffer.Length == 0)
				return false;

			if (!this.Peek(buffer, position, out definition, out value))
				return false;

			position += value.Length;

			if (this.SkipWhitespace)
			{
				Match match = Lexer.whitespace.Match(buffer, position);
				if (match.Success)
				{
					//Console.WriteLine("White space " + position + " : " + match.Index + " " + match.Length);
					position += match.Length;
				}
			}

			return true;
		}
	}
}
