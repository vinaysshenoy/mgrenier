using System;
using System.Xml;
using System.Collections.Generic;
using UnityEngine;

namespace SVG
{
	public interface SVGITag
	{
		Rect CalculateBound(XmlNode node, float scale);


		bool NodetoMesh(XmlNode node, ref Mesh mesh, Rect canvas, float scale, float depth, ref List<Vector3> vertices, ref List<int> tris, ref List<Vector2> uvs, ref List<Vector3> normals, ref List<Color> colors);

	}
}
