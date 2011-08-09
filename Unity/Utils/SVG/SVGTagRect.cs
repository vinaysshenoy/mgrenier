using System;
using System.Xml;
using System.Collections.Generic;
using UnityEngine;

namespace SVG
{
	class SVGTagRect : SVGITag
	{
		public Rect CalculateBound(XmlNode node, float scale)
		{
			float x = 0, y = 0, w = 0, h = 0;
			XmlNode attr;

			attr = node.Attributes.GetNamedItem("x");
			if (attr != null)
				x = float.Parse(attr.Value);

			attr = node.Attributes.GetNamedItem("y");
			if (attr != null)
				y = -float.Parse(attr.Value);

			attr = node.Attributes.GetNamedItem("width");
			if (attr != null)
				w = float.Parse(attr.Value);

			attr = node.Attributes.GetNamedItem("height");
			if (attr != null)
				h = -float.Parse(attr.Value);

			return new Rect(x * scale, y * scale, w * scale, h * scale);
		}

		public bool NodetoMesh(XmlNode node, ref Mesh mesh, Rect canvas, float scale, float depth, ref List<Vector3> vertices, ref List<int> tris, ref List<Vector2> uvs, ref List<Vector3> normals, ref List<Color> colors)
		{
			Rect bound = this.CalculateBound(node, scale);
			int i = vertices.Count;

			vertices.Add(new Vector3(bound.xMin, depth * scale, bound.yMin));
			vertices.Add(new Vector3(bound.xMax, depth * scale, bound.yMin));
			vertices.Add(new Vector3(bound.xMax, depth * scale, bound.yMax));
			vertices.Add(new Vector3(bound.xMin, depth * scale, bound.yMax));

			tris.Add(i + 0);
			tris.Add(i + 1);
			tris.Add(i + 2);
			tris.Add(i + 0);
			tris.Add(i + 2);
			tris.Add(i + 3);

			uvs.Add(new Vector2(bound.xMin / canvas.xMax, bound.yMin / -canvas.yMax));
			uvs.Add(new Vector2(bound.xMax / canvas.xMax, bound.yMin / -canvas.yMax));
			uvs.Add(new Vector2(bound.xMax / canvas.xMax, bound.yMax / -canvas.yMax));
			uvs.Add(new Vector2(bound.xMin / canvas.xMax, bound.yMax / -canvas.yMax));

			normals.Add(Vector3.up);
			normals.Add(Vector3.up);
			normals.Add(Vector3.up);
			normals.Add(Vector3.up);

			colors.Add(Color.white);
			colors.Add(Color.white);
			colors.Add(Color.white);
			colors.Add(Color.white);

			return true;
		}
	}
}
