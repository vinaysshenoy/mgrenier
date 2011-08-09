using System;
using System.Xml;
using System.Collections.Generic;
using UnityEngine;

namespace SVG
{
	class SVGTagPolygon : SVGITag
	{
		public Rect CalculateBound(XmlNode node, float scale)
		{
			Vector2[] points = null;
			XmlNode attr;

			attr = node.Attributes.GetNamedItem("points");
			if (attr != null)
				points = ParsePoints(attr.Value, scale);

			if (points == null)
				return new Rect();

			return CalculateBound(points);
		}

		public Rect CalculateBound(Vector2[] points)
		{
			float xMin = float.MaxValue, yMin = float.MaxValue, xMax = float.MinValue, yMax = float.MinValue;

			for (int a = points.Length - 1; a >= 0; --a)
			{
				xMin = Mathf.Min(xMin, points[a].x);
				yMin = Mathf.Min(yMin, points[a].y);
				xMax = Mathf.Max(xMax, points[a].x);
				yMax = Mathf.Max(yMax, points[a].y);
			}

			return new Rect(xMin, yMax, xMax - xMin, yMin - yMax);
		}

		public bool NodetoMesh(XmlNode node, ref Mesh mesh, Rect canvas, float scale, float depth, ref List<Vector3> vertices, ref List<int> tris, ref List<Vector2> uvs, ref List<Vector3> normals, ref List<Color> colors)
		{
			Vector2[] points = null;
			XmlNode attr = node.Attributes.GetNamedItem("points");
			if (attr != null)
				points = ParsePoints(attr.Value, scale);

			Rect bound = this.CalculateBound(points);
			int i = vertices.Count;

			for (int a = 0, b = points.Length; a < b; ++a)
			{
				vertices.Add(new Vector3(points[a].x, depth * scale, points[a].y));
				uvs.Add(new Vector2(points[a].x / canvas.xMax, points[a].y / -canvas.yMax));
				normals.Add(Vector3.up);
				colors.Add(Color.white);
			}

			int[] triangles = TriangularizePoints(points);
			for (int a = 0, b = triangles.Length; a < b; ++a)
				tris.Add(i + triangles[a]);

			return true;
		}

		static protected Vector2[] ParsePoints(string str, float scale)
		{
			List<Vector2> points = new List<Vector2>();

			string[] pts = str.Split(' ');
			string[] pt;
			float x, y;
			for (int a = 0, b = pts.Length; a < b; ++a)
			{
				pt = pts[a].Split(',');
				x = float.Parse(pt[0]);
				y = -float.Parse(pt[1]);
				points.Add(new Vector2(x, y));
			}

			return points.ToArray();
		}

		static int[] TriangularizePoints(Vector2[] points)
		{
			List<int> tris = new List<int>();

			if (points.Length < 3)
				return null;

			int i = points.Length;
			int a;
			int ear;
			int curr;
			int under, over;
			List<int> newpts;

			//Vector2[] pts = (Vector2[])points.Clone();
			int[] pts = new int[points.Length];
			for (a = points.Length - 1; a >= 0; --a)
				pts[a] = a;

			while (i > 3)
			{
				// Find ear
				ear = -1;
				for (a = 0; a < i; ++a)
					if (isEar(a, pts, points))
					{
						ear = a;
						break;
					}

				// Never found an ear
				if (ear == -1)
				{
					Debug.LogError("No Ear !");
					break;
				}

				// Clip off
				--i;

				newpts = new List<int>();
				curr = 0;
				for (a = 0; a < i; ++a)
				{
					if (curr == ear)
						curr++;
					newpts.Add(curr);
					curr++;
				}

				// Add triangle
				under = ear == 0 ? pts.Length - 1 : ear - 1;
				over = ear == pts.Length - 1 ? 0 : ear + 1;
				tris.Add(ear);
				tris.Add(over);
				tris.Add(under);

				pts = newpts.ToArray();
			}

			tris.Add(pts[1]);
			tris.Add(pts[0]);
			tris.Add(pts[2]);

			 
			return tris.ToArray();
		}

		static protected bool isEar(int i, int[] pts, Vector2[] points)
		{
			Vector2 d0, d1;

			if (i >= pts.Length || i < 0 || pts.Length < 3)
				return false;

			int upper = i == pts.Length - 1 ? 0 : i + 1;
			int lower = i == 0 ? pts.Length - 1 : i - 1;

			d0 = points[pts[i]] - points[pts[lower]];
			d1 = points[pts[upper]] - points[pts[i]];

			float cross = d0.x * d1.y - d1.x * d0.y;
			if (cross > 0)
				return false;

			for (int a = 0, b = pts.Length; a < b; ++a)
				if (a != i && a != lower && a != upper)
					if (PointInTriangle(points[pts[a]], points[pts[i]], points[pts[upper]], points[pts[lower]]))
						return false;

			return true;
		}

		static protected bool PointInTriangle(Vector2 p, Vector2 v1, Vector2 v2, Vector2 v3)
		{
			return (p.y - v1.y) * (v2.x - v1.x) - (p.x - v1.x) * (v2.y - v1.y) <= 0.0 &&
					(p.y - v2.y) * (v3.x - v2.x) - (p.x - v2.x) * (v3.y - v2.y) <= 0.0 &&
					(p.y - v3.y) * (v1.x - v3.x) - (p.x - v3.x) * (v1.y - v3.y) <= 0.0;
		}
	}
}
