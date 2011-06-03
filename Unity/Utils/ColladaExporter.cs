using UnityEngine;
using UnityEditor;
using System;
using System.Xml;
using System.Text;

public class ColladaExporter
{
	public static void SingleMesh(String path, Mesh mesh)
	{
		StringBuilder str;
		XmlTextWriter xml = new XmlTextWriter(path, Encoding.UTF8);
		xml.Formatting = Formatting.Indented;
		xml.WriteStartDocument();
		xml.WriteStartElement("COLLADA");
		xml.WriteAttributeString("xmlns", "http://www.collada.org/2005/11/COLLADASchema");
		xml.WriteAttributeString("version", "1.4.1");

		xml.WriteStartElement("asset");
		xml.WriteStartElement("contributor");
		xml.WriteElementString("author", "Unity User");
		xml.WriteElementString("author_tool", "Unity " + Application.unityVersion);
		xml.WriteEndElement();
		xml.WriteElementString("created", DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:00"));
		xml.WriteElementString("modified", DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:00"));
		xml.WriteElementString("up_axis", "Y_UP");
		xml.WriteEndElement();

		xml.WriteStartElement("library_cameras");
		xml.WriteEndElement();

		xml.WriteStartElement("library_lights");
		xml.WriteEndElement();

		xml.WriteStartElement("library_images");
		xml.WriteEndElement();

		xml.WriteStartElement("library_effects");
		xml.WriteEndElement();

		xml.WriteStartElement("library_materials");
		xml.WriteEndElement();

		xml.WriteStartElement("library_geometries");

		xml.WriteStartElement("geometry");
		xml.WriteAttributeString("id", "NavMesh_001-mesh");

		xml.WriteStartElement("mesh");

		xml.WriteStartElement("source");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-positions");

		xml.WriteStartElement("float_array");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-positions-array");
		xml.WriteAttributeString("count", (mesh.vertices.Length * 3).ToString());

		str = new StringBuilder();
		for (int i = 0, n = mesh.vertices.Length; i < n; ++i)
		{
			str.Append((-mesh.vertices[i].x).ToString());
			str.Append(" ");
			str.Append(mesh.vertices[i].y.ToString());
			str.Append(" ");
			str.Append(mesh.vertices[i].z.ToString());
			if (i + 1 != n)
				str.Append(" ");
		}
		xml.WriteString(str.ToString());
		str = null;

		xml.WriteEndElement(); // float_array

		xml.WriteStartElement("technique_common");

		xml.WriteStartElement("accessor");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-positions-array");
		xml.WriteAttributeString("count", mesh.vertices.Length.ToString());
		xml.WriteAttributeString("stride", "3");

		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "X");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "Y");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "Z");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();

		xml.WriteEndElement(); // accessor

		xml.WriteEndElement(); // technique_common

		xml.WriteEndElement(); // source

		xml.WriteStartElement("source");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-colors");

		xml.WriteStartElement("float_array");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-colors-array");
		xml.WriteAttributeString("count", (mesh.colors.Length * 3).ToString());

		str = new StringBuilder();
		for (int i = 0, n = mesh.colors.Length; i < n; ++i)
		{
			//str.Append(mesh.colors[i].a.ToString());
			//str.Append(" ");
			str.Append(mesh.colors[i].r.ToString());
			str.Append(" ");
			str.Append(mesh.colors[i].g.ToString());
			str.Append(" ");
			str.Append(mesh.colors[i].b.ToString());
			if (i + 1 != n)
				str.Append(" ");
		}
		xml.WriteString(str.ToString());
		str = null;

		xml.WriteEndElement(); // float_array

		xml.WriteStartElement("technique_common");

		xml.WriteStartElement("accessor");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-colors-array");
		xml.WriteAttributeString("count", mesh.colors.Length.ToString());
		xml.WriteAttributeString("stride", "3");

