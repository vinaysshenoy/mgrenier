using System;
using System.Xml;
using System.Collections.Generic;
using UnityEngine;

namespace SVG
{
	class SVGTagCircle : SVGITag
	{
		private int _edges;
		private int edges
		{
			get
			{
				return this._edges;
			}
			set
			{
				if (value < 3)
					throw new ArgumentOutOfRangeException("edges", value, "Number of edges must be at least 3");
				this._edges = value;
			}
		}

		public SVGTagCircle()
			: this(20)
		{
		}

		public SVGTagCircle(int edges)
		{
			this.edges = edges;
		}

		public Rect CalculateBound(XmlNode node, float scale)
		{
			float x = 0, y = 0, r = 0;
			XmlNode attr;

			attr = node.Attributes.GetNamedItem("cx");
			if (attr != null)
				x = float.Parse(attr.Value);

			attr = node.Attributes.GetNamedItem("cy");
			if (attr != null)
				y = -float.Parse(attr.Value);

			attr = node.Attributes.GetNamedItem("r");
			if (attr != null)
				r = float.Parse(attr.Value);

			return new Rect(x * scale - r * scale, y * scale - r * scale, x * scale + r * scale, y * scale + r * scale);
		}

		public bool NodetoMesh(XmlNode node, ref Mesh mesh, Rect canvas, float scale, float depth, ref List<Vector3> vertices, ref List<int> tris, ref List<Vector2> uvs, ref List<Vector3> normals, ref List<Color> colors)
		{
			Rect bound = this.CalculateBound(node, scale);
			float x = 0, y = 0, r = 0,
				  rad = (360f / (float)this.edges) * Mathf.PI / 180;
			XmlNode attr;
			attr = node.Attributes.GetNamedItem("cx");
			if (attr != null)
				x = float.Parse(attr.Value) * scale;

			attr = node.Attributes.GetNamedItem("cy");
			if (attr != null)
				y = -float.Parse(attr.Value) * scale;

			attr = node.Attributes.GetNamedItem("r");
			if (attr != null)
				r = float.Parse(attr.Value) * scale;

			int i = vertices.Count;
			Vector3 v;
			for (int a = 0, b = this.edges; a < b; ++a)
			{
				v = new Vector3(-r, depth * scale, 0);
				RotateVector2(ref v, rad * a);
				v.x += x;
				v.z += y;
				vertices.Add(v);
				uvs.Add(new Vector2(v.x / canvas.xMax, v.z / -canvas.yMax));
				normals.Add(Vector3.up);
				colors.Add(Color.white);
			}

			for (int a = 2, b = this.edges; a < b; ++a)
			{
				tris.Add(i + a + 0);
				tris.Add(i + a - 1);
				tris.Add(i);
			}

			return true;
		}

		static protected void RotateVector2(ref Vector3 v, float radian)
		{
			float t = v.x,
				  c = Mathf.Cos(radian),
				  s = Mathf.Sin(radian);
			v.x = t * c - v.z * s;
			v.z = t * s + v.z * c;
		}
	}
}
