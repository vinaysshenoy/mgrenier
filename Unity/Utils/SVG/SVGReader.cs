using System;
using System.Xml;
using System.Collections.Generic;
using UnityEngine;

namespace SVG
{
	class SVGReader
	{
		XmlDocument xml;
		XmlNamespaceManager nsmgr;
		Dictionary<string, SVGITag> taghandler;
		
		public SVGReader(string file)
		{
			XmlTextReader reader = new XmlTextReader(file);
			this.xml = new XmlDocument();
			this.xml.Load(reader);
			reader.Close();

			this.Initialize();
		}

		public SVGReader(XmlDocument svg)
		{
			this.xml = new XmlDocument();
			this.xml.LoadXml(svg.OuterXml);

			this.Initialize();
		}

		protected void Initialize()
		{
			this.taghandler = new Dictionary<string, SVGITag>();
			this.taghandler.Add("rect", new SVGTagRect());
			this.taghandler.Add("circle", new SVGTagCircle());
			this.taghandler.Add("polygon", new SVGTagPolygon());

			this.nsmgr = new XmlNamespaceManager(this.xml.NameTable);
			this.nsmgr.AddNamespace("x", "http://www.w3.org/2000/svg");
		}

		public Mesh SingleShape()
		{
			return this.SingleShape(1f);
		}

		public Mesh SingleShape(float scale)
		{
			Mesh mesh = new Mesh();
			XmlNodeList nodes = this.xml.SelectNodes("/x:svg/x:*", this.nsmgr);
			string name;
			Rect totalBound = new Rect(), bound;

			foreach (XmlNode node in nodes)
			{
				name = node.Name.ToLower();

				if (!this.taghandler.ContainsKey(name))
					continue;

				bound = this.taghandler[name].CalculateBound(node, scale);

				totalBound.xMin = Mathf.Min(totalBound.xMin, bound.xMin);
				totalBound.xMax = Mathf.Max(totalBound.xMax, bound.xMax);
				totalBound.yMin = Mathf.Max(totalBound.yMin, bound.yMin);
				totalBound.yMax = Mathf.Min(totalBound.yMax, bound.yMax);
			}

			List<Vector3> vertices = new List<Vector3>();
			List<Vector3> normals = new List<Vector3>();
			List<Vector2> uvs = new List<Vector2>();
			List<Color> colors = new List<Color>();
			List<int> tris = new List<int>();

			float depth = 0;
			foreach (XmlNode node in nodes)
			{
				name = node.Name.ToLower();
				if (!this.taghandler.ContainsKey(name))
					continue;
				if (!this.taghandler[name].NodetoMesh(node, ref mesh, totalBound, scale, depth, ref vertices, ref tris, ref uvs, ref normals, ref colors))
					return null;

				depth += 0.1f;
			}

			mesh.Clear();
			mesh.vertices = vertices.ToArray();
			mesh.normals = normals.ToArray();
			mesh.uv = uvs.ToArray();
			mesh.colors = colors.ToArray();
			mesh.triangles = tris.ToArray();
			mesh.RecalculateBounds();
			mesh.Optimize();

			return mesh;
		}

	}
}