		/*xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "A");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();*/
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "R");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "G");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "B");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();

		xml.WriteEndElement(); // accessor

		xml.WriteEndElement(); // technique_common

		xml.WriteEndElement(); // source

		xml.WriteStartElement("source");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-normals");

		xml.WriteStartElement("float_array");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-normals-array");
		xml.WriteAttributeString("count", (mesh.normals.Length * 3).ToString());

		str = new StringBuilder();
		for (int i = 0, n = mesh.normals.Length; i < n; ++i)
		{
			str.Append((-mesh.normals[i].x).ToString());
			str.Append(" ");
			str.Append(mesh.normals[i].y.ToString());
			str.Append(" ");
			str.Append(mesh.normals[i].z.ToString());
			if (i + 1 != n)
				str.Append(" ");
		}
		xml.WriteString(str.ToString());
		str = null;

		xml.WriteEndElement(); // float_array

		xml.WriteStartElement("technique_common");

		xml.WriteStartElement("accessor");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-normals-array");
		xml.WriteAttributeString("count", mesh.normals.Length.ToString());
		xml.WriteAttributeString("stride", "3");

		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "X");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "Y");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();
		xml.WriteStartElement("param");
		xml.WriteAttributeString("name", "Z");
		xml.WriteAttributeString("type", "float");
		xml.WriteEndElement();

		xml.WriteEndElement(); // accessor

		xml.WriteEndElement(); // technique_common

		xml.WriteEndElement(); // source

		xml.WriteStartElement("vertices");
		xml.WriteAttributeString("id", "NavMesh_001-mesh-vertices");

		xml.WriteStartElement("input");
		xml.WriteAttributeString("semantic", "POSITION");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-positions");
		xml.WriteEndElement();

		xml.WriteStartElement("input");
		xml.WriteAttributeString("semantic", "NORMAL");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-normals");
		xml.WriteEndElement();

		xml.WriteStartElement("input");
		xml.WriteAttributeString("semantic", "COLOR");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-colors");
		xml.WriteEndElement();

		xml.WriteEndElement(); // vertices

		xml.WriteStartElement("triangles");
		xml.WriteAttributeString("count", (mesh.triangles.Length / 3).ToString());

		xml.WriteStartElement("input");
		xml.WriteAttributeString("semantic", "VERTEX");
		xml.WriteAttributeString("source", "#NavMesh_001-mesh-vertices");
		xml.WriteAttributeString("offset", "0");
		xml.WriteEndElement();

		str = new StringBuilder();
		//for (int i = 0, n = mesh.triangles.Length; i < n; ++i)
		for (int i = mesh.triangles.Length - 1; i >= 0; --i)
		{
			str.Append(mesh.triangles[i].ToString());
			str.Append(" ");
		}
		xml.WriteElementString("p", str.ToString());
		str = null;

		xml.WriteEndElement(); // triangles


		xml.WriteEndElement(); // mesh

		xml.WriteEndElement(); // geometry

		xml.WriteEndElement(); // library_geometries

		xml.WriteStartElement("library_animations");
		xml.WriteEndElement();

		xml.WriteStartElement("library_controllers");
		xml.WriteEndElement();

		xml.WriteStartElement("library_visual_scenes");

		xml.WriteStartElement("visual_scene");
		xml.WriteAttributeString("id", "Scene");
		xml.WriteAttributeString("name", "Scene");

		xml.WriteStartElement("node");
		xml.WriteAttributeString("id", "NavMesh_001");
		xml.WriteAttributeString("type", "Node");

		xml.WriteStartElement("translate");
		xml.WriteAttributeString("sid", "location");
		xml.WriteString("0 0 0");
		xml.WriteEndElement();

		xml.WriteStartElement("rotate");
		xml.WriteAttributeString("sid", "rotationZ");
		xml.WriteString("0 0 1 0");
		xml.WriteEndElement();
		xml.WriteStartElement("rotate");
		xml.WriteAttributeString("sid", "rotationY");
		xml.WriteString("0 1 0 0");
		xml.WriteEndElement();
		xml.WriteStartElement("rotate");
		xml.WriteAttributeString("sid", "rotationX");
		xml.WriteString("1 0 0 0");
		xml.WriteEndElement();

		xml.WriteStartElement("scale");
		xml.WriteAttributeString("sid", "scale");
		xml.WriteString("1 1 1");
		xml.WriteEndElement();

		xml.WriteStartElement("instance_geometry");
		xml.WriteAttributeString("url", "#NavMesh_001-mesh");
		xml.WriteEndElement();


		xml.WriteEndElement(); // node

		xml.WriteEndElement(); // visual_scene

		xml.WriteEndElement(); // library_visuel_scenes

		xml.WriteStartElement("scene");

		xml.WriteStartElement("instance_visual_scene");
		xml.WriteAttributeString("url", "#Scene");
		xml.WriteEndElement();

		xml.WriteEndElement();

		xml.WriteEndElement();
		xml.WriteEndDocument();
		xml.Close();
	}


}