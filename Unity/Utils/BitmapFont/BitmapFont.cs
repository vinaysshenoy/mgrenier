using UnityEngine;
using System.Collections.Generic;

public class BitmapFont : MonoBehaviour {

	[System.Serializable]
	public class Char
	{
		public int Id;
		public Vector2 Position;
		public Vector2 Size;
		public Vector2 Offset;
		public int Page;
		public float XAdvance;
	}

	[System.Serializable]
	public class Kerning
	{
		public int FirstChar;
		public int SecondChar;
		public float Amount;
	}

	[HideInInspector]
	public float Size;
	[HideInInspector]
	public float LineHeight;
	[HideInInspector]
	public float Base;
	[HideInInspector]
	public float ScaleW;
	[HideInInspector]
	public float ScaleH;

	[HideInInspector]
	public Char[] Chars;
	[HideInInspector]
	public Kerning[] Kernings;
	[HideInInspector]
	public Rect[] PageOffsets;
	[HideInInspector]
	public Texture2D PageAtlas;

	public Char GetChar(int id)
	{
		foreach (Char c in this.Chars)
			if (id == c.Id)
				return c;
		return this.Chars[0];
	}

	public Rect GetRect(char c)
	{
		return this.GetRect((int)c);
	}

	public Rect GetRect(int id)
	{
		return this.GetRect(GetChar(id));
	}

	public Rect GetRect(Char c)
	{
		Vector2 scaledSize = new Vector2(c.Size.x / this.ScaleW, c.Size.y / this.ScaleH);
		Vector2 scaledPos = new Vector2(c.Position.x / this.ScaleW, c.Position.y / this.ScaleH);
		Vector2 uvPos = new Vector2(scaledPos.x, 1 - (scaledPos.y + scaledSize.y));

		Rect offset = this.PageOffsets[c.Page];
		uvPos = new Vector2(uvPos.x * offset.width + offset.xMin, uvPos.y * offset.height + offset.yMin);
		scaledSize = new Vector2(scaledSize.x * offset.width, scaledSize.y * offset.height);

		return new Rect(uvPos.x, uvPos.y, scaledSize.x, scaledSize.y);
	}

	public float GetKerning(char first, char second)
	{
		return this.GetKerning((int)first, (int)second);
	}

	public float GetKerning(int first, int second)
	{
		if (this.Kernings == null)
			return 0;

		foreach (Kerning k in this.Kernings)
			if (k.FirstChar == first && k.SecondChar == second)
				return k.Amount;

		return 0;
	}

	public Vector2 GetTextRect(string text, float renderSize)
	{
		string[] lines;
		return this.GetTextRect(text, new Vector2(renderSize, renderSize), float.MaxValue, out lines);
	}

	public Vector2 GetTextRect(string text, float renderSize, float maxSize)
	{
		string[] lines;
		return this.GetTextRect(text, new Vector2(renderSize, renderSize), maxSize, out lines);
	}

	public Vector2 GetTextRect(string text, Vector2 renderSize, float maxSize, out string[] lines)
	{
		List<string> ls = new List<string>();
		Vector2 r = new Vector2(0, renderSize.y);
		Vector2 p = new Vector2(0, renderSize.y);
		Vector2 s = renderSize / this.Size;
		bool reachMax = false;

		string line = "";
		for (int a = 0, b = text.Length; a < b; ++a)
		{
			Char c = this.GetChar(text[a]);
			float k = 0;
			if (a < b - 1)
				k = this.GetKerning(c.Id, (int)text[a + 1]);
			float l = (c.XAdvance + k) * s.x;
			
			if (!reachMax)
				r.x += l;

			if ((int)text[a] == 10)
			{
				ls.Add(line + '\n');
				line = "";
				p.x = 0;
				p.y += renderSize.y;
				r.y += renderSize.y;
				continue;
			}

			if (Mathf.Abs(p.x) + l >= maxSize)
			{
				ls.Add(line);
				line = "";
				p.x = 0;
				reachMax = true;
				p.y += renderSize.y;
				r.y += renderSize.y;
			}

			line += text[a];
			p.x += l;
		}
		if (line != "")
			ls.Add(line);
		lines = ls.ToArray();

		return r;
	}

}
